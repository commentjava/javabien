open Parser
open Eval

let debug u = Printf.printf "%s\n" (Memory.string_from_memory_unit u);;

let _execute lexbuf verbose doPrintAST skip_type_checking debug =
  try
    let ast = compilationUnit Lexer.token lexbuf in
    if verbose then print_endline "successful parsing";
    if doPrintAST then AST.print_AST ast;
    let ast = if skip_type_checking then ast else TypeChecker.typing ast in
    if verbose then AST.print_program ast;
    execute_program ast debug (* TODO: change that to typed_ast *)
  with
    | Error ->
      print_string "Syntax error: ";
      Location.print (Location.curr lexbuf)
    | Error.Error(e,l) ->
      Error.report_error e;
      Location.print l;;

let execute lexbuf verbose doPrintAST skip_type_checking =
  _execute lexbuf verbose doPrintAST skip_type_checking debug

let custom_exec lexbuf verbose doPrintAST skip_type_checking debug =
  _execute lexbuf verbose doPrintAST skip_type_checking debug
