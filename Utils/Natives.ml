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

  natives
;;

