(** The type of bird that occupy the board *)
type bird_species = Pigeon | Cardinal | Owl | BlueJay | KingFisher

(** The type of bird that contains the following fields: species, size, hits *)
type bird = {species : bird_specie; size : int; hits : int}

(***)
type coordinate = char * int