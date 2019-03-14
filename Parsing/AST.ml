type argument = {
    final : bool;
    vararg : bool;
    ptype : Type.t;
    pident : string;
  }

type value =
  | String of string
  | Int of string
  | Float of string
  | Char of char option
  | Null
  | Boolean of bool

type postfix_op =
  | Incr
  | Decr

type prefix_op =
  | Op_not
  | Op_neg
  | Op_incr
  | Op_decr
  | Op_bnot

type assign_op =
  | Assign
  | Ass_add
  | Ass_sub
  | Ass_mul
  | Ass_div
  | Ass_mod
  | Ass_shl
  | Ass_shr
  | Ass_shrr
  | Ass_and
  | Ass_xor
  | Ass_or

type infix_op =
  | Op_cor
  | Op_cand
  | Op_or
  | Op_and
  | Op_xor
  | Op_eq
  | Op_ne
  | Op_gt
  | Op_lt
  | Op_ge
  | Op_le
  | Op_shl
  | Op_shr
  | Op_shrr
  | Op_add
  | Op_sub
  | Op_mul
  | Op_div
  | Op_mod

type expression_desc =
  | New of string option * string list * expression list
  | NewArrayEmpty of Type.t * expression list
  | NewArrayInitialized of Type.t * expression
  | Call of expression option * string * expression list
  | Attr of expression * string
  | If of expression * expression * expression
  | Val of value
  | Name of string
  | ArrayInit of expression list
  | Array of expression * expression list (* TODO fix the parser, see README *)
  | AssignExp of expression * assign_op * expression
  | Post of expression * postfix_op
  | Pre of prefix_op * expression
  | Op of expression * infix_op * expression
  | CondOp of expression * expression * expression
  | Cast of Type.t * expression
  | Type of Type.t
  | ClassOf of Type.t
  | Instanceof of expression * Type.t
  | VoidClass

and expression =
    {
      edesc : expression_desc;
(*      eloc : Location.t;
      mutable etype : Type.t option;*)
    }

type switchLabel =
  | CstExpr of expression
  | Default

type modifier =
  | Abstract
  | Public
  | Protected
  | Private
  | Static
  | Final
  | Strictfp
  | Transient
  | Volatile
  | Synchronized
  | Native

type astattribute = {
      mutable amodifiers : modifier list;
      aname : string;
      atype : Type.t;
      adefault : expression option;
      aloc : Location.t;
    }




type qualified_name = string list

type statement =
  | VarDecl of (Type.t * string * expression option) list
  | Block of statement list
  | Nop
  | While of expression * statement
  | For of (Type.t option * string * expression option) list * expression option * expression list * statement
  | If of expression * statement * statement option
  | Return of expression option
  | Throw of expression
  | Try of statement list * (argument * statement list) list * statement list
  | Expr of expression

type astmethod = {
    mutable mmodifiers : modifier list;
    mname : string;
    mreturntype : Type.t;
    margstype : argument list;
    mthrows : Type.ref_type list;
    mbody : statement list;
    mloc : Location.t;
  }
type astconst = {
    mutable cmodifiers : modifier list;
    cname : string;
    cargstype : argument list;
    cthrows : Type.ref_type list;
    cbody : statement list;
    cloc : Location.t;
  }

and astclass = {
    cparent : Type.ref_type;
    cattributes : astattribute list;
    cinits : initial list;
    cconsts : astconst list;
    cmethods : astmethod list;
    ctypes : asttype list;
    cloc : Location.t;
  }

and type_info =
  | Class of astclass
  | Inter

and initial = {
    static : bool ;
    block : statement list
  }

and asttype =
  {
    mutable modifiers : modifier list;
    id : string;
    info : type_info;
  }

type t = {
    package : qualified_name option;
    type_list : asttype list;
  }

let string_of_value = function
  | String s -> "\""^s^"\""
  | Boolean b -> string_of_bool b
  | Int s -> s
  | Float f -> f
  | Char(Some c) -> String.make 1 c
  | Char(None) -> "à"
  | Null -> "null"

let string_of_assign_op = function
  | Assign  -> " = "
  | Ass_add -> " += "
  | Ass_sub -> " -= "
  | Ass_mul -> " *= "
  | Ass_div -> " /= "
  | Ass_mod -> " %= "
  | Ass_shl -> " <<="
  | Ass_shr -> " >>= "
  | Ass_shrr-> " >>>= "
  | Ass_and -> " &= "
  | Ass_xor -> " ^= "
  | Ass_or  -> " |= "

