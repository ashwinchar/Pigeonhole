type bird_species =
  | Pigeon
  | Cardinal
  | Owl
  | Eagle
  | KingFisher

type bird = {
  species : bird_species;
  points : int;
  birds_left : int;
}

type grid_square = {
  occupied : bool;
  shot_at : bool;
}

type coord = char * int

val rows : int list
val columns : char list

exception HoleHere
exception Malformed

module BirdMapping : sig
  type t = (coord * grid_square) list

  val find : 'a -> ('a * 'b) list -> 'b option
  val remove : 'a -> ('a * 'b) list -> ('a * 'b) list
  val insert : 'a -> 'b -> ('a * 'b) list -> ('a * 'b) list
  val is_empty : 'a list -> bool
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

val pair :
  int list -> char -> (coord * grid_square) list -> (coord * grid_square) list

val init_grid :
  int list ->
  char list ->
  (coord * grid_square) list ->
  (coord * grid_square) list

val make_grid :
  'a list ->
  ('a * grid_square) list ->
  ('a * grid_square) list ->
  ('a * grid_square) list

val get_col_list :
  int list -> char -> int -> int -> (int * char) list -> (int * char) list

val get_row_list :
  int -> char list -> char -> char -> (int * char) list -> (int * char) list
