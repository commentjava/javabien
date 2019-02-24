open TestUtils

let dirname = "Test/typing/should_fail";;

let execute filename =
  let input_file = open_in filename in
  let lexbuf = Lexing.from_channel input_file in
  Location.init lexbuf filename;
  try
    Compile.execute_tc lexbuf;
    assert false
  with error -> match error with
    | Assert_failure (s) -> (
      seek_in input_file 0;
      close_in (input_file);
      raise error
    )
    | _ -> (
      seek_in input_file 0;
      close_in (input_file);
    )
;;

let () =
  test_dir dirname execute;
;;
