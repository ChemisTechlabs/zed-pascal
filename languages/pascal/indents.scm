; Begin/end blocks
(block (kEnd) @end) @indent

; Procedure and function bodies
(defProc body: (block (kEnd) @end)) @indent

; Class and record declarations
(declClass (kEnd) @end) @indent

; Case statements
(case (kEnd) @end) @indent

; Try/except/finally blocks
(try (kEnd) @end) @indent

; Repeat/until loops
(repeat (kUntil) @end) @indent

; Interface and implementation sections
(interface) @indent
(implementation) @indent

; If/then/else statements (indent the then/else parts)
(if then: (_) @indent)
(ifElse then: (_) @indent)
(ifElse else: (_) @indent)

; While/do loops
(while body: (_) @indent)

; For loops
(for body: (_) @indent)
(foreach body: (_) @indent)

; With statements
(with body: (_) @indent)

; Asm blocks
(asm (kEnd) @end) @indent

; Declaration sections - indent their contents
(declSection (_) @indent)

; Var/const/type sections - indent their contents
(declVars (_) @indent)
(declConsts (_) @indent)
(declTypes (_) @indent)
