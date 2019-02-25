(*******  Env Printing  ********)
type javamattribute = {
  atype: Type.t;
  loc: Location.t;
}

type javamethodarguments = {
  args_types: (string, Type.t) Env.t;
  types: Type.t list;
}

type javamethod = {
  return_type: Type.t;
  args: javamethodarguments;
  loc : Location.t;
}

type javaconst = {
  args: javamethodarguments;
  loc : Location.t;
}

type javaclass = {
  attributes: (string, javamattribute) Env.t;
  methods: (string, javamethod) Env.t;
  constructors: (string, javaconst) Env.t;
  types : classes_env; (* For enclosed classes *)
  modifiers : AST.modifier list;
  loc : Location.t;
} and classes_env = (string, javaclass) Env.t

type exec_env = (string, Type.t) Env.t

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
  print_green_string (Type.stringOf t)
;;

let print_attribute (a: javamattribute) depth =
  print_type a.atype depth;
;;

let print_method (m: javamethod) depth =
  print_newline ();
  print_string (depth ^ "├─ " ^ colorWhite ^ "return type: "^ colorReset );
  print_type m.return_type depth;
  print_newline ();
  print_string (depth ^ "└─ ");
  Env.print "args" print_white_string print_type m.args.args_types (depth ^ "   ")
;;

let print_methods methods depth =
  Env.print "Methods" print_white_string print_method methods depth
;;

let print_constructor (c: javaconst) depth =
  print_newline ();
  print_string (depth ^ "└─ ");
  Env.print "args" print_white_string print_type c.args.args_types (depth ^ "   ")
;;

let rec print_constructors consts depth =
  Env.print "Constructors" print_white_string print_constructor consts depth
;;

let print_attributes attributes depth =
  Env.print "Attributes" print_white_string print_attribute attributes depth
;;

let rec print_modifiers modifiers depth =
  match modifiers with
  | [] -> ()
  | [m] -> print_string (depth ^ "|  "); AST.print_AST_modifier m "" true
  | h::t -> (
    print_string (depth ^ "|  ");
    AST.print_AST_modifier h "" false;
    print_modifiers t depth
  )
;;

let rec print_javaclass (v: javaclass) depth =
  print_string ("\n" ^ depth ^ "├─ ");
  print_string "Modifiers:\n";
  print_modifiers v.modifiers depth;
  print_string (depth ^ "├─ ");
  print_constructors v.constructors (depth ^ "│  ");
  print_string ("\n" ^ depth ^ "├─ ");
  print_methods v.methods (depth ^ "│  ");
  print_string ("\n" ^ depth ^ "├─ ");
  print_attributes v.attributes (depth ^ "|  ");
  print_string ("\n" ^ depth ^ "└─ ");
  Env.print "Enclosed classes" print_string print_javaclass v.types (depth ^ "   ")
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
  try
    Env.find env attribute.aname;
    raise (TypeExcept.AlreadyDeclared ("Attribute already defined " ^ attribute.aname))
  with Not_found -> (
    Env.define env attribute.aname {
      atype = attribute.atype;
      loc = attribute.aloc
    }
  )
;;

let rec env_astattribute_list env attribute_list =
  match attribute_list with
  | [] -> env
  | h::t -> env_astattribute_list (env_astattribute env h) t
;;

let rec get_args_type (argstype: AST.argument list) (args: javamethodarguments) =
  match argstype with
  | [] -> args
  | h::t -> (
    if (Env.mem args.args_types h.pident) then (
      raise (TypeExcept.VariableAlreadyDefined(h.pident));
    );
    get_args_type t {
      args_types = (Env.define args.args_types h.pident h.ptype);
      types = args.types @ [h.ptype]
    }
  )
;;

let env_astmethod (env: (string, javamethod) Env.t) (amethod: AST.astmethod) =
  let args_env = get_args_type amethod.margstype ({
    args_types = Env.initial();
    types = []
  }) in
  if (Env.mem env amethod.mname) then (
    let method_ = Env.find env amethod.mname in
    if method_.args.types = args_env.types then
      raise (TypeExcept.MethodAlreadyDefined(amethod.mname, amethod.mreturntype));
  );
  Env.define env amethod.mname {
    return_type = amethod.mreturntype;
    args = args_env;
    loc = amethod.mloc
  }
;;

let rec env_astmethod_list (env: (string, javamethod) Env.t) (method_list: AST.astmethod list) =
  match method_list with
  | [] -> env
  | h::t -> env_astmethod_list (env_astmethod env h) t
