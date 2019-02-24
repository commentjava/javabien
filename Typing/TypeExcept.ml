exception WrongType of string
exception ClassAlreadyDefined of string
exception MethodAlreadyDefined of string * Type.t
exception VariableAlreadyDefined of string
exception AlreadyDeclared of string
exception NoSuchConstructor of string

(* There should be much more exceptions *)