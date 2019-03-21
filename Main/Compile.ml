open Parser
open Eval

let debug u = Printf.printf "%s\n" (Memory.string_from_memory_unit u);;

(**
 * Return a list of files in dir and it subdirectories
 * TODO: duplicate of Test/TestUtils.ml
 *)
let load_std_asts =
  let load_ast filename =
    let input_file = open_in filename in
    let lexbuf = Lexing.from_channel input_file in
    Location.init lexbuf filename;
    compilationUnit Lexer.token lexbuf in
  List.map load_ast (Files.dir_contents "stdlib") ;;

let _execute lexbuf verbose doPrintAST doPrintTypeEnv skip_type_checking skip_eval entry_point args debug load_std =
  try
    let ast = compilationUnit Lexer.token lexbuf in

    let std_asts = match load_std with
      | true -> load_std_asts
      | false -> [] in
    if verbose then print_endline "successful parsing";
    if doPrintAST then AST.print_AST ast;
    let ast = if skip_type_checking then ast else TypeChecker.typing ast doPrintTypeEnv in
    if verbose then AST.print_program ast;
    if not skip_eval then execute_program ast std_asts entry_point args debug (* TODO: change that to typed_ast *)
  with
    | Error ->
      print_string "Syntax error: ";
      Location.print (Location.curr lexbuf)
    | Error.Error(e,l) ->
      Error.report_error e;
      Location.print l;;

let execute lexbuf verbose doPrintAST skip_type_checking entry_point args load_std =
  _execute lexbuf verbose doPrintAST false skip_type_checking false entry_point args debug load_std

(* Execute only type-checking *)
let execute_tc lexbuf =
  _execute lexbuf false false true false true "" [] debug false

let custom_exec lexbuf verbose doPrintAST skip_type_checking skip_eval entry_point args debug load_std =
  _execute lexbuf verbose doPrintAST false skip_type_checking skip_eval entry_point args debug load_std
