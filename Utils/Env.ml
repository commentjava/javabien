type ('a,'b) t = ('a, 'b) Hashtbl.t

let initial () = (Hashtbl.create 17 : ('a,'b) t)

let find env = Hashtbl.find env

let mem env = Hashtbl.mem env

let define env n t =
  let result = Hashtbl.copy env in
    Hashtbl.add result n t;
    result

let iter f = Hashtbl.iter (fun s i -> f (s,i))

let rec print_tab t =
  if t = 0 then
      ()
  else
      begin
          print_string "  ";
          print_tab (t - 1)
      end

let print name print_key print_val env tab =
  if (Hashtbl.length env > 0) then
    begin
      if (name <> "") then (
        print_tab tab;
        print_string (name^": ");
        print_newline()
      );
      let first = ref true in
      Hashtbl.iter
	(fun key value ->
	  (* if !first then
	    first := false
    else *)
      print_tab (tab + 1);
      print_key key;
      print_string ": ";
      print_val value)
    env
    end