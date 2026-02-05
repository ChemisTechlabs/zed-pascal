; Begin/end blocks
(block (kEnd) @end) @indent

; Declaration sections - var/const/type/uses indent their contents
(declUses (moduleName)) @indent
(declConsts (declConst)) @indent
(declTypes (declType)) @indent
(declVars (declVar)) @indent

; Inline var declaration
(varDef (kVar)) @indent
; Inline var declaration with assignment
(varAssignDef (kVar)) @indent

; Record type declaration
(declClass (kRecord) @start (kEnd) @end) @indent
; Variant record case statement
(declVariant (_)) @indent

; Helpers declaration
(declHelper (_) @start (kEnd) @end) @indent

; Classes / Interfaces
(declIntf (kEnd) @end) @indent

((declSection (_)) @indent)
;(declSection) @outdent
;(declClass (declSection)) @outdent

; Object type declaration
(declClass (kObject) @start (kEnd) @end) @indent

; Procedure and function bodies
;(defProc body: (block (kEnd) @end)) @indent
;begin/end handles it

; Try/except/finally blocks
(try (kFinally) @end) @indent
(try (kFinally) @start (kEnd) @end) @indent

(try (kExcept) @end) @indent
(try (kExcept) @start (kEnd) @end) @indent
(exceptionHandler (kDo)) @indent

; Repeat/until loops
(repeat (kUntil) @end) @indent

; For loops indent all, outdent begin end block
(for body: (block)) @outdent
(for body: (_)) @indent
(foreach body: (block)) @outdent
(foreach body: (_)) @indent

; While/do loops indent all, outdent begin end block
(while body: (block)) @outdent
(while body: (_)) @indent

; Case statements indent all, else, outdent begin end block
(case (kEnd) @end) @indent
(caseCase body: (block)) @outdent
(caseCase (_)) @indent
(case (kElse) @start (kEnd) @end) @indent

; If/then/else statements
(if then: (block)) @outdent
(if then: (_)) @indent

; ifElse statement
(ifElse then: (block)) @outdent
(ifElse then: (_) ) @indent
(ifElse else: (statement) @indent)
(ifElse else: (assignment) @end) @indent

; Anonymous method assigned to variable, indent following block
(assignment (lambda)) @indent

; With statements indent all, outdent begin end block
(with body: (block)) @outdent
(with body: (_)) @indent

; Asm blocks
(asm (kEnd) @end) @indent

; initialization/finalization blocks
(initialization (_)) @indent
(finalization (_)) @indent

(kEndDot) @outdent
