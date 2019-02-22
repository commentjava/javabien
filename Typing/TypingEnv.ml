exception MethodAlreadyDefined of string * Type.t
exception VariableAlreadyDefined of string
exception AlreadyDeclared of string


(*******  Env Printing  ********)
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

type exec_env = (string, Type.t) Env.t
type classes_env = (string, javaclass) Env.t

type tc_env = {
  classes_env: classes_env;
  exec_env: exec_env;
  current_class: string;
}

(*******  Env Printing  ********)
let colorWhite = "\x1b[1;37m" ;;
let colorReset = "\x1b[0m" ;;
let colorGreen = "\x1b[0;32m" ;;

let print_white_string s =
  print_string (colorWhite ^ s ^ colorReset)
;;

let print_green_string s =
  print_string (colorGreen ^ s ^ colorReset)
;;

let print_type t depth =
  print_green_string (Type.stringOf t);
  print_newline ()
;;

let print_attribute (a: javamattribute) depth =
  print_type a.atype depth;
;;

let print_method (m: javamethod) depth =
  print_newline ();
  print_string (depth ^ "├─ " ^ colorWhite ^ "return type: "^ colorReset );
  print_type m.return_type depth;
  print_string (depth ^ "└─ ");
  Env.print "args" print_white_string print_type m.args_types (depth ^ "   ");
;;

let print_methods methods depth =
  Env.print "Methods" print_white_string print_method methods depth
;;

let print_attributes attributes depth =
  Env.print "Attributes" print_white_string print_attribute attributes depth
;;

let print_javaclass (v: javaclass) depth =
  print_string ("\n" ^ depth ^ "├─ ");
  print_methods v.methods (depth ^ "│  ");
  print_string ("\n" ^ depth ^ "└─ ");
  print_attributes v.attributes (depth ^ "   ");
  (* Location.print v.loc;
  print_newline() *)
;;

let print_classes_env (c_env: classes_env) =
  Env.print ("Class env") print_white_string print_javaclass c_env "";
;;

let print_exec_env (e_env: exec_env) =
  Env.print "Exec env" print_string print_type e_env ""
;;

let print_tc_env (env: tc_env) =
  print_string ("Current class: " ^ env.current_class ^ "\n");
  print_classes_env env.classes_env;
  print_exec_env env.exec_env
;;

(*******  Class Env Creating  ********)


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
      if (Env.mem args_env h.pident) then (
        let arg_type = Env.find args_env h.pident in
        if arg_type = h.ptype then
          raise (VariableAlreadyDefined(h.pident));
      );
      let args_env_tmp = Env.define args_env h.pident h.ptype in
      get_args_type t args_env_tmp
    )
  in
  let args_env_tmp = get_args_type amethod.margstype env_args in
  if (Env.mem env amethod.mname) then (
    let method_ = Env.find env amethod.mname in
    if Env.values method_.args_types = Env.values args_env_tmp then
      raise (MethodAlreadyDefined(amethod.mname, amethod.mreturntype));
  );
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

let create_classes_env (ast: AST.t) =
  let env = Env.initial() in
  env_asttype_list env ast.type_list
;;

(*******  Exec Env  ********)

let rec exec_add_arguments (exec_env: exec_env) (arguments: AST.argument list) =
  match arguments with
  | [] -> exec_env
  | h::t -> exec_add_arguments (Env.define exec_env h.pident h.ptype) t (* TODO check if pident is already in the env *)
;;

let add_variable (env: tc_env) (varname: string) (vartype: Type.t) =
  try
    Env.find env.exec_env varname;
    raise(VariableAlreadyDefined varname)
  with Not_found -> (
    { env with exec_env = (Env.define env.exec_env varname vartype) }
  )
;;

(*******  TC Env  ********)
let get_var_type (env: tc_env) (varname: string) =
  try
    Env.find env.exec_env varname
  with Not_found -> (
    let current_javaclass = Env.find env.classes_env env.current_class in
    let attr = Env.find current_javaclass.attributes varname in
    attr.atype
  )
;;

let create_env (ast: AST.t) =
  let classes_env = create_classes_env ast in
  {
    classes_env = classes_env;
    exec_env = Env.initial();
    current_class = ""
  }
;;