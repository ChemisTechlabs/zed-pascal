# Pascal language

A Pascal Language extension for Zed Editor.

| Feature                | Status                                                                     |
| ---------------------- | -------------------------------------------------------------------------- |
| Grammar (highlighting) | [tree-sitter-pascal](https://github.com/ChemisTechlabs/tree-sitter-pascal) |
| Language Server        | [pasls](https://github.com/genericptr/pascal-language-server)              |
| Linter                 | Planned                                                                    |
| Formatter              | Planned                                                                    |

## Language server (pasls)

On supported platforms the extension downloads a prebuilt `pasls` binary from
the [pascal-language-server releases](https://github.com/ChemisTechlabs/pascal-language-server/releases)
on first use and caches it. **No prebuilt binary is available for macOS Intel
(x86_64) or Windows ARM64** — on those platforms, install
[pasls](https://github.com/ChemisTechlabs/pascal-language-server) manually on
`PATH` (download a release binary or build from source, then symlink it into
a directory on `PATH`), or set `lsp.pascal.binary.path`.

The extension spawns `pasls` from `PATH` and sets per-platform defaults
automatically:

| Env            | Linux               | macOS (ARM)                  | macOS (Intel)              | Windows                           |
| -------------- | ------------------- | ---------------------------- | -------------------------- | --------------------------------- |
| `PP`           | `/usr/bin/fpc`      | `/opt/homebrew/bin/fpc`      | `/usr/local/bin/fpc`       | `C:\FPC\bin\x86_64-win64\fpc.exe` |
| `FPCDIR`       | `/usr/share/fpcsrc` | `/opt/homebrew/share/fpcsrc` | `/usr/local/share/fpcsrc`  | `C:\Source`                       |
| `LAZARUSDIR`   | `$HOME/.lazarus`    | `/usr/local/share/lazarus`   | `/usr/local/share/lazarus` | `C:\lazarus`                      |
| `FPCTARGET`    | `linux`             | `darwin`                     | `darwin`                   | `win32`                           |
| `FPCTARGETCPU` | `x86_64`/`aarch64`  | `aarch64`                    | `x86_64`                   | `x86_64`                          |

Any of them can be overridden in Zed settings under
`lsp.pascal-language-server.binary.env`, for example:

```json
"lsp": {
  "pascal": {
    "binary": {
      "path": "/opt/homebrew/bin/pasls",
      "env": {
        "PP": "/opt/homebrew/bin/fpc",
        "FPCDIR": "/opt/homebrew/share/fpcsrc",
        "LAZARUSDIR": "~/Lazarus"
      }
    }
  }
}
```

- `PP` — path to the Free Pascal compiler binary.
- `FPCDIR` — Free Pascal source directory.
- `LAZARUSDIR` — Lazarus IDE directory.
- `binary.path` / `binary.arguments` — override the pasls binary and args.
