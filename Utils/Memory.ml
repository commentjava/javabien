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
  val make_memory_stack : 'a memory ref -> 'a memory ref
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
    parent : 'a memory option; (* link to the parent stack *)
  }

  (*
  Print a memory
  *)
  let print_memory (m : 'a memory ref) (f : 'a -> unit) : unit =
    Printf.printf "\n======================\n";
    Printf.printf "==== MEMORY DUMP =====\n";
    Printf.printf "=== Names in scope ===\n";
    let rec print_stack = function
      | None -> Printf.printf "END OF STACKS\n\n"
      | Some(s) -> (
        List.iter
          (fun n ->
            Printf.printf "  Stack :\n";
            Hashtbl.iter
              (fun x y ->
                Printf.printf "    %s -> %i\n" x y
              )
              n
          )
          s.names;
          Printf.printf "\nPARENT STACK:\n";
          print_stack s.parent) in
    print_stack (Some !m);
    Printf.printf "=== Memory Structure ===\n";
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
      parent = None;
    }

  (*
  Give a reference to a memory empiled over the given one
  *)
  let make_empiled_memory (mem : 'a memory ref) : 'a memory ref =
    ref {
      names = (Hashtbl.create 10)::(!mem.names);
      data = !mem.data;
      next_id = ref (!(!mem.next_id));
      parent = !mem.parent;
    }
  (**
   * New memory stack used for method calls
   * TODO: add `this` in the stack
   *)
  let make_memory_stack (mem : 'a memory ref) : 'a memory ref =
    let names = List.hd (List.rev !mem.names) in
    ref {
      names = (Hashtbl.create 10)::[names];
      data = !mem.data;
      next_id = ref (!(!mem.next_id));
      parent = Some(!mem);
    }

  (***** Memory tools *************************************)
  let apply_garbage_collector (mem : 'a memory ref) (f : 'a memory ref -> 'a -> (memory_address, bool) Hashtbl.t -> unit) : unit =
    let checker = Hashtbl.create 10 in
    Hashtbl.iter
      (fun mem_a obj ->
        Hashtbl.add checker mem_a true
      )
      !mem.data;
    let rec check_stack = function
      | None -> ()
      | Some(s) -> (
        List.iter
          (fun n ->
            Hashtbl.iter
              (fun n addr ->
                f mem (get_object_from_address mem addr) checker;
                Hashtbl.remove checker addr
              )
              n
          )
        s.names;
        check_stack s.parent;
        ) in
    check_stack (Some !mem);
    Hashtbl.iter
      (fun addr b ->
        Hashtbl.remove !mem.data addr
      )
      checker
end

(***** Object definition ******************************************)

type m_class = {
  (* attributes : (name, memory_address) Hashtbl.t *)
  methods : (Memory.name, Memory.memory_address) Hashtbl.t;
  attributes : (Memory.name, Memory.memory_address) Hashtbl.t
}
type m_method = {
  arguments : AST.argument list;
  body : AST.statement list
}
type m_object = {
  t : Memory.memory_address;
  attributes : (Memory.name, Memory.memory_address) Hashtbl.t
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
  | DebugClass
  | DebugMethod
  | MemDumpMethod

let string_from_memory_unit (u : memory_unit) : string =
  match u with
  | Class c -> "Class";
  | Method m -> "Method";
  | Object o -> "Object";  (* TODO: use to_tostring method *)
  | Null -> "null";
  | Primitive (Int i) -> string_of_int i;
  | Primitive (Boolean b) -> string_of_bool b;
  | DebugClass -> "DebugClass"
  | DebugMethod -> "DebugMethod"
  | MemDumpMethod -> "DebugMethod"
;;

let java_this : Memory.name = "this";;
let java_void : Memory.memory_address = 0;;
(*
Print a memory_unit
*)
let print_memory_unit u =
  match u with
  | Class c ->
    Printf.printf "\t[Class]\n";
    Hashtbl.iter
      (fun x y ->
        Printf.printf "\t[a] %s -> %i\n" x y;
      )
      c.attributes;
    Hashtbl.iter
      (fun x y ->
        Printf.printf "\t[m] %s -> %i\n" x y;
      )
      c.methods;
  | Method m ->
    Printf.printf "\t[Method]\n";
    List.iter (AST.print_statement "\t") m.body;
  | Object o ->
    Printf.printf "\t[Object]\n";
    Printf.printf "\tInstance of: %i\n" o.t;
    Hashtbl.iter
      (fun x y ->
        Printf.printf "\t[a] %s -> %i\n" x y;
      )
      o.attributes;
  | Null ->
    Printf.printf "\t[null]\n";
  | Primitive (Int i) -> Printf.printf "\t[INT] %i\n" i;
  | Primitive (Boolean b) -> Printf.printf "\t[BOOL] %b\n" b;
  | DebugClass ->
    Printf.printf "\t[Debug class]\n"
  | DebugMethod ->
    Printf.printf "\t[Debug method]\n"
  | MemDumpMethod ->
    Printf.printf "\t[Mem Dump method]\n"
;;

(* -> populate_mem
Give a reference to a new memory populated with the following :
  "null" -> 0 -> Null
  "debug" -> 1 -> debug()
*)
let make_populated_memory () : 'a Memory.memory ref =
  let mem = Memory.make_memory () in
  Memory.add_link_name_object mem "null" Null;
  (* Create a debug class *)
  let debug_m_addr = Memory.add_object mem DebugMethod in
  let memdump_m_addr = Memory.add_object mem MemDumpMethod in
  let debug_c_addr = Memory.add_link_name_object mem "Debug" (Class {
    methods = Hashtbl.create 10;
    attributes = Hashtbl.create 10;
}) in
  match Memory.get_object_from_address mem debug_c_addr with
  | Class c ->
      Hashtbl.add c.methods "debug" debug_m_addr;
      Hashtbl.add c.methods "dumpMemory" memdump_m_addr;
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
    remove_addr_from_checker mem (Memory.get_object_from_address mem o.t) checker;
    Hashtbl.remove checker o.t
  | Null -> ()
  | Primitive p -> ()
  | DebugClass -> ()
  | MemDumpMethod -> ()
  | DebugMethod -> ()
;;

let apply_garbage_collector mem : unit =
  (* print_memory mem; *)
  Memory.apply_garbage_collector mem remove_addr_from_checker;
  (* Printf.printf "Gargbage collected!\n"; *)
  (* print_memory mem; *)
;;

let get_method_address (mem : memory_unit Memory.memory ref) obj n =
  let methods = match obj with
    | Object o -> (
      match Memory.get_object_from_address mem o.t with
      | Class c -> c.methods
      | _ -> raise (MemoryError "Only Classes and objects can have methods")
    )
    | Class c -> c.methods
    | Null -> raise (MemoryError "NullException")
    | _ -> raise (MemoryError "Only Classes and objects can have methods") in
  Hashtbl.find methods n;;

let get_attribute_address (mem : memory_unit Memory.memory ref) obj n =
  let attributes = match obj with
    | Object o -> o.attributes
    | Class c -> c.methods
    | Null -> raise (MemoryError "NullException")
    | _ -> raise (MemoryError "Only Classes and objects can have methods") in
  Hashtbl.find attributes n;;

let set_attribute_address (mem : memory_unit Memory.memory ref) obj n new_addr =
  let attributes = match obj with
    | Object o -> o.attributes
    | Class c -> c.methods
    | Null -> raise (MemoryError "NullException")
    | _ -> raise (MemoryError "Only Classes and objects can have methods") in
  Hashtbl.replace attributes n new_addr;;
