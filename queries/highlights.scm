;; Aligned with tree-sitter-java/queries/highlights.scm for consistency

; Function declarations
(function_declaration
  (simple_identifier) @function.method)

; Constructors
(constructor_invocation
  (user_type
    (type_identifier) @constructor))
(primary_constructor) @constructor
(secondary_constructor
  ("constructor") @constructor)

; Annotation symbol - will be overridden by specific annotation rules
"@" @operator

; Types

(type_identifier) @type

; Built-in types
((type_identifier) @type.builtin
  (#any-of? @type.builtin
    "Byte" "Short" "Int" "Long" "UByte" "UShort" "UInt" "ULong"
    "Float" "Double" "Boolean" "Char" "String" "Unit" "Nothing"
    "Array" "ByteArray" "ShortArray" "IntArray" "LongArray"
    "UByteArray" "UShortArray" "UIntArray" "ULongArray"
    "FloatArray" "DoubleArray" "BooleanArray" "CharArray"
    "Map" "Set" "List" "MutableMap" "MutableSet" "MutableList"))

; Constants

(enum_entry
  (simple_identifier) @constant)

((simple_identifier) @constant
 (#match? @constant "^[A-Z][A-Z0-9_]*$"))

; Builtins

(this_expression) @variable.builtin
((simple_identifier) @variable.builtin
  (#eq? @variable.builtin "it"))
((simple_identifier) @variable.builtin
  (#eq? @variable.builtin "field"))

; Built-in functions
(call_expression
  . (simple_identifier) @function.builtin
    (#any-of? @function.builtin
      "arrayOf" "arrayOfNulls" "byteArrayOf" "shortArrayOf" "intArrayOf" 
      "longArrayOf" "floatArrayOf" "doubleArrayOf" "booleanArrayOf" "charArrayOf"
      "emptyArray" "mapOf" "setOf" "listOf" "emptyMap" "emptySet" "emptyList"
      "mutableMapOf" "mutableSetOf" "mutableListOf"
      "print" "println" "error" "TODO" "run" "runCatching" "repeat"
      "lazy" "lazyOf" "enumValues" "enumValueOf" "assert" "check" 
      "checkNotNull" "require" "requireNotNull" "with" "suspend" "synchronized"))

; Literals

[
  (integer_literal)
  (long_literal)
  (hex_literal)
  (bin_literal)
  (unsigned_literal)
] @number

(real_literal) @number

[
  (character_literal)
  (string_literal)
] @string
(character_escape_seq) @string.escape

[
  (boolean_literal)
  (null_literal)
] @constant.builtin

[
  (line_comment)
  (multiline_comment)
  (shebang_line)
] @comment

; Keywords - using modifier nodes as in original

[
  (class_modifier)
  (member_modifier)
  (function_modifier)
  (property_modifier)
  (platform_modifier)
  (variance_modifier)
  (parameter_modifier)
  (visibility_modifier)
  (reification_modifier)
  (inheritance_modifier)
] @keyword

[
  "val"
  "var"
  "enum"
  "class"
  "object"
  "interface"
] @keyword

("fun") @keyword.function
("typealias") @keyword

[
  "if"
  "else" 
  "when"
] @conditional

[
  "for"
  "do"
  "while"
] @repeat

[
  "try"
  "catch"
  "throw"
  "finally"
] @exception

(jump_expression) @keyword.return

; Operators
[
  "!"
  "!="
  "!=="
  "="
  "=="
  "==="
  ">"
  ">="
  "<"
  "<="
  "||"
  "&&"
  "+"
  "++"
  "+="
  "-"
  "--"
  "-="
  "*"
  "*="
  "/"
  "/="
  "%"
  "%="
  "?."
  "?:"
  "!!"
  "is"
  "!is"
  "in"
  "!in"
  "as"
  "as?"
  ".."
  "->"
] @operator

; Punctuation
[
  ";"
  ","
  "."
  "::"
] @punctuation.delimiter

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

; Variables

(parameter
  (simple_identifier) @variable.parameter)
(parameter_with_optional_type
  (simple_identifier) @variable.parameter)
(lambda_literal
  (lambda_parameters
    (variable_declaration
      (simple_identifier) @variable.parameter)))

(variable_declaration
  (simple_identifier) @variable)

(property_declaration
  (variable_declaration
    (simple_identifier) @property))

(class_parameter
  (simple_identifier) @property)

; General navigation suffix (for properties) - placed after more specific rules
(_
  (navigation_suffix
    (simple_identifier) @property))

; Import and package
(package_header
  . (identifier) @namespace)

(import_header
  "import" @include)

; Generic parameters - handled through type_identifier nodes

; String interpolation
(string_literal
  "$" @punctuation.special
  (interpolated_identifier) @none)
(string_literal
  "${" @punctuation.special
  (interpolated_expression) @none
  "}" @punctuation.special)

; Labels
(label) @label

; Method calls - placed at end for higher priority over property rules
(call_expression
  . (simple_identifier) @function.method)
(call_expression
  (navigation_expression
    (navigation_suffix
      (simple_identifier) @function.method) . ))
(super_expression) @function.builtin

; Annotations - placed at end for highest priority over type rules
(annotation
  "@" @attribute)
(annotation
  (user_type
    (type_identifier) @attribute))
(annotation
  (constructor_invocation
    (user_type
      (type_identifier) @attribute)))