(* Evaluate a Java AST *)

type memory_val = {
	content : AST.type_info
}

type data_store = (int, memory_val) Hashtbl.t
type reference_store = (string, int) Hashtbl.t

type memory = {
  names : reference_store;
  data : data_store;
  mutable next_id : int;
}

let declare_type mem (t : AST.asttype) =
  Hashtbl.add !mem.names t.id !mem.next_id;
	Hashtbl.add !mem.data !mem.next_id { content = t.info };
	!mem.next_id <- !mem.next_id + 1;
;;

let print_memory m =
	Hashtbl.iter (fun x y -> Printf.printf "%s -> %i\n" x y) m.names;
	Hashtbl.iter (fun x _ -> Printf.printf "%i -> \n" x) m.data;;

let execute_statement mem = function
	| VarDecl dl ->

let execute_method (f : AST.astmethod)  =
	Printf.printf "method %s executed\n" f.mname;
	List.iter (AST.print_statement "")  f.mbody;;

let execute_program (p : AST.t) =
  let mem = ref {
		names = Hashtbl.create 10;
		data = Hashtbl.create 10;
		next_id = 0;
	} in
  List.iter (declare_type mem) p.type_list;
	(* print_memory !mem; *)
	let main_class_id = Hashtbl.find !mem.names "HelloWorld" in
	let main_class = (Hashtbl.find !mem.data main_class_id).content in
	match main_class with
		| Class c -> (let main_method = List.hd c.cmethods in execute_method main_method)
		| Inter -> ();


