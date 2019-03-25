(* An environment enables to store and access information associated
   with a string key. *)
type ('a,'b) t

(* creation of a new empty environment *)
val initial : unit -> ('a,'b) t

(* get the value associated to a key *)
val find : ('a,'b) t -> 'a -> 'b

(* get the values associated to a key *)
val find_all : ('a,'b) t -> 'a -> 'b list

(* is the key associated to a value is the environment *)
val mem : ('a,'b) t -> 'a -> bool

(* define a key with the value associated *)
val define : ('a,'b) t -> 'a -> 'b -> ('a,'b) t

(* iterate a function over all the bindings of the environment *)
val iter : ('a * 'b -> unit) -> ('a,'b) t -> unit

(* returns values *)
val values :  ('a,'b) t -> 'b list

(* returns key-value pairs *)
val key_value_pairs : ('a,'b) t -> ('a * 'b) list

(* A function to print a hash table *)
val print : string -> ('a -> unit) -> ('b -> string -> unit) -> ('a, 'b) t -> string -> unit