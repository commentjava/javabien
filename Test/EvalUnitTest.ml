open TestUtils

exception AssertError of string;;
let test_dirname = "Test/eval_units"

let create_debug =
  let d = ref [ ] in
  let debug_function u = d := !d @ [(Memory.string_from_memory_unit u)] in
  debug_function, d;;

let strip str =
    let str = Str.replace_first (Str.regexp "^ +") "" str in
      Str.replace_first (Str.regexp " +$") "" str;;

let check_debug file actual =
  let ref expected = ref [] in
  try
    while true; do
      let line = input_line file in
      match Str.string_match (Str.regexp "^\\/\\/:") line 0 with
      | true -> (
        let m = strip (Str.string_after line 3) in
        match  m != (List.hd !actual) with
        | false -> actual := (List.tl !actual);
        | true -> raise (AssertError (m ^ " != " ^ (List.hd !actual))));
      | false -> ();
    done
  with End_of_file -> ();
  match List.length !actual with
    | 0 -> ();
    | _ -> raise (AssertError "Not everything matched");;

let execute filename =
    let input_file = open_in filename in
    let lexbuf = Lexing.from_channel input_file in
    Location.init lexbuf filename;
    let debug, debug_result = create_debug in
    Compile.custom_exec lexbuf false false true debug;
    seek_in input_file;
    check_debug input_file debug_result;
    close_in (input_file)
let () =
  test_dir test_dirname execute
