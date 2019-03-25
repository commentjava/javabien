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
  val save_temp_var : 'a memory ref -> memory_address -> unit
  (***** Memory tools *************************************)
  val apply_garbage_collector : 'a memory ref -> bool -> ('a memory ref -> 'a -> (memory_address, bool) Hashtbl.t -> unit) -> unit

end = struct
  type memory_address = int
  type name = string

  (***** Memory definition ******************************************)
  type reference_store = (name, memory_address) Hashtbl.t
  type 'a data_store = (memory_address, 'a) Hashtbl.t
  type address_counter = { mutable ac : memory_address }
  type unnamed_reference_store = { mutable urs : memory_address list }
  type gci = { mutable old_pop : int }

  type 'a memory = {
    names : reference_store list;
    current_expr : unnamed_reference_store list;
    data : 'a data_store;
    next_id : address_counter ref;
    parent : 'a memory option; (* link to the parent stack *)
    gc_infos : gci; (* informations for the GC *)
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
        List.iter2
          (fun n ce ->
            Printf.printf "  Stack :\n";
            Hashtbl.iter
              (fun x y ->
                Printf.printf "    %s -> %i\n" x y
              )
              n;
            List.iter
              (fun y ->
                Printf.printf "    _ -> %i\n" y
              )
              ce.urs
          )
          s.names s.current_expr;
        Printf.printf "\nPARENT STACK:\n";
        print_stack s.parent)
    in
    print_stack (Some !m);
    Printf.printf "=== Memory Structure ===\n";
    let rec print_data (i : int) =
      if i < 0 then
        ()
      else
        match Hashtbl.find_opt (!m.data) i with
        | None -> print_data (i - 1)
        | Some(obj) ->
          begin
            Printf.printf "%i -> " i;
            f obj;
            print_data (i - 1)
          end
    in
    print_data (!(!m.next_id).ac);
    Printf.printf "\n\n"

  (***** Memory getter ************************************)
  (* HIDDEN
  Give the next free memory_address and increase the counter
  *)
  let get_next_address (addr_c : address_counter ref) : memory_address =
    let mem_a = !addr_c.ac in
    !addr_c.ac <- mem_a + 1;
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
    try
      Hashtbl.find !mem.data mem_a
    with
      Not_found ->
        begin
          print_endline ("The address " ^ (string_of_int mem_a) ^ " does not exist.");
          raise Not_found
        end

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
      current_expr = [{ urs = [] }];
      data = Hashtbl.create 10;
      next_id = ref { ac = 0 };
      parent = None;
      gc_infos = { old_pop = 0 };
    }

  (*
  Give a reference to a memory empiled over the given one
  *)
  let make_empiled_memory (mem : 'a memory ref) : 'a memory ref =
    ref {
      names = (Hashtbl.create 10)::(!mem.names);
      current_expr = {urs = []}::(!mem.current_expr);
      data = !mem.data;
      next_id = ref (!(!mem.next_id));
      parent = !mem.parent;
      gc_infos = !mem.gc_infos;
    }
  (**
   * New memory stack used for method calls
   *)
  let make_memory_stack (mem : 'a memory ref) : 'a memory ref =
    ref {
      names = (Hashtbl.create 10)::[List.hd (List.rev (!mem).names)];
      current_expr = {urs = []} :: [List.hd (List.rev (!mem).current_expr)];
      data = !mem.data;
      next_id = ref (!(!mem.next_id));
      parent = Some(!mem);
      gc_infos = !mem.gc_infos;
    }

  let save_temp_var (mem : 'a memory ref) (addr : memory_address) : unit =
    (List.hd (!mem).current_expr).urs <- (addr :: (List.hd (!mem).current_expr).urs)

  (***** Memory tools *************************************)
  let apply_garbage_collector (mem : 'a memory ref) (force : bool) (f : 'a memory ref -> 'a -> (memory_address, bool) Hashtbl.t -> unit) : unit =
    if (Hashtbl.length (!mem).data) < 2 * (!mem).gc_infos.old_pop && (not force) then
      ()
    else
      let checker = Hashtbl.create 10 in
      (* add all address to the checker *)
      Hashtbl.iter
        (fun mem_a obj ->
          Hashtbl.add checker mem_a true
        )
        !mem.data;
      (* remove all address linked to the memory from the checker *)
      let rec check_stack (memO : 'a memory option) : unit =
        match memO with
        | None -> ()
        | Some(s) -> (
          List.iter
            (fun (n : reference_store) ->
              Hashtbl.iter
                (fun (n : name) (addr : memory_address) ->
                  f mem (get_object_from_address mem addr) checker;
                  Hashtbl.remove checker addr
                )
                n
            )
            s.names;
          List.iter
            (fun (ce : unnamed_reference_store) ->
              List.iter
                (fun (addr : memory_address) ->
                  f mem (get_object_from_address mem addr) checker;
                  Hashtbl.remove checker addr
                )
                ce.urs
            )
            s.current_expr;
          check_stack s.parent;
          ) in
      check_stack (Some !mem);
      (* remove all address left in the checker from the data *)
      Hashtbl.iter
        (fun addr b ->
          Hashtbl.remove !mem.data addr;
        )
        checker;
      (!mem).gc_infos.old_pop <- Hashtbl.length (!mem).data
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
  constructors : Memory.memory_address list;
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
and m_array =  {
  values : Memory.memory_address array;
  attributes : (Memory.name, m_attr) Hashtbl.t;
}
and m_primitive =
  | Int of int
  | Boolean of bool
  | Char of char
  | Float of float
and memory_unit =
  | Class of m_class
  | Method of m_method
  | Object of m_object
  | Primitive of m_primitive
  | Null
  | Array of m_array
  | NativeMethod of m_native_method

let string_from_memory_unit (u : memory_unit) : string =
  match u with
  | Class c -> "Class"
  | Method m -> "Method"
  | Object o -> "Object"  (* TODO: use to_string method *)
  | Null -> "null"
  | Array a -> "Array: " ^ String.concat " ; " (Array.to_list (Array.map string_of_int a.values))
  | Primitive (Int i) -> string_of_int i
  | Primitive (Boolean b) -> string_of_bool b
  | Primitive (Char c) -> String.make 1 c
  | Primitive (Float f) -> string_of_float f
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
        Printf.printf "\t[a] %s -> %i\n" x y.v;
      )
      c.attributes;
    List.iter
      (fun addr ->
        Printf.printf "\t[c] -> %i\n" addr
      )
      c.constructors;
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
  | Array a ->
      Printf.printf "\t[array]\n";
      Array.iter
      (fun x ->
        Printf.printf "\t %i\n" x;
      )
      a.values;
  | Primitive (Int i) -> Printf.printf "\t[INT] %i\n" i;
  | Primitive (Char c) -> Printf.printf "\t[CHAR] %c\n" c;
  | Primitive (Boolean b) -> Printf.printf "\t[BOOL] %b\n" b;
  | Primitive (Float f) -> Printf.printf "\t[FLOAT] %F\n" f;
;;

(* -> populate_mem
Give a reference to a new memory populated with the following :
  "null" -> 0 -> Null
*)
let make_populated_memory () : 'a Memory.memory ref =
  let mem = Memory.make_memory () in
  Memory.add_link_name_object mem "null" Null;
  Memory.add_link_name_object mem "__1" (Primitive(Int 1));
  Memory.add_link_name_object mem "__0" (Primitive(Int 0));
  Memory.add_link_name_object mem "__true" (Primitive(Boolean true));
  Memory.add_link_name_object mem "__false" (Primitive(Boolean false));
  Memory.add_link_name_object mem "__0f" (Primitive(Float 0.0));
  Memory.add_link_name_object mem "__empty_chr" (Primitive(Char (char_of_int 0)));
  mem
;;

let java_this : Memory.name = "this";;
let java_void : Memory.memory_address = 0;;
let java_1 : Memory.memory_address = 1;;
let java_0 : Memory.memory_address = 2;;
let java_true : Memory.memory_address = 3;;
let java_false : Memory.memory_address = 4;;
let java_0f : Memory.memory_address = 5;;
let java_empty_char : Memory.memory_address = 6;;

let print_memory mem : unit =
  Memory.print_memory mem print_memory_unit
;;

let rec remove_addr_from_checker mem (mem_u : memory_unit) (checker : (Memory.memory_address, bool) Hashtbl.t) : unit =
  match mem_u with
  | Class c->
    begin
      Hashtbl.iter
        (fun n addr ->
          remove_addr_from_checker mem (Memory.get_object_from_address mem addr) checker;
          Hashtbl.remove checker addr
        )
        c.methods;
      List.iter
        (fun addr ->
          remove_addr_from_checker mem (Memory.get_object_from_address mem addr) checker;
          Hashtbl.remove checker addr
        )
        c.constructors;
      Hashtbl.iter
        (fun n attr ->
          let addr = attr.v in
          remove_addr_from_checker mem (Memory.get_object_from_address mem addr) checker;
          Hashtbl.remove checker addr
        )
        c.attributes
    end
  | Method m -> ()
  | Object o ->
    begin
      remove_addr_from_checker mem (Memory.get_object_from_address mem o.t) checker;
      Hashtbl.remove checker o.t;
      Hashtbl.iter
        (fun n attr ->
          let addr = attr.v in
          remove_addr_from_checker mem (Memory.get_object_from_address mem addr) checker;
          Hashtbl.remove checker addr
        )
        o.attributes
    end
  | Primitive p -> ()
  | Null -> ()
  | Array a ->
    Array.iter
      (fun (addr : Memory.memory_address) ->
        remove_addr_from_checker mem (Memory.get_object_from_address mem addr) checker;
        Hashtbl.remove checker addr
      )
      a.values
  | NativeMethod m -> ()
;;

let apply_garbage_collector mem force : unit =
  (* print_memory mem; *)
  Memory.apply_garbage_collector mem force remove_addr_from_checker;
  (* Printf.printf "!!!! Gargbage collected !!!!!\n"; *)
  (* print_memory mem; *)
;;

let get_method_address (mem : memory_unit Memory.memory ref) obj n =
  let methods = match obj with
    | Object o -> (
      match Memory.get_object_from_address mem o.t with
      | Class c -> c.methods
      | _ -> raise (MemoryError "Only classes and objects can have methods")
    )
    | Class c -> c.methods
    | Null -> raise (MemoryError "NullException")
    | _ -> raise (MemoryError "Only classes and objects can have methods") in
  Hashtbl.find methods n;;

let get_class_from_address mem addr : m_class =
  match Memory.get_object_from_address mem addr with
  | Class c -> c
  | _ -> raise (MemoryError "Class expected");;

let get_attribute_value_address (mem : memory_unit Memory.memory ref) (obj : memory_unit) (n : Memory.name) =
  let attributes = match obj with
  | Object o -> [o.attributes; (get_class_from_address mem o.t).attributes]
  | Class c -> [c.attributes]
  | Array a -> [a.attributes]
  | Null -> raise (MemoryError "NullException")
  | _ -> raise (MemoryError "Only classes and objects can have attributes") in
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
  attrs;;

let create_array mem (ls : Memory.memory_address list) : Memory.memory_address =
  let length_addr = Memory.add_object mem (Primitive(Int(List.length ls))) in
  let arr_attrs = Hashtbl.create 10 in
  Hashtbl.add arr_attrs "length" ({
    v = length_addr;
    modifiers = [];
  });
  Memory.add_object mem (Array {
    values = Array.of_list ls;
    attributes = arr_attrs;
  })

