open Memory

exception NotImplemented of string;;
exception NullException of string;;
exception InvalidOp of string;;

(** Create a new method for the class located at `class_id` *)
let declare_method mem (class_id : memory_address) (m : AST.astmethod) =
  let method_id = new_mem_obj mem (Method{
    body = m.mbody
  }) in
  match Hashtbl.find !mem.data class_id with
  | Class cl -> Hashtbl.add cl.methods m.mname method_id;
  | _ -> raise(MemoryError "Only classes can have methods");;

(** Declare a new Java type. Only java Classes are implemented *)
let declare_type mem (t : AST.asttype) =
  let class_id = !mem.next_id in
  match t.info with
  | Class cl -> (
    let methods = Hashtbl.create 10 in
    let class_id = new_mem_obj mem (Class { methods = methods; }) in
    new_mem_name mem t.id class_id;
    List.iter (declare_method mem class_id) cl.cmethods;);
  | Inter -> ();
;;

(** Resolve in memory a fqn of the form `classname.method` *)
let resolve_fqn mem fqn =
    let obj_id = Hashtbl.find !mem.names (List.hd fqn) in
    List.fold_left (fun obj_id name ->
      match Hashtbl.find !mem.data obj_id with
      | Class cl -> (
        try
          Hashtbl.find cl.methods name
        with Not_found -> raise (NotImplemented "Resolution of attributes not impl")
      );
      | Object o -> raise (NotImplemented "Resolution not Implemented");
      | Null -> raise (NullException (name ^ " is undefined"));
      | Method _ -> raise (MemoryError ("Could not resolve " ^ name));
      | _ -> -1)
    obj_id
    (List.tl fqn);;

