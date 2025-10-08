; Program declaration
(declProgram 
  (kProgram) @context
  name: (identifier) @name) @item

; Unit declaration
(declUnit
  (kUnit) @context
  name: (identifier) @name) @item

; Library declaration  
(declLibrary
  (kLibrary) @context
  name: (identifier) @name) @item

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
  (kType) @context
  name: (identifier) @name) @item

; Class declarations
(declClass
  (kClass) @context
  name: (identifier) @name) @item

; Record declarations
(declRecord
  (kRecord) @context
  name: (identifier) @name) @item

; Interface declarations
(declInterface
  (kInterface) @context
  name: (identifier) @name) @item

; Object declarations
(declObject
  (kObject) @context
  name: (identifier) @name) @item

; Constant declarations
(declConst
  (kConst) @context
  name: (identifier) @name) @item

; Variable declarations
(declVar
  (kVar) @context
  name: (identifier) @name) @item

; Property declarations
(declProp
  (kProperty) @context
  name: (identifier) @name) @item

; Interface section
(interface
  (kInterface) @context
  @name) @item

; Implementation section
(implementation
  (kImplementation) @context
  @name) @item

; Initialization section
(initialization
  (kInitialization) @context
  @name) @item

; Finalization section
(finalization
  (kFinalization) @context
  @name) @item