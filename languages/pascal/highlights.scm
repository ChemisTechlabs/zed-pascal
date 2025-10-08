; Pascal Keywords
[
  (kProgram)
  (kLibrary)
  (kUnit)
  (kUses)
  (kBegin)
  (kEnd)
  (kAsm)
  (kVar)
  (kThreadvar)
  (kConst)
  (kResourcestring)
  (kConstref)
  (kOut)
  (kType)
  (kLabel)
  (kExports)
  (kAbsolute)
  (kProperty)
  (kRead)
  (kWrite)
  (kImplements)
  (kDefault)
  (kNodefault)
  (kStored)
  (kIndex)
  (kDispId)
  (kClass)
  (kInterface)
  (kDispInterface)
  (kObject)
  (kRecord)
  (kObjcclass)
  (kObjccategory)
  (kObjcprotocol)
  (kArray)
  (kFile)
  (kString)
  (kSet)
  (kOf)
  (kHelper)
  (kPacked)
  (kGeneric)
  (kSpecialize)
  (kFunction)
  (kProcedure)
  (kConstructor)
  (kDestructor)
  (kOperator)
  (kReference)
  (kImplementation)
  (kInitialization)
  (kFinalization)
  (kPublished)
  (kPublic)
  (kProtected)
  (kPrivate)
  (kStrict)
  (kRequired)
  (kOptional)
  (kForward)
  (kStatic)
  (kVirtual)
  (kAbstract)
  (kSealed)
  (kDynamic)
  (kOverride)
  (kOverload)
  (kReintroduce)
  (kInherited)
  (kInline)
  (kStdcall)
  (kCdecl)
  (kCppdecl)
  (kPascal)
  (kRegister)
  (kMwpascal)
  (kExternal)
  (kName)
  (kMessage)
  (kDeprecated)
  (kExperimental)
  (kPlatform)
  (kUnimplemented)
  (kCvar)
  (kExport)
  (kFar)
  (kNear)
  (kSafecall)
  (kAssembler)
  (kNostackframe)
  (kInterrupt)
  (kNoreturn)
  (kIocheck)
  (kLocal)
  (kHardfloat)
  (kSoftfloat)
  (kMs_abi_default)
  (kMs_abi_cdecl)
  (kSaveregisters)
  (kSysv_abi_default)
  (kSysv_abi_cdecl)
  (kVectorcall)
  (kVarargs)
  (kWinapi)
  (kAlias)
  (kDelayed)
  (kFor)
  (kTo)
  (kDownto)
  (kIf)
  (kThen)
  (kElse)
  (kDo)
  (kWhile)
  (kRepeat)
  (kUntil)
  (kTry)
  (kExcept)
  (kFinally)
  (kRaise)
  (kOn)
  (kCase)
  (kWith)
  (kGoto)
  (kOr)
  (kXor)
  (kDiv)
  (kMod)
  (kAnd)
  (kShl)
  (kShr)
  (kNot)
  (kIs)
  (kAs)
  (kIn)
  (kNil)
] @keyword

; Builtin constants
[
  (kTrue)
  (kFalse)
] @boolean

; Punctuation - brackets
[
  "("
  ")"
  "["
  "]"
] @punctuation.bracket

; Punctuation - delimiters
[
  ";"
  ","
  ":"
  ".."
  (kEndDot)
] @punctuation.delimiter

; Operators
[
  (kDot)
  (kAdd)
  (kSub)
  (kMul)
  (kFdiv)
  (kAssign)
  (kAssignAdd)
  (kAssignSub)
  (kAssignMul)
  (kAssignDiv)
  (kEq)
  (kLt)
  (kLte)
  (kGt)
  (kGte)
  (kNeq)
  (kAt)
  (kHat)
] @operator

; Literals
(literalNumber) @number
(literalString) @string

; Comments and preprocessor
(comment) @comment
(pp) @preproc

; Type declarations
(declType name: (identifier) @type)
(declType name: (genericTpl entity: (identifier) @type))

; Function and procedure declarations
(declProc name: (identifier) @function)
(declProc name: (genericTpl entity: (identifier) @function))
(declProc name: (genericDot rhs: (identifier) @function))
(declProc name: (genericDot rhs: (genericTpl entity: (identifier) @function)))

; Property declarations
(declProp name: (identifier) @property)

; Function parameters
(declArg name: (identifier) @variable)

; Template parameters
(genericArg name: (identifier) @type)
(genericArg type: (typeref) @type)

; Exception parameters
(exceptionHandler variable: (identifier) @variable)

; Type references - more specific patterns first
(typeref (identifier) @type)
(declString (kString) @type)
(declArray (kArray) @type)
(declFile (kFile) @type)
(declSet (kSet) @type)
(declMetaClass (kClass) @type)

; General type references
(typeref) @type

; Constants and labels
[
  (caseLabel)
  (label)
] @constant

; Variable and constant declarations
(declVar name: (identifier) @variable)
(declField name: (identifier) @property)
(declConst name: (identifier) @constant)
(declEnumValue name: (identifier) @constant)

; Function calls
(exprCall (identifier) @function)
(exprCall entity: (exprTpl entity: (identifier) @function))
(exprCall entity: (exprDot rhs: (identifier) @function))
(exprCall entity: (exprDot rhs: (exprTpl entity: (identifier) @function)))

; Dot notation field access
(exprDot rhs: (identifier) @property)

; Generic types and functions
(genericDot (identifier) @type)
(genericDot (genericTpl entity: (identifier) @type))

; Exit, Break, Continue statements
(statement ((identifier) @keyword
  (#match? @keyword "^[eE][xX][iI][tT]$")))
(statement (exprCall entity: ((identifier) @keyword
  (#match? @keyword "^[eE][xX][iI][tT]$"))))
(statement ((identifier) @keyword
  (#match? @keyword "^[bB][rR][eE][aA][kK]$")))
(statement ((identifier) @keyword
  (#match? @keyword "^[cC][oO][nN][tT][iI][nN][uU][eE]$")))

; Program/Unit/Library names - highlight like Go package names
(program (moduleName (identifier) @namespace))
(unit (moduleName (identifier) @namespace))
(library (moduleName (identifier) @namespace))

; Variable type references in declarations
(declVar type: (type (typeref (identifier) @type)))
(declVar type: (type (declString (kString) @type)))
(declVar type: (type (declArray (kArray) @type)))
(declVar type: (type (declFile (kFile) @type)))
(declVar type: (type (declSet (kSet) @type)))

; Statement with single identifier - highlight as function call
(statement (identifier) @function)

; Default identifier highlighting
(identifier) @variable
