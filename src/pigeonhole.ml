type bird_species =
  | Pigeon
  | Cardinal
  | Owl
  | Eagle
  | KingFisher  (** The type of bird that the player can "shoot" into a hole *)

type bird = {
  species : bird_species;
  size : int;
  hits : int;
}
(** The type of bird that contains the following fields: species, size, hits *)

type coordinate = char * int
(** Type to identify tiles on the game board *)

type grid_player = {
  point : coordinate;
  occupied : bool;
  hit : bool;
  shot_at : bool;
}

type grid_opponent = {
  point : coordinate;
  shot_at : bool;
  hit : bool;
}

let rows = [ 'a'; 'b'; 'c'; 'd'; 'e'; 'f'; 'g'; 'h'; 'i'; 'j' ]
let columns = [ 0; 1; 2; 3; 4; 5; 6; 7; 8; 9 ]
