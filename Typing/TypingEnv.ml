(*******  Env Printing  ********)
type javamattribute = {
  atype: Type.t;
  modifiers : AST.modifier list;
  loc: Location.t;
}

type javamethodarguments = {
  args_types: (string, Type.t) Env.t;
  types: Type.t list;
}

type javamethod = {
  return_type: Type.t;
  args: javamethodarguments;
  modifiers : AST.modifier list;
  body: AST.statement list;
  loc : Location.t;
}

type javaconst = {
  args: javamethodarguments;
  modifiers: AST.modifier list;
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
  current_method: javamethod option
}

type enclosed_elt =
  | ConstList of javaconst list
  | MethodList of javamethod list
  | Attr of javamattribute
  | Type of javaclass

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

let print_modifier m depth last =
  print_string (depth ^ (if last then "└─ " else "├─ "));
  print_green_string (AST.stringOf_modifier m)
;;

let rec print_modifiers modifiers depth =
  match modifiers with
  | [] -> ()
  | [m] -> print_modifier m "" true
  | h::t -> (
    print_modifier h "" false;
    print_string ("\n" ^ depth ^ "   ");
    print_modifiers t depth
  )
;;

let print_attribute (a: javamattribute) depth =
  print_type a.atype depth;
  print_string ("\n" ^ depth ^ "└─ modifiers:");
  if List.length a.modifiers > 0 then (
    print_string ("\n" ^ depth ^ "   ");
    print_modifiers a.modifiers depth;
  )
;;

let print_method (m: javamethod) depth =
  print_newline ();
  print_string (depth ^ "├─ " ^ colorWhite ^ "return type: "^ colorReset );
  print_type m.return_type depth;
  print_newline ();
  print_string (depth ^ "├─ " ^ colorWhite ^ "modifiers: "^ colorReset );
  if List.length m.modifiers > 0 then (
    print_string ("\n" ^ depth ^ "|   ");
    print_modifiers m.modifiers depth;
  );
  print_string ("\n" ^ depth ^ "└─ ");
  Env.print "args" print_white_string print_type m.args.args_types (depth ^ "   ")
;;

let print_methods methods depth =
  Env.print "Methods" print_white_string print_method methods depth
;;

let print_constructor (c: javaconst) depth =
  print_newline ();
  print_string (depth ^ "├─ ");
  Env.print "args" print_white_string print_type c.args.args_types (depth ^ "|  ");
  print_string ("\n" ^ depth ^ "└─ " ^ colorWhite ^ "modifiers: "^ colorReset );
  if List.length c.modifiers > 0 then (
    print_string ("\n" ^ depth ^ "|   ");
    print_modifiers c.modifiers depth;
  );
;;

let rec print_constructors consts depth =
  Env.print "Constructors" print_white_string print_constructor consts depth
;;

let print_attributes attributes depth =
  Env.print "Attributes" print_white_string print_attribute attributes depth
;;

let rec print_javaclass (v: javaclass) depth =
  print_string ("\n" ^ depth ^ "├─ ");
  print_string "Modifiers:";
  if List.length v.modifiers > 0 then (
    print_string ("\n" ^ depth ^ "|  ");
    print_modifiers v.modifiers depth;
  );
  print_string ("\n" ^ depth ^ "├─ ");
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
  print_newline();
  print_exec_env env.exec_env
;;


(*******  Class Env Creating  ********)

let check_modifiers_combination (m1: AST.modifier) (m2: AST.modifier) (ms: AST.modifier list) =
  if List.mem m1 ms && List.mem m2 ms then
    raise(TypeExcept.IllegalModifiersCombination(AST.stringOf_modifier(m1), AST.stringOf_modifier(m2)))
;;

let rec env_modifier_list (modifier_list: AST.modifier list) (noduplicate_list: AST.modifier list) =
  (* no more than one access modifier *)
  check_modifiers_combination AST.Public AST.Private modifier_list;
  check_modifiers_combination AST.Public AST.Protected modifier_list;
  check_modifiers_combination AST.Private AST.Protected modifier_list;
  match modifier_list with
  | [] -> noduplicate_list
  | h::t -> (
    if List.mem h t then raise(TypeExcept.RepeatedModifier(AST.stringOf_modifier h));
    env_modifier_list t noduplicate_list @ [h]
  )