let string_of_infix_op = function
  | Op_cor   -> " || "
  | Op_cand  -> " && "
  | Op_or    -> " | "
  | Op_and   -> " & "
  | Op_xor   -> " ^ "
  | Op_eq    -> " == "
  | Op_ne    -> " != "
  | Op_gt    -> " > "
  | Op_lt    -> " < "
  | Op_ge    -> " >= "
  | Op_le    -> " <= "
  | Op_shl   -> " << "
  | Op_shr   -> " >> "
  | Op_shrr  -> " >>> "
  | Op_add   -> " + "
  | Op_sub   -> " - "
  | Op_mul   -> " * "
  | Op_div   -> " / "
  | Op_mod   -> " % "

let string_of_prefix_op = function
  | Op_not -> "!"
  | Op_neg -> "-"
  | Op_incr -> "++"
  | Op_decr -> "--"
  | Op_bnot -> "~"


let rec string_of_expression_desc = function
  | New(None,n,al) ->
      "new "^(String.concat "." n)^"("^
      (String.concat "," (List.map string_of_expression al))^
      ")"
  | New(Some n1,n2,al) ->
      n1^".new "^(String.concat "." n2)^"("^
      (String.concat "," (List.map string_of_expression al))^
      ")"
  | If(c,e1,e2) ->
      "if "^(string_of_expression c)^" { "^
      (string_of_expression e1)^" } else { "^(string_of_expression e2)^" }"
  | Call(r,m,al) ->
     (match r with
      | Some r -> (string_of_expression r)^"."
      | None -> "")^
       m^"("^
      (String.concat "," (List.map string_of_expression al))^
	")"
  | Attr(r,a) ->
      (string_of_expression r)^
      "."^a
  | Val v -> string_of_value v
  | Name s -> s
  | AssignExp(e1,op,e2) ->
      (string_of_expression e1)^(string_of_assign_op op)^(string_of_expression e2)
  | Op(e1,op,e2) ->
      (string_of_expression e1)^(string_of_infix_op op)^(string_of_expression e2)
  | CondOp(e1,e2,e3) ->
     (string_of_expression e1)^"?"^(string_of_expression e2)^":"^(string_of_expression e3)
  | Array(e,el) ->
     (string_of_expression e)^(ListII.concat_map "" (function e -> "["^(string_of_expression e)^"]") el)
  | ArrayInit el ->
     "{"^(ListII.concat_map "," string_of_expression el)^"}"
  | Cast(t,e) ->
      "("^(Type.stringOf t)^") "^(string_of_expression e)
  | Post(e,Incr) -> (string_of_expression e)^"++"
  | Post(e,Decr) -> (string_of_expression e)^"--"
  | Pre(op,e) -> (string_of_prefix_op op)^(string_of_expression e)
  | Type t -> Type.stringOf t
  | ClassOf t -> Type.stringOf t
  | Instanceof(e,t) -> (string_of_expression e)^" instanceof "^(Type.stringOf t)
  | VoidClass -> "void.class"
  | NewArrayEmpty(t, exp_lengths) ->
     "new " ^ (Type.stringOf t) ^ (ListII.concat_map "" (function e -> "["^(string_of_expression e)^"]") exp_lengths)
  | NewArrayInitialized(t, exp_init) ->
     "new " ^ (Type.stringOf t) ^ (string_of_expression exp_init)

and string_of_expression e =
  let s = string_of_expression_desc e.edesc in
  s(*
    match e.etype with
      | None -> s
      | Some t -> "("^s^" : "^(Type.stringOf t)^")"*)

let print_attribute tab a =
  print_string tab;
  print_string ((Type.stringOf a.atype)^" "^a.aname);
  (match a.adefault with
    | None -> ()
    | Some e -> print_string(" = "^(string_of_expression e)));
  print_endline ";"

let stringOf_arg a =
  (if a.final then "final " else "")^
    (Type.stringOf a.ptype)^
      (if a.vararg then "..." else "")^
	" "^a.pident

let stringOf_modifier = function
  | Abstract  -> "abstract"
  | Public    -> "public"
  | Protected -> "protected"
  | Private   -> "private"
  | Static    -> "static"
  | Final     -> "final"
  | Strictfp  -> "strictfp"
  | Transient    -> "transient"
  | Volatile     -> "volatile"
  | Synchronized -> "synchronized"
  | Native       -> "native"

