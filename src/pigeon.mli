module type BirdMap = sig 
  (**[('k, 'v) t] is a map that will bind ['k] values to ['v] values *)
  type ('k, 'v) t
  (** [insert k v m] is the map m with an additional binding added, that 
      binding being ['k] to ['v]. If the key ['k] is already bound in m 
      (say to 's) than [insert k v m] will return m but with a binding of 's to 
      'k instead of to 'v  *)
  val insert : 'k -> 'v -> ('k, 'v) t -> unit
  (** [find k v m] is Some v if k contains a binding inside of m otherwise 
      None*)
  val find : 'k -> ('k, 'v) t -> 'v option
  (** [remove k m] is the map m but with the key value binding held by k 
      removed *)
  val remove : 'k -> ('k, 'v) t -> unit
  (** [empty] is the empty map *)
  val empty : ('k, 'v) t
  (** [bindings m] is the assoiation list of bindings 
      that are inside of map m *)
  val bindings : ('k, 'v) t -> ('k * 'v) list
  (** [mem k m] returns true if [k] is a key in the map otherwise false*)
  val mem : 'k -> ('k, 'v) t -> bool 
end