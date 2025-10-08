; Root scope
(root) @local.scope

; Procedure and function scopes
(defProc) @local.scope
(lambda) @local.scope
(interface (declProc) @local.scope)
(declSection (declProc) @local.scope)
(declClass (declProc) @local.scope)  
(declHelper (declProc) @local.scope)
(declProcRef) @local.scope

; Exception handler scopes
(exceptionHandler) @local.scope
(exceptionHandler variable: (identifier) @local.definition)

; Variable and parameter definitions
(declArg name: (identifier) @local.definition)
(declVar name: (identifier) @local.definition)
(declConst name: (identifier) @local.definition)
(declLabel name: (identifier) @local.definition)
(genericArg name: (identifier) @local.definition)
(declEnumValue name: (identifier) @local.definition)
(declType name: (identifier) @local.definition)
(declType name: (genericTpl entity: (identifier) @local.definition))

; Procedure/function definitions
(declProc name: (identifier) @local.definition)

; Identifier references
(identifier) @local.reference