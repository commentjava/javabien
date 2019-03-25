let verbose = ref false
let doPrintAST = ref false
let skip_type_checking = ref false
let no_std_lib = ref false
let forced_main_class = ref ""
let program = ref ""
let args = ref []

let get_file str =
  let temp2 = Filename.check_suffix str ".java" in
  let file = (if temp2 then str else str^".java") in
  let filename =
    begin
      try
	let idx = String.rindex str '/' in
	let temp1 = String.sub str (idx + 1) ((String.length str) - idx - 1) in
	if temp2 then Filename.chop_suffix temp1 ".java" else temp1
      with Not_found ->
	if temp2 then Filename.chop_suffix str ".java" else str
    end
  in
  file, filename

let prepare_compilation input =
  match !program with
  | "" -> program := input
  | _ -> args := !args@[input];;

let compile source args =
  let (file, class_name) = get_file source in
  let main_class = match !forced_main_class with
  | "" -> class_name
  | c -> c in
  try
    let input_file = open_in file in
    let lexbuf = Lexing.from_channel input_file in
    Location.init lexbuf file;
    Compile.execute lexbuf !verbose !doPrintAST !skip_type_checking main_class args (not !no_std_lib);
    close_in (input_file)
  with Sys_error s ->
    print_endline ("Can't find file '" ^ file ^ "'")

let () =
  (*
  print_endline "miniJava compiler";
   *)
  Arg.parse [
    "-v",Arg.Set verbose,"verbose mode" ;
    "-ast",Arg.Set doPrintAST,"print AST" ;
    "-skip-tc",Arg.Set skip_type_checking,"skip type checking";
    "-no-stdlib",Arg.Set no_std_lib,"Do not load stdlib";
    "-main-class",Arg.Set_string forced_main_class ,"Specify main class, default to program filename";
  ] prepare_compilation "Usage: ./Main.byte [options] <Program.java> [java args]";
  compile !program !args

