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
] @constant.builtin

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
(declProp name: (identifier) @function)

; Function parameters
(declArg name: (identifier) @parameter)

; Template parameters
(genericArg name: (identifier) @type.parameter)
(genericArg type: (typeref) @type)

; Exception parameters
(exceptionHandler variable: (identifier) @parameter)

; Type references
(typeref) @type

; Constants and labels
[
  (caseLabel)
  (label)
] @constant

; Variable and constant declarations
(declVar name: (identifier) @variable)
(declField name: (identifier) @variable)
(declConst name: (identifier) @constant)
(declEnumValue name: (identifier) @constant)

; Function calls
(exprCall entity: (identifier) @function.call)
(exprCall entity: (exprTpl entity: (identifier) @function.call))
(exprCall entity: (exprDot rhs: (identifier) @function.call))
(exprCall entity: (exprDot rhs: (exprTpl entity: (identifier) @function.call)))

; Generic types and functions
(genericDot (identifier) @type)
(genericDot (genericTpl entity: (identifier) @type))

; Exit, Break, Continue statements
(statement ((identifier) @keyword.control
  (#match? @keyword.control "^[eE][xX][iI][tT]$")))
(statement (exprCall entity: ((identifier) @keyword.control
  (#match? @keyword.control "^[eE][xX][iI][tT]$"))))
(statement ((identifier) @keyword.control
  (#match? @keyword.control "^[bB][rR][eE][aA][kK]$")))
(statement ((identifier) @keyword.control
  (#match? @keyword.control "^[cC][oO][nN][tT][iI][nN][uU][eE]$")))

; Default identifier highlighting
(identifier) @variable