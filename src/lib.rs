use zed_extension_api::{
    self as zed, Architecture, LanguageServerId, Os, Result, settings::LspSettings,
};

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

        if !binary_exists(&command) {
            return Err(format!(
                "`{command}` not found in PATH. Install pasls or set `lsp.pasls.binary.path` in settings."
            ));
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
