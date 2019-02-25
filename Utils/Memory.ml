exception MemoryError of string;;

module Memory : sig
  type memory_address = int
  type name = string

  (***** Memory definition ******************************************)
  type 'a memory
  val print_memory : 'a memory ref -> ('a -> unit) -> unit                      (* print_memory *)
  (***** Memory getter ************************************)
  val get_address_from_name : 'a memory ref -> name -> memory_address
  val get_object_from_address : 'a memory ref -> memory_address -> 'a
  val get_object_from_name : 'a memory ref -> name -> 'a
  (***** Memory setter ************************************)
  val add_link_name_address : 'a memory ref -> name -> memory_address -> unit   (* new_mem_name *)
  val add_object : 'a memory ref -> 'a -> memory_address                        (* new_mem_obj *)
  val add_link_name_object : 'a memory ref -> name -> 'a -> memory_address
  (***** Memory factory ***********************************)
  val make_memory : unit -> 'a memory ref                                       (* new_memory *)
  val make_empiled_memory : 'a memory ref -> 'a memory ref
  (***** Memory tools *************************************)
  val apply_garbage_collector : 'a memory ref -> ('a memory ref -> 'a -> (memory_address, bool) Hashtbl.t -> unit) -> unit

end = struct
  type memory_address = int
  type name = string

  (***** Memory definition ******************************************)
  type reference_store = (name, memory_address) Hashtbl.t
  type 'a data_store = (memory_address, 'a) Hashtbl.t
  type address_counter = { mutable v : memory_address }

  type 'a memory = {
    names : reference_store list;
    data : 'a data_store;
    next_id : address_counter ref;
  }

  (*
  Print a memory
  *)
  let print_memory (m : 'a memory ref) (f : 'a -> unit) : unit =
    Printf.printf "Names in scope :\n";
    List.iter
      (fun n ->
        Printf.printf "  Stack :\n";
        Hashtbl.iter
          (fun x y ->
            Printf.printf "    %s -> %i\n" x y
          )
          n
      )
      !m.names;
    Printf.printf "\nMemory Structure :\n";
    Hashtbl.iter
      (fun x y ->
        Printf.printf "%i -> " x;
        f y
      )
      !m.data;
    Printf.printf "\n\n"

  (***** Memory getter ************************************)
  (* HIDDEN
  Give the next free memory_address and increase the counter
  *)
  let get_next_address (addr_c : address_counter ref) : memory_address =
    let mem_a = !addr_c.v in
    !addr_c.v <- mem_a + 1;
    mem_a

  (*
  Give the memory_address correponding to the given name
  Raise Not_found if the name is not linked
  *)
  let get_address_from_name (mem : 'a memory ref) (n : name) : memory_address =
    let rec aux (names : reference_store list) : memory_address =
      match names with
      | [] -> raise Not_found
      | hname::tnames ->
        try
          Hashtbl.find hname n
        with Not_found -> aux tnames
    in
    aux !mem.names

  (*
  Give the memory_unit corresponding to the given memory_address
  Raise Not_found if the memory_address is not linked
  *)
  let get_object_from_address (mem : 'a memory ref) (mem_a : memory_address) : 'a =
    Hashtbl.find !mem.data mem_a

  (*
  Give the memory_unit corresponding to the given name
  Raise Not_found if the name is not linked
  *)
  let get_object_from_name (mem : 'a memory ref) (n : name) : 'a =
    get_object_from_address mem (get_address_from_name mem n)

  (***** Memory setter ************************************)
  (* -> new_mem_name
  Link the given name with the given memory_address
  *)
  let add_link_name_address (mem : 'a memory ref) (n : name) (mem_a : memory_address) : unit =
    let rec find_name_in_stack (names : reference_store list) : bool =
      match names with
      | [] -> false
      | hname::tnames ->
        if Hashtbl.mem hname n then
          (Hashtbl.replace hname n mem_a;
          true)
        else
          find_name_in_stack tnames
    in
    if find_name_in_stack !mem.names then
      ()
    else
      match !mem.names with
      | [] -> raise (MemoryError "Memory is missing")
      | hname::tnames -> Hashtbl.replace hname n mem_a

  (* -> new_mem_obj
  Insert the given memory_unit in the memory
  Give the memory_address assigned to this memory_unit
  *)
  let add_object (mem : 'a memory ref) (mem_u : 'a) : memory_address =
    let mem_a = get_next_address !mem.next_id in
    Hashtbl.add !mem.data mem_a mem_u;
    mem_a

  (*
  Insert the given memory_unit in the memory
  Link the given name to this memory_unit
  Give the memory_address assigned to the memory_unit
  *)
  let add_link_name_object (mem : 'a memory ref) (n : name) (mem_u : 'a) : memory_address =
    let mem_a = add_object mem mem_u in
    add_link_name_address mem n mem_a;
    mem_a

  (***** Memory factory ***********************************)
  (* -> new_memory
  Give a reference to a new empty memory
  *)
  let make_memory () : 'a memory ref =
    ref {
      names = [Hashtbl.create 10];
      data = Hashtbl.create 10;
      next_id = ref { v = 0 };
    }

  (*
  Give a reference to a memory empiled over the given one
  *)
  let make_empiled_memory (mem : 'a memory ref) : 'a memory ref =
    ref {
      names = (Hashtbl.create 10)::(!mem.names);
      data = !mem.data;
      next_id = ref (!(!mem.next_id));
    }

  (***** Memory tools *************************************)
  let apply_garbage_collector (mem : 'a memory ref) (f : 'a memory ref -> 'a -> (memory_address, bool) Hashtbl.t -> unit) : unit =
    let checker = Hashtbl.create 10 in
    Hashtbl.iter
      (fun mem_a obj ->
        Hashtbl.add checker mem_a true
      )
      !mem.data;
    List.iter
      (fun n ->
        Hashtbl.iter
          (fun n addr ->
            f mem (get_object_from_address mem addr) checker;
            Hashtbl.remove checker addr
          )
          n
      )
      !mem.names;
    Hashtbl.iter
      (fun addr b ->
        Hashtbl.remove !mem.data addr
      )
      checker

end

(***** Object definition ******************************************)

type m_class = {
  (* attributes : (name, memory_address) Hashtbl.t *)
  methods : (Memory.name, Memory.memory_address) Hashtbl.t
}
type m_method = {
  body : AST.statement list
}
type m_object = {
  t : Memory.memory_address
}
type m_primitive =
  | Int of int
  | Boolean of bool
type memory_unit =
  | Class of m_class
  | Method of m_method
  | Object of m_object
  | Primitive of m_primitive
  | Null
  | DebugMethod

let string_from_memory_unit (u : memory_unit) : string =
  match u with
  | Class c -> "Class";
  | Method m -> "Method";
  | Object o -> "Object";  (* TODO: use to_tostring method *)
  | Null -> "null";
  | Primitive (Int i) -> string_of_int i;
  | Primitive (Boolean b) -> string_of_bool b;
  | DebugMethod -> "DebugMethod"
;;
(*
Print a memory_unit
*)
let print_memory_unit u =
  match u with
  | Class c ->
    Printf.printf "\t[Class]\n";
    Hashtbl.iter
      (fun x y ->
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
  | Primitive (Int i) -> Printf.printf "\t[INT] %i\n" i;
  | Primitive (Boolean b) -> Printf.printf "\t[BOOL] %b\n" b;
  | DebugMethod ->
    Printf.printf "\t[Debug method]\n"
;;

(* -> populate_mem
Give a reference to a new memory populated with the following :
  "null" -> 0 -> Null
  "debug" -> 1 -> debug()
*)
let make_populated_memory () : 'a Memory.memory ref =
  let mem = Memory.make_memory () in
  Memory.add_link_name_object mem "null" Null;
  Memory.add_link_name_object mem "debug" DebugMethod;
  mem
;;

let print_memory mem : unit =
  Memory.print_memory mem print_memory_unit
;;

let rec remove_addr_from_checker mem (mem_u : memory_unit) (checker : (Memory.memory_address, bool) Hashtbl.t) : unit =
  match mem_u with
  | Class c->
    Hashtbl.iter
      (fun n addr ->
        remove_addr_from_checker mem (Memory.get_object_from_address mem addr) checker;
        Hashtbl.remove checker addr
      )
      c.methods
  | Method m -> ()
  | Object o ->
    remove_addr_from_checker mem (Memory.get_object_from_address mem o.t)checker;
    Hashtbl.remove checker o.t
  | Null -> ()
  | Primitive p -> ()
  | DebugMethod -> ()
;;

let apply_garbage_collector mem : unit =
  Memory.apply_garbage_collector mem remove_addr_from_checker
;;
