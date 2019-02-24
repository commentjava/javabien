exception AlreadyDeclared of string
exception ClassAlreadyDefined of string
exception ConstructorAlreadyDefined of string
exception InvalidConstructorName of string * Location.t * string
exception MethodAlreadyDefined of string * Type.t
exception NoSuchConstructor of string
exception VariableAlreadyDefined of string
exception WrongType of string

(* There should be much more exceptions *)

let print_error error =
  let colorRed = "\x1b[0;31m" in
  let colorReset = "\x1b[0m" in
  match error with
  | InvalidConstructorName(cname, cloc, class_name) -> (
      print_string (colorRed ^ "Invalid constructor " ^ cname ^ " for class " ^ class_name ^ "\n");
      print_string "@ ";
      Location.print cloc;
      print_string colorReset;
  )
  | _ as e -> raise(e)
;;