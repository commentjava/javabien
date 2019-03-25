let ensure_numeric_type (ptype: Type.primitive) =
  match ptype with
  | Type.Boolean -> raise(TypeExcept.WrongType "Expected a numeric")(* TODO Inheritance not checked *)
  | _ -> ptype
;;

let ensure_boolean_type (ptype: Type.primitive) =
  match ptype with
  | Type.Boolean -> Type.Boolean (* TODO Inheritance not checked *)
  | _ -> raise(TypeExcept.WrongType "Expected a boolean")
;;

let unboxing_conversion (type_: Type.t) = (* 5.1.8 *)
  let convertible_ref = ["Boolean"; "Byte"; "Character"; "Short"; "Integer"; "Long"; "Float"; "Double"] in
  match type_ with
  | Type.Primitive(p) -> p
  | Type.Ref(ref_type) when (List.length ref_type.tpath) == 0 && (List.mem ref_type.tid convertible_ref) -> (
    match ref_type.tid with (* TODO this doesn't handle types that inherit of convertible types *)
    | "Boolean" -> Type.Boolean
    | "Byte" -> Type.Byte
    | "Character" -> Type.Char
    | "Short" -> Type.Short
    | "Integer" -> Type.Int
    | "Long" -> Type.Long
    | "Float" -> Type.Float
    | "Doube" -> Type.Double
    )
  | Type.Void -> raise(TypeExcept.WrongType "Void can't be unboxed")
  | Type.Array(t, s) -> raise(TypeExcept.WrongType "Array can't be unboxed")
;;

let unary_numeric_promotion (n_type: Type.t) = (* 5.6.1 *)
  let n_type = unboxing_conversion n_type in
  match n_type with
  | Type.Byte | Type.Short | Type.Char | Type.Int -> Type.Int
  | Type.Long | Type.Float | Type.Double | Type.Boolean -> n_type
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

let capture_conversion (types: Type.t) = (* 5.1.10 *)
  Type.Ref(Type.object_type) (* Used in cast exp. My brain fried after reading the spec about this *)
;;

let is_constant_expression (exp: AST.expression_desc) =
  false (* TODO. Used in cast exp *)
;;

let casting_conversion (from_type: Type.t) (to_type: Type.t) = (* 5.5 *)
  print_string "\x1b[0;33mWarning: Casting conversions not implemented!\x1b[0m\n";
  to_type (* TODO *)
;;

let check_reifiable_type (t: Type.t) = (* 4.7 *)
  (* TODO *)
  ()
;;

(*** Ast nodes checks ***)

(* value *)
let check_value env (value: AST.value) =
  match value with
  | AST.String(s) -> Type.Ref(Type.string_type)
  | AST.Int(s) -> Type.Primitive(Type.Int)
  | AST.Float(s) -> Type.Primitive(Type.Float)
  | AST.Char(s) -> Type.Primitive(Type.Char)
  | AST.Null -> Type.Ref({tpath = []; tid = "Null"})
  | AST.Boolean(s) -> Type.Primitive(Type.Boolean)
;;

(* AST.expression *)
let rec check_expression (env: TypingEnv.tc_env) (expression: AST.expression) =
  let check_exp_op env (e1: AST.expression) (op: AST.infix_op) (e2: AST.expression) =
    let check_exp_op_add (t1: Type.t) (t2: Type.t) =
      match (t1, t2) with
      | _, Type.Ref(tr) when tr == Type.string_type -> Type.Ref(Type.string_type)
      | Type.Ref(tr), _ when tr == Type.string_type -> Type.Ref(Type.string_type)
      | _, _ -> binary_numeric_promotion t1 t2
    in
    let check_exp_op_bool (t1: Type.t) (t2: Type.t) =
      ensure_boolean_type (unboxing_conversion t1);
      ensure_boolean_type (unboxing_conversion t2);
      Type.Primitive(Type.Boolean)
    in
    let check_exp_op_eq (t1: Type.t) (t2: Type.t) = (* 15.21 *)
      let reference_equality (t1: Type.t) (t2: Type.t) = (* 15.21.3 *)
        try
          casting_conversion t1 t2;
          Type.Primitive(Type.Boolean)
        with _ ->
          casting_conversion t2 t1;
          Type.Primitive(Type.Boolean)
      in
      match t1, t2 with
      | Type.Ref(rt1), Type.Ref(rt2) -> reference_equality t1 t2
      | _, _ -> (
        let pt1 = unboxing_conversion t1 in
        let pt2 = unboxing_conversion t2 in
        match pt1, pt2 with
        | Type.Boolean, Type.Boolean -> Type.Primitive(Type.Boolean)
        | _, _ -> ensure_numeric_type pt1; ensure_numeric_type pt2; Type.Primitive(Type.Boolean)
      )
    in
    let numerical_comparison (t1: Type.t) (t2: Type.t) =
      let pt1 = unboxing_conversion t1 in
      let pt2 = unboxing_conversion t2 in
      ensure_numeric_type pt1; ensure_numeric_type pt2;
      Type.Primitive(Type.Boolean)
    in
    let bitwise_and_logical (t1: Type.t) (t2: Type.t) = (* 15.22 *)
      let pt1 = unboxing_conversion t1 in
      let pt2 = unboxing_conversion t2 in
      match pt1, pt2 with
      | Type.Boolean, Type.Boolean -> Type.Primitive(Type.Boolean) (* 15.22.2 *)
      | _, _ -> binary_numeric_promotion t1 t2 (* 15.22.1 *)
    in
    let check_exp_shift (t1: Type.t) (t2: Type.t) = (* 15.19 *)
      let promoted_t1 = unary_numeric_promotion t1 in
      let promoted_t2 = unary_numeric_promotion t2 in
      Type.Primitive(promoted_t1)
    in
    let t1 = check_expression env e1 in
    let t2 = check_expression env e2 in
    match op with
    | Op_cor -> check_exp_op_bool t1 t2
    | Op_cand -> check_exp_op_bool t1 t2
    | Op_or -> bitwise_and_logical t1 t2
    | Op_and -> bitwise_and_logical t1 t2
    | Op_xor -> bitwise_and_logical t1 t2
    | Op_eq -> check_exp_op_eq t1 t2
    | Op_ne -> check_exp_op_eq t1 t2
    | Op_gt -> numerical_comparison t1 t2
    | Op_lt -> numerical_comparison t1 t2
    | Op_ge -> numerical_comparison t1 t2
    | Op_le -> numerical_comparison t1 t2
    | Op_shl -> check_exp_shift t1 t2
    | Op_shr -> check_exp_shift t1 t2
    | Op_shrr -> check_exp_shift t1 t2
    | Op_add -> check_exp_op_add t1 t2
    | Op_sub -> binary_numeric_promotion t1 t2
    | Op_mul -> binary_numeric_promotion t1 t2
    | Op_div -> binary_numeric_promotion t1 t2
    | Op_mod -> binary_numeric_promotion t1 t2
  in
  let check_expression_if env condition if_exp else_exp =
    let condition_type = unboxing_conversion (check_expression env condition)
    in
    match condition_type with
    | Type.Boolean -> (
      let type_if = check_expression env if_exp in
      let type_else = check_expression env else_exp in
      if (type_if = type_else) then type_if else raise(TypeExcept.WrongType "If expression must return the same type")
    )
    | _ -> raise(TypeExcept.WrongType "Expected a boolean in if")
  in
  let rec check_types_exp_array_init expected_type exp_to_check =
    match exp_to_check with
    | [] -> (
      match expected_type with
      | Type.Array(t, len) -> Type.Array(t, len + 1)
      | _ -> Type.Array(expected_type, 1)
    )
    | h::t -> if (check_expression env h) = expected_type then check_types_exp_array_init expected_type t else raise(TypeExcept.WrongType "Array init with different types")
  in
  let check_instanceof env exp_type ref_type = (* 15.20.2 *)
    match exp_type, ref_type with
    | Type.Ref(ert), Type.Ref(rt) -> check_reifiable_type ref_type; casting_conversion exp_type ref_type; Type.Primitive(Type.Boolean)
    | _, _ -> raise(TypeExcept.WrongType "instance of except a ref type")
  in
  let expression = expression.edesc in
  match expression with
  | AST.New(s, q_name, e) -> (
    let new_type = Type.Ref({
      tpath = (List.rev (List.tl (List.rev q_name)));
      tid = (List.hd (List.rev q_name)) }
      ) (* I feel like there is a better way to build that reference type *)
    in
    TypingEnv.check_constructor_exist env new_type (List.map (check_expression env) e)
  ) (* TODO Class1.new Y() not handled, check if Some(s) *)
  | AST.NewArrayEmpty(t, e_lengths) -> Type.Array(t, List.length e_lengths)
  | AST.NewArrayInitialized(t, e_init) -> if t = (check_expression env e_init) then t else raise(TypeExcept.WrongType "NewArrayInitialized is assigned a wrong type")
  | AST.Call(eo, s, el) -> (
    let e_type = match eo with
      | Some(e) -> check_expression env e
      | None -> Type.Ref({tpath = [] ; tid = env.current_class})
    in
    TypingEnv.function_return_type env e_type s (List.map (check_expression env) el)
  )
  | AST.Attr(e, str) -> TypingEnv.class_attr_type env (check_expression env e) str
  | AST.If(cond_e, if_e, else_e) -> check_expression_if env cond_e if_e else_e (* TODO How do we test that? *)
  | AST.Val(v) -> check_value env v
  | AST.Name(s) -> TypingEnv.get_var_type env s
  | AST.ArrayInit(exp_l) -> if (List.length exp_l) = 0 then Type.Void else ( (* 10.6 TODO probably not jls complient, we might need to apply unboxing convertion *)
      let expected_type = check_expression env (List.hd exp_l) in
      check_types_exp_array_init expected_type (List.tl exp_l)
    )
  | AST.Array(e, es) -> (
    let check_es_type e =
      match unary_numeric_promotion (check_expression env e) with
      | Type.Int -> ()
      | _ -> raise(TypeExcept.WrongType "Array access except an int")
    in
    let array_t = check_expression env e in
    match array_t with
    | Type.Array(t, size) -> (
      match List.length es with
      | 0 -> array_t
      | 1 -> check_es_type (List.hd es); t
      | _ -> (
        let accessed_type = if size > 1 then Type.Array(t, size - 1) else t in
        check_expression env {edesc = AST.Array({edesc = AST.Type(accessed_type)}, (List.tl es))}
      )
    )
    | _ -> raise(TypeExcept.WrongType "array required, but other type found")
  )
  | AST.AssignExp(l_exp, o, r_exp) -> (
    let r_type = (check_expression env r_exp) in
    let l_type = (check_expression env l_exp) in
    match (r_type = l_type)  with (* TODO binary_numeric_promotion and unboxing_conversion is probably needed + check += -= etc *)
    | true -> r_type
    | false -> raise(TypeExcept.WrongType "Can't assign a different type") (* TODO Inheritance *)
  )
  | AST.Post(e, o) -> Type.Primitive(ensure_numeric_type (unboxing_conversion (check_expression env e)))
  | AST.Pre(o, e) -> (
    let exp_type = unboxing_conversion (check_expression env e) in
    match o with
    | Op_not -> Type.Primitive(ensure_boolean_type exp_type)
    | Op_neg -> Type.Primitive(ensure_numeric_type exp_type)
    | Op_incr -> Type.Primitive(ensure_numeric_type exp_type)
    | Op_decr -> Type.Primitive(ensure_numeric_type exp_type)
    | Op_bnot -> Type.Primitive(ensure_boolean_type exp_type)
  )
  | AST.Op(e1, op, e2) -> check_exp_op env e1 op e2
  | AST.CondOp(e, e2, e3) -> raise(Failure "Expression condop not implemented") (* section 15.25 Some complicated cases won't be handled *)
  | AST.Cast(t, e) -> raise(Failure "Expression cast not implemented") (* TODO Inheritance *)
  | AST.Type(t) -> t
  | AST.ClassOf(t) -> raise(Failure "Expression classof not implemented")
  | AST.Instanceof(e, t) -> check_instanceof env (check_expression env e) t (* 15.20.2 *)
  | AST.VoidClass -> Type.Void
;;

let check_return (env: TypingEnv.tc_env) (expression: AST.expression option) =
  (* At this point env.current_method cannot be None *)
  match env.current_method with
  | Some m -> (
    match expression with
    | Some e -> (
      if m.return_type == Type.Void then
        raise(TypeExcept.IncompatibleType("Unexpected return value"));
      (* TODO: check expression type and return type *)
      check_expression env e
    )
    | None -> (
      if m.return_type <> Type.Void then
        raise(TypeExcept.IncompatibleType("Missing return value"));
      Type.Void
    )
  )
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
      | None -> env
    )
    | _ -> raise(TypeExcept.WrongType "Expected a boolean in if")
  in
  match statement with
  | AST.VarDecl(l) -> (
    List.fold_left (fun env (vartype, varname, varinit) -> (
        let env = TypingEnv.add_variable env varname vartype in
        match varinit with
        | None -> env
        | Some(e) -> check_expression env {edesc = AST.AssignExp({edesc = AST.Type(vartype)}, AST.Assign, e) }; env
      )) env l
  )
  | AST.Block(s) -> check_statement_list env s
  | AST.Nop -> env
  | AST.While(c, s) -> print_string "\x1b[0;33mWarning: Statement while not implemented!\x1b[0m\n"; env
  | AST.For(a, e, e2, s) ->  print_string "\x1b[0;33mWarning: Statement for not implemented!\x1b[0m\n"; env
  | AST.If(cond_e, if_s, else_s) -> check_statement_if env cond_e if_s else_s
  | AST.Return(e) -> check_return env e; env
  | AST.Throw(e) -> print_string "\x1b[0;33mWarning: Statement throw not implemented!\x1b[0m\n"; env
  | AST.Try(s, a, s2) -> print_string "\x1b[0;33mWarning: Statement try implemented!\x1b[0m\n"; env
  | AST.Expr(e) -> check_expression env e; env
and check_statement_list env (statements: AST.statement list) =
    match statements with
    | [] -> env
    | h::t -> check_statement_list (check_statement env h) t
;;

let rec check_statement_for_return (statement: AST.statement) (return_count: int) =
  let check_statement_if condition if_statement else_statement =
    let if_return_count = check_statement_for_return if_statement return_count in
    match else_statement with
    | Some(else_s) -> check_statement_for_return else_s if_return_count
    | None -> if_return_count
  in
  match statement with
  | AST.Block(s) -> check_statement_list_for_return s return_count
  | AST.If(cond_e, if_s, else_s) -> check_statement_if cond_e if_s else_s
  | AST.Return(e) -> return_count+1
  | _ -> return_count
and check_statement_list_for_return (statements: AST.statement list) (return_count: int) =
    match statements with
    | [] -> return_count
    | h::t -> check_statement_list_for_return t (check_statement_for_return h return_count)
;;

(* javamethod *)
let check_javamethod (env: TypingEnv.tc_env) (javamethod: TypingEnv.javamethod) =
  (* Check other fields than mdbody *)
  let env = { env with
    exec_env = (TypingEnv.exec_add_arguments env.exec_env (Env.key_value_pairs javamethod.args.args_types)) ;
    current_method = Some javamethod
  } in
  (* let rec check_return_statements statements return_count =
    match statements with
    | [] -> (
      if javamethod.return_type <> Type.Void && return_count = 0 then (
        Location.print javamethod.loc;
        if not (List.mem AST.Native javamethod.modifiers) && not (List.mem AST.Abstract javamethod.modifiers) then
          raise(TypeExcept.MissingReturnStatement)
      )
    )
    | h::t -> (
      match h with
      | AST.Return(e) -> check_return_statements t (return_count+1)
      | _ -> check_return_statements t return_count
    )
  in *)
  let return_count = check_statement_list_for_return javamethod.body 0 in
  if javamethod.return_type <> Type.Void && return_count = 0 &&
    not (List.mem AST.Native javamethod.modifiers) && not (List.mem AST.Abstract javamethod.modifiers) then
      raise(TypeExcept.MissingReturnStatement);
  check_statement_list env javamethod.body;
  ()
;;

(* javaclass *)
let check_javaclass (env: TypingEnv.tc_env) (cname: string) (c: TypingEnv.javaclass) =
  (* Check other fields than cmethods *)
  let env = { env with current_class = cname} in
  List.iter (check_javamethod env) (Env.values c.methods)
;;

(* (* type_info *)
let check_type_info env (type_info: AST.type_info) =
  match type_info with
  | Class(c) -> check_javaclass env c
  | Inter -> raise(Failure "Interface not implemented")
;; *)


(* (* asttype *)
let check_asttype (env: TypingEnv.tc_env) (asttype: AST.asttype) =
  (* Check other fields than info *)
  let env = { env with current_class = asttype.id} in
  check_type_info env asttype.info
;; *)

(* t *)
let check_t (env: TypingEnv.tc_env) =
  (* Check other fields than type_list *)
  let rec check_class_list clist =
    match clist with
    | [] -> ()
    | (cname,c)::t -> check_javaclass env cname c; check_class_list t
  in
  check_class_list (Env.key_value_pairs env.classes_env)
  (* The line bellow should be equivalent to what's above, but it doesn't compile, why? *)
  (* List.iter (check_asttype env) ast.type_list; *)
;;

let rec typing (ast: AST.t) (std_asts: AST.t list) doPrintTypeEnv =
  try (
    let env = TypingEnv.create_env ast std_asts in
    if doPrintTypeEnv then TypingEnv.print_classes_env env.classes_env;
    print_newline ();
    check_t env;
    print_string "\nType checking \x1b[0;32mok\x1b[0m\n";
    ast (* For now don't change the ast, in the future it might be changed to include to be a typed ast *)
  )
  with e -> TypeExcept.print_error e; ast
