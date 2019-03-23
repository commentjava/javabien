open Memory

let init_natives debug =
  let native_mem_dump (mem : 'a Memory.memory ref) : statement_return =
    print_memory mem; Void
  in
  let native_debug (mem : 'a Memory.memory ref) : statement_return =
    debug (Memory.get_object_from_name mem "o"); Void
  in

  (* class Double : gives the max possible value for a double *)
  let native_double_max_value mem : statement_return =
    Return (Memory.add_object mem (Primitive(Float((2.0 -. (2.0 ** -52.0)) *. (2.0 ** 1023.0)))))
  in
  (* class Double : gives the smallest positive normal value for a double *)
  let native_double_min_normal mem : statement_return =
    Return (Memory.add_object mem (Primitive(Float(2.0 ** -1022.0))))
  in
  (* class Double : gives the smallest positive nonzero value for a double *)
  let native_double_min_value mem : statement_return =
    Return (Memory.add_object mem (Primitive(Float(2.0 ** -1074.0))))
  in
  (* class Double : gives the Not-a-Number value for a double *)
  let native_double_nan mem : statement_return =
    Return (Memory.add_object mem (Primitive(Float(nan))))
  in
  (* class Double : gives the negative infinity value for a double *)
  let native_double_negative_infinity mem : statement_return =
    Return (Memory.add_object mem (Primitive(Float(neg_infinity))))
  in
  (* class Double : gives the positive infinity value for a double *)
  let native_double_positive_infinity mem : statement_return =
    Return (Memory.add_object mem (Primitive(Float(infinity))))
  in
  (* class Double : returns true if the specified value is a NaN, false otherwise *)
  let native_double_isNaN mem : statement_return =
    match Memory.get_object_from_name mem "d" with
    | Primitive(Float(f)) -> Return (Memory.add_object mem (Primitive(Boolean(classify_float f == FP_nan))))
    | _ -> Return (Memory.add_object mem (Primitive(Boolean(false))))
  in
  (* class Double : returns true if the specified value is an infinite, false otherwise *)
  let native_double_isInfinite mem : statement_return =
    match Memory.get_object_from_name mem "d" with
    | Primitive(Float(f)) -> Return (Memory.add_object mem (Primitive(Boolean(classify_float f == FP_infinite))))
    |_ -> Return (Memory.add_object mem (Primitive(Boolean(false))))
  in
  (* class Double : returns the specified value as an Int *)
  let native_double_intValue mem : statement_return =
    match Memory.get_object_from_name mem "d" with
    | Primitive(Float(f)) -> Return (Memory.add_object mem (Primitive(Int(int_of_float f))))
    | Primitive(Int(i)) -> Return (Memory.get_address_from_name mem "d")
    | _ -> Return (Memory.add_object mem (Primitive(Int(0))))
  in

  let native_set_in0 (mem : 'a Memory.memory ref) : statement_return =
    (Memory.get_object_from_name mem "this"); Void in
  let native_set_out0 (mem : 'a Memory.memory ref) : statement_return =
    debug (Memory.get_object_from_name mem "out"); Void in
  let native_set_err0 (mem : 'a Memory.memory ref) : statement_return =
    debug (Memory.get_object_from_name mem "err"); Void in

  let native_read_bytes (mem : 'a Memory.memory ref) : statement_return =
    debug (Memory.get_object_from_name mem "fd"); Void in

  let native_write_bytes (mem : 'a Memory.memory ref) : statement_return =
    let this = Memory.get_object_from_name mem "this" in
    let java_fd_addr = get_attribute_value_address mem this "fd" in
    let java_fd = match (Memory.get_object_from_address mem java_fd_addr) with Object o -> o in
    let java_buffer = match (Memory.get_object_from_name mem "b") with Array a -> a.values in
    let offest = match (Memory.get_object_from_name mem "off") with Primitive(Int(i)) -> i in
    let len = match (Memory.get_object_from_name mem "len") with Primitive(Int(i)) -> i in
    let fd_addr = Hashtbl.find java_fd.attributes "fd" in
    let fd_ = match (Memory.get_object_from_address mem fd_addr.v) with Primitive(Int(i)) -> i in
    let fd = match fd_ with
    | 0 -> Unix.stdin
    | 1 -> Unix.stdout
    | 2 -> Unix.stderr in
    let buff_ls = Array.to_list (Array.map (
      fun x ->
        match Memory.get_object_from_address mem x with Primitive(Char(c)) -> c
    )
    java_buffer) in
    let buff_ls = List.map (String.make 1) buff_ls in
    let buff = Bytes.of_string (String.concat "" buff_ls) in
    Unix.write fd buff offest len;
    Void in

  let natives = Hashtbl.create 10 in
  Hashtbl.add natives "Debug.dumpMemory" native_mem_dump;
  Hashtbl.add natives "Debug.debug" native_debug;
  Hashtbl.add natives "Double._max_value" native_double_max_value;
  Hashtbl.add natives "Double._min_normal" native_double_min_normal;
  Hashtbl.add natives "Double._min_value" native_double_min_value;
  Hashtbl.add natives "Double._nan" native_double_nan;
  Hashtbl.add natives "Double._negative_infinity" native_double_negative_infinity;
  Hashtbl.add natives "Double._positive_infinity" native_double_positive_infinity;
  Hashtbl.add natives "Double._isNaN" native_double_isNaN;
  Hashtbl.add natives "Double._isInfinite" native_double_isInfinite;
  Hashtbl.add natives "Double._intValue" native_double_intValue;
  Hashtbl.add natives "System.setIn0" native_set_in0;
  Hashtbl.add natives "System.setOut0" native_set_err0;
  Hashtbl.add natives "System.setErr0" native_set_err0;
  Hashtbl.add natives "FileInputStream.readBytes" native_read_bytes;
  Hashtbl.add natives "FileOutputStream.writeBytes" native_write_bytes;
    natives;;

