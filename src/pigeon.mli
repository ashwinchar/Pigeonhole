(** [bird_species] represents the type of bird the player can "shoot" into a
    hole *)
type bird_species =
  | PigeonBird
  | CardinalBird
  | OwlBird
  | EagleBird
  | KingFisherBird
  | NoBird

type bird = {
  species : bird_species;
  points : int;
  birds_left : int;
}
(** [bird] is the type that contains the following fields: species, size, hits *)

type grid_square = {
  occupied : bool;
  shot_at : bool;
}
(** [grid_square] represents a given grid space contains a hole or has been shot
    at*)

type coord = char * int
(** [coord] is used to represent tiles on the game board *)

val rows : int list
(** [rows] is a list of possible row numbers for the grid *)

val columns : char list
(** [columns] is a list of possible column letters for the grid *)

exception HoleHere
(** Raises: [HoleHere] when a hole is already placed at given coordinates. *)

exception Malformed
(** Raises: [Malformed] when there is an invalid command. *)

module BirdMapping : sig
  type t = (coord * grid_square) list

  val find : 'a -> ('a * 'b) list -> 'b option
  val remove : 'a -> ('a * 'b) list -> ('a * 'b) list
  val insert : 'a -> 'b -> ('a * 'b) list -> ('a * 'b) list
  val is_empty : 'a list -> bool
  val empty : 'a list
  val mem : 'a -> ('a * 'b) list -> bool
  val to_list : 'a list -> 'a list
end

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