let stringOf_sl = function
  | CstExpr e -> "case "^(string_of_expression e)
  | Default -> "default"

let rec print_switchBody tab switch_label_list stm_list =
     List.iter (fun c -> print_endline(tab^(stringOf_sl c)^":")) switch_label_list;
     List.iter (print_statement (tab^"\t")) stm_list

and print_statement tab = function
  | VarDecl dl ->
     List.iter (fun (t,id,init) ->
		print_string(tab^(Type.stringOf t)^" "^id);
		(match init with
		| None -> ()
		| Some e -> print_string (" = "^(string_of_expression e)));
		print_endline ";"
	       ) dl
  | Block b ->
     print_endline(tab^"{");
     List.iter (print_statement (tab^"  ")) b;
     print_endline(tab^"}")
  | Nop -> print_endline(tab^";")
  | Expr e -> print_endline(tab^(string_of_expression e)^";")
  | Return None -> print_endline(tab^"return;")
  | Return Some(e) -> print_endline(tab^"return "^(string_of_expression e)^";")
  | Throw e -> print_endline(tab^"throw "^(string_of_expression e)^";")
  | While(e,s) ->
     print_endline(tab^"while ("^(string_of_expression e)^") {");
     print_statement (tab^"  ") s;
     print_endline(tab^"}")
  | If(e,s,None) ->
     print_endline(tab^"if ("^(string_of_expression e)^") {");
     print_statement (tab^"  ") s;
     print_endline(tab^"}")
  | If(e,s1,Some s2) ->
     print_endline(tab^"if ("^(string_of_expression e)^") {");
     print_statement (tab^"  ") s1;
     print_endline(tab^"} else {");
     print_statement (tab^"  ") s2;
     print_endline(tab^"}")
  | For(fil,eo,el,s) ->
     print_string(tab^"for (");
     List.iter (fun (t,s,eo) ->
		(match t with
		 | None -> ()
		 | Some t -> print_string ((Type.stringOf t)^" "));
		print_string(s);
		(match eo with
		| None -> ()
		| Some e -> print_string (" "^(string_of_expression e)))) fil;
     print_string ";";
     (match eo with
      | None -> ()
      | Some e -> print_string (" "^(string_of_expression e)));
     print_string ";";
     print_string(ListII.concat_map "," string_of_expression el);
     print_endline ") {";
     print_statement (tab^"  ") s;
     print_endline(tab^"}")
  | Try(body,catch,finally) ->
     print_endline(tab^"try {");
     List.iter (print_statement (tab^"  ")) body;
     List.iter (fun (a,sl) ->
		print_endline(tab^"} catch ("^(stringOf_arg a)^")");
		List.iter (print_statement (tab^"  ")) sl) catch;
     (if finally != [] then
	begin
	  print_endline(tab^"} finally {");
	  List.iter (print_statement (tab^"  ")) finally
	end);
     print_endline(tab^"}");

and print_method tab m =
  print_string tab;
  print_string((Type.stringOf m.mreturntype)^" "^m.mname^"(");
  print_string(ListII.concat_map "," stringOf_arg m.margstype);
  print_string(")");
  print_string(" "^ListII.concat_map "," Type.stringOf_ref m.mthrows);
  print_endline(" {");
  List.iter (print_statement (tab^"  ")) m.mbody;
  print_endline(tab^"}")

and print_const tab c =
  print_string (tab^c.cname^"(");
  print_string(ListII.concat_map "," stringOf_arg c.cargstype);
  print_endline(") {");
  List.iter (print_statement (tab^"  ")) c.cbody;
  print_endline(tab^"}")

and print_class tab c =
  print_endline(" extends "^(Type.stringOf_ref c.cparent)^" {");
  List.iter (print_attribute (tab^"  ")) c.cattributes;
  List.iter (print_const (tab^"  ")) c.cconsts;
  List.iter (print_method (tab^"  ")) c.cmethods;
  print_endline(tab^"}")

and print_type tab t =
  if t.modifiers != [] then
    print_string (tab^(ListII.concat_map " " stringOf_modifier t.modifiers)^" ");
  print_string ("class "^t.id);
  (match t.info with
   | Class c -> print_class tab c
   | Inter -> ())

