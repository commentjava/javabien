type ('a,'b) t = ('a, 'b) Hashtbl.t

let initial () = (Hashtbl.create 17 : ('a,'b) t)

let find env = Hashtbl.find env

let mem env = Hashtbl.mem env

let define env n t =
  let result = Hashtbl.copy env in
    Hashtbl.add result n t;
    result

let iter f = Hashtbl.iter (fun s i -> f (s,i))

let values env = Hashtbl.fold (fun k v acc -> v :: acc) env []

let key_value_pairs env = Hashtbl.fold (fun k v acc -> (k, v) :: acc) env []

let whitespace = "   " ;;
let branche = "│  " ;;
let colorRed = "\x1b[0;31m" ;;
let colorGreen = "\x1b[0;32m" ;;
let colorLightGreen = "\x1b[1;32m" ;;
let colorLightCyan = "\x1b[1;36m" ;;
let colorWhite = "\x1b[1;37m" ;;
let colorReset = "\x1b[0m" ;;

let incr c =
  c + 1
;;

let print name print_key print_val env depth =
  let tbl_length = Hashtbl.length env in
  if (name <> "") then (
    print_string (colorWhite ^ name ^ colorReset ^ ":");
  );
  let idx = ref 0 in
  Hashtbl.iter (fun key value ->
    idx := incr !idx;
    print_newline();
    let d_key = if !idx == tbl_length then "└─ " else "├─ " in
    let d_value = if !idx == tbl_length then whitespace else branche in
    print_string (depth ^ d_key);
    print_key key;
    print_string " ";
    print_val value (depth ^ d_value))
  env