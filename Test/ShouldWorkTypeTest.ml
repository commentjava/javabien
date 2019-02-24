open TestUtils

let dirname = "Test/typing/should_work";;

let execute filename =
  let input_file = open_in filename in
  let lexbuf = Lexing.from_channel input_file in
  Location.init lexbuf filename;
  Compile.execute_tc lexbuf;
  seek_in input_file 0;
  close_in (input_file);
;;

let () =
  test_dir dirname execute;
;;