let print_package p =
  print_string "package ";
  print_endline (String.concat "." p)

let print_program p =
  (match p.package with
  | None -> ()
  | Some pack -> print_package pack );
  List.iter (fun t -> print_type "" t; print_newline()) p.type_list


(********** Print AST **********)

(* utils *)

let whitespaceAST = "   " ;;
let brancheAST = "│  " ;;
let colorRed = "\x1b[0;31m" ;;
let colorGreen = "\x1b[0;32m" ;;
let colorLightGreen = "\x1b[1;32m" ;;
let colorLightCyan = "\x1b[1;36m" ;;
let colorWhite = "\x1b[1;37m" ;;
let colorReset = "\x1b[0m" ;;

let print_AST_elt s depth last =
    print_endline (depth ^ (if last then "└─ " else "├─ ") ^ s)
;;

let print_AST_string s depth last =
    print_AST_elt (colorLightGreen ^ s ^ colorReset) depth last
;;

let print_AST_title s depth last =
    print_AST_elt (colorWhite ^ s ^ colorReset) depth last
;;

let extend_depth depth last =
    depth ^ (if last then whitespaceAST else brancheAST)
;;


let apply_opt f optV depth last =
    match optV with
    | None -> print_AST_elt "none" depth last
    | Some v -> f v depth last
;;

let rec apply_list f vList depth =
    match vList with
    | [] -> ()
    | v::[] ->
        f v depth true
    | v::rList ->
        f v depth false;
        apply_list f rList depth
;;

(* functions *)

let print_AST_type t depth last =
    print_AST_string (Type.stringOf t) depth last
;;

let print_AST_bool b depth last =
    print_AST_string (string_of_bool b) depth last
;;

let print_AST_ref_type r depth last =
    print_AST_string (Type.stringOf_ref r) depth last
;;

let print_AST_int i depth last =
    print_AST_string (string_of_int i) depth last
;;

let print_AST_char c depth last =
    print_AST_string (String.make 1 c) depth last
;;

let print_AST_locationt (loc : Location.t) depth last =
    print_AST_title "Location" depth last;
    print_AST_title "From" (extend_depth depth last) false;
    (*print_AST_int ((loc.loc_start).pos_lnum) (extend_depth (extend_depth depth last) false) false;
    print_AST_int (loc.loc_start.pos_cnum) (extend_depth (extend_depth depth last) false) false;
    print_AST_int (loc.loc_start.pos_cbol) (extend_depth (extend_depth depth last) false) true;*)
    print_AST_title "To" (extend_depth depth last) true
    (*print_AST_int (loc.loc_end.pos_lnum) (extend_depth (extend_depth depth last) true) false;
    print_AST_int (loc.loc_end.pos_cnum) (extend_depth (extend_depth depth last) true) false;
    print_AST_int (loc.loc_end.pos_cbol) (extend_depth (extend_depth depth last) true) true*)
;;

let print_AST_argument a depth last =
    print_AST_title "Argument" depth last;
    print_AST_bool (a.final) (extend_depth depth last) false;
    print_AST_bool (a.vararg) (extend_depth depth last) false;
    print_AST_type (a.ptype) (extend_depth depth last) false;
    print_AST_string (a.pident) (extend_depth depth last) true
;;

let print_AST_value v depth last =
    match v with
    | String (s) ->
        print_AST_title "String" depth last;
        print_AST_string s (extend_depth depth last) true
    | Int (s) ->
        print_AST_title "Int" depth last;
        print_AST_string s (extend_depth depth last) true
    | Float (s) ->
        print_AST_title "Float" depth last;
        print_AST_string s (extend_depth depth last) true
    | Char (cOpt) ->
        print_AST_title "Char" depth last;
        apply_opt print_AST_char cOpt (extend_depth depth last) true
    | Null ->
        print_AST_string "Null" depth last;
    | Boolean (b) ->
        print_AST_title "Boolean" depth last;
        print_AST_bool b (extend_depth depth last) true
;;

let print_AST_postfix_op p depth last =
    match p with
    | Incr ->
        print_AST_title "Incr" depth last
    | Decr ->
        print_AST_title "Decr" depth last
;;

let print_AST_prefix_op p depth last =
    print_AST_string (string_of_prefix_op p) depth last
;;

let print_AST_assign_op a depth last =
    print_AST_string (string_of_assign_op a) depth last
;;

