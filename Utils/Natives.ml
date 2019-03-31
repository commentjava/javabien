open Memory

let opened_files = Hashtbl.create 10;;
let next_key = ref 0;;

let new_file (fd : Unix.file_descr) : int =
  Hashtbl.add opened_files !next_key fd;
  next_key := !next_key + 1;
  !next_key - 1;;


let java_arr_to_ocaml_str mem java_array =
    let buff_ls = Array.to_list (Array.map (
      fun x ->
        match Memory.get_object_from_address mem x with Primitive(Char(c)) -> c
    )
    java_array) in
    String.concat "" (List.map (String.make 1) buff_ls);;

let java_arr_to_ocaml_b mem java_array =
  let s = java_arr_to_ocaml_str mem java_array in
  Bytes.of_string s;;

let create_java_string mem (str : string) : Memory.memory_address =
  let str_cl_addr = Memory.get_address_from_name mem "String" in
  let str_cl = get_class_from_address mem str_cl_addr in
  let str_obj = (Object{
    t = str_cl_addr;
    attributes = copy_non_static_attrs mem str_cl;
  }) in
  let explode str =
    let rec exp i l =
      if i < 0 then l else exp (i - 1) (str.[i] :: l) in
    exp (String.length str - 1) [] in
  let s = Str.global_replace (Str.regexp "\\\\n") (String.make 1 '\n') str in
  let str_c = String.length s in
  let str_o = 0 in

  let str_v = List.map (fun c -> Memory.add_object mem (Primitive(Char(c))))
  (explode s) in
  let str_c_mem = Memory.add_object mem (Primitive(Int(str_c))) in
  let str_o_mem = Memory.add_object mem (Primitive(Int(str_o))) in
  let str_mem = create_array mem str_v in
  set_attribute_value_address mem str_obj "value" str_mem;
  set_attribute_value_address mem str_obj "count" str_c_mem;
  set_attribute_value_address mem str_obj "offset" str_o_mem;
  Memory.add_object mem str_obj

(* *** utils *** *)

(* function used to get a float from the given name in the memory *)
let expect_float mem (n : Memory.name) : float option =
  match Memory.get_object_from_name mem n with
  | Primitive(Float(f)) -> Some f
  | Primitive(Int(i)) -> Some (float_of_int i)
  | _ -> None
;;

(* function used to return a float *)
let return_float mem (f : float) : statement_return =
  Return (Memory.add_object mem (Primitive(Float(f))))
;;

(* function used to return an int *)
let return_int mem (i : int) : statement_return =
  Return (Memory.add_object mem (Primitive(Int(i))))
