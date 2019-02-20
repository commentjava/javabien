exception WrongType of Type.t

let ensure_numeric_type (ptype: Type.primitive) =
  match ptype with
  | Type.Boolean -> raise(WrongType (Type.Primitive(ptype)))(* Inheritance not checked *)
  | _ -> ()
;;

let ensure_boolean_type (ptype: Type.primitive) =
  match ptype with
  | Type.Boolean -> () (* Inheritance not checked *)
  | _ -> raise(WrongType (Type.Primitive(ptype)))
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
  | _ -> raise(WrongType type_)
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
  | String(s) -> Type.Ref(Type.string_type)
  | Int(s) -> Type.Primitive(Type.Int)
  | Float(s) -> Type.Primitive(Type.Float)
  | Char(s) -> Type.Primitive(Type.Char)
  (*| Null -> Type.Ref({Everyting???})*)
  | Boolean(s) -> Type.Primitive(Type.Boolean)
;;

(* expression *)
(* TODO String operations aren't take into account !!! *)
(* From the jls: If the type of either operand of a + operator is String, then the operation isstring concatenation *)

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
  | New(s, sl, e) -> raise(Failure "Expression new not implemented")
  | NewArray(t, e, e2) -> raise(Failure "Expression newarray not implemented")
  | Call(e, s, e2) -> raise(Failure "Expression call not implemented")
  | Attr(e, s) -> raise(Failure "Expression attr not implemented")
  | If(e, e2, e3) -> raise(Failure "Expression if not implemented")
  | Val(v) -> check_value env v
  | Name(s) -> raise(Failure "Expression name not implemented")
  | ArrayInit(e) -> raise(Failure "Expression arrayinit not implemented")
  | Array(e, es) -> raise(Failure "Expression array not implemented")
  | AssignExp(e, o, e2) -> raise(Failure "Expression assignexp not implemented")
  | Post(e, o) -> raise(Failure "Expression post not implemented")
  | Pre(o, e) -> raise(Failure "Expression pre not implemented")
  | Op(e1, op, e2) -> check_exp_op env e1 op e2
  | CondOp(e, e2, e3) -> raise(Failure "Expression condop not implemented")
  | Cast(t, e) -> raise(Failure "Expression cast not implemented")
  | Type(t) -> raise(Failure "Expression type not implemented")
  | ClassOf(t) -> raise(Failure "Expression classof not implemented")
  | Instanceof(e, t) -> raise(Failure "Expression instanceof not implemented")
  | VoidClass -> Type.Void
;;

(* statement *)
let check_statement env (statement: AST.statement) =
  match statement with
  | VarDecl(l) -> raise(Failure "Statement vardecl not implemented")
  | Block(s) -> raise(Failure "Statement block not implemented")
  | Nop -> raise(Failure "Statement nop not implemented")
  | While(e, s) -> raise(Failure "Statement while not implemented")
  | For(a, e, e2, s) -> raise(Failure "Statement for not implemented")
  | If(e, s, s2) -> raise(Failure "Statement if not implemented")
  | Return(e) -> raise(Failure "Statement return not implemented")
  | Throw(e) -> raise(Failure "Statement throw not implemented")
  | Try(s, a, s2) -> raise(Failure "Statement try not implemented")
  | Expr(e) -> check_expression env e; ()
;;

(* astmethod *)
let check_astmethod env (astmethod: AST.astmethod) =
  (* Check other fields than mdbody *)
  List.iter (check_statement env) astmethod.mbody
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
let check_asttype env (asttype: AST.asttype) =
  (* Check other fields than info *)
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
  Env.print "Env" print_string TypingEnv.print_javaclass env 0;
  check_t env ast;
  ast (* For now don't change the ast, in the future it might be changed to include types informations *)
;;