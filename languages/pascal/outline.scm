; Program declaration
(program 
  (kProgram) @context
  (moduleName (identifier) @name)) @item

; Unit declaration
(unit
  (kUnit) @context
  (moduleName (identifier) @name)) @item

; Library declaration  
(library
  (kLibrary) @context
  (moduleName (identifier) @name)) @item

; Procedure declarations
(declProc
  (kProcedure) @context
  name: (identifier) @name) @item

; Function declarations
(declProc
  (kFunction) @context
  name: (identifier) @name) @item

; Constructor declarations
(declProc
  (kConstructor) @context
  name: (identifier) @name) @item

; Destructor declarations
(declProc
  (kDestructor) @context
  name: (identifier) @name) @item

; Type declarations
(declType
  name: (identifier) @name) @item

; Class declarations
(declType
  name: (identifier) @name
  type: (declClass
    (kClass) @context)) @item

; Record declarations
(declType
  name: (identifier) @name
  type: (declClass
    (kRecord) @context)) @item

; Interface declarations
(declType
  name: (identifier) @name
  type: (declIntf
    (kInterface) @context)) @item

; Object declarations
(declType
  name: (identifier) @name
  type: (declClass
    (kObject) @context)) @item

; Constant declarations
(declConst
  name: (identifier) @name) @item

; Variable declarations
(declVar
  name: (identifier) @name) @item

; Property declarations
(declProp
  name: (identifier) @name) @item

; Interface section
(interface) @item

; Implementation section
(implementation) @item

; Initialization section
(initialization) @item

; Finalization section
(finalization) @item