;;

let env_astattribute env (attribute: AST.astattribute) =
  if Env.mem env attribute.aname then
    raise (TypeExcept.AlreadyDeclared ("Attribute already defined " ^ attribute.aname));

  let modifiers = env_modifier_list attribute.amodifiers [] in
  (* check attributes modifiers, only one access modifier *)
  check_modifiers_combination AST.Final AST.Volatile modifiers;

  Env.define env attribute.aname {
    atype = attribute.atype;
    modifiers;
    loc = attribute.aloc
  }
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

let check_method_modifiers (modifiers: AST.modifier list) (amethod: AST.astmethod) =
  let modifiers = env_modifier_list amethod.mmodifiers [] in
  let rec check_modifiers_combination_list (m: AST.modifier) (l: AST.modifier list) =
    match l with
    | [] -> ()
    | h::t -> check_modifiers_combination m h modifiers; check_modifiers_combination_list m t
  in
  check_modifiers_combination_list AST.Abstract ([
    AST.Private; AST.Static; AST.Final; AST.Native; AST.Strictfp; AST.Synchronized
  ]);
  check_modifiers_combination AST.Native AST.Strictfp modifiers;

  let hasBody = (List.length amethod.mbody) > 0 in
  let isAbstract = List.mem AST.Abstract modifiers in
  let isNative = List.mem AST.Native modifiers in

  if isAbstract && hasBody then
    raise(TypeExcept.CannotHaveMethodBody(AST.stringOf_modifier(AST.Abstract)));
  if isNative && hasBody then
    raise(TypeExcept.CannotHaveMethodBody(AST.stringOf_modifier(AST.Native)));
  if not isAbstract && not isNative && not hasBody then
    raise(TypeExcept.MissingMethodBody(amethod.mname));

  modifiers
;;

let env_astmethod (env: (string, javamethod) Env.t) (amethod: AST.astmethod) (isClassAbstract: bool) =
  let args_env = get_args_type amethod.margstype ({
    args_types = Env.initial();
    types = []
  }) in
  if (Env.mem env amethod.mname) then (
    let method_ = Env.find env amethod.mname in
    if method_.args.types = args_env.types then
      raise (TypeExcept.MethodAlreadyDefined(amethod.mname, amethod.mreturntype));
  );
  if not isClassAbstract && List.mem AST.Abstract amethod.mmodifiers then
    raise (TypeExcept.AbstractMethodInNormalClass(amethod.mname));

  (* check modifiers *)
  let modifiers = check_method_modifiers amethod.mmodifiers amethod in

  Env.define env amethod.mname {
    return_type = amethod.mreturntype;
    args = args_env;
    body = amethod.mbody;
    modifiers;
    loc = amethod.mloc
  }
;;

let rec env_astmethod_list (env: (string, javamethod) Env.t) (method_list: AST.astmethod list) (isClassAbstract: bool) =
  match method_list with
  | [] -> env
  | h::t -> env_astmethod_list (env_astmethod env h isClassAbstract) t isClassAbstract
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
    modifiers = env_modifier_list const.cmodifiers [];
    loc = const.cloc
  }
;;

let rec env_astconstructor_list (env: (string, javaconst) Env.t) (method_list: AST.astconst list) (astclass_name: string) (astclass: AST.astclass) =
  match method_list with
  | [] -> (
    (* Add default constructor *)
    let args_env = ({
      args_types = Env.initial();
      types = []
    }) in
    Env.define env astclass_name {
      args = args_env;
      modifiers = [];
      loc = astclass.cloc
    }
  )
  | [const] -> env_astconstructor env const astclass_name
  | h::t -> env_astconstructor_list (env_astconstructor env h astclass_name) t astclass_name astclass
;;

let check_class_modifiers (class_modifiers: AST.modifier list) =
  let modifiers = (env_modifier_list class_modifiers []) in
  if List.mem AST.Final modifiers && List.mem AST.Abstract modifiers then
    raise(TypeExcept.IllegalModifiersCombination(
      AST.stringOf_modifier(AST.Final), AST.stringOf_modifier(AST.Abstract))
  );
  modifiers
