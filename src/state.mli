exception TurnException

type game_mode =
  | Setup
  | Gameplay

type state = {
  bird_list : Pigeon.bird list;
  grid : Pigeon.BirdMapping.t;
  holes_on_board : int;
  hit_list : Pigeon.coord list;
  has_turn : bool;
  score : int;
  mode : game_mode;
  selected_bird : Pigeon.bird_species;
}

val init_pigeons : Pigeon.bird
val init_cards : Pigeon.bird
val init_owls : Pigeon.bird
val init_eagles : Pigeon.bird
val init_kingfisher : Pigeon.bird
val init_birds : Pigeon.bird list
val init_state : state
val set_hole : Pigeon.coord -> state -> state

val update_bird_list :
  Pigeon.bird -> Pigeon.bird list -> Pigeon.bird list -> Pigeon.bird list

val num_holes_hit : 'a list -> int

val shoot_grid_helper :
  Pigeon.bird ->
  ((char * int) * Pigeon.grid_square) list ->
  Pigeon.coord ->
  Pigeon.BirdMapping.t ->
  state ->
  Pigeon.BirdMapping.t

val shoot_grid :
  Pigeon.bird ->
  ((char * int) * Pigeon.grid_square) list ->
  Pigeon.coord ->
  state ->
  state

val can_shoot :
  Pigeon.bird -> 'a * 'b -> (('a * 'b) * Pigeon.grid_square) list -> bool

val switch_turn : state -> state -> state * state
val switch_mode : state -> state -> state * state

val get_bird_from_species :
  Pigeon.bird list -> Pigeon.bird_species -> Pigeon.bird
