open Memory

exception NotImplemented of string;;
exception NullException of string;;
exception InvalidOp of string;;

(** Create a new method for the class located at `class_id` *)
let declare_method mem (class_addr : Memory.memory_address) (m : AST.astmethod) : unit =
  let method_addr = Memory.add_object mem (Method{ body = m.mbody; }) in
  match (Memory.get_object_from_address mem class_addr) with
  | Class cl -> Hashtbl.add cl.methods m.mname method_addr
  | _ -> raise(MemoryError "Only classes can have methods")
;;

(** Declare a new Java type. Only java Classes are implemented *)
let declare_type mem (t : AST.asttype) : unit =
  match t.info with
  | Class cl ->
    let class_addr = Memory.add_link_name_object mem t.id (Class { methods = Hashtbl.create 10; }) in
    List.iter (declare_method mem class_addr) cl.cmethods
  | Inter -> ()
;;

(** Resolve in memory a fqn of the form `classname.method` *)
let resolve_fqn mem (fqn : string list) : Memory.memory_address =
  let obj_addr = Memory.get_address_from_name mem (List.hd fqn) in
  List.fold_left
    (fun obj_id name ->
      match (Memory.get_object_from_address mem obj_addr) with
      | Class cl -> (
        try
          Hashtbl.find cl.methods name
        with Not_found -> raise (NotImplemented "Resolution of attributes not impl")
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
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let cand_primitives mem = function
  | Boolean(i1), Boolean(i2) -> Memory.add_object mem (Primitive(Boolean(i1 && i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let or_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 lor i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let and_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 land i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let xor_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 lxor i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

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

(** Call the entryPoint of an AST tree, this function looks for the function
  * `void main(String[] args)` in the class `HelloWorld` *)
let execute_program (p : AST.t) debug =
  (** Execute the method located at the method_id memory address
   * TODO: pass arguments to the method
   *)
  let rec execute_method mem (method_addr : Memory.memory_address) (attrs : Memory.memory_address list) =
    match (Memory.get_object_from_address mem method_addr) with
    | Method m -> List.iter (execute_statement mem) m.body
    | DebugMethod -> debug (Memory.get_object_from_address mem (List.hd attrs)); ()
    | _ -> raise(MemoryError "Only methods are callable")

  (** Execute a statement in memory *)
  and execute_statement mem = function
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
            Memory.add_link_name_address mem name variable_addr
          )
          dl
      end
    | AST.If (cond, is_true, is_false) ->
      begin
        let mem = Memory.make_empiled_memory mem in
        let res_addr = execute_expression mem cond in
        begin
          match Memory.get_object_from_address mem res_addr, is_false with
          | Primitive(Boolean(true)), _ -> execute_statement mem is_true
          | Primitive(Boolean(false)), Some(e) -> execute_statement mem e
          | Primitive(Boolean(false)), None -> ()
        end;
        Printf.printf "  If statement finished\n";
        print_memory mem
      end
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
        Printf.printf "  While statement finished\n";
        print_memory mem
      end
    | AST.Block b ->
      begin
        let mem = Memory.make_empiled_memory mem in
        List.iter (execute_statement mem) b;
        Printf.printf "  Block statement finished\n";
        print_memory mem;
      end
    | AST.Expr e -> execute_expression mem e; ()
    | AST.Nop -> ()
    | _ -> raise(NotImplemented "Statement not Implemented")

  (** Execute an expression in memory *)
  and execute_expression mem (expr : AST.expression) : Memory.memory_address =
    match expr.edesc with
    | AST.Val v ->
      begin
        match v with
        | AST.Int i -> Memory.add_object mem (Primitive(Int(int_of_string i)))
        | AST.Boolean b -> Memory.add_object mem (Primitive(Boolean(b)))
        | _ -> 0
      end
    (* | AST.If (cond, is_true, is_false) -> (
        let res_id = execute_expression mem cond in
        match Hashtbl.find !mem.data res_id with
        | Primitive(Boolean(true)) -> execute_expression mem is_true;
        | Primitive(Boolean(false)) -> execute_expression mem is_false;
    ); *)
    | AST.New (None, fqn, args) ->
      begin
        let class_addr = resolve_fqn mem fqn in
        Memory.add_object mem (Object { t = class_addr; })
      end
    | AST.Name n ->
      begin
        Memory.get_address_from_name mem n
      end
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
        op mem (e1_val, e2_val)
      end
    | AST.Call (_, name, args) ->
      begin
        let args_addr = List.map (fun e -> execute_expression mem e) args in
        let method_addr = resolve_fqn mem [name] in
        execute_method mem method_addr args_addr;
        0 (* TODO: return method return value *)
      end
    | _ -> raise(NotImplemented "Expression Implemented")
  in

  let mem = make_populated_memory () in
  List.iter (declare_type mem) p.type_list;
  let main_method_addr = resolve_fqn mem ["HelloWorld"; "main"] in
  execute_method mem main_method_addr [];
  Printf.printf "  Programm finished\n";
  print_memory mem;
;;

