; Program declaration
(program
    (kProgram) @context
    (moduleName) @name) @item

; Program uses - bucket
(program
    (declUses
        (kUses) @name) @item)

; Program uses module names
(program
    (declUses
        (moduleName) @name @item))

; Library declaration
(library
    (kLibrary) @context
    (moduleName) @name) @item

; Unit declaration
(unit
    (kUnit) @context
    (moduleName) @name) @item

; Interface - bucket
(interface
    (kInterface) @context) @item

; Interface uses - bucket
(interface
    (declUses
        (kUses) @name) @item)

; Interface uses module names
(interface
    (declUses
        (moduleName) @name @item))

; Implementation - bucket
(implementation
    (kImplementation) @context) @item

; Implementation uses - bucket
(implementation
    (declUses
        (kUses) @name) @item)

; Implementation uses module names
(implementation
    (declUses
        (moduleName) @name @item))

; Type declarations
(declTypes
    (kType) @name) @item

(declType
    (identifier) @name) @item

(declType
    (declClass
        (identifier) @name) @item)

; Visibility buckets (class/record sections)
(declSection
    (kPrivate) @name) @item

(declSection
    (kProtected) @name) @item

(declSection
    (kPublic) @name) @item

(declSection
    (kPublished) @name) @item

; makes sub nodes, need new idea here
;(declSection (kStrict) @context (kPrivate) @name) @item
;(declSection (kStrict) @context (kProtected) @name) @item

; Constructor declarations
(declProc
    (kConstructor) @context
    name: (_) @name) @item

; Destructor declarations
(declProc
    (kDestructor) @context
    name: (_) @name) @item

; Procedure declarations
(declProc
    (kProcedure) @context
    name: (_) @name) @item

; Function declarations
(declProc
    (kFunction) @context
    name: (_) @name) @item

; Constant declarations - buckets
(program
    (declConsts
        (kConst) @context) @item)

(interface
    (declConsts
        (kConst) @context) @item)

(implementation
    (declConsts
        (kConst) @context) @item)

; Constant declarations - identifiers
(program
    (declConsts
        (declConst
            name: (identifier) @name) @item))

(interface
    (declConsts
        (declConst
            name: (identifier) @name) @item))

(implementation
    (declConsts
        (declConst
            name: (identifier) @name) @item))

; Variable declarations - buckets
(program
    (declVars
        (kVar) @context) @item)

(interface
    (declVars
        (kVar) @context) @item)

(implementation
    (declVars
        (kVar) @context) @item)

; Variable declarations - identifiers
(program
    (declVars
        (declVar) @name @item))

(interface
    (declVars
        (declVar) @name @item))

(implementation
    (declVars
        (declVar) @name @item))

; Threadvar - buckets
(program
    (declVars
        (kThreadvar) @context) @item)

(interface
    (declVars
        (kThreadvar) @context) @item)

(implementation
    (declVars
        (kThreadvar) @context) @item)

; Resource string - buckets
(program
    (declConsts
        (kResourcestring) @context) @item)

(interface
    (declConsts
        (kResourcestring) @context) @item)

(implementation
    (declConsts
        (kResourcestring) @context) @item)

; Resourcestring identifiers use same node as const

; Field declarations
(declField) @name @item

; Property declarations
(declProp
    (kProperty) @context name: (identifier) @name) @item

; Program main block (shows as "begin end")
(program
    (block
        (kBegin) @context (kEnd) @name ) @item)

; Initialization section
(initialization
    (kInitialization) @context) @item

; Finalization section
(finalization
    (kFinalization) @context) @item
