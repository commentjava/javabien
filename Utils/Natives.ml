open Memory

let init_natives debug =
  let native_mem_dump (mem : 'a Memory.memory ref) : statement_return =
    print_memory mem; Void in
  let native_debug (mem : 'a Memory.memory ref) : statement_return =
    debug (Memory.get_object_from_name mem "o"); Void in

  let natives = Hashtbl.create 10 in
  Hashtbl.add natives "Debug.dumpMemory" native_mem_dump;
  Hashtbl.add natives "Debug.debug" native_debug;
    natives;;

