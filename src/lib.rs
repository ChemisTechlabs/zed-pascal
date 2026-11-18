use zed_extension_api::{self as zed, Architecture, LanguageServerId, Os, Result, settings::LspSettings};

/// Repository that publishes prebuilt `pasls` binaries.
const PASLS_REPO: &str = "ChemisTechlabs/pascal-language-server";

/// Returns the release asset name of a prebuilt `pasls` binary for the given
/// platform, or `None` when no prebuilt binary is published for it.
fn pasls_asset_name(os: Os, arch: Architecture) -> Option<&'static str> {
    match (os, arch) {
        (Os::Mac, Architecture::Aarch64) => Some("pasls-aarch64-darwin.zip"),
        // No prebuilt binary is published for macOS Intel.
        (Os::Mac, _) => None,
        (Os::Linux, Architecture::Aarch64) => Some("pasls-aarch64-linux.tar.gz"),
        (Os::Linux, _) => Some("pasls-x86_64-linux.tar.gz"),
        // No prebuilt binary is published for Windows ARM64.
        (Os::Windows, Architecture::Aarch64) => None,
        (Os::Windows, _) => Some("pasls-x86_64-win64.zip"),
    }
}

/// Returns a writable cache directory for downloaded binaries.
///
/// `std::env::temp_dir` is not usable here: on WASI it panics when `TMPDIR`
/// is unset, which is the case in Zed's extension sandbox.
fn cache_dir() -> Result<std::path::PathBuf> {
    let base = std::env::var_os("HOME")
        .or_else(|| std::env::var_os("USERPROFILE"))
        .map(|home| std::path::PathBuf::from(home).join(".cache").join("zed-pascal"))
        .or_else(|| std::env::current_dir().ok())
        .ok_or_else(|| "no writable cache directory found".to_string())?;
    std::fs::create_dir_all(&base)
        .map_err(|e| format!("failed to create `{}`: {e}", base.display()))?;
    Ok(base)
}

/// Recursively finds the binary named `binary_name` inside `dir`.
fn find_binary(dir: &std::path::Path, binary_name: &str) -> Option<std::path::PathBuf> {
    for entry in std::fs::read_dir(dir).ok()?.flatten() {
        let path = entry.path();
        if path.is_dir() {
            if let Some(found) = find_binary(&path, binary_name) {
                return Some(found);
            }
        } else if path.file_name()?.to_string_lossy() == binary_name {
            return Some(path);
        }
    }
    None
}

/// Downloads the given `pasls` release asset from the latest release of
/// [`PASLS_REPO`], extracts it into a cache directory, marks the binary
/// executable, and returns the path to it.
fn download_pasls(asset_name: &str) -> Result<String> {
    let binary_name = if cfg!(windows) { "pasls.exe" } else { "pasls" };
    let dir = cache_dir()?;
    let cache_path = dir.join(binary_name);
    if cache_path.is_file() {
        // Re-mark executable: an older version may have cached the binary
        // without the exec bit.
        zed::make_file_executable(&cache_path.to_string_lossy())
            .map_err(|e| format!("failed to make `{}` executable: {e}", cache_path.display()))?;
        return Ok(cache_path.to_string_lossy().into_owned());
    }

    let release = zed::latest_github_release(
        PASLS_REPO,
        zed::GithubReleaseOptions {
            require_assets: true,
            pre_release: false,
        },
    )
    .map_err(|e| format!("failed to fetch latest pasls release: {e}"))?;
    let asset = release
        .assets
        .iter()
        .find(|a| a.name == asset_name)
        .ok_or_else(|| format!("asset `{asset_name}` not found in latest pasls release"))?;

    let file_type = if asset_name.ends_with(".zip") {
        zed::DownloadedFileType::Zip
    } else if asset_name.ends_with(".tar.gz") {
        zed::DownloadedFileType::GzipTar
    } else {
        zed::DownloadedFileType::Uncompressed
    };
    let extract_dir = dir.join(asset_name);
    zed::download_file(&asset.download_url, &extract_dir.to_string_lossy(), file_type)
        .map_err(|e| format!("failed to download `{asset_name}`: {e}"))?;

    let extracted = find_binary(&extract_dir, binary_name)
        .ok_or_else(|| format!("`{binary_name}` not found in extracted `{asset_name}`"))?;
    std::fs::copy(&extracted, &cache_path)
        .map_err(|e| format!("failed to write `{}`: {e}", cache_path.display()))?;
    zed::make_file_executable(&cache_path.to_string_lossy())
        .map_err(|e| format!("failed to make `{}` executable: {e}", cache_path.display()))?;
    Ok(cache_path.to_string_lossy().into_owned())
}

