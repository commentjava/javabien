type method_desc = (Type.t * Type.t list)

type javaclass = {
  attributes: (string, Type.t) Env.t;
  methods: (string, method_desc) Env.t;
}

(*** Env printing ***)

let print_type t =
  print_string (Type.stringOf t)
;;

let print_method ((return_type, args_types): method_desc) =
  print_type return_type
;;

let print_methods methods =
  Env.print "Methods" print_string print_method methods 2
;;

let print_attributes attributes =
  Env.print "Attributes" print_string print_type attributes 2
;;

let print_javaclass (v: javaclass) =
  print_newline();
  print_methods v.methods;
  print_newline();
  print_attributes v.attributes;
  print_newline()
;;

(*** Env creation ***)

let env_astattribute env (attribute: AST.astattribute) =
  Env.define env attribute.aname attribute.atype

let rec env_astattribute_list env attribute_list =
  match attribute_list with
  | [] -> env
  | h::t -> env_astattribute_list (env_astattribute env h) t
;;

let env_astmethod env (amethod: AST.astmethod) =
  let rec get_args_type (argstype: AST.argument list) current_args =
    match argstype with
    | [] -> current_args
    | h::t -> get_args_type t (current_args @ [h.ptype])
  in
  Env.define env amethod.mname (amethod.mreturntype, (get_args_type amethod.margstype []))
;;

let rec env_astmethod_list env method_list =
  match method_list with
  | [] -> env
  | h::t -> env_astmethod_list (env_astmethod env h) t
;;

let env_asttype env (asttype: AST.asttype) =
  (* TODO modifiers *)
  match asttype.info with
  | AST.Class(astclass) ->
    let attributes = Env.initial() in
    let attributes = env_astattribute_list attributes astclass.cattributes in
    let methods = Env.initial() in
    let methods = env_astmethod_list methods astclass.cmethods in
    Env.define env asttype.id {attributes; methods}
  | AST.Inter -> env (* Interfaces not implemented *)
;;

let rec env_asttype_list env asttype_list =
  match asttype_list with
  | [] -> env
  | h::t -> env_asttype_list (env_asttype env h) t
;;

let create_env (ast: AST.t) =
  let env = Env.initial() in
  env_asttype_list env ast.type_list
;;