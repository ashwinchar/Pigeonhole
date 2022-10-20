(** The type of bird that occupy the board *)
type bird_specie = Pigeon | Cardinal | Owl | BlueJay | KingFisher

(** The type of bird that contains the following fields: species, size, hits *)
type bird = {species : bird_specie; size : int; hits : int}

(** Type to identify tiles on the game board*)
type coordinate = char * int