;;

let env_astconstructor (env: (string, javaconst) Env.t) (const: AST.astconst) astclass_name =
  if const.cname <> astclass_name then raise(TypeExcept.InvalidConstructorName(const.cname, const.cloc, astclass_name));
  let args_env = get_args_type const.cargstype ({
    args_types = Env.initial();
    types = []
  }) in
  if (Env.mem env const.cname) then (
    let const_ = Env.find env const.cname in
    if const_.args.types = args_env.types then
      raise (TypeExcept.ConstructorAlreadyDefined(const.cname));
  );
  Env.define env const.cname {
    args = args_env;
    loc = const.cloc
  }
;;

let rec env_astconstructor_list (env: (string, javaconst) Env.t) (method_list: AST.astconst list) astclass_name =
  match method_list with
  | [] -> env
  | h::t -> env_astconstructor_list (env_astconstructor env h astclass_name) t astclass_name
;;

let rec env_modifier_list modifier_list =
  modifier_list
;;

let rec env_astclass astclass_name (astclass: AST.astclass) (enclosing_classes: string list) =
  (* For enclosed classes *)
  let enclosing_classes = enclosing_classes @ [astclass_name] in
  let rec env_enclosed_asttypes_list (enclosed_env: (string, javaclass) Env.t) (types_list: AST.asttype list) =
    match types_list with
    | [] -> enclosed_env
    | h::t -> (
      if List.mem h.id enclosing_classes then raise(TypeExcept.ClassAlreadyDefined(h.id));
      env_enclosed_asttypes_list (env_asttype enclosed_env h enclosing_classes) t
    )
  in
  let attributes = env_astattribute_list (Env.initial()) astclass.cattributes in
  let methods = env_astmethod_list (Env.initial()) astclass.cmethods in
  let consts = env_astconstructor_list (Env.initial()) astclass.cconsts astclass_name in (* TODO default constructor MyClass() when no constructor is defined *)
  let types = env_enclosed_asttypes_list (Env.initial()) astclass.ctypes in
  {
    attributes;
    methods;
    constructors = consts;
    types;
    modifiers = [];
    loc = astclass.cloc;
  }
and env_asttype (env: classes_env) (asttype: AST.asttype) (enclosing_classes: string list) =
  (* TODO modifiers *)
  match asttype.info with
  | AST.Class(astclass) -> (
    if Env.mem env asttype.id then raise(TypeExcept.ClassAlreadyDefined(asttype.id));
    Env.define env asttype.id {
      (env_astclass asttype.id astclass enclosing_classes)
      with modifiers = (env_modifier_list asttype.modifiers)
    }
  )
  | AST.Inter -> env (* Interfaces not implemented *)
;;

let rec env_asttype_list env asttype_list =
  match asttype_list with
  | [] -> env
  | h::t -> env_asttype_list (env_asttype env h []) t
;;

let create_classes_env (ast: AST.t) =
  let env = Env.initial() in
  env_asttype_list env ast.type_list
;;

(* The following 3 functions: check_constructor_exist, function_return_type, and class_attr_type could be refactored *)
let check_constructor_exist (env: tc_env) (c_type: Type.t) (params: Type.t list) =
  let has_params (const: javaconst) = ()
    (* TODO The hashmap make things more complicated than necessary, should we change args_type to be a list without params names or implement this function as is *)
  in
  match c_type with
  | Ref(r) -> (
    match r.tpath with
    | [] -> (
      let t_class = Env.find env.classes_env r.tid in
      (* let const = Env.find has_params t_class.constructors in *)
      c_type
    )
    | h::t -> c_type (*TODO nested references and nested classes *)
  )
  | _ -> raise(TypeExcept.WrongType "Only reference types have constructors")
;;

let function_return_type (env: tc_env) (c_type: Type.t) (params: Type.t list) =
  Type.Ref(Type.object_type) (* TODO raise an error if the function doesn't exist and return the actual return type *)
;;

let class_attr_type (env: tc_env) (c_type: Type.t) (attr_name: string) =
  match c_type with
  | Ref(r) -> (
    match r.tpath with
    | [] -> (
      let t_class = Env.find env.classes_env r.tid in
      let attr = Env.find t_class.attributes attr_name in
      attr.atype
    )
    | h::t -> Type.Ref(Type.object_type) (*TODO nested references and nested classes *)
  )
  | _ -> raise(TypeExcept.WrongType "Can't access an attribute if it's not a reference type")
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
    raise(TypeExcept.VariableAlreadyDefined varname)
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