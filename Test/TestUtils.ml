type new_test =
 | Normal of string
 | Skip of string


let successCount = ref 0
let failCount = ref 0
let skipTestsCount = ref 0

(* Colors in terminal *)
let green = "\x1b[0;32m"
let red = "\x1b[0;31m"
let reset_color = "\x1b[0m"

let run_assert_func assert_fct file =
  (* Run assert_fct on the file, and increment the fail counter if there is an exception, else increment the success counter *)
  try
    print_endline ("\n> Testing " ^ file);
    assert_fct file;
    successCount := !successCount + 1; print_endline (green ^ "> " ^ file ^ " passed " ^ reset_color)
  with
    error ->
        let msg = Printexc.to_string error
        and stack = Printexc.get_backtrace ()
        in print_endline ("Error : " ^ msg);
        print_endline ("Stack : " ^ stack);
        failCount := !failCount + 1; print_endline (red ^ "/!\\/!\\ " ^ file ^ " failed /!\\/!\\" ^ reset_color)

let test_file assert_fct file =
  match file with
  | Normal f -> run_assert_func assert_fct f
  | Skip f -> skipTestsCount := !skipTestsCount + 1

let rec filter_java files =
  match files with
    | [] -> []
    | hd :: tl when Filename.check_suffix hd ".java" -> Normal hd :: (filter_java tl)
    | hd :: tl when Filename.check_suffix hd ".java.disabled" ->  Skip hd :: (filter_java tl)
    | hd :: tl -> filter_java tl

let test_dir dir assert_fct =
  (* Run the assert_fct for each file in the *)
  if Files.dir_is_empty dir then
    print_endline ("There is no file to test in " ^ dir)
  else
    let files = filter_java (Files.dir_contents dir)
    in
      List.iter (test_file assert_fct) files;
      print_endline ("\n=== " ^ (string_of_int (!successCount + !failCount)) ^ " tests ("^ string_of_int (!skipTestsCount) ^ " Skipped) ===");
      print_endline (">>>  Passed: " ^ (string_of_int !successCount));
      print_endline (">>>  Failed: " ^ (string_of_int !failCount));
      match !failCount with
        | 0 -> print_endline (green ^ "SUCCESS\n" ^ reset_color);
        | _ -> print_endline (red ^ "!FAILURE\n" ^ reset_color);
      exit !failCount;;

