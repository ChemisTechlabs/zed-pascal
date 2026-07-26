use zed_extension_api::{self as zed, settings::LspSettings, Extension, LanguageServerId, Result};

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
        let mut command = "/usr/bin/pasls".to_string();
        let mut args = vec![];
        let mut env = vec![
            ("PP".to_string(), "/usr/bin/fpc".to_string()),
            ("FPCDIR".to_string(), "/usr/share/fpcsrc".to_string()),
            ("LAZARUSDIR".to_string(), "/home/.lazarus/Lazarus".to_string()),
            ("FPCTARGET".to_string(), "linux".to_string()),
            ("FPCTARGETCPU".to_string(), "x86_64".to_string()),
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
