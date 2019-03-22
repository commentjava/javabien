open Memory

exception InvalidOp of string;;

let cor_primitives mem = function
  | Boolean(i1), Boolean(i2) -> Memory.add_object mem (Primitive(Boolean(i1 || i2)));
  | _ -> raise (InvalidOp "cor: Cannot bool those primitives");;

let cand_primitives mem = function
  | Boolean(i1), Boolean(i2) -> Memory.add_object mem (Primitive(Boolean(i1 && i2)));
  | _ -> raise (InvalidOp "cand: Cannot bool those primitives");;

let or_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 lor i2)));
  | _ -> raise (InvalidOp "or: Cannot bool those primitives");;

let and_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 land i2)));
  | _ -> raise (InvalidOp "and: Cannot bool those primitives");;

let xor_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 lxor i2)));
  | _ -> raise (InvalidOp "xor: Cannot bool those primitives");;

(** Operation to add two Primitive types *)
let add_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 + i2)));
  | _ -> raise (InvalidOp "Cannot add those primitives");;

(** Operation to add two Primitive types *)
let sub_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 - i2)));
  | _ -> raise (InvalidOp "Cannot sub those primitives");;

(** Operation to multiply two Primitive types *)
let mul_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 * i2)));
  | _ -> raise (InvalidOp "Cannot mul those primitives");;

(** Operation to divide two Primitive types *)
let div_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 / i2)));
  | _ -> raise (InvalidOp "Cannot mul those primitives");;

(** Operation to mod two Primitive types *)
let mod_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 mod i2)));
  | _ -> raise (InvalidOp "Cannot mod those primitives");;

let eq_primitives mem = function
  | Boolean(i1), Boolean(i2) -> Memory.add_object mem (Primitive(Boolean(i1 == i2)));
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Boolean(i1 == i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let ne_primitives mem = function
  | Boolean(i1), Boolean(i2) -> Memory.add_object mem (Primitive(Boolean(i1 != i2)));
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Boolean(i1 != i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let gt_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Boolean(i1 > i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let lt_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Boolean(i1 < i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let ge_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Boolean(i1 >= i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let le_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Boolean(i1 <= i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let shl_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 lsl i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

let shr_primitives mem = function
  | Int(i1), Int(i2) -> Memory.add_object mem (Primitive(Int(i1 lsr i2)));
  | _ -> raise (InvalidOp "Cannot bool those primitives");;

(* Operations on object *)
(** Verify in memory that two addresses are equal
 * TODO: unboxing *)
let eq_obj mem = function
  | a, b -> Memory.add_object mem (Primitive(Boolean(a == b)));;

(** Verify in memory that two addresses are not equal
 * TODO: unboxing *)
let ne_obj mem = function
  | a, b -> Memory.add_object mem (Primitive(Boolean(a != b)));;


