; Override scopes for Zed. These give the `not_in = ["string"]` entries in
; config.toml a scope to refer to (so `{`, `(*` and quotes do not auto-close
; inside a string), and mark comments so completions stay quiet there.
;
; Contributed alongside the queries adapted from tree-sitter-delphi13
; (MIT License, https://github.com/Alexl-git/tree-sitter-delphi13).

(comment) @comment.inclusive
(literalString) @string
