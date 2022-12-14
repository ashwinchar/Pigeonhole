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

(** A [BirdMapping] contains the states of tiles on the grid. *)
module BirdMapping : sig
  type t = (coord * grid_square) list
  (**[t] represents a grid space mapping a [coord] to its corresponding
     [grid_space] *)

  val find : 'a -> ('a * 'b) list -> 'b option
  (**[find k m] outputs an option of the grid_space corresponding to coordinate
     [k] from the BirdMapping [m]*)

  val remove : 'a -> ('a * 'b) list -> ('a * 'b) list
  (**[remove k m] removes the entry corresponding to coordinate [k] from the
     BirdMapping [m] and outputs the resulting BirdMapping*)

  val insert : 'a -> 'b -> ('a * 'b) list -> ('a * 'b) list
  (**[insert k v m] inserts the coordinate, grid_space tuple corresponding with
     [k] and [v] into the BirdMapping [m] and returns the BirdMapping*)

  val is_empty : 'a list -> bool
  (**[is_empty d] returns whether or not the BirdMapping [d] contains any
     elements*)

  val empty : 'a list
  (**[empty] outputs an empty BirdMapping with no elements*)

  val mem : 'a -> ('a * 'b) list -> bool
  (**[mem k m] outputs whether or not the coordinate [k] is in the BirdMapping
     [m]*)

  val to_list : 'a list -> 'a list
  (**[to_list d] outputs the association list representation of the BirdMapping
     [d]*)
end

val pair :
  int list -> char -> (coord * grid_square) list -> (coord * grid_square) list
(**[pair row col out] creates a list of row column pairs of BirdMappings based
   off of a row list [row] with initial conditions for grid spaces set to false*)

val init_grid :
  int list ->
  char list ->
  (coord * grid_square) list ->
  (coord * grid_square) list
(**[init_grid row col] creates a BirdMapping representing a player grid with
   initial conditions for the grid_spaces set to false*)

val make_grid :
  'a list ->
  ('a * grid_square) list ->
  ('a * grid_square) list ->
  ('a * grid_square) list
(**[make_grid hole_coords grid out] is a grid that is formed based on the
   grid_soace information of each coordinate*)

val get_col_list :
  int list -> char -> int -> int -> (int * char) list -> (int * char) list
(**[get_col_list row col row1 row2 out] is a list of coordinates each where
   column ouutputted corresponds to a row between row1 and row2.*)

val get_row_list :
  int -> char list -> char -> char -> (int * char) list -> (int * char) list
(**[get_row_list row col col1 col2 out] is a list of coordinates each where row
   ouutputted corresponds to a column between col1 and col2.*)
