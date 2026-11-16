; Injections: SQL inside string literals (FireDAC / dbExpress / IBX code
; carries a lot of SQL in strings).
;
; Adapted from tree-sitter-delphi13 (MIT License,
; https://github.com/Alexl-git/tree-sitter-delphi13) and checked against the
; tree-sitter-pascal revision pinned in extension.toml.
;
; Matching is anchored at the start of the literal and needs a PAIRED keyword
; (SELECT..FROM, UPDATE..SET, INSERT INTO, DELETE FROM, CREATE/ALTER/DROP
; <object>, EXECUTE PROCEDURE/BLOCK, MERGE INTO), so prose such as
; 'Select a file to continue' is not painted as SQL.
;
; No inline `(?i)` flag on purpose: native tree-sitter (Rust regex) accepts it,
; but web-tree-sitter hands the pattern to JavaScript RegExp, which rejects it
; and takes the whole query file down. Case-insensitivity is spelled out as
; [Ss][Ee][Ll]... classes, which both engines accept.
((literalString) @injection.content
  (#match? @injection.content "^'\\s*([Ss][Ee][Ll][Ee][Cc][Tt]\\b[\\s\\S]*\\b[Ff][Rr][Oo][Mm]\\b|[Ii][Nn][Ss][Ee][Rr][Tt]\\s+[Ii][Nn][Tt][Oo]\\b|[Uu][Pp][Dd][Aa][Tt][Ee]\\b[\\s\\S]*\\b[Ss][Ee][Tt]\\b|[Dd][Ee][Ll][Ee][Tt][Ee]\\s+[Ff][Rr][Oo][Mm]\\b|[Cc][Rr][Ee][Aa][Tt][Ee]\\s+([Oo][Rr]\\s+[Aa][Ll][Tt][Ee][Rr]\\s+)?([Tt][Aa][Bb][Ll][Ee]|[Vv][Ii][Ee][Ww]|[Ii][Nn][Dd][Ee][Xx]|[Pp][Rr][Oo][Cc][Ee][Dd][Uu][Rr][Ee]|[Tt][Rr][Ii][Gg][Gg][Ee][Rr]|[Gg][Ee][Nn][Ee][Rr][Aa][Tt][Oo][Rr]|[Ss][Ee][Qq][Uu][Ee][Nn][Cc][Ee]|[Dd][Oo][Mm][Aa][Ii][Nn]|[Ee][Xx][Cc][Ee][Pp][Tt][Ii][Oo][Nn])\\b|[Aa][Ll][Tt][Ee][Rr]\\s+([Tt][Aa][Bb][Ll][Ee]|[Vv][Ii][Ee][Ww]|[Ii][Nn][Dd][Ee][Xx]|[Pp][Rr][Oo][Cc][Ee][Dd][Uu][Rr][Ee]|[Tt][Rr][Ii][Gg][Gg][Ee][Rr]|[Dd][Aa][Tt][Aa][Bb][Aa][Ss][Ee])\\b|[Dd][Rr][Oo][Pp]\\s+([Tt][Aa][Bb][Ll][Ee]|[Vv][Ii][Ee][Ww]|[Ii][Nn][Dd][Ee][Xx]|[Pp][Rr][Oo][Cc][Ee][Dd][Uu][Rr][Ee]|[Tt][Rr][Ii][Gg][Gg][Ee][Rr]|[Gg][Ee][Nn][Ee][Rr][Aa][Tt][Oo][Rr]|[Ss][Ee][Qq][Uu][Ee][Nn][Cc][Ee]|[Dd][Oo][Mm][Aa][Ii][Nn]|[Ee][Xx][Cc][Ee][Pp][Tt][Ii][Oo][Nn])\\b|[Ee][Xx][Ee][Cc][Uu][Tt][Ee]\\s+([Pp][Rr][Oo][Cc][Ee][Dd][Uu][Rr][Ee]|[Bb][Ll][Oo][Cc][Kk]|[Ss][Tt][Aa][Tt][Ee][Mm][Ee][Nn][Tt])\\b|[Mm][Ee][Rr][Gg][Ee]\\s+[Ii][Nn][Tt][Oo]\\b)")
  (#set! injection.language "sql"))
