open Parser
open Eval

let execute lexbuf verbose =
  try
    let ast = compilationUnit Lexer.token lexbuf in
    print_endline "successfull parsing";
    let typed_ast = TypeChecker.typing ast in
    if verbose then AST.print_program ast;
    execute_program ast
  with 
    | Error ->
      print_string "Syntax error: ";
      Location.print (Location.curr lexbuf)
    | Error.Error(e,l) ->
      Error.report_error e;
      Location.print l
