open Memory
open Primitives

exception NotImplemented of string;;
exception NullException of string;;
exception IndexError of string;;
exception CannotFindSymbol of string;;

(** Resolve in memory a fqn of the form `parentclass.classname.method` *)
let resolve_fqn mem (fqn : string list) : Memory.memory_address =
  let obj_name = List.hd fqn in
  let obj_addr =try
    Memory.get_address_from_name mem obj_name
  with Not_found -> raise (CannotFindSymbol ("Cannot find symbol " ^ obj_name)) in
  List.fold_left
    (fun obj_id name ->
      match (Memory.get_object_from_address mem obj_addr) with
      | Class cl -> (
        try
          Hashtbl.find cl.methods name
        with Not_found -> (Hashtbl.find cl.attributes name).v
      );
      | Object o -> raise (NotImplemented "Resolution not Implemented");
      | Null -> raise (NullException (name ^ " is undefined"));
      | Method _ -> raise (MemoryError ("Could not resolve " ^ name));
      | _ -> -1
    )
    obj_addr
    (List.tl fqn)
;;

(** Call the entryPoint of an AST tree, this function looks for the function
  * `void main(String[] args)` in the class `entry_point` *)
let execute_program (p : AST.t) (additional_asts : AST.t list) (entry_point : string) (args : string list) debug =
  (** Execute the method located at the method_id memory address *)
  let rec execute_method (mem : 'a Memory.memory ref) (caller_id : Memory.memory_address) (method_addr : Memory.memory_address) (args : Memory.memory_address list) : statement_return =
    let mem = Memory.make_memory_stack mem in
    let bind_args arguments =
      List.iter2 (
        fun (argn : AST.argument) argv -> Memory.add_link_name_address mem argn.pident argv
      ) arguments args;
      Memory.add_link_name_address mem java_this caller_id in
    match (Memory.get_object_from_address mem method_addr) with
    | Method m -> (
      bind_args m.arguments;
      exec_st_list mem m.body;
    )
    | NativeMethod m -> (
      bind_args m.arguments;
      m.body mem;
    )
    | _ -> raise(MemoryError "Only methods are callable")

  and exec_st_list mem = function
    | [] -> Void
    | hd::tl -> (
      match execute_statement mem hd with
      | Void -> exec_st_list mem tl
      | Return e -> Return e
      | Raise -> raise (NotImplemented "Exceptions are not implemented")
    )

  (** Execute a statement in memory *)
  and execute_statement (mem : 'a Memory.memory ref) = function
    (** TODO: Take into account the apparent type *)
    | AST.VarDecl dl ->
      begin
        List.iter
          (fun (t, name, init) ->
            let type_in_mem = (* TODO: probably check type here, like arrray length *)
              match t with
              | Type.Array (_, _) -> "array"
              | Type.Primitive _ -> "prim"
              | Type.Ref ref_type -> ref_type.tid
              | Type.Void -> raise(MemoryError "Invalid type")
            in
            let variable_addr =
              match init with
              | None -> Memory.add_object mem Null
              | Some e -> execute_expression mem e
            in
            Memory.add_link_name_address mem name variable_addr;
          )
          dl;
          Void
      end
    | AST.Block b ->
      begin
        let mem = Memory.make_empiled_memory mem in
        let res = exec_st_list mem b in
        let gc_keep = match res with
        | Void -> []
        | Return e -> [e]
        | Raise -> raise (NotImplemented "Exception not implemented") in
        (* apply_garbage_collector mem gc_keep; *)
        res
      end
    | AST.Nop -> Void
    | AST.While (cond, body) ->
      begin
        let mem = Memory.make_empiled_memory mem in
        let rec run_while cond body =
          let res_addr = execute_expression mem cond in
          match (Memory.get_object_from_address mem res_addr) with
          | Primitive(Boolean(true)) -> (execute_statement mem body; run_while cond body;)
          | Primitive(Boolean(false)) -> ();
        in
        run_while cond body;
        Void
      end
    | AST.For (init, cond, update_expr, body) ->
      begin
        let mem = Memory.make_empiled_memory mem in
        List.iter
          ( fun (t, name, expr) ->
            match expr with
            | None -> (Memory.add_link_name_object mem name Null; ())
            | Some(e) -> Memory.add_link_name_address mem name (execute_expression mem e)
          )
          init;
        let rec run_for (() : unit) =
          let res =
            match cond with
            | None -> Primitive(Boolean(true))
            | Some(c) -> Memory.get_object_from_address mem (execute_expression mem c)
          in
          match res with
          | Primitive(Boolean(true)) ->
            begin
              execute_statement mem body;
              List.map (execute_expression mem) update_expr;
              run_for ()
            end
          | Primitive(Boolean(false)) -> ()
        in
        run_for ();
        Void
      end
    | AST.If (cond, is_true, is_false) ->
      begin
        let mem = Memory.make_empiled_memory mem in
        let res_addr = execute_expression mem cond in
        begin
          match Memory.get_object_from_address mem res_addr, is_false with
          | Primitive(Boolean(true)), _ -> execute_statement mem is_true
          | Primitive(Boolean(false)), Some(e) -> execute_statement mem e
          | Primitive(Boolean(false)), None -> Void
        end
      end
    | AST.Return None -> Return java_void
    | AST.Return Some(expr) -> Return (execute_expression mem expr)
    (* | AST.Throw *)
    (* | AST.Try *)
    | AST.Expr e -> execute_expression mem e; Void
    | _ -> raise(NotImplemented "Statement not Implemented")

  (** Execute an expression in memory *)
  and execute_expression mem (expr : AST.expression) : Memory.memory_address =
    match expr.edesc with
    | AST.New (None, fqn, args) ->
      begin
        let args_addr = List.map (fun e -> execute_expression mem e) args in
        let class_addr = resolve_fqn mem fqn in
        match Memory.get_object_from_address mem class_addr with
        | Class cl -> (
          let obj_addr = Memory.add_object mem (Object {
            t = class_addr;
            attributes = copy_non_static_attrs mem cl
          }) in
          match cl.constructors with
          | [] -> obj_addr;
          | hd::tl -> execute_method mem obj_addr hd args_addr; obj_addr; (* TODO: This is  a hack because we do not handle method overloading *)
        )
        | _ -> raise (MemoryError "Invalid new on non-class object")
      end
    | AST.NewArrayInitialized (t, expr) -> execute_expression mem expr
    | ArrayInit (values) ->
        let arr = Array.of_list (List.map (execute_expression mem) values) in
        Memory.add_object mem (Array {
          values = arr;
        })
    | NewArrayEmpty (t, sizes) ->
      begin
        let empty_value = function
        | Type.Primitive(Int) -> Memory.add_object mem (Primitive(Int(0)))
        | _ -> raise (NotImplemented "EmptyArray not implemented for this type") in
        let rec repeat f = function
        | 0 -> []
        | n -> (f) :: repeat f (n-1) in
        let rec build_array = function
        | [hd] -> Memory.add_object mem (Array {
          values = Array.of_list (repeat (empty_value t) hd);
        })
        | hd :: tl -> Memory.add_object mem (Array {
          values = Array.of_list (repeat (build_array tl) hd);
        }) in
        let sizes_addr = List.map (execute_expression mem) sizes in
        build_array sizes_addr
      end
    | AST.Call (obj_name, method_name, args) ->
      begin
        let obj_addr = match obj_name with
        | Some(addr) -> execute_expression mem addr
        | None -> Memory.get_address_from_name mem java_this in
        let obj = Memory.get_object_from_address mem obj_addr in
        let args_addr = List.map (fun e -> execute_expression mem e) args in
        let method_addr = get_method_address mem obj method_name in
        match execute_method mem obj_addr method_addr args_addr with
        | Void -> java_void
        | Return e -> e
        | Raise -> raise (NotImplemented "Exception are not implemented")
      end
    | AST.Attr (caller, aname) ->
      begin
        let cl_addr = execute_expression mem caller in
        let cl = Memory.get_object_from_address mem cl_addr in
        get_attribute_value_address mem cl aname
      end
    (* | AST.If (cond, is_true, is_false) -> (
        let res_id = execute_expression mem cond in
        match Hashtbl.find !mem.data res_id with
        | Primitive(Boolean(true)) -> execute_expression mem is_true;
        | Primitive(Boolean(false)) -> execute_expression mem is_false;
    ); *)
    | AST.Val v ->
      begin
        match v with
        | AST.Int i -> Memory.add_object mem (Primitive(Int(int_of_string i)))
        | AST.Boolean b -> Memory.add_object mem (Primitive(Boolean(b)))
        | AST.Char (Some c) -> Memory.add_object mem (Primitive(Char(c)))
        | AST.Char (None) -> Memory.add_object mem (Primitive(Char(' ')))
        (*| AST.String s ->
            let str_cl_addr = Memory.get_address_from_name mem "String" in
            let str_cl = get_class_from_address mem str_cl_addr in
            let str_obj = (Object{
              t = str_cl_addr;
              attributes = copy_non_static_attrs mem str_cl;
            }) in
            let str_v = List.map (fun c -> Memory.add_object mem (Primitive(Char(c))))
            (List.init (String.length s) (String.get s)) in
            let str_mem = Memory.add_object mem (Array {
              values = Array.of_list str_v;
            }) in
            set_attribute_value_address mem str_obj "value" str_mem;
            Memory.add_object mem str_obj*)
        | _ -> 0
      end
    | AST.Name n ->
      begin
        try
        Memory.get_address_from_name mem n
        with Not_found -> print_memory mem; raise (MemoryError ("Name " ^ n ^ " not found in scope"))
      end
    (* | AST.ArrayInit *)
    | AST.Array (obj_name, attrs) ->
        let rec fetch_obj obj_addr = function
          | [] -> obj_addr;
          | hd::tl -> (
            let hd_addr = execute_expression mem hd in
            let hd_value = match Memory.get_object_from_address mem hd_addr with
            | Primitive (Int(p)) -> p;
            | _ -> raise (IndexError "Unkown index") in
            match Memory.get_object_from_address mem obj_addr with
            | Array (a) -> fetch_obj a.values.(hd_value) tl;
            | _ -> raise (IndexError "Unkown index");
          ) in
        let obj_addr = execute_expression mem obj_name in
        fetch_obj obj_addr attrs

    | AST.AssignExp (e1, op, e2) ->
      begin
        redirect_expression mem e1 op (execute_expression mem e2)
      end
    (* | AST.Post *)
    (* | AST.Pre *)
    | AST.Op (e1, op, e2) ->
      begin
        let e1_addr = execute_expression mem e1 in
        let e2_addr = execute_expression mem e2 in
        let (e1_val, e2_val) = ((Memory.get_object_from_address mem e1_addr),
                               (Memory.get_object_from_address mem e2_addr)) in
        match e1_val, e2_val, op with
        | Primitive(p1), Primitive(p2), AST.Op_cor -> cor_primitives mem (p1, p2)
        | Primitive(p1), Primitive(p2), AST.Op_cand -> cand_primitives mem (p1, p2)
        | Primitive(p1), Primitive(p2), AST.Op_or -> or_primitives mem (p1, p2)
        | Primitive(p1), Primitive(p2), AST.Op_and -> and_primitives mem (p1, p2)
        | Primitive(p1), Primitive(p2), AST.Op_xor -> xor_primitives mem (p1, p2)
        | Primitive(p1), Primitive(p2), AST.Op_eq -> eq_primitives mem (p1, p2)
        | Object(_), Object(_), AST.Op_eq -> eq_obj mem (e1_addr, e2_addr)
        | Null, Null, AST.Op_eq -> eq_obj mem (0, 0)
        | Null, Object(_), AST.Op_eq -> eq_obj mem (0, e2_addr)
        | Object(_), Null, AST.Op_eq -> eq_obj mem (e1_addr, 0)
        | Primitive(p1), Primitive(p2), AST.Op_ne -> ne_primitives mem (p1, p2)
        | Object(_), Object(_), AST.Op_ne -> ne_obj mem (e1_addr, e2_addr)
        | Null, Null, AST.Op_ne -> ne_obj mem (0, 0)
        | Null, Object(_), AST.Op_ne -> ne_obj mem (0, e2_addr)
        | Object(_), Null, AST.Op_ne -> ne_obj mem (e1_addr, 0)
        | Primitive(p1), Primitive(p2), AST.Op_gt -> gt_primitives mem (p1, p2)
        | Primitive(p1), Primitive(p2), AST.Op_lt -> lt_primitives mem (p1, p2)
        | Primitive(p1), Primitive(p2), AST.Op_ge -> ge_primitives mem (p1, p2)
        | Primitive(p1), Primitive(p2), AST.Op_le -> le_primitives mem (p1, p2)
        | Primitive(p1), Primitive(p2), AST.Op_shl -> shl_primitives mem (p1, p2)
        | Primitive(p1), Primitive(p2), AST.Op_shr -> shr_primitives mem (p1, p2)
        | Primitive(p1), Primitive(p2), AST.Op_add -> add_primitives mem (p1, p2)
        | Primitive(p1), Primitive(p2), AST.Op_sub -> sub_primitives mem (p1, p2)
        | Primitive(p1), Primitive(p2), AST.Op_mul -> mul_primitives mem (p1, p2)
        | Primitive(p1), Primitive(p2), AST.Op_div -> div_primitives mem (p1, p2)
        | Primitive(p1), Primitive(p2), AST.Op_mod -> mod_primitives mem (p1, p2)
      end
    (* | AST.CondOp *)
    (* | AST.Cast *)
    (* | AST.Type *)
    (* | AST.ClassOf *)
    (* | AST.InstanceOf *)
    (* | AST.VoidClass *)
    | _ -> raise(NotImplemented "Expression not Implemented")
  (** Redirect the result of the given expression to the given memory_address *)
  and redirect_expression mem (e1 : AST.expression) (op : AST.assign_op) (e2_addr : Memory.memory_address) : Memory.memory_address =
    match e1.edesc with
    (* | New of string option * string list * expression list *)
    (* | NewArray of Type.t * (expression option) list * expression option *)
    (* | Call of expression option * string * expression list *)
    (* | Attr of expression * string *)
    | AST.Attr (caller, attr_name) ->
      begin
        let cl_addr = execute_expression mem caller in
        let cl = Memory.get_object_from_address mem cl_addr in
        let attr_addr = get_attribute_value_address mem cl attr_name in
        let res_addr =
          match op with
          | AST.Assign -> e2_addr
          | _ -> raise(NotImplemented "Attr Redirect Expression not Implemented")
          in
        set_attribute_value_address mem cl attr_name res_addr;
        res_addr
      end
    (* | If of expression * expression * expression *)
    (* | Val of value *)
    | AST.Name (n) ->
      begin
        let e1_val = Memory.get_object_from_name mem n in
        let res_addr =
          match op with
          | AST.Assign -> e2_addr
          (* | Ass_add -> TODO : make a function to apply an operator between two memory_address or two memory_unit and use it in execute_expression->AST.Op *)
          (* | Ass_sub *)
          (* | Ass_mul *)
          (* | Ass_div *)
          (* | Ass_mod *)
          (* | Ass_shl *)
          (* | Ass_shr *)
          (* | Ass_shrr *)
          (* | Ass_and *)
          (* | Ass_xor *)
          (* | Ass_or *)
          | _ -> raise(NotImplemented "Named Redirect Expression not Implemented")
        in
        Memory.add_link_name_address mem n res_addr;
        res_addr
      end
    (* | AST.ArrayInit *)
    | AST.Array(obj_name, attrs) ->
      let get_arr_or_raise addr =
        match Memory.get_object_from_address mem addr with
          | Array (a) -> a.values
          | _ -> raise (IndexError "Unkown index") in
      let rec fetch_prev_obj prev_obj_addr obj_addr index = function
        | [] -> (prev_obj_addr, index);
        | hd::tl -> (
          let hd_addr = execute_expression mem hd in
          let hd_value = match Memory.get_object_from_address mem hd_addr with
          | Primitive (Int(p)) -> p;
          | _ -> raise (IndexError "Unkown index") in
          let a = get_arr_or_raise obj_addr in
          fetch_prev_obj obj_addr a.(hd_value) hd_value tl;
        ) in
      let obj_addr = execute_expression mem obj_name in
      let arr_addr, index = fetch_prev_obj obj_addr obj_addr 0 attrs  in
      Array.set (get_arr_or_raise arr_addr) index e2_addr;
      e2_addr
    (* | AST.AssignExp (e1, op, e2) -> *)
    (* | AST.Post *)
    (* | AST.Pre *)
    (* | AST.Op (e1, op, e2) ->*)
    (* | AST.CondOp *)
    (* | AST.Cast *)
    (* | AST.Type *)
    (* | AST.ClassOf *)
    (* | AST.InstanceOf *)
    (* | AST.VoidClass *)
    | _ -> raise(NotImplemented "Redirect Expression not Implemented")

  (** Declare a new Java type. Only java Classes are implemented *)
  and declare_type mem natives (t : AST.asttype) : unit =
    match t.info with
    | Class cl ->
      let constructors = List.map (declare_constructor mem) cl.cconsts in
      let class_addr = Memory.add_link_name_object mem t.id (Class {
        name = t.id;
        constructors = constructors;
        methods = Hashtbl.create 10;
        attributes = Hashtbl.create 10;
      }) in
      List.iter (declare_method mem natives class_addr) cl.cmethods;
      List.iter (declare_attr mem class_addr) cl.cattributes
    | Inter -> raise (NotImplemented "Interfaces are not implemented")

  (** Declare a new class attribute *)
  and declare_attr mem (class_addr : Memory.memory_address) (a : AST.astattribute) : unit =
    let attr_addr = match a.adefault with
    | None -> java_void
    | Some(expr) -> execute_expression mem expr in (* TODO execute now only for static, otherwise execute at object instantiation *)
    let cl = get_class_from_address mem class_addr in
    Hashtbl.add cl.attributes a.aname {
      v = attr_addr;
      modifiers = a.amodifiers;
    }

  (** Create a new constructor *)
  and declare_constructor mem (m : AST.astconst) : Memory.memory_address =
      Memory.add_object mem (Method{
        body = m.cbody;
        arguments = m.cargstype;
      })
  (** Create a new method for the class located at `class_addr` *)
  and declare_method mem natives (class_addr : Memory.memory_address) (m : AST.astmethod) : unit =
    let cl = get_class_from_address mem class_addr in
    match List.exists (fun x -> x == AST.Native) m.mmodifiers with
    | false -> (
      let method_addr = Memory.add_object mem (Method{
        body = m.mbody;
        arguments = m.margstype;
      }) in
      Hashtbl.add cl.methods m.mname method_addr
      )
    | true -> (
      let native_name = String.concat "." [cl.name; m.mname] in  (* TODO: handle classes in classes *)
      let native_method = Hashtbl.find natives native_name in
      let method_addr = Memory.add_object mem (NativeMethod{
        body = native_method;
        arguments = m.margstype;
      }) in
      Hashtbl.add cl.methods m.mname method_addr
      ) in

  let natives = Natives.init_natives debug in
  let mem = make_populated_memory () in

  (* load additionnal types (e.g. stdlib) *)
  List.iter (
    fun (prog : AST.t) -> (List.iter (declare_type mem natives) prog.type_list)
    (* fun (prog : AST.t) -> (AST.print_AST prog) *)
    )
  additional_asts;

  (* Populate program memory *)
  List.iter (declare_type mem natives) p.type_list;

  (* Entry point *)
  let main_addr = resolve_fqn mem [entry_point] in
  let main_method_addr = resolve_fqn mem [entry_point; "main"] in
  let m_args = [] in (* TODO: use args passed, blocked by array def *)
  execute_method mem main_addr main_method_addr m_args;
  apply_garbage_collector mem [];
;;

