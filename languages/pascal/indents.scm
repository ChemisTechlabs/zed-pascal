; Begin/end blocks
(compoundStmt (kEnd) @end) @indent

; Procedure and function bodies
(defProc body: (compoundStmt (kEnd) @end)) @indent

; Class and record declarations
(declClass (kEnd) @end) @indent
(declRecord (kEnd) @end) @indent

; Case statements
(stmtCase (kEnd) @end) @indent

; Try/except/finally blocks
(stmtTry (kEnd) @end) @indent

; Repeat/until loops
(stmtRepeat (kUntil) @end) @indent

; Interface and implementation sections
(interface (kEnd) @end) @indent
(implementation (kEnd) @end) @indent

; If/then/else statements (indent the then/else parts)
(stmtIf consequence: (_) @indent)
(stmtIf alternative: (_) @indent)

; While/do loops
(stmtWhile body: (_) @indent)

; For loops  
(stmtFor body: (_) @indent)

; With statements
(stmtWith body: (_) @indent)

; Asm blocks
(asm (kEnd) @end) @indent

; Declaration sections
(declSection @indent)

; Var/const/type sections
(declVar @indent)
(declConst @indent)
(declType @indent)