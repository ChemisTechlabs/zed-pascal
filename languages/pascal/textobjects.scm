; Text objects: structural selection and navigation (vim-mode `vif` / `vaf` /
; `vic` / `vac`, "select inside/around function").
;
; Adapted from tree-sitter-delphi13 (MIT License,
; https://github.com/Alexl-git/tree-sitter-delphi13) and checked against the
; tree-sitter-pascal revision pinned in extension.toml.
;
; `around` spans the whole construct; `inside` spans its body only.

; Implemented routines: `inside` is everything between begin and end.
(defProc
  body: (block
    (kBegin)
    (_)* @function.inside
    (kEnd))) @function.around

; Routine declarations (interface section, class members, forward decls).
(declProc) @function.around

; Anonymous methods.
(lambda
  (block
    (kBegin)
    (_)* @function.inside
    (kEnd))) @function.around

; class / record / object
(declType
  (declClass
    [(kClass) (kRecord) (kObject)]
    (_)* @class.inside
    (kEnd))) @class.around

; interface / dispinterface
(declType
  (declIntf
    [(kInterface) (kDispInterface)]
    (_)* @class.inside
    (kEnd))) @class.around

; class helper / record helper
(declType
  (declHelper
    (kFor)
    .
    (_)
    (_)* @class.inside
    (kEnd))) @class.around

; Comments
(comment)+ @comment.around
