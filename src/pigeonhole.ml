type bird_species =
  | Pigeon
  | Cardinal
  | Owl
  | BlueJay
  | KingFisher  (** The type of bird that the player can "shoot" into a hole *)

type bird = {
  species : bird_species;
  size : int;
  hits : int;
}
(** The type of bird that contains the following fields: species, size, hits *)

type coordinate = char * int
(** Type to identify tiles on the game board *)
