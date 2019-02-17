open Memory

exception NotImplemented of string;;

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

let execute_statement mem = function
	| AST.VarDecl dl ->
      List.iter (fun (t, name, init) ->
      let type_in_mem = (match t with
      | Type.Array (_, _)-> raise(NotImplemented "Statement Implemented");
      | Type.Primitive _ -> raise(NotImplemented "Statement Implemented");
      | Type.Ref ref_type -> ref_type.tid;
      | Type.Void -> raise(MemoryError "Invalid type")) in
      let var_type_id = Hashtbl.find !mem.names type_in_mem in
      let variable_id = new_mem_obj mem (Object {
        t = var_type_id;
      }) in
      new_mem_name mem name variable_id;
      match init with
      | None -> ();
      | Some e -> ();)
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
	let main_class_id = Hashtbl.find !mem.names "HelloWorld" in
	let main_class = (Hashtbl.find !mem.data main_class_id) in
	match main_class with
		| Class c ->
      let main_method_id = Hashtbl.find c.methods "main" in
      execute_method mem main_method_id;
      print_memory !mem;
    | _ -> ();