/// Checks if a binary exists in the system's PATH or as an absolute/relative path.
///
/// # Arguments
/// * `command` - The name of the binary or path to check.
///
/// # Returns
/// `true` if the binary exists, `false` otherwise.
fn binary_exists(command: &str) -> bool {
    if command.contains(std::path::MAIN_SEPARATOR) || command.contains('/') {
        return std::path::Path::new(command).is_file();
    }
    std::env::var_os("PATH").map_or(false, |paths| {
        std::env::split_paths(&paths).any(|dir| {
            let candidate = dir.join(command);
            candidate.is_file()
                || std::path::Path::new(&format!("{}.exe", candidate.display())).is_file()
        })
    })
}

struct PascalExtension;

impl zed::Extension for PascalExtension {
    fn new() -> Self {
        PascalExtension
    }

    fn language_server_command(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let mut command = "pasls".to_string();
        let mut args = vec![];

        let (os, arch) = zed::current_platform();
        let home = std::env::var("HOME").unwrap_or_default();
        let (target_os, target_cpu, pp, fpcdir, lazarusdir): (&str, &str, &str, &str, String) =
            match os {
                Os::Mac => match arch {
                    Architecture::Aarch64 => (
                        "darwin",
                        "aarch64",
                        "/opt/homebrew/bin/fpc",
                        "/opt/homebrew/share/fpcsrc",
                        "/usr/local/share/lazarus".to_string(),
                    ),
                    _ => (
                        "darwin",
                        "x86_64",
                        "/usr/local/bin/fpc",
                        "/usr/local/share/fpcsrc",
                        "/usr/local/share/lazarus".to_string(),
                    ),
                },
                Os::Linux => (
                    "linux",
                    match arch {
                        Architecture::Aarch64 => "aarch64",
                        _ => "x86_64",
                    },
                    "/usr/bin/fpc",
                    "/usr/share/fpcsrc",
                    format!("{home}/.lazarus"),
                ),
                Os::Windows => (
                    "win32",
                    "x86_64",
                    r"C:\FPC\bin\x86_64-win64\fpc.exe",
                    r"C:\Source",
                    r"C:\lazarus".to_string(),
                ),
            };
        let mut env = vec![
            ("PP".to_string(), pp.to_string()),
            ("FPCDIR".to_string(), fpcdir.to_string()),
            ("LAZARUSDIR".to_string(), lazarusdir.to_string()),
            ("FPCTARGET".to_string(), target_os.to_string()),
            ("FPCTARGETCPU".to_string(), target_cpu.to_string()),
        ];

        if let Ok(lsp_settings) = LspSettings::for_worktree(language_server_id.as_ref(), worktree) {
            if let Some(binary) = lsp_settings.binary {
                if let Some(path) = binary.path {
                    command = path;
                }
                if let Some(binary_args) = binary.arguments {
                    args = binary_args;
                }

                if let Some(binary_env) = binary.env {
                    for (key, value) in binary_env {
                        if let Some(existing) = env.iter_mut().find(|item| item.0 == key) {
                            existing.1 = value;
                        } else {
                            env.push((key, value));
                        }
                    }
                }
            }
        }

        if command == "pasls" {
            if let Some(asset) = pasls_asset_name(os, arch) {
                if let Ok(path) = download_pasls(asset) {
                    command = path;
                }
            }
        }

        if !binary_exists(&command) {
            let hint = if pasls_asset_name(os, arch).is_none() {
                "No prebuilt pasls binary is published for this platform. Install pasls manually or set `lsp.pasls.binary.path` in settings."
            } else {
                "`pasls` not found in PATH and download failed. Install pasls or set `lsp.pasls.binary.path` in settings."
            };
            return Err(format!("`{command}` not found. {hint}"));
        }

        Ok(zed::Command { command, args, env })
    }

    fn language_server_initialization_options(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<Option<zed::serde_json::Value>> {
        // Fetch the settings for `pasls` in the current workspace
        let settings = LspSettings::for_worktree(language_server_id.as_ref(), worktree)
            .ok()
            .and_then(|lsp_settings| lsp_settings.initialization_options.clone());

        Ok(settings)
    }
}

zed::register_extension!(PascalExtension);
