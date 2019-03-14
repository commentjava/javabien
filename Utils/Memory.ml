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
  val save_temp_var : 'a memory ref -> memory_address -> 'a memory ref
  (***** Memory tools *************************************)
  val apply_garbage_collector : 'a memory ref -> memory_address list -> ('a memory ref -> 'a -> (memory_address, bool) Hashtbl.t -> unit) -> unit

end = struct
  type memory_address = int
  type name = string

  (***** Memory definition ******************************************)
  type reference_store = (name, memory_address) Hashtbl.t
  type 'a data_store = (memory_address, 'a) Hashtbl.t
  type address_counter = { mutable v : memory_address }

  type 'a memory = {
    names : reference_store list;
    current_expr : memory_address list list;
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
      current_expr = [[]];
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
      current_expr = (!mem.current_expr);
      data = !mem.data;
      next_id = ref (!(!mem.next_id));
      parent = !mem.parent;
    }
  (**
   * New memory stack used for method calls
   *)
  let make_memory_stack (mem : 'a memory ref) : 'a memory ref =
    let names = List.hd (List.rev !mem.names) in
    ref {
      names = (Hashtbl.create 10)::[names];
      current_expr = [[]];
      data = !mem.data;
      next_id = ref (!(!mem.next_id));
      parent = Some(!mem);
    }

  let save_temp_var (mem : 'a memory ref) (addr : memory_address) : 'a memory ref =
    let new_hd = addr :: (List.hd !mem.current_expr) in
    ref {
      names = !mem.names;
      current_expr = new_hd :: (List.tl !mem.current_expr);
      data = !mem.data;
      next_id = ref (!(!mem.next_id));
      parent = !mem.parent
    }

  (***** Memory tools *************************************)
  let apply_garbage_collector (mem : 'a memory ref) (keep : memory_address list) (f : 'a memory ref -> 'a -> (memory_address, bool) Hashtbl.t -> unit) : unit =
    let checker = Hashtbl.create 10 in
    Hashtbl.iter
      (fun mem_a obj ->
        match List.find_opt (fun x -> x == mem_a) keep with
        | None -> Hashtbl.add checker mem_a true
        | _ -> ()
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

type statement_return =
  | Void
  | Return of Memory.memory_address
  | Raise (* TODO *)
and m_attr = {
  v : Memory.memory_address;
  modifiers : AST.modifier list;
}
and m_class = {
  (* attributes : (name, memory_address) Hashtbl.t *)
  name : string;
  methods : (Memory.name, Memory.memory_address) Hashtbl.t;
  attributes : (Memory.name, m_attr) Hashtbl.t
}
and m_method = {
  arguments : AST.argument list;
  body : AST.statement list
}
and m_object = {
  t : Memory.memory_address;
  attributes : (Memory.name, m_attr) Hashtbl.t
}
and m_native_method = {
  arguments : AST.argument list;
  body : memory_unit Memory.memory ref -> statement_return
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
  | NativeMethod of m_native_method
  | MemDumpMethod

let string_from_memory_unit (u : memory_unit) : string =
  match u with
  | Class c -> "Class";
  | Method m -> "Method";
  | Object o -> "Object";  (* TODO: use to_string method *)
  | Null -> "null";
  | Primitive (Int i) -> string_of_int i;
  | Primitive (Boolean b) -> string_of_bool b;
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
        Printf.printf "\t[a] %s -> %i\n" x y.v;
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
  | NativeMethod m ->
    Printf.printf "\t[Native Method]\n";
  | Object o ->
    Printf.printf "\t[Object]\n";
    Printf.printf "\tInstance of: %i\n" o.t;
    Hashtbl.iter
      (fun x y ->
        Printf.printf "\t[a] %s -> %i\n" x y.v;
      )
      o.attributes;
  | Null ->
    Printf.printf "\t[null]\n";
  | Primitive (Int i) -> Printf.printf "\t[INT] %i\n" i;
  | Primitive (Boolean b) -> Printf.printf "\t[BOOL] %b\n" b;
;;

(* -> populate_mem
Give a reference to a new memory populated with the following :
  "null" -> 0 -> Null
*)
let make_populated_memory () : 'a Memory.memory ref =
  let mem = Memory.make_memory () in
  Memory.add_link_name_object mem "null" Null;
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
  | NativeMethod m -> ()
  | Object o ->
    remove_addr_from_checker mem (Memory.get_object_from_address mem o.t) checker;
    Hashtbl.remove checker o.t
  | Null -> ()
  | Primitive p -> ()
;;

let apply_garbage_collector mem keep : unit =
  (* print_memory mem; *)
  Memory.apply_garbage_collector mem keep remove_addr_from_checker;
  (* Printf.printf "!!!! Gargbage collected !!!!!\n"; *)
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

let get_class_from_address mem addr : m_class =
  match Memory.get_object_from_address mem addr with
  | Class c -> c
  | _ -> raise (MemoryError "Class expected");;

let get_attribute_value_address (mem : memory_unit Memory.memory ref) (obj : memory_unit) (n : Memory.name) =
  let attributes = match obj with
  | Object o -> [o.attributes; (get_class_from_address mem o.t).attributes]
  | Class c -> [c.attributes]
  | Null -> raise (MemoryError "NullException")
  | _ -> raise (MemoryError "Only Classes and objects can have methods") in
  let addr, found = List.fold_left (fun (c, found) attrs ->
    match found with
    | true -> c, found
    | false -> (
      try
        (Hashtbl.find attrs n).v, true
      with Not_found -> c, found
      )
  )
  (java_void, false)
  attributes in
  match found with
  | true -> addr
  | false -> raise Not_found;;

let set_attribute_value_address (mem : memory_unit Memory.memory ref) obj n new_addr =
  let attributes = match obj with
  | Object o -> [o.attributes; (get_class_from_address mem o.t).attributes]
  | Class c -> [c.attributes]
  | Null -> raise (MemoryError "NullException")
  | _ -> raise (MemoryError "Only Classes and objects can have methods") in
  let don = List.fold_left (fun don attrs ->
    match don with
    | true -> true
    | false -> (
      try
        let old_attr = Hashtbl.find attrs n in
        Hashtbl.replace attrs n {
          v = new_addr;
          modifiers = old_attr.modifiers;
        }; true
      with Not_found -> don
    )
  )
  false
  attributes in
  match don with
  | true -> ()
  | false -> raise Not_found;;

let copy_non_static_attrs (mem : memory_unit Memory.memory ref) (cl : m_class) : (Memory.name, m_attr) Hashtbl.t =
  let attrs = Hashtbl.create 10 in
  Hashtbl.iter (fun k v -> match List.mem AST.Static v.modifiers with
    | false -> Hashtbl.add attrs k v
    | true -> ()
  )
  cl.attributes;
  attrs