;;

let rec env_enclosed_asttypes_list (enclosed_env: (string, javaclass) Env.t) (types_list: AST.asttype list) (enclosing_classes: string list) =
  match types_list with
  | [] -> enclosed_env
  | h::t -> env_enclosed_asttypes_list (env_asttype enclosed_env h enclosing_classes) t enclosing_classes

and env_astclass (env: classes_env) (astclass_name: string) (astclass: AST.astclass)
    (enclosing_classes: string list) (modifiers: AST.modifier list) =

  (* check if class is already defined in same level or in enclosing classes *)
  if Env.mem env astclass_name or List.mem astclass_name enclosing_classes then
    raise(TypeExcept.ClassAlreadyDefined(astclass_name));

  let modifiers = check_class_modifiers modifiers in
  let isAbstract = List.mem AST.Abstract modifiers in

  let attributes = env_astattribute_list (Env.initial()) astclass.cattributes in
  let methods = env_astmethod_list (Env.initial()) astclass.cmethods isAbstract in
  let consts = env_astconstructor_list (Env.initial()) astclass.cconsts astclass_name astclass in (* TODO default constructor MyClass() when no constructor is defined *)

  (* For enclosed classes *)
  let types = env_enclosed_asttypes_list (Env.initial()) astclass.ctypes (enclosing_classes @ [astclass_name]) in

  Env.define env astclass_name {
    attributes;
    methods;
    constructors = consts;
    types;
    modifiers;
    loc = astclass.cloc;
  }

and env_asttype (env: classes_env) (asttype: AST.asttype) (enclosing_classes: string list) =
  (* TODO modifiers *)
  match asttype.info with
  | AST.Class(astclass) -> env_astclass env asttype.id astclass enclosing_classes asttype.modifiers
  | AST.Inter -> env (* Interfaces not implemented *)
;;

let rec env_asttype_list env asttype_list =
  match asttype_list with
  | [] -> env
  | h::t -> env_asttype_list (env_asttype env h []) t
;;

let create_classes_env (ast: AST.t) (std_asts: AST.t list) =
  let rec create_classes_env_list env (asts: AST.t list) =
    match asts with
    | [] -> env
    | h::t -> create_classes_env_list (env_asttype_list env h.type_list) t
  in
  let env = Env.initial() in
  create_classes_env_list env (ast::std_asts)
;;

(*
When looking for an element in a class:
  * look in the class for attribute/method/type
  * look in inherited class attribute/method/type
  * look in same package for type
  TODO: check accessibility
*)
let rec get_elt_of_enclosed_class enclosing_class (elt: string) (qualified_name: string list) =
  match qualified_name with
  | [n] -> (
    try (
      match elt with
      | "const" -> ConstList(Env.find_all enclosing_class.constructors n)
      | "method" -> MethodList(Env.find_all enclosing_class.methods n)
      | "attr" -> Attr(Env.find enclosing_class.attributes n)
      | "type" -> Type(Env.find enclosing_class.types n)
    ) with Not_found -> (
        (* attr can be either attribute or internal type *)
        if elt = "attr" then
          get_elt_of_enclosed_class enclosing_class "type" [n]
        else raise(TypeExcept.CannotFindSymbol(n))
      )
    )
  | h::t -> (
    try (
      let enclosed_class = Env.find enclosing_class.types h in
      get_elt_of_enclosed_class enclosed_class elt t
    ) with Not_found -> raise(TypeExcept.CannotFindSymbol(h))
  )
;;

