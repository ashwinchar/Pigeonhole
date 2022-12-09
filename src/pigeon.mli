type bird_species =
  | Pigeon
  | Cardinal
  | Owl
  | Eagle
  | KingFisher

type bird = {
  species : bird_species;
  points : int;
}

type grid_square = {
  occupied : bool;
  shot_at : bool;
}

type coord = string

val rows : char array
val columns : int array

module BirdMapping : sig
  type t = (coord * grid_square) list

  val find : 'a -> ('a * 'b) list -> 'b option
  val remove : 'a -> ('a * 'b) list -> ('a * 'b) list
  val insert : 'a -> 'b -> ('a * 'b) list -> ('a * 'b) list
  val empty : 'a list
  val mem : 'a -> ('a * 'b) list -> bool
end

type grid_player = {
  grid : BirdMapping.t;
  mutable score : int;
}

type grid_opponent = {
  grid : BirdMapping.t;
  mutable score : int;
}
