use zed_extension_api::{
    self as zed, Architecture, LanguageServerId, Os, Result, settings::LspSettings,
};

/// Repo publishing prebuilt `pasls` binaries.
const PASLS_REPO: &str = "ChemisTechlabs/pascal-language-server";

/// Prebuilt `pasls` asset for the platform, if one is published.
fn pasls_asset_name(os: Os, arch: Architecture) -> Option<&'static str> {
    match (os, arch) {
        (Os::Mac, Architecture::Aarch64) => Some("pasls-aarch64-darwin.zip"),
        (Os::Mac, _) => None,
        (Os::Linux, Architecture::Aarch64) => Some("pasls-aarch64-linux.tar.gz"),
        (Os::Linux, _) => Some("pasls-x86_64-linux.tar.gz"),
        (Os::Windows, Architecture::Aarch64) => None,
        (Os::Windows, _) => Some("pasls-x86_64-win64.zip"),
    }
}

/// Deletes old `pasls-*` dirs, keeping only `version_dir`.
fn remove_outdated_versions(version_dir: &str) -> Result<()> {
    let entries = std::fs::read_dir(".")
        .map_err(|e| format!("failed to list the extension working directory: {e}"))?;
    for entry in entries {
        let entry = entry.map_err(|e| format!("failed to load directory entry: {e}"))?;
        if entry
            .file_name()
            .to_str()
            .is_none_or(|name| name.starts_with("pasls-") && name != version_dir)
        {
            std::fs::remove_dir_all(entry.path()).ok();
        }
    }
    Ok(())
}

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

/// `PATH` lookup goes through `Worktree::which` (host-side; WASM has no env).
fn binary_exists(worktree: &zed::Worktree, command: &str) -> bool {
    if command.contains(std::path::MAIN_SEPARATOR) || command.contains('/') {
        return std::path::Path::new(command).is_file();
    }
    worktree.which(command).is_some()
}

/// Downloads and caches the `pasls` release asset; returns the binary path.
fn download_pasls(language_server_id: &LanguageServerId, asset_name: &str) -> Result<String> {
    let (os, _) = zed::current_platform();
    let binary_name = if matches!(os, Os::Windows) {
        "pasls.exe"
    } else {
        "pasls"
    };

    zed::set_language_server_installation_status(
        language_server_id,
        &zed::LanguageServerInstallationStatus::CheckingForUpdate,
    );
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

    let version_dir = format!("pasls-{}", release.version);
    std::fs::create_dir_all(&version_dir)
        .map_err(|e| format!("failed to create `{version_dir}`: {e}"))?;
    let cache_path = std::path::PathBuf::from(&version_dir).join(binary_name);
    if cache_path.is_file() {
        zed::make_file_executable(&cache_path.to_string_lossy())
            .map_err(|e| format!("failed to make `{}` executable: {e}", cache_path.display()))?;
        remove_outdated_versions(&version_dir)?;
        return Ok(cache_path.to_string_lossy().into_owned());
    }

    zed::set_language_server_installation_status(
        language_server_id,
        &zed::LanguageServerInstallationStatus::Downloading,
    );
    let file_type = if asset_name.ends_with(".zip") {
        zed::DownloadedFileType::Zip
    } else if asset_name.ends_with(".tar.gz") {
        zed::DownloadedFileType::GzipTar
    } else {
        zed::DownloadedFileType::Uncompressed
    };
    let extract_dir = std::path::PathBuf::from(&version_dir).join(asset_name);
    zed::download_file(
        &asset.download_url,
        &extract_dir.to_string_lossy(),
        file_type,
    )
    .map_err(|e| format!("failed to download `{asset_name}`: {e}"))?;

    let extracted = find_binary(&extract_dir, binary_name)
        .ok_or_else(|| format!("`{binary_name}` not found in extracted `{asset_name}`"))?;
    std::fs::copy(&extracted, &cache_path)
        .map_err(|e| format!("failed to write `{}`: {e}", cache_path.display()))?;
    zed::make_file_executable(&cache_path.to_string_lossy())
        .map_err(|e| format!("failed to make `{}` executable: {e}", cache_path.display()))?;
    remove_outdated_versions(&version_dir)?;
    Ok(cache_path.to_string_lossy().into_owned())
}

struct PascalExtension {
    cached_binary_path: Option<String>,
}

impl zed::Extension for PascalExtension {
    fn new() -> Self {
        PascalExtension {
            cached_binary_path: None,
        }
    }

    fn language_server_command(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let mut command = "pasls".to_string();
        let mut args = vec![];
        let mut env: Vec<(String, String)> = vec![];

        let (os, arch) = zed::current_platform();

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
            if let Some(path) = worktree.which("pasls") {
                command = path;
            } else if let Some(path) = self
                .cached_binary_path
                .clone()
                .filter(|path| std::path::Path::new(path).is_file())
            {
                command = path;
            } else if let Some(asset) = pasls_asset_name(os, arch)
                && let Ok(path) = download_pasls(language_server_id, asset)
            {
                self.cached_binary_path = Some(path.clone());
                command = path;
            }
        }

        if !binary_exists(worktree, &command) {
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
        let settings = LspSettings::for_worktree(language_server_id.as_ref(), worktree)
            .ok()
            .and_then(|lsp_settings| lsp_settings.initialization_options.clone());

        Ok(settings)
    }
}

zed::register_extension!(PascalExtension);
