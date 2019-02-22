exception WrongType of string

let ensure_numeric_type (ptype: Type.primitive) =
  match ptype with
  | Type.Boolean -> raise(WrongType "Expected a numeric")(* TODO Inheritance not checked *)
  | _ -> ()
;;

let ensure_boolean_type (ptype: Type.primitive) =
  match ptype with
  | Type.Boolean -> () (* TODO Inheritance not checked *)
  | _ -> raise(WrongType "Expected a boolean")
;;

let unboxing_conversion (type_: Type.t) = (* 5.1.8 *)
  let convertible_ref = ["Boolean"; "Byte"; "Character"; "Short"; "Integer"; "Long"; "Float"; "Double"] in
  match type_ with
  | Type.Primitive(p) -> p
  | Type.Ref(ref_type) when (List.length ref_type.tpath) == 0 && (List.mem ref_type.tid convertible_ref) -> ( 
    match ref_type.tid with (* TODO this doesn't handle types that inherit from the convertible ones *)
    | "Boolean" -> Type.Boolean
    | "Byte" -> Type.Byte
    | "Character" -> Type.Char
    | "Short" -> Type.Short
    | "Integer" -> Type.Int
    | "Long" -> Type.Long
    | "Float" -> Type.Float
    | "Doube" -> Type.Double
    )
  | _ -> raise(WrongType "Can't be unboxed")
;;

let binary_numeric_promotion (type_1: Type.t) (type_2: Type.t) = (* 5.6.2 *)
  let ptype_1 = unboxing_conversion type_1 in
  let ptype_2 = unboxing_conversion type_2 in
  ensure_numeric_type ptype_1;
  ensure_numeric_type ptype_2;
  match (ptype_1, ptype_2) with
    | _, Type.Double | Type.Double, _ -> Type.Primitive(Type.Double)
    | _, Type.Float | Type.Float, _ -> Type.Primitive(Type.Float)
    | _, Type.Long | Type.Long, _ -> Type.Primitive(Type.Long)
    | _, _ -> Type.Primitive(Type.Int)
;;


(*** Ast nodes checks ***)

(* value *)
let check_value env (value: AST.value) =
  match value with
  | AST.String(s) -> Type.Ref(Type.string_type)
  | AST.Int(s) -> Type.Primitive(Type.Int)
  | AST.Float(s) -> Type.Primitive(Type.Float)
  | AST.Char(s) -> Type.Primitive(Type.Char)
  (*| Null -> Type.Ref({Everyting???})*)
  | AST.Boolean(s) -> Type.Primitive(Type.Boolean)
;;

(* expression *)
let rec check_expression env (expression: AST.expression) =
  let check_exp_op env (e1: AST.expression) (op: AST.infix_op) (e2: AST.expression) =
    let check_exp_op_add e1 e2 = 
      let type_e1 = check_expression env e1 in
      let type_e2 = check_expression env e2 in
      match (type_e1, type_e2) with
      | _, Type.Ref(tr) when tr == Type.string_type -> Type.Ref(Type.string_type)
      | Type.Ref(tr), _ when tr == Type.string_type -> Type.Ref(Type.string_type)
      | _, _ -> binary_numeric_promotion type_e1 type_e2
    in
    match op with
    (* | Op_cor -> Type.Boolean TODO check expression types *)
    (* | Op_cand -> Type.Boolean TODO check expression types *)
    (* | Op_or -> Type.Int TODO check expression types and fix returned type *)
    (* | Op_and -> Type.Int TODO check expression types and fix returned type *)
    (* | Op_xor -> Type.Int TODO check expression types and fix returned type *)
    (* | Op_eq -> Type.Int TODO check expression types and fix returned type *)
    (* | Op_ne -> Type.Int TODO check expression types and fix returned type *)
    (* | Op_gt -> Type.Int TODO check expression types and fix returned type *)
    (* | Op_lt -> Type.Int TODO check expression types and fix returned type *)
    (* | Op_ge -> Type.Int TODO check expression types and fix returned type *)
    (* | Op_le -> Type.Int TODO check expression types and fix returned type *)
    (* | Op_shl -> Type.Int TODO check expression types and fix returned type *)
    (* | Op_shr -> Type.Int TODO check expression types and fix returned type *)
    (* | Op_shrr -> Type.Int TODO check expression types and fix returned type *)
    | Op_add -> check_exp_op_add e1 e2;
    | Op_sub -> binary_numeric_promotion (check_expression env e1) (check_expression env e2)
    | Op_mul -> binary_numeric_promotion (check_expression env e1) (check_expression env e2)
    | Op_div -> binary_numeric_promotion (check_expression env e1) (check_expression env e2)
    | Op_mod -> binary_numeric_promotion (check_expression env e1) (check_expression env e2)
  in
  let expression = expression.edesc in
  match expression with
  | AST.New(s, sl, e) -> raise(Failure "Expression new not implemented")
  | AST.NewArray(t, e, e2) -> raise(Failure "Expression newarray not implemented")
  | AST.Call(e, s, e2) -> raise(Failure "Expression call not implemented")
  | AST.Attr(e, s) -> raise(Failure "Expression attr not implemented")
  | AST.If(e, e2, e3) -> raise(Failure "Expression if not implemented")
  | AST.Val(v) -> check_value env v
  | AST.Name(s) -> TypingEnv.get_var_type env s
  | AST.ArrayInit(e) -> raise(Failure "Expression arrayinit not implemented")
  | AST.Array(e, es) -> raise(Failure "Expression array not implemented")
  | AST.AssignExp(e, o, e2) -> (
    match ((check_expression env e) = (check_expression env e2))  with (* TODO binary_numeric_promotion and unboxing_conversion is probably needed *)
    | true -> Type.Void
    | false -> raise(WrongType "Can't assign a different type") (* TODO Inheritance *)
  )
  | AST.Post(e, o) -> raise(Failure "Expression post not implemented")
  | AST.Pre(o, e) -> raise(Failure "Expression pre not implemented")
  | AST.Op(e1, op, e2) -> check_exp_op env e1 op e2
  | AST.CondOp(e, e2, e3) -> raise(Failure "Expression condop not implemented") (* section 15.25 *)
  | AST.Cast(t, e) -> raise(Failure "Expression cast not implemented") (* TODO Inheritance *)
  | AST.Type(t) -> t
  | AST.ClassOf(t) -> raise(Failure "Expression classof not implemented")
  | AST.Instanceof(e, t) -> Type.Primitive(Type.Boolean)
  | AST.VoidClass -> Type.Void
;;

(* statement *)
let rec check_statement env (statement: AST.statement) =
  let check_statement_if env condition if_statement else_statement = 
    let condition_type = unboxing_conversion (check_expression env condition)
    in
    match condition_type with
    | Type.Boolean -> (
      check_statement env if_statement;
      match else_statement with
      | Some(else_s) -> check_statement env else_s
      | _ -> env
    )
    | _ -> raise(WrongType "Expected a boolean in if")
  in
  match statement with
  | AST.VarDecl(l) -> List.fold_left (fun env (vartype, varname, varinit) -> TypingEnv.add_variable env varname vartype) env l
  | AST.Block(s) -> check_statement_list env s
  | AST.Nop -> env
  | AST.While(c, s) -> raise(Failure "Statement while not implemented")
  | AST.For(a, e, e2, s) -> raise(Failure "Statement for not implemented")
  | AST.If(cond_e, if_s, else_s) -> check_statement_if env cond_e if_s else_s
  | AST.Return(e) -> raise(Failure "Statement return not implemented")
  | AST.Throw(e) -> raise(Failure "Statement throw not implemented")
  | AST.Try(s, a, s2) -> raise(Failure "Statement try not implemented")
  | AST.Expr(e) -> check_expression env e; env
and check_statement_list env (statements: AST.statement list) =
    match statements with
    | [] -> env
    | h::t -> check_statement_list (check_statement env h) t
;;

(* astmethod *)
let check_astmethod (env: TypingEnv.tc_env) (astmethod: AST.astmethod) =
  (* Check other fields than mdbody *)
  let env = { env with exec_env = (TypingEnv.exec_add_arguments env.exec_env astmethod.margstype) } in
  check_statement_list env astmethod.mbody;
  ()
;;

(* astclass *)
let check_astclass env (astclass: AST.astclass) =
  (* Check other fields than cmethods *)
  List.iter (check_astmethod env) astclass.cmethods
;;

(* type_info *)
let check_type_info env (type_info: AST.type_info) =
  match type_info with
  | Class(c) -> check_astclass env c
  | Inter -> raise(Failure "Interface not implemented")
;;

(* asttype *)
let check_asttype (env: TypingEnv.tc_env) (asttype: AST.asttype) =
  (* Check other fields than info *)
  let env = { env with current_class = asttype.id} in
  check_type_info env asttype.info
;;

(* t *)
let check_t env (ast: AST.t) =
  (* Check other fields than type_list *)
  let rec check_type_list tlist =
    match tlist with
    | [] -> ()
    | h::t -> check_asttype env h; check_type_list t
  in
  check_type_list ast.type_list
  (* The line bellow should be equivalent to what's above, but it doesn't compile, why? *)
  (* List.iter (check_asttype env) ast.type_list; *)
;;

let rec typing (ast: AST.t) =
  let env = TypingEnv.create_env ast in
  TypingEnv.print_classes_env env.classes_env;
  print_newline ();
  check_t env ast;
  print_string "\nType checking \x1b[0;32mok\x1b[0m\n";
  ast (* For now don't change the ast, in the future it might be changed to include to be a typed ast *)
;;