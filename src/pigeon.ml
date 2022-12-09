type bird_species =
  | Pigeon
  | Cardinal
  | Owl
  | Eagle
  | KingFisher  (** The type of bird that the player can "shoot" into a hole *)

type bird = {
  species : bird_species;
  points : int;
}
(** The type of bird that contains the following fields: species, size, hits *)

type grid_square = {
  occupied : bool;
  shot_at : bool;
}

type coord = string
(** Type to identify tiles on the game board *)

let rows = [| 'a'; 'b'; 'c'; 'd'; 'e'; 'f'; 'g'; 'h'; 'i'; 'j' |]
let columns = [| 0; 1; 2; 3; 4; 5; 6; 7; 8; 9 |]

module BirdMapping = struct
  type t = (coord * grid_square) list
  (** 
  Abstraction Function : [[(k1,v1); (k2, v2); (k3, v3); ... ; (kn, vn)]] is 
  an association list that represents the map 
  {k1 : v1, k2 : v2, k3 :v3, ... , kn : vn}. If a key is inserted but already
  bounded to the map we will remove the key and replace it with a new binding. 
  The empty map is just {}
  Representataion Invariant: The map contains no dups. 
  *)

  let find k m = List.assoc_opt k m
  let remove k m = List.remove_assoc k m

  let rec insert k v m =
    match m with
    | [] -> [ (k, v) ]
    | (k', v') :: t -> if k = k' then (k, v) :: t else (k', v') :: insert k v t

  let empty d = d = []
  let empty = []

  let rec mem k m =
    match m with
    | [] -> false
    | (k', _) :: t -> if k' = k then true else mem k t
end

type grid_player = {
  grid : BirdMapping.t;
  mutable score : int;
}

type grid_opponent = {
  grid : BirdMapping.t;
  mutable score : int;
}
