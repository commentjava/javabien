exception AlreadyDeclared of string
exception ClassAlreadyDefined of string
exception InvalidConstructorName of string * string
exception MethodAlreadyDefined of string * Type.t
exception NoSuchConstructor of string
exception VariableAlreadyDefined of string
exception WrongType of string

(* There should be much more exceptions *)