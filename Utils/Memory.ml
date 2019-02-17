(*include Map.Make(Address)

let print name print_val map =
  if (not(is_empty map)) then
    begin
      if (name <> "") then print_string (name^": ");
      let first = ref true in
      iter
	(fun key value ->
	  if !first then
	    first := false
	  else
	    print_string ", ";
	  print_int key;
	  print_string ":";
	  print_val value)
	map
    end*)

exception MemoryError of string;;

type memory_address = int
type name = string

type m_class = {
  (* attributes : (name, memory_address) Hashtbl.t *)
  methods : (name, memory_address) Hashtbl.t
}
and m_method = {
  body : AST.statement list
}
and m_object = {
  t : memory_address
}
and m_primitive =
  | Int of int
  | Boolean of bool
and memory_unit =
  | Class of m_class
  | Method of m_method
  | Object of m_object
  | Primitive of m_primitive
  | Null

type data_store = (memory_address, memory_unit) Hashtbl.t
type reference_store = (name, memory_address) Hashtbl.t

type memory = {
  names : reference_store;
  data : data_store;
  mutable next_id : memory_address;
}

let print_memory_unit u =
  match u with
  | Class c ->
      Printf.printf "\t[Class]\n";
      Hashtbl.iter (fun x y ->
        Printf.printf "\tm: %s -> %i\n" x y;
      )
      c.methods;
  | Method m ->
      Printf.printf "\t[Method]\n";
      List.iter (AST.print_statement "\t") m.body;
  | Object o ->
      Printf.printf "\t[Object]\n";
      Printf.printf "\tInstance of: %i\n" o.t;
  | Null ->
      Printf.printf "\t[null]\n";
  | Primitive (Int i) -> Printf.printf "\t[INT] %i\n" i;;

let print_memory m =
  Printf.printf "Names in scope :\n";
	Hashtbl.iter (fun x y -> Printf.printf "%s -> %i\n" x y) m.names;

  Printf.printf "\nMemory Structure :\n";
	Hashtbl.iter (fun x y ->
    Printf.printf "%i -> " x;
    print_memory_unit y;
  ) m.data;;

(** Create a new object in the memory *)
let new_mem_name mem name id =
  Hashtbl.add !mem.names name id;;

(** Insert a new scoped name in the memory *)
let new_mem_obj mem obj =
  let obj_id = !mem.next_id in
  Hashtbl.add !mem.data obj_id obj;
	!mem.next_id <- !mem.next_id + 1;
  obj_id;;

(** Create a reference to a new memory *)
let new_memory () =
  let mem = ref {
		names = Hashtbl.create 10;
		data = Hashtbl.create 10;
		next_id = 0;
	} in
  mem;;

