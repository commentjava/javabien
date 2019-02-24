open TestUtils

exception AssertError of string;;
let test_dirname = "Test/eval_units"

let create_debug d =
  let debug_function u = d := !d @ [(Memory.string_from_memory_unit u)] in
  debug_function;;

let strip str =
    let str = Str.replace_first (Str.regexp "^ +") "" str in
      Str.replace_first (Str.regexp " +$") "" str;;

let rec cmp = function
  | [], [] -> ();
  | [], _ -> raise (AssertError "too many debugs");
  | _, [] -> raise (AssertError "Missing debugs");
  | h1::t1, h2::t2 -> (match h1 <> h2 with
    | true -> raise (AssertError (h1 ^ " != " ^ h2));
    | false -> cmp (t1, t2));;

let check_debug file actual =
  let expected = ref [] in
  try
    while true; do
      let line = input_line file in
      match Str.string_match (Str.regexp "^\\/\\/:") line 0 with
      | true -> expected := !expected @ [strip (Str.string_after line 3)];
      | false -> ();
    done;
  with End_of_file -> ();
  cmp (!expected, !actual);;

let execute filename =
    let input_file = open_in filename in
    let lexbuf = Lexing.from_channel input_file in
    Location.init lexbuf filename;
    let debug_result = ref [] in
    let debug = create_debug debug_result in
    Compile.custom_exec lexbuf false false true debug;
    seek_in input_file 0;
    check_debug input_file debug_result;
    close_in (input_file)
let () =
  test_dir test_dirname execute