let cor_primitives mem = function
  | Boolean(i1), Boolean(i2) -> new_mem_obj mem (Primitive(Boolean(i1 || i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let cand_primitives mem = function
  | Boolean(i1), Boolean(i2) -> new_mem_obj mem (Primitive(Boolean(i1 && i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let or_primitives mem = function
  | Int(i1), Int(i2) -> new_mem_obj mem (Primitive(Int(i1 lor i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let and_primitives mem = function
  | Int(i1), Int(i2) -> new_mem_obj mem (Primitive(Int(i1 land i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let xor_primitives mem = function
  | Int(i1), Int(i2) -> new_mem_obj mem (Primitive(Int(i1 lxor i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

(** Operation to add two Primitive types *)
let add_primitives mem = function
  | Int(i1), Int(i2) -> new_mem_obj mem (Primitive(Int(i1 + i2)));
  | _ -> raise (InvalidOp "Cannot add those primitives");;

(** Operation to add two Primitive types *)
let sub_primitives mem = function
  | Int(i1), Int(i2) -> new_mem_obj mem (Primitive(Int(i1 - i2)));
  | _ -> raise (InvalidOp "Cannot sub those primitives");;

(** Operation to multiply two Primitive types *)
let mul_primitives mem = function
  | Int(i1), Int(i2) -> new_mem_obj mem (Primitive(Int(i1 * i2)));
  | _ -> raise (InvalidOp "Cannot mul those primitives");;

(** Operation to divide two Primitive types *)
let div_primitives mem = function
  | Int(i1), Int(i2) -> new_mem_obj mem (Primitive(Int(i1 * i2)));
  | _ -> raise (InvalidOp "Cannot mul those primitives");;

(** Operation to mod two Primitive types *)
let mod_primitives mem = function
  | Int(i1), Int(i2) -> new_mem_obj mem (Primitive(Int(i1 mod i2)));
  | _ -> raise (InvalidOp "Cannot mod those primitives");;

let eq_primitives mem = function
  | Boolean(i1), Boolean(i2) -> new_mem_obj mem (Primitive(Boolean(i1 == i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let ne_primitives mem = function
  | Boolean(i1), Boolean(i2) -> new_mem_obj mem (Primitive(Boolean(i1 != i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let gt_primitives mem = function
  | Int(i1), Int(i2) -> new_mem_obj mem (Primitive(Boolean(i1 > i2)));
  | Boolean(i1), Boolean(i2) -> new_mem_obj mem (Primitive(Boolean(i1 > i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let lt_primitives mem = function
  | Int(i1), Int(i2) -> new_mem_obj mem (Primitive(Boolean(i1 < i2)));
  | Boolean(i1), Boolean(i2) -> new_mem_obj mem (Primitive(Boolean(i1 < i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let ge_primitives mem = function
  | Int(i1), Int(i2) -> new_mem_obj mem (Primitive(Boolean(i1 >= i2)));
  | Boolean(i1), Boolean(i2) -> new_mem_obj mem (Primitive(Boolean(i1 >= i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let le_primitives mem = function
  | Int(i1), Int(i2) -> new_mem_obj mem (Primitive(Boolean(i1 <= i2)));
  | Boolean(i1), Boolean(i2) -> new_mem_obj mem (Primitive(Boolean(i1 <= i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let shl_primitives mem = function
  | Int(i1), Int(i2) -> new_mem_obj mem (Primitive(Int(i1 lsl i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let shr_primitives mem = function
  | Int(i1), Int(i2) -> new_mem_obj mem (Primitive(Int(i1 lsr i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

(** Call the entryPoint of an AST tree, this function looks for the function
  * `void main(String[] args)` in the class `HelloWorld` *)
let execute_program (p : AST.t) debug =
  (** Execute the method located at the method_id memory address
   * TODO: pass arguments to the method
   *)
  let rec execute_method mem (method_id : memory_address) attrs =
    match Hashtbl.find !mem.data method_id with
    | Method m -> List.iter (execute_statement mem) m.body;
    | DebugMethod -> debug (Hashtbl.find !mem.data (List.hd attrs)); ();
    | _ -> raise(MemoryError "Only methods are callable");

  (** Execute a statement in memory *)
  and execute_statement mem = function
    (** TODO: Take into account the type for apparent type` *)
    | AST.VarDecl dl ->
        List.iter (fun (t, name, init) ->
        let type_in_mem = (match t with
        | Type.Array (_, _)-> raise(NotImplemented "Statement Implemented");
        | Type.Primitive _ -> "prim";
        | Type.Ref ref_type -> ref_type.tid;
        | Type.Void -> raise(MemoryError "Invalid type")) in
        let variable_id = match init with
        | None -> new_mem_obj mem Null;
        | Some e -> execute_expression mem e in
        new_mem_name mem name variable_id;
        )
        dl
    | AST.If (cond, is_true, is_false) -> (
        let res_id = execute_expression mem cond in
        match Hashtbl.find !mem.data res_id, is_false with
        | Primitive(Boolean(true)), _ -> execute_statement mem is_true;
        | Primitive(Boolean(false)), Some(e) -> execute_statement mem e;
        | Primitive(Boolean(false)), None -> ();
    );
    | AST.While (cond, body) -> (
      let rec run_while cond body =
        let res_id = execute_expression mem cond in
        match Hashtbl.find !mem.data res_id with
        | Primitive(Boolean(true)) -> (execute_statement mem body; run_while cond body;)
        | Primitive(Boolean(false)) -> (); in
      run_while cond body;
        );
    | AST.Block b -> List.iter (execute_statement mem) b;
    | AST.Expr e -> execute_expression mem e; ();
    | AST.Nop -> ();
    | _ -> raise(NotImplemented "Statement not Implemented");

  (** Execute an expression in memory *)
  and execute_expression mem (expr : AST.expression) =
    match expr.edesc with
    | AST.Val v -> (match v with
        | AST.Int i -> new_mem_obj mem (Primitive(Int(int_of_string i)));
        | AST.Boolean b -> new_mem_obj mem (Primitive(Boolean(b)));
        | _ -> 0;
    );
    (* | AST.If (cond, is_true, is_false) -> (
        let res_id = execute_expression mem cond in
        match Hashtbl.find !mem.data res_id with
        | Primitive(Boolean(true)) -> execute_expression mem is_true;
        | Primitive(Boolean(false)) -> execute_expression mem is_false;
    ); *)
    | AST.New (None, fqn, args) -> (
      let class_id = resolve_fqn mem fqn in
      new_mem_obj mem (Object {
          t = class_id;
        })
      );
    | AST.Name n -> Hashtbl.find !mem.names n;
    | AST.Op (e1, op, e2) ->
        let e1_id = execute_expression mem e1 in
        let e2_id = execute_expression mem e2 in
        let (e1_val, e2_val) = match Hashtbl.find !mem.data e1_id, Hashtbl.find !mem.data e2_id with
          | Primitive(p1), Primitive(p2) -> p1, p2;
          | _ -> raise (InvalidOp "Operations can only be done on primitives");
        in
        let op = match op with
        | AST.Op_cor -> mod_primitives
        | AST.Op_cand -> mod_primitives
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
        op mem (e1_val, e2_val);
    | AST.Call (_, name, args) ->
      let args_id = List.map (fun e -> execute_expression mem e) args in
      let method_id = resolve_fqn mem [name] in
      execute_method mem method_id args_id;
      0 (* TODO: return method return value *)
    | _ -> raise(NotImplemented "Expression Implemented"); in

  let mem = new_memory () in
  populate_mem mem;
  List.iter (declare_type mem) p.type_list;
  let main_method_id = resolve_fqn mem ["HelloWorld"; "main"] in
  execute_method mem main_method_id [];
  (* print_memory !mem; *)
;;

