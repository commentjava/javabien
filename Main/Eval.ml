open Memory

exception NotImplemented of string;;
exception NullException of string;;
exception InvalidOp of string;;

(** Resolve in memory a fqn of the form `classname.method` *)
let resolve_fqn mem (fqn : string list) : Memory.memory_address =
  let obj_name = List.hd fqn in
  let obj_addr = Memory.get_address_from_name mem obj_name in
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

let cor_primitives mem = function
  | Boolean(i1), Boolean(i2) -> Memory.add_object mem (Primitive(Boolean(i1 || i2)));
  | _ -> raise (InvalidOp "cor: Cannot bool those primitives");;

let cand_primitives mem = function
  | Boolean(i1), Boolean(i2) -> Memory.add_object mem (Primitive(Boolean(i1 && i2)));
  | _ -> raise (InvalidOp "cand: Cannot bool those primitives");;

let or_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 lor i2)));
  | _ -> raise (InvalidOp "or: Cannot bool those primitives");;

let and_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 land i2)));
  | _ -> raise (InvalidOp "and: Cannot bool those primitives");;

let xor_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 lxor i2)));
  | _ -> raise (InvalidOp "xor: Cannot bool those primitives");;

(** Operation to add two Primitive types *)
let add_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 + i2)));
  | _ -> raise (InvalidOp "Cannot add those primitives");;

(** Operation to add two Primitive types *)
let sub_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 - i2)));
  | _ -> raise (InvalidOp "Cannot sub those primitives");;

(** Operation to multiply two Primitive types *)
let mul_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 * i2)));
  | _ -> raise (InvalidOp "Cannot mul those primitives");;

(** Operation to divide two Primitive types *)
let div_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 * i2)));
  | _ -> raise (InvalidOp "Cannot mul those primitives");;

(** Operation to mod two Primitive types *)
let mod_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 mod i2)));
  | _ -> raise (InvalidOp "Cannot mod those primitives");;

