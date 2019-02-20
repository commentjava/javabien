exception ExcpectedNumeric of Type.primitive
exception ExcpectedBoolean of Type.primitive

let ensure_numeric_type (ptype: Type.primitive) =
  match ptype with
  | Boolean -> raise(ExcpectedNumeric ptype)(* Inheritance not checked *)
  | _ -> ()
;;

let ensure_boolean_type (ptype: Type.primitive) =
  match ptype with
  | Boolean -> () (* Inheritance not checked *)
  | _ -> raise(ExcpectedBoolean ptype)
;;

let unboxing_conversion (type_: Type.t) = (* 5.1.8 *)
  let convertible_ref = ["Boolean"; "Byte"; "Character"; "Short"; "Integer"; "Long"; "Float"; "Double"] in
  match type_ with
  | Type.Primitive(p) -> p
  | Type.Ref(ref_type) when (List.length ref_type.tpath) == 0 && (List.mem ref_type.tid convertible_ref) -> 
    match ref_type.tid with (* TODO this doesn't handle types that inherit from the convertible ones *)
    | "Boolean" -> Type.Boolean
    | "Byte" -> Type.Byte
    | "Character" -> Type.Char
    | "Short" -> Type.Short
    | "Integer" -> Type.Int
    | "Long" -> Type.Long
    | "Float" -> Type.Float
    | "Doube" -> Type.Double
  (* TODO null case and unmatched cases *)
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

(* expression *)
(* TODO String operations aren't take into account !!! *)
(* From the jls: If the type of either operand of a + operator is String, then the operation isstring concatenation *)
let rec check_op env (e1: AST.expression) (op: AST.infix_op) (e2: AST.expression) =
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
  | Op_add -> binary_numeric_promotion (check_expression env e1) (check_expression env e2)
  | Op_sub -> binary_numeric_promotion (check_expression env e1) (check_expression env e2)
  | Op_mul -> binary_numeric_promotion (check_expression env e1) (check_expression env e2)
  | Op_div -> binary_numeric_promotion (check_expression env e1) (check_expression env e2)
  | Op_mod -> binary_numeric_promotion (check_expression env e1) (check_expression env e2)
and check_expression env (expression: AST.expression) =
  let expression = expression.edesc in
  match expression with
  (*| New of string option * string list * expression list *)
  (*| NewArray of Type.t * (expression option) list * expression option*)
  (*| Call of expression option * string * expression list*)
  (*| Attr of expression * string*)
  (*| If of expression * expression * expression*)
  (*| Val of value*)
  (*| Name of string*)
  (*| ArrayInit of expression list*)
  (*| Array of expression * (expression option) list*)
  (*| AssignExp of expression * assign_op * expression*)
  (*| Post of expression * postfix_op*)
  (*| Pre of prefix_op * expression*)
  | Op(e1, op, e2) -> check_op env e1 op e2
  (*| CondOp of expression * expression * expression*)
  (*| Cast of Type.t * expression*)
  (*| Type of Type.t*)
  (*| ClassOf of Type.t *)
  (*| Instanceof *)
  | VoidClass -> Type.Void
;;

(* statement *)
let check_statement env (statement: AST.statement) =
  match statement with
  (*| VarDecl of (Type.t * string * expression option) list *)
  (*| Block of statement list *)
  (*| Nop *)
  (*| While of expression * statement *)
  (*| For of (Type.t option * string * expression option) list * expression option * expression list * statement *)
  (*| If of expression * statement * statement option *)
  (*| Return of expression option *)
  (*| Throw of expression *)
  (*| Try of statement list * (argument * statement list) list * statement list *)
  | Expr(e) -> check_expression env e; ()
;;

(* astmethod *)
let check_astmethod env (astmethod: AST.astmethod) =
  (* Check other fields than mdbody *)
  List.iter (check_statement env) astmethod.mbody (* env modification are not inplace, this won't allow variable definition in method *)
;;

(* astclass *)
let check_astclass env (astclass: AST.astclass) =
  (* Check other fields than cmethods *)
  List.iter (check_astmethod env) astclass.cmethods
;;

(* type_info *)
let check_type_info env (type_info: AST.type_info) =
  match type_info with
  | Class(c) -> check_astclass c
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