let print_AST_infix_op i depth last =
    print_AST_string (string_of_infix_op i) depth last
;;

let rec print_AST_expression_desc e depth last =
    match e with
    | New (sOpt, sList, eList) ->
        print_AST_title "New" depth last;
        apply_opt print_AST_string sOpt (extend_depth depth last) false;
        print_AST_title "Types :" (extend_depth depth last) false;
        apply_list print_AST_string sList (extend_depth (extend_depth depth last) false);
        print_AST_title "Expressions :" (extend_depth depth last) true;
        apply_list print_AST_expression eList (extend_depth (extend_depth depth last) true)
    | NewArrayEmpty (t, eList) ->
        print_AST_title "NewArrayEmpty" depth last;
        print_AST_type t (extend_depth depth last) false;
        print_AST_title "Sizes :" (extend_depth depth last) true;
        apply_list print_AST_expression eList (extend_depth (extend_depth depth last) true)
    | NewArrayInitialized (t, e) ->
        print_AST_title "NewArrayInitialized" depth last;
        print_AST_type t (extend_depth depth last) false;
        print_AST_title "Init :" (extend_depth depth last) false;
        print_AST_expression e (extend_depth depth last) true
    | Call (eOpt, s, eList) ->
        print_AST_title "Call" depth last;
        apply_opt print_AST_expression eOpt (extend_depth depth last) false;
        print_AST_string s (extend_depth depth last) false;
        print_AST_title "Arguments :" (extend_depth depth last) true;
        apply_list print_AST_expression eList (extend_depth (extend_depth depth last) true)
    | Attr (e, s) ->
        print_AST_title "Attr" depth last;
        print_AST_expression e (extend_depth depth last) false;
        print_AST_string s (extend_depth depth last) true
    | If (e1, e2, e3) ->
        print_AST_title "If" depth last;
        print_AST_expression e1 (extend_depth depth last) false;
        print_AST_expression e2 (extend_depth depth last) false;
        print_AST_expression e3 (extend_depth depth last) true
    | Val (v) ->
        print_AST_title "Val" depth last;
        print_AST_value v (extend_depth depth last) true
    | Name (s) ->
        print_AST_title "Name" depth last;
        print_AST_string s (extend_depth depth last) true
    | ArrayInit (eList) ->
        print_AST_title "ArrayInit" depth last;
        print_AST_title "Expressions :" (extend_depth depth last) true;
        apply_list print_AST_expression eList (extend_depth (extend_depth depth last) true)
    | Array (e, eList) ->
        print_AST_title "Array" depth last;
        print_AST_expression e (extend_depth depth last) false;
        print_AST_title "Expressions :" (extend_depth depth last) true;
        apply_list print_AST_expression eList (extend_depth (extend_depth depth last) true)
    | AssignExp (e1, a, e2) ->
        print_AST_title "AssignExp" depth last;
        print_AST_expression e1 (extend_depth depth last) false;
        print_AST_assign_op a (extend_depth depth last) false;
        print_AST_expression e2 (extend_depth depth last) true
    | Post (e, p) ->
        print_AST_title "Post" depth last;
        print_AST_expression e (extend_depth depth last) false;
        print_AST_postfix_op p (extend_depth depth last) true
    | Pre (p, e) ->
        print_AST_title "Pre" depth last;
        print_AST_prefix_op p (extend_depth depth last) false;
        print_AST_expression e (extend_depth depth last) true
    | Op (e1, i, e2) ->
        print_AST_title "Op" depth last;
        print_AST_expression e1 (extend_depth depth last) false;
        print_AST_infix_op i (extend_depth depth last) false;
        print_AST_expression e2 (extend_depth depth last) true
    | CondOp (e1, e2, e3) ->
        print_AST_title "CondOp" depth last;
        print_AST_expression e1 (extend_depth depth last) false;
        print_AST_expression e2 (extend_depth depth last) false;
        print_AST_expression e3 (extend_depth depth last) true
    | Cast (t, e) ->
        print_AST_title "Cast" depth last;
        print_AST_type t (extend_depth depth last) false;
        print_AST_expression e (extend_depth depth last) true
    | Type (t) ->
        print_AST_title "Type" depth last;
        print_AST_type t (extend_depth depth last) true;
    | ClassOf (t) ->
        print_AST_title "ClassOf" depth last;
        print_AST_type t (extend_depth depth last) true;
    | Instanceof (e, t) ->
        print_AST_title "Cast" depth last;
        print_AST_expression e (extend_depth depth last) false;
        print_AST_type t (extend_depth depth last) true
    | VoidClass ->
        print_AST_title "VoidClass" depth last
and
print_AST_expression e depth last =
    print_AST_title "Expression" depth last;
    print_AST_expression_desc (e.edesc) (extend_depth depth last) true
;;

let print_AST_switchLabel s depth last =
    match s with
    | CstExpr (e) ->
        print_AST_title "CstExpr" depth last;
        print_AST_expression e (extend_depth depth last) true
    | Default ->
        print_AST_title "Default" depth last;
;;

let print_AST_modifier m depth last =
    print_AST_string (stringOf_modifier m) depth last
;;

let print_AST_astattribute a depth last =
    print_AST_title "AstAttribute" depth last;
    print_AST_title "Modifiers :" (extend_depth depth last) false;
    apply_list print_AST_modifier (a.amodifiers) (extend_depth (extend_depth depth last) false);
    print_AST_string (a.aname) (extend_depth depth last) false;
    print_AST_type (a.atype) (extend_depth depth last) false;
    apply_opt print_AST_expression (a.adefault) (extend_depth depth last) true
;;

let print_AST_qualified_name q depth last =
    print_AST_title "Qualified name :" depth last;
    apply_list print_AST_string q (extend_depth depth last)
;;

let rec print_AST_statement s depth last =
    match s with
    | VarDecl (tseList) ->
        print_AST_title "VarDecl" depth last;
        apply_list
            (fun (t, s, e) depth last ->
                print_AST_title "Element" depth last;
                print_AST_type t (extend_depth depth last) false;
                print_AST_string s (extend_depth depth last) false;
                apply_opt print_AST_expression e (extend_depth depth last) true)
            tseList (extend_depth depth last)
    | Block (sList) ->
        print_AST_title "Block" depth last;
        print_AST_title "Statements :" (extend_depth depth last) true;
        apply_list print_AST_statement sList (extend_depth (extend_depth depth last) true)
    | Nop ->
        print_AST_title "Nop" depth last
    | While (e, s) ->
        print_AST_title "While" depth last;
        print_AST_expression e (extend_depth depth last) false;
        print_AST_statement s (extend_depth depth last) true
    | For (tseList, eOpt, eList, s) ->
        print_AST_title "For" depth last;
        print_AST_title "Initialization :" (extend_depth depth last) false;
        apply_list
            (fun (tOpt, s, eOpt) depth last ->
                print_AST_title "Element" depth last;
                apply_opt print_AST_type tOpt (extend_depth depth last) false;
                print_AST_string s (extend_depth depth last) false;
                apply_opt print_AST_expression eOpt (extend_depth depth last) true)
            tseList (extend_depth (extend_depth depth last) false);
        apply_opt print_AST_expression eOpt (extend_depth depth last) false;
        print_AST_title "Expressions :" (extend_depth depth last) false;
        apply_list print_AST_expression eList (extend_depth (extend_depth depth last) false);
        print_AST_statement s (extend_depth depth last) true
    | If (e, s, sOpt) ->
        print_AST_title "If" depth last;
        print_AST_expression e (extend_depth depth last) false;
        print_AST_statement s (extend_depth depth last) false;
        apply_opt print_AST_statement sOpt (extend_depth depth last) true
    | Return (eOpt) ->
        print_AST_title "Return" depth last;
        apply_opt print_AST_expression eOpt (extend_depth depth last) true
    | Throw (e) ->
        print_AST_title "Throw" depth last;
        print_AST_expression e (extend_depth depth last) true
    | Try (sList, asList, sList2) ->
        print_AST_title "Try" depth last;
        print_AST_title "Body :" (extend_depth depth last) false;
        apply_list print_AST_statement sList (extend_depth (extend_depth depth last) false);
        print_AST_title "Catch :" (extend_depth depth last) false;
        apply_list
            (fun (a, sList) depth last ->
                print_AST_title "Element" depth last;
                print_AST_argument a (extend_depth depth last) false;
                print_AST_title "Statements :" (extend_depth depth last) true;
                apply_list print_AST_statement sList (extend_depth (extend_depth depth last) true))
            asList (extend_depth (extend_depth depth last) false);
        print_AST_title "Finally :" (extend_depth depth last) true;
        apply_list print_AST_statement sList2 (extend_depth (extend_depth depth last) true);
    | Expr (e) ->
        print_AST_title "Expr" depth last;
        print_AST_expression e (extend_depth depth last) true
;;

let print_AST_astmethod a depth last =
    print_AST_title "AST method" depth last;
    print_AST_title "Modifiers :" (extend_depth depth last) false;
    apply_list print_AST_modifier (a.mmodifiers) (extend_depth (extend_depth depth last) false);
    print_AST_string (a.mname) (extend_depth depth last) false;
    print_AST_type (a.mreturntype) (extend_depth depth last) false;
    print_AST_title "Arguments :" (extend_depth depth last) false;
    apply_list print_AST_argument (a.margstype) (extend_depth (extend_depth depth last) false);
    print_AST_title "Throws :" (extend_depth depth last) false;
    apply_list print_AST_ref_type (a.mthrows) (extend_depth (extend_depth depth last) false);
    print_AST_title "Body :" (extend_depth depth last) true;
    apply_list print_AST_statement (a.mbody) (extend_depth (extend_depth depth last) true)
;;

let rec print_AST_astconst c depth last =
    print_AST_title "AST constructors" depth last;
    print_AST_title "Modifiers :" (extend_depth depth last) false;
    apply_list print_AST_modifier (c.cmodifiers) (extend_depth (extend_depth depth last) false);
    print_AST_string (c.cname) (extend_depth depth last) false;
    print_AST_title "Arguments :" (extend_depth depth last) false;
    apply_list print_AST_argument (c.cargstype) (extend_depth (extend_depth depth last) false);
    print_AST_title "Throws :" (extend_depth depth last) false;
    apply_list print_AST_ref_type (c.cthrows) (extend_depth (extend_depth depth last) false);
    print_AST_title "Body :" (extend_depth depth last) true;
    apply_list print_AST_statement (c.cbody) (extend_depth (extend_depth depth last) true)
and
print_AST_astclass c depth last =
    print_AST_title "AST class" depth last;
    print_AST_title "Attributes :" (extend_depth depth last) false;
    apply_list print_AST_astattribute (c.cattributes) (extend_depth (extend_depth depth last) false);
    print_AST_title "Inits :" (extend_depth depth last) false;
    apply_list print_AST_initial (c.cinits) (extend_depth (extend_depth depth last) false);
    print_AST_title "Constructors :" (extend_depth depth last) false;
    apply_list print_AST_astconst (c.cconsts) (extend_depth (extend_depth depth last) false);
    print_AST_title "Methods :" (extend_depth depth last) false;
    apply_list print_AST_astmethod (c.cmethods) (extend_depth (extend_depth depth last) false);
    print_AST_title "Types :" (extend_depth depth last) false;
    apply_list print_AST_asttype (c.ctypes) (extend_depth (extend_depth depth last) false);
    print_AST_locationt (c.cloc) (extend_depth depth last) true
and
print_AST_type_info t depth last =
    match t with
    | Class (c) ->
        print_AST_title "Class" depth last;
        print_AST_astclass c (extend_depth depth last) true
    | Inter ->
        print_AST_title "Inter" depth last
and
print_AST_initial i depth last =
    print_AST_title "Initial" depth last;
    print_AST_bool (i.static) (extend_depth depth last) false;
    print_AST_title "Statements :" (extend_depth depth last) true;
    apply_list print_AST_statement (i.block) (extend_depth (extend_depth depth last) true)
and
print_AST_asttype t depth last =
    print_AST_title "AST Type" depth last;
    print_AST_title "Modifiers :" (extend_depth depth last) false;
    apply_list print_AST_modifier (t.modifiers) (extend_depth (extend_depth depth last) false);
    print_AST_string (t.id) (extend_depth depth last) false;
    print_AST_type_info (t.info) (extend_depth depth last) true
;;

let print_AST_astt t depth last =
    print_AST_title "Type t" depth last;
    apply_opt print_AST_qualified_name (t.package) (extend_depth depth last) false;
    print_AST_title "Types :" (extend_depth depth last) true;
    apply_list print_AST_asttype (t.type_list) (extend_depth (extend_depth depth last) true)
;;

let print_AST t =
    print_endline "" ;
    print_endline "" ;
    print_endline "" ;
    print_endline "AST" ;
    print_AST_astt t "" true;
    print_endline "" ;
    print_endline ""
;;
