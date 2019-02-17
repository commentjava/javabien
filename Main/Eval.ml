open Memory

exception NotImplemented of string;;
exception NullException of string;;
exception InvalidOp of string;;

(** Create a new method for the class located at `class_id` *)
let declare_method mem (class_id : memory_address) (m : AST.astmethod) =
  let method_id = new_mem_obj mem (Method{
    body = m.mbody
  }) in
  match Hashtbl.find !mem.data class_id with
  | Class cl -> Hashtbl.add cl.methods m.mname method_id;
  | _ -> raise(MemoryError "Only classes can have methods");;

(** Declare a new Java type. Only java Classes are implemented *)
let declare_type mem (t : AST.asttype) =
  let class_id = !mem.next_id in
  match t.info with
  | Class cl -> (
    let methods = Hashtbl.create 10 in
    let class_id = new_mem_obj mem (Class { methods = methods; }) in
    new_mem_name mem t.id class_id;
    List.iter (declare_method mem class_id) cl.cmethods;);
  | Inter -> ();
;;

(** Resolve in memory a fqn of the form `classname.method` *)
let resolve_fqn mem fqn =
    let obj_id = Hashtbl.find !mem.names (List.hd fqn) in
    List.fold_left (fun obj_id name ->
      match Hashtbl.find !mem.data obj_id with
      | Class cl -> (
        try
          Hashtbl.find cl.methods name
        with Not_found -> raise (NotImplemented "Resolution of attributes not impl")
      );
      | Object o -> raise (NotImplemented "Resolution not Implemented");
      | Null -> raise (NullException (name ^ " is undefined"));
      | Method _ -> raise (MemoryError ("Could not resolve " ^ name));
      | _ -> -1)
    obj_id
    (List.tl fqn);;

(** Operation to add two Primitive types *)
let add_primitives mem = function
  | Int(i1), Int(i2) -> new_mem_obj mem (Primitive(Int(i1 + i2)));
  | _ -> raise (InvalidOp "Cannot add those primitives");;

(** Execute an expression in memory *)
let rec execute_expression mem (expr : AST.expression) =
  match expr.edesc with
  | AST.Val v -> (match v with
      | AST.Int i -> new_mem_obj mem (Primitive(Int(int_of_string i)));
      | _ -> 0;
  );
  | AST.New (None, fqn, args) -> (
    let class_id = resolve_fqn mem fqn in
    new_mem_obj mem (Object {
        t = class_id;
      })
    );
  | AST.Name n -> Hashtbl.find !mem.names n;
  | AST.Op (e1, op, e2) ->
      let e1_id = execute_expression mem e1 in
      let e2_id = execute_expression mem e2 in
      let (e1_val, e2_val) = match Hashtbl.find !mem.data e1_id, Hashtbl.find !mem.data e2_id with
        | Primitive(p1), Primitive(p2) -> p1, p2;
        | _ -> raise (InvalidOp "Operations can only be done on primitives");
      in
      (match op with
      | AST.Op_add -> add_primitives mem (e1_val, e2_val)
      );
  | _ -> raise(NotImplemented "Statement Implemented");;

(** Execute a statement in memory *)
let execute_statement mem = function
  (** TODO: Take into account the type for apparent type` *)
	| AST.VarDecl dl ->
      List.iter (fun (t, name, init) ->
      let type_in_mem = (match t with
      | Type.Array (_, _)-> raise(NotImplemented "Statement Implemented");
      | Type.Primitive _ -> "prim";
      | Type.Ref ref_type -> ref_type.tid;
      | Type.Void -> raise(MemoryError "Invalid type")) in
      let variable_id = match init with
      | None -> new_mem_obj mem Null;
      | Some e -> execute_expression mem e in
      new_mem_name mem name variable_id;
      )
      dl
  | _ -> raise(NotImplemented "Statement Implemented");;

(** Execute the method located at the method_id memory address
 * TODO: pass arguments to the method
 *)
let execute_method mem (method_id : memory_address) =
  match Hashtbl.find !mem.data method_id with
	| Method m -> List.iter (execute_statement mem) m.body;
  | _ -> raise(MemoryError "Only methods are callable");;

(** Call the entryPoint of an AST tree, this function looks for the function
  * `void main(String[] args)` in the class `HelloWorld` *)
let execute_program (p : AST.t) =
  let mem = new_memory () in
  List.iter (declare_type mem) p.type_list;
  let main_method_id = resolve_fqn mem ["HelloWorld"; "main"] in
  execute_method mem main_method_id;
  print_memory !mem;