(* The following 3 functions: check_constructor_exist, function_return_type, and class_attr_type could be refactored *)
let check_constructor_exist (env: tc_env) (c_type: Type.t) (params: Type.t list) =
  match c_type with
  | Ref(r) -> (
    let rec check_constructors (clist: javaconst list) =
      match clist with
      | [] -> raise(TypeExcept.CannotFindSymbol(r.tid))
      | [c] -> (
        if c.args.types = params then c_type
        else raise(TypeExcept.WrongConstructorArguments(r.tid, params))
      )
      | h::t -> if h.args.types = params then c_type else check_constructors t
    in
    try (
      match r.tpath@[r.tid;r.tid] with
      | h::t -> (
        let class_ = match (Env.mem env.classes_env h) with
          | true -> Env.find env.classes_env h
          (* it is maybe enclosed *)
          (* TODO inheritance *)
          | false -> Env.find (Env.find env.classes_env env.current_class).types h
        in
        let elt = get_elt_of_enclosed_class class_ "const" t in
        match elt with
        | ConstList(c) -> check_constructors c
      )
    ) with Not_found -> raise(TypeExcept.CannotFindSymbol(r.tid))
  )
  | _ -> raise(TypeExcept.WrongType "Only reference types have constructors")
;;

let rec function_return_type (env: tc_env) (c_type: Type.t) (mname: string) (params: Type.t list) =
  let rec check_methods (mlist: javamethod list) =
    match mlist with
    | [] -> raise(TypeExcept.CannotFindSymbol(mname))
    | [m] -> (
      if m.args.types = params then m.return_type
      else raise(TypeExcept.WrongMethodArguments(mname, params, m.args.types))
    )
    | h::t -> if h.args.types = params then h.return_type else check_methods t
  in
  match c_type with
  | Ref(r) -> (
    try (
      match r.tpath@[r.tid]@[mname] with
      | h::t -> (
        let class_ = Env.find env.classes_env h in
        let elt = get_elt_of_enclosed_class class_ "method" t in
        match elt with
        | MethodList(m) -> check_methods m
      )
    ) with Not_found -> raise(TypeExcept.CannotFindSymbol(r.tid))
  )
  | _ -> raise(TypeExcept.WrongType "Only reference types have methods")
;;

let class_attr_type (env: tc_env) (c_type: Type.t) (attr_name: string) =
  match c_type with
  | Ref(r) -> (
    try (
      match r.tpath@[r.tid]@[attr_name] with
      | h::t -> (
        let class_ = Env.find env.classes_env h in
        let elt = get_elt_of_enclosed_class class_ "attr" t in
        match elt with
        | Attr(a) -> a.atype
        (* Attr could be a enclosed type *)
        | Type(c) -> Type.Ref({tpath = r.tpath@[r.tid] ; tid = attr_name})
      )
    ) with Not_found -> raise(TypeExcept.CannotFindSymbol(r.tid))
  )
  | _ -> raise(TypeExcept.WrongType "Can't access an attribute if it's not a reference type")
;;

(*******  Exec Env  ********)

let rec exec_add_arguments (exec_env: exec_env) (arguments: (string * Type.t) list) =
  match arguments with
  | [] -> exec_env
  | (name, atype)::t -> exec_add_arguments (Env.define exec_env name atype) t (* TODO check if pident is already in the env *)
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
    try (
      let current_javaclass = Env.find env.classes_env env.current_class in
      (*
        When looking for an variable in a class:
          * look in the class for attribute/type
          * TODO : look in inherited class for attribute/type
          * look in same package for type (here classes_env)
      *)
      if Env.mem current_javaclass.attributes varname then (
        let attr = Env.find current_javaclass.attributes varname in
        attr.atype
      ) else if Env.mem current_javaclass.types varname then (
        let type_ = Env.find current_javaclass.types varname in
        Type.Ref({tpath = [env.current_class] ; tid = varname})
      ) else if Env.mem env.classes_env varname then (
        let type_ = Env.find env.classes_env varname in
        (* TODO: check accessibility *)
        Type.Ref({tpath = [] ; tid = varname})
      ) else if varname = "this" then (
        Type.Ref({tpath = [] ; tid = env.current_class})
      ) else raise(TypeExcept.CannotFindSymbol(varname))
    ) with Not_found -> raise(TypeExcept.CannotFindSymbol(env.current_class))
  )
;;

let create_env (ast: AST.t) (std_asts: AST.t list) =
  let classes_env = create_classes_env ast std_asts in
  {
    classes_env = classes_env;
    exec_env = Env.initial();
    current_class = "";
    current_method = None
  }
;;