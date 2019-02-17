open Parser
open Eval

let execute lexbuf verbose doPrintAST =
  try
    let ast = compilationUnit Lexer.token lexbuf in
    print_endline "successful parsing";
    let typed_ast = TypeChecker.typing ast in
    if verbose then AST.print_program ast;
    if doPrintAST then AST.print_AST ast;
    execute_program ast (* TODO: change that to typed_ast *)
  with
    | Error ->
      print_string "Syntax error: ";
      Location.print (Location.curr lexbuf)
    | Error.Error(e,l) ->
      Error.report_error e;
      Location.print l
