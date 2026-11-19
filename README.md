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
a directory on `PATH`), or set `lsp.pasls.binary.path`.

The extension spawns `pasls` from `PATH` and passes it only the environment
variables you set. **No environment variables are set by default** — configure
the CodeTools environment your installation needs under
`lsp.pascal.binary.env`, for example:

```json
"lsp": {
  "pascal": {
    "binary": {
      "env": {
        "PP": "/usr/bin/fpc",
        "FPCDIR": "/usr/share/fpcsrc",
        "LAZARUSDIR": "/usr/local/share/lazarus"
      }
    }
  }
}
```

- `PP` — path to the Free Pascal compiler binary (e.g. `/usr/bin/fpc`).
- `FPCDIR` — Free Pascal source directory (e.g. `/usr/share/fpcsrc` on Debian/Ubuntu,
  `/usr/local/share/fpcsrc` from source or Homebrew).
- `LAZARUSDIR` — Lazarus sources directory (e.g. `/usr/local/share/lazarus`).
- `FPCTARGET` — target operating system (e.g. `linux`, `darwin`, `win32`).
- `FPCTARGETCPU` — target CPU (e.g. `x86_64`, `aarch64`).
