; Parentheses and square brackets
("(" @open ")" @close)
("[" @open "]" @close)

; Record blocks
((kRecord) @open (kEnd) @close)

; Class blocks
((kClass) @open (kEnd) @close)

; Interface definitions
((kInterface) @open (kEnd) @close)
((kDispInterface) @open (kEnd) @close)

; Begin/end blocks
((kBegin) @open (kEnd) @close)
((kBegin) @open (kEndDot) @close)

; Case statement blocks
((kCase) @open (kElse) @close)
((kCase) @open (kEnd) @close)

; Try/finally/except blocks (staged)
((kTry) @open (kFinally) @close)
((kFinally) @open (kEnd) @close)

((kTry) @open (kExcept) @close)
((kExcept) @open (kEnd) @close)

; Try/finally/except blocks
((kTry) @open (kEnd) @close)

; Repeat/until blocks
((kRepeat) @open (kUntil) @close)

; Asm blocks
((kAsm) @open (kEnd) @close)
