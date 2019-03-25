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
    let fd = Unix.openfile fn [Unix.O_RDONLY] 640 in (* TODO: only read *)
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

  let native_int_pow (mem : 'a Memory.memory ref) : statement_return =
    let rec pow a = function
      | 0 -> 1
      | 1 -> a
      | n ->
        let b = pow a (n / 2) in
        b * b * (if n mod 2 = 0 then 1 else a) in
    let a = match (Memory.get_object_from_name mem "a") with Primitive(Int(i)) -> i in
    let b = match (Memory.get_object_from_name mem "b") with Primitive(Int(i)) -> i in
    Return (Memory.add_object mem (Primitive(Int(pow a b)))) in

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
  Hashtbl.add natives "FileInputStream.close" native_close_file;
  Hashtbl.add natives "FileOutputStream.writeBytes" native_write_bytes;
  Hashtbl.add natives "FileOutputStream.close" native_close_file;
  Hashtbl.add natives "File.open" native_open_file;
  Hashtbl.add natives "Math.pow" native_int_pow;
  Hashtbl.add natives "ServerSocket.init" native_init_socket;
  Hashtbl.add natives "ServerSocket.accept" native_accept_socket;
  Hashtbl.add natives "Socket.close" native_close_file;
  Hashtbl.add natives "ServerSocket.close" native_close_file;

  (* According to unix spec 0, 1, 2 are always opened *)
  new_file Unix.stdin;
  new_file Unix.stdout;
  new_file Unix.stderr;

  natives;;