let eq_primitives mem = function
  | Boolean(i1), Boolean(i2) -> Memory.add_object mem (Primitive(Boolean(i1 == i2)));
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Boolean(i1 == i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let ne_primitives mem = function
  | Boolean(i1), Boolean(i2) -> Memory.add_object mem (Primitive(Boolean(i1 != i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let gt_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Boolean(i1 > i2)));
  | Boolean(i1), Boolean(i2) -> Memory.add_object mem (Primitive(Boolean(i1 > i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let lt_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Boolean(i1 < i2)));
  | Boolean(i1), Boolean(i2) -> Memory.add_object mem (Primitive(Boolean(i1 < i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let ge_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Boolean(i1 >= i2)));
  | Boolean(i1), Boolean(i2) -> Memory.add_object mem (Primitive(Boolean(i1 >= i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let le_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Boolean(i1 <= i2)));
  | Boolean(i1), Boolean(i2) -> Memory.add_object mem (Primitive(Boolean(i1 <= i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let shl_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 lsl i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let shr_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 lsr i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;


type statement_return =
  | Void
  | Return of Memory.memory_address
  | Raise (* TODO *)

(** Call the entryPoint of an AST tree, this function looks for the function
  * `void main(String[] args)` in the class `HelloWorld` *)
let execute_program (p : AST.t) (args : string list) debug =
  (** Execute the method located at the method_id memory address *)
  let rec execute_method (mem : 'a Memory.memory ref) (caller_id : Memory.memory_address) (method_addr : Memory.memory_address) (args : Memory.memory_address list) : statement_return =
    let mem = Memory.make_memory_stack mem in
    match (Memory.get_object_from_address mem method_addr) with
    | Method m -> (
      List.iter2 (
        fun (argn : AST.argument) argv -> Memory.add_link_name_address mem argn.pident argv
      ) m.arguments args;
      Memory.add_link_name_address mem java_this caller_id;
      exec_st_list mem m.body;
    )
    | MemDumpMethod -> print_memory mem; Void
    | DebugMethod -> debug (Memory.get_object_from_address mem (List.hd args)); Void
    | _ -> raise(MemoryError "Only methods are callable")

  and exec_st_list mem = function
    | [] -> Void
    | hd::tl -> (
      match execute_statement mem hd with
      | Void -> exec_st_list mem tl
      | Return e -> Return e
      | Raise -> raise (NotImplemented "Exception not implemented")
    )

  (** Execute a statement in memory *)
  and execute_statement (mem : 'a Memory.memory ref) = function
    (** TODO: Take into account the type for apparent type` *)
    | AST.VarDecl dl ->
      begin
        List.iter
          (fun (t, name, init) ->
            let type_in_mem =
              match t with
              | Type.Array (_, _)-> raise(NotImplemented "Statement Implemented")
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
        apply_garbage_collector mem gc_keep;
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
    (* | AST.For *)
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
        let class_addr = resolve_fqn mem fqn in
        match Memory.get_object_from_address mem class_addr with
        | Class cl -> Memory.add_object mem (Object {
          t = class_addr;
          attributes = copy_non_static_attrs mem cl
        })
        | _ -> raise (MemoryError "Invalid new on non class object")
      end
    (* | AST.NewArray *)
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
        | Raise -> raise (NotImplemented "Exception not implemented")
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
        | _ -> 0
      end
    | AST.Name n ->
      begin
        try
        Memory.get_address_from_name mem n
        with Not_found -> print_memory mem; raise (MemoryError ("Name " ^ n ^ "not found in scope"))
      end
    (* | AST.ArrayInit *)
    (* | AST.Array *)
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
        let (e1_val, e2_val) =
        match (Memory.get_object_from_address mem e1_addr), (Memory.get_object_from_address mem e2_addr) with
          | Primitive(p1), Primitive(p2) -> p1, p2
          | _ -> raise (InvalidOp "Operations can only be done on primitives")
        in
        let op = match op with
        | AST.Op_cor -> cor_primitives
        | AST.Op_cand -> cand_primitives
        | AST.Op_or -> or_primitives
        | AST.Op_and -> and_primitives
        | AST.Op_xor -> xor_primitives
        | AST.Op_eq -> eq_primitives
        | AST.Op_ne -> ne_primitives
        | AST.Op_gt -> gt_primitives
        | AST.Op_lt -> lt_primitives
        | AST.Op_ge -> ge_primitives
        | AST.Op_le -> le_primitives
        | AST.Op_shl -> shl_primitives
        | AST.Op_shr -> shr_primitives
        | AST.Op_add -> add_primitives
        | AST.Op_sub -> sub_primitives
        | AST.Op_mul -> mul_primitives
        | AST.Op_div -> div_primitives
        | AST.Op_mod -> mod_primitives in
        op mem (e1_val, e2_val)
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
    (* | AST.Array *)
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
    | _ -> raise(NotImplemented "Redirect Expression Implemented")

  (** Declare a new Java type. Only java Classes are implemented *)
  and declare_type mem (t : AST.asttype) : unit =
    match t.info with
    | Class cl ->
      let class_addr = Memory.add_link_name_object mem t.id (Class {
        methods = Hashtbl.create 10;
        attributes = Hashtbl.create 10;
      }) in
      List.iter (declare_method mem class_addr) cl.cmethods;
      List.iter (declare_attr mem class_addr) cl.cattributes
    | Inter -> ()

  (** Declare a new class attribute *)
  and declare_attr mem (class_addr : Memory.memory_address) (a : AST.astattribute) : unit =
    let attr_addr = match a.adefault with
    | None -> java_void
    | Some(expr) -> execute_expression mem expr in
    match Memory.get_object_from_address mem class_addr with
    | Class cl -> Hashtbl.add cl.attributes a.aname {
      v = attr_addr;
      modifiers = a.amodifiers;
    }
    | _ -> raise(MemoryError "Only classes can have methods")

  (** Create a new method for the class located at `class_addr` *)
  and declare_method mem (class_addr : Memory.memory_address) (m : AST.astmethod) : unit =
    let method_addr = Memory.add_object mem (Method{
      body = m.mbody;
      arguments = m.margstype;
    }) in
    match (Memory.get_object_from_address mem class_addr) with
    | Class cl -> Hashtbl.add cl.methods m.mname method_addr
    | _ -> raise(MemoryError "Only classes can have methods")
  in

  let mem = make_populated_memory () in
  List.iter (declare_type mem) p.type_list;
  let main_addr = resolve_fqn mem ["HelloWorld"] in
  let main_method_addr = resolve_fqn mem ["HelloWorld"; "main"] in
  let m_args = [] in (* TODO: use args passed, blocked by array def *)
  execute_method mem main_addr main_method_addr m_args;
  apply_garbage_collector mem [];
  (* print_memory mem; *)

;;

