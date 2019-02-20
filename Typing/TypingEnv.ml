type javamattribute = {
  atype: Type.t;
  loc: Location.t;
}

type javamethod = {
  return_type: Type.t;
  args_types: (string, Type.t) Env.t;
  loc : Location.t;
}

type javaclass = {
  attributes: (string, javamattribute) Env.t;
  methods: (string, javamethod) Env.t;
  loc : Location.t;
}


(*******  Env Printing  ********)


let print_type t =
  print_string (Type.stringOf t);
  print_newline()
;;

let print_attribute (a: javamattribute) =
  print_type a.atype
;;

let print_method (m: javamethod) =
  print_type m.return_type;
  Env.print "args" print_string print_type m.args_types 4
;;

let print_methods methods =
  Env.print "Methods" print_string print_method methods 2
;;

let print_attributes attributes =
  Env.print "Attributes" print_string print_attribute attributes 2
;;

let print_javaclass (v: javaclass) =
  print_newline();
  print_methods v.methods;
  print_newline();
  print_attributes v.attributes;
  print_newline();
  (* Location.print v.loc;
  print_newline() *)
;;


(*******  Env Creating  ********)


let env_astattribute env (attribute: AST.astattribute) =
  Env.define env attribute.aname {
    atype = attribute.atype;
    loc = attribute.aloc
  }
;;

let rec env_astattribute_list env attribute_list =
  match attribute_list with
  | [] -> env
  | h::t -> env_astattribute_list (env_astattribute env h) t
;;

let env_astmethod env (amethod: AST.astmethod) =
  let env_args = Env.initial() in
  let rec get_args_type (argstype: AST.argument list) args_env =
    match argstype with
    | [] -> args_env
    | h::t -> (
      let args_env_tmp = Env.define args_env h.pident h.ptype in
      get_args_type t args_env_tmp
    )
  in
  let args_env_tmp = get_args_type amethod.margstype env_args in
  Env.define env amethod.mname {
    return_type = amethod.mreturntype;
    args_types = args_env_tmp;
    loc = amethod.mloc
  }
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
    Env.define env asttype.id {
      attributes;
      methods;
      loc = astclass.cloc;
    }
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