
type bird_species =
  | Pigeon
  | Cardinal
  | Owl
  | BlueJay
  | KingFisher  (** The type of bird that the player can "shoot" into a hole *)

type bird = {
  species : bird_species;
  points : int
}
(** The type of bird that contains the following fields: species, size, hits *)

type grid_square = {
  coordinate : char * int;
  mutable occupied : bool;
  mutable shot_at : bool;
}
(** Type to identify tiles on the game board *)

type grid_player = {
  grid : grid_square array;
  mutable score : int
}

type grid_opponent = {
  grid : grid_square array;
  mutable score : int
}

let rows = [| 'a'; 'b'; 'c'; 'd'; 'e'; 'f'; 'g'; 'h'; 'i'; 'j' |]
let columns = [| 0; 1; 2; 3; 4; 5; 6; 7; 8; 9 |]