;;

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
  (* class Double : gives the smallest positive nonzero value for a double *)
  let native_double_min_value mem : statement_return =
    Return (Memory.add_object mem (Primitive(Float(2.0 ** -1074.0))))
  in
  (* class Double : returns the specified value as an Int *)
  let native_double_intValue mem : statement_return =
    match Memory.get_object_from_name mem "d" with
    | Primitive(Int i) -> Return (Memory.get_address_from_name mem "d")
    | Primitive(Float f) ->
      if not(f = f) then
        Return java_0
      else if f >= (float_of_int max_int) then
        return_int mem max_int
      else if f <= (float_of_int min_int) then
        return_int mem min_int
      else
        return_int mem (int_of_float f)
    | _ -> Return java_0
  in

  (* class Math : returns the sine of the specified value *)
  let native_math_sin mem : statement_return =
    match expect_float mem "a" with
    | Some f -> return_float mem (sin f)
    | _ -> Return java_0f
  in
  (* class Math : returns the cosine of the specified value *)
  let native_math_cos mem : statement_return =
    match expect_float mem "a" with
    | Some f -> return_float mem (cos f)
    | _ -> Return java_0f
  in
  (* class Math : returns the tangente of the specified value *)
  let native_math_tan mem : statement_return =
    match expect_float mem "a" with
    | Some f -> return_float mem (tan f)
    | _ -> Return java_0f
  in
  (* class Math : returns the arc sine of the specified value *)
  let native_math_asin mem : statement_return =
    match expect_float mem "a" with
    | Some f -> return_float mem (asin f)
    | _ -> Return java_0f
  in
  (* class Math : returns the arc cosine of the specified value *)
  let native_math_acos mem : statement_return =
    match expect_float mem "a" with
    | Some f -> return_float mem (acos f)
    | _ -> Return java_0f
  in
  (* class Math : returns the arc tangente of the specified value *)
  let native_math_atan mem : statement_return =
    match expect_float mem "a" with
    | Some f -> return_float mem (atan f)
    | _ -> Return java_0f
  in
  (* class Math : returns e raised to the power of the specified value *)
  let native_math_exp mem : statement_return =
    match expect_float mem "a" with
    | Some f -> return_float mem (exp f)
    | _ -> Return java_0f
  in
  (* class Math : returns the natural logarithm of the specified value *)
  let native_math_log mem : statement_return =
    match expect_float mem "a" with
    | Some f -> return_float mem (log f)
    | _ -> Return java_0f
  in
  (* class Math : returns the square root of the specified value *)
  let native_math_sqrt mem : statement_return =
    match expect_float mem "a" with
    | Some f -> return_float mem (sqrt f)
    | _ -> Return java_0f
  in
  (* class Math : returns the smallest double that is not less than the specified value and is equal to an integer *)
  let native_math_ceil mem : statement_return =
    match expect_float mem "a" with
    | Some f -> return_float mem (ceil f)
    | _ -> Return java_0f
  in
  (* class Math : returns the largest double that is not greater than the specified value and is equal to an integer *)
  let native_math_floor mem : statement_return =
    match expect_float mem "a" with
    | Some f -> return_float mem (floor f)
    | _ -> Return java_0f
  in
  (* class Math : returns the angle of polar coordinates from the specified rectangulat coordinates *)
  let native_math_atan2 mem : statement_return =
    match (expect_float mem "y"), (expect_float mem "x") with
    | Some fy, Some fx -> return_float mem (atan2 fy fx)
    | _, _ -> Return java_0f
  in
  (* class Math : returns the first value raised to the power of the second value *)
  let native_math_pow mem : statement_return =
    match (expect_float mem "a"), (expect_float mem "b") with
    | Some fa, Some 0.0 -> Return java_1f
    | Some fa, Some fb when (abs_float fa = 1.0) && (classify_float fb = FP_infinite) -> return_float mem nan
    | Some fa, Some fb -> return_float mem (fa ** fb)
    | _, _ -> Return java_0f
  in

  let native_set_in0 (mem : 'a Memory.memory ref) : statement_return =
    (Memory.get_object_from_name mem "this"); Void in
  let native_set_out0 (mem : 'a Memory.memory ref) : statement_return =
    debug (Memory.get_object_from_name mem "out"); Void in
  let native_set_err0 (mem : 'a Memory.memory ref) : statement_return =
    debug (Memory.get_object_from_name mem "err"); Void in

  let native_read_bytes (mem : 'a Memory.memory ref) : statement_return =
    let this = Memory.get_object_from_name mem "this" in
    let java_fd_addr = get_attribute_value_address mem this "fd" in
    let java_fd = match (Memory.get_object_from_address mem java_fd_addr) with Object o -> o in
    let java_buffer = match (Memory.get_object_from_name mem "b") with Array a -> a.values in
    let offset = match (Memory.get_object_from_name mem "off") with Primitive(Int(i)) -> i in
    let len = match (Memory.get_object_from_name mem "len") with Primitive(Int(i)) -> i in
    let fd_addr = Hashtbl.find java_fd.attributes "fd" in
    let fd_ = match (Memory.get_object_from_address mem fd_addr.v) with Primitive(Int(i)) -> i in
    let fd = Hashtbl.find opened_files fd_ in
    let buff = java_arr_to_ocaml_b mem java_buffer in
    let n_read = Unix.read fd buff offset len in

    Bytes.iteri (fun i x -> java_buffer.(i) <- (Memory.add_object mem (Primitive(Char(x))))) buff;
    Return (Memory.add_object mem (Primitive(Int(n_read)))) in

  let native_open_file (mem : 'a Memory.memory ref) : statement_return =
    let java_fn = match Memory.get_object_from_name mem "filename" with Object o -> o in
    let java_fn_str_addr = Hashtbl.find java_fn.attributes "value" in
    let java_fn_str = match Memory.get_object_from_address mem java_fn_str_addr.v with Array a -> a.values in
    let fn = java_arr_to_ocaml_str mem java_fn_str in

    let fd_id = try
      let fd = Unix.openfile fn [Unix.O_RDONLY] 640 in (* TODO: only read *)
      new_file fd

    with Unix.Unix_error (_, _, _) -> -1 in

    let fd_cl_addr = Memory.get_address_from_name mem "FileDescriptor" in
    let fd_cl = get_class_from_address mem fd_cl_addr in
    let fd_obj = (Object {
      t = fd_cl_addr;
      attributes = copy_non_static_attrs mem fd_cl;
    }) in
    let fd_attr_addr = Memory.add_object mem (Primitive(Int(fd_id))) in
    set_attribute_value_address mem fd_obj "fd" fd_attr_addr;
    Return (Memory.add_object mem fd_obj) in

  let native_close_file (mem : 'a Memory.memory ref) : statement_return =
    let this = Memory.get_object_from_name mem "this" in
    let java_fd_addr = get_attribute_value_address mem this "fd" in
    let java_fd = match (Memory.get_object_from_address mem java_fd_addr) with Object o -> o in
    let fd_addr = Hashtbl.find java_fd.attributes "fd" in
    let fd_ = match (Memory.get_object_from_address mem fd_addr.v) with Primitive(Int(i)) -> i in
    let fd = Hashtbl.find opened_files fd_ in
    Unix.close fd;
    Hashtbl.remove opened_files fd_;
    Void in

  let native_write_bytes (mem : 'a Memory.memory ref) : statement_return =
    let this = Memory.get_object_from_name mem "this" in
    let java_fd_addr = get_attribute_value_address mem this "fd" in
    let java_fd = match (Memory.get_object_from_address mem java_fd_addr) with Object o -> o in
    let java_buffer = match (Memory.get_object_from_name mem "b") with Array a -> a.values in
    let offest = match (Memory.get_object_from_name mem "off") with Primitive(Int(i)) -> i in
    let len = match (Memory.get_object_from_name mem "len") with Primitive(Int(i)) -> i in
    let fd_addr = Hashtbl.find java_fd.attributes "fd" in
    let fd_ = match (Memory.get_object_from_address mem fd_addr.v) with Primitive(Int(i)) -> i in
    let fd = Hashtbl.find opened_files fd_ in
    let buff = java_arr_to_ocaml_b mem java_buffer in
    Unix.write fd buff offest len;
    Void in

  let native_init_socket (mem : 'a Memory.memory ref) : statement_return =
    let this = Memory.get_object_from_name mem "this" in
    let java_port_addr = get_attribute_value_address mem this "port" in
    let port = match (Memory.get_object_from_address mem java_port_addr) with Primitive(Int(p)) -> p in
    let fd = Unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in

    Unix.bind fd (Unix.ADDR_INET(Unix.inet_addr_any, port));
    Unix.listen fd 10;

    let fd_id = new_file fd in
    let fd_cl_addr = Memory.get_address_from_name mem "FileDescriptor" in
    let fd_cl = get_class_from_address mem fd_cl_addr in
    let fd_obj = (Object {
      t = fd_cl_addr;
      attributes = copy_non_static_attrs mem fd_cl;
    }) in
    let fd_attr_addr = Memory.add_object mem (Primitive(Int(fd_id))) in
    set_attribute_value_address mem fd_obj "fd" fd_attr_addr;
    Return (Memory.add_object mem fd_obj) in

  let native_accept_socket (mem : 'a Memory.memory ref) : statement_return =
    let this = Memory.get_object_from_name mem "this" in
    let java_fd_addr = get_attribute_value_address mem this "fd" in
    let java_fd = match (Memory.get_object_from_address mem java_fd_addr) with Object o -> o in
    let fd_addr = Hashtbl.find java_fd.attributes "fd" in
    let fd_ = match (Memory.get_object_from_address mem fd_addr.v) with Primitive(Int(i)) -> i in
    let fd = Hashtbl.find opened_files fd_ in

    let socket_cl_addr = Memory.get_address_from_name mem "Socket" in
    let socket_cl = get_class_from_address mem socket_cl_addr in

    let fd_cl_addr = Memory.get_address_from_name mem "FileDescriptor" in
    let fd_cl = get_class_from_address mem fd_cl_addr in

    let (c_fd, cl_addr) = Unix.accept fd in
    let c_fd_id = new_file c_fd in

    let c_fd_obj = (Object {
      t = fd_cl_addr;
      attributes = copy_non_static_attrs mem fd_cl;
    }) in
    let c_fd_attr_addr = Memory.add_object mem (Primitive(Int(c_fd_id))) in
    set_attribute_value_address mem c_fd_obj "fd" c_fd_attr_addr;
    let c_fd_obj_addr = Memory.add_object mem c_fd_obj in
    let socket_obj = (Object {
      t = socket_cl_addr;
      attributes = copy_non_static_attrs mem socket_cl;
    }) in
    set_attribute_value_address mem socket_obj "fd" c_fd_obj_addr;

    Return (Memory.add_object mem socket_obj) in
  let native_int_to_string (mem : 'a Memory.memory ref) : statement_return =
    let n = match (Memory.get_object_from_name mem "n") with Primitive(Int(i)) -> i in
    Return (create_java_string mem (string_of_int n)) in

  let natives = Hashtbl.create 10 in
  Hashtbl.add natives "Debug.dumpMemory" native_mem_dump;
  Hashtbl.add natives "Debug.debug" native_debug;
  Hashtbl.add natives "Double._max_value" native_double_max_value;
  Hashtbl.add natives "Double._min_value" native_double_min_value;
  Hashtbl.add natives "Double._intValue" native_double_intValue;
  Hashtbl.add natives "Math.sin" native_math_sin;
  Hashtbl.add natives "Math.cos" native_math_cos;
  Hashtbl.add natives "Math.tan" native_math_tan;
  Hashtbl.add natives "Math.asin" native_math_asin;
  Hashtbl.add natives "Math.acos" native_math_acos;
  Hashtbl.add natives "Math.atan" native_math_atan;
  Hashtbl.add natives "Math.exp" native_math_exp;
  Hashtbl.add natives "Math.log" native_math_log;
  Hashtbl.add natives "Math.sqrt" native_math_sqrt;
  Hashtbl.add natives "Math.ceil" native_math_ceil;
  Hashtbl.add natives "Math.floor" native_math_floor;
  Hashtbl.add natives "Math.atan2" native_math_atan2;
  Hashtbl.add natives "Math.pow" native_math_pow;
  Hashtbl.add natives "System.setIn0" native_set_in0;
  Hashtbl.add natives "System.setOut0" native_set_err0;
  Hashtbl.add natives "System.setErr0" native_set_err0;
  Hashtbl.add natives "FileInputStream.readBytes" native_read_bytes;
  Hashtbl.add natives "FileInputStream.close" native_close_file;
  Hashtbl.add natives "FileOutputStream.writeBytes" native_write_bytes;
  Hashtbl.add natives "FileOutputStream.close" native_close_file;
  Hashtbl.add natives "File.open" native_open_file;
  Hashtbl.add natives "ServerSocket.init" native_init_socket;
  Hashtbl.add natives "ServerSocket.accept" native_accept_socket;
  Hashtbl.add natives "Socket.close" native_close_file;
  Hashtbl.add natives "ServerSocket.close" native_close_file;
  Hashtbl.add natives "String.fromInteger" native_int_to_string;

  (* According to unix spec 0, 1, 2 are always opened *)
  new_file Unix.stdin;
  new_file Unix.stdout;
  new_file Unix.stderr;

  natives;;

