; Parentheses and square brackets
("(" @open ")" @close)
("[" @open "]" @close)

; Begin/end blocks
((kBegin) @open (kEnd) @close)

; Case statement blocks  
((kCase) @open (kEnd) @close)

; Record blocks
((kRecord) @open (kEnd) @close)

; Class blocks
((kClass) @open (kEnd) @close)

; Try/except blocks
((kTry) @open (kEnd) @close)

; Repeat/until blocks
((kRepeat) @open (kUntil) @close)

; Interface/implementation sections
((kInterface) @open (kImplementation) @close)

; Asm blocks
((kAsm) @open (kEnd) @close)