exception TurnException
(**[TurnException] raised whenever both players have [has_turn] set to true or
   when both players have [has_turn] set to false*)

(**Represents whther the players are in [Setup] mode, where players set holes,
   or [Gameplay] mode where players are throwing birds*)
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
(** type [state] represents a given players state at a certain point of time
    during the game. The state contains information on the bird inventory
    [bird_list], their opponents current grid [grid], the number of holes on
    their opponents grid [holes_on_board], the coordinates of each hole hit
    [hit_list], if it's the player's turn [has_turn], the player's updated score
    [score], the current game_mode [mode], and the current bird selected by the
    player [selected_bird]*)

val init_pigeons : Pigeon.bird
(** [init_pigeons] is a bird representing a pigeon with initial point value and
    birds left set*)

val init_cards : Pigeon.bird
(** [init_cards] is a bird representing a cardinal with initial point value and
    birds left set*)

val init_owls : Pigeon.bird
(** [init_owls] is a bird representing an owl with initial point value and birds
    left set*)

val init_eagles : Pigeon.bird
(** [init_eagles] is a bird representing an eagle with initial point value and
    birds left set*)

val init_kingfisher : Pigeon.bird
(** [init_kingfisher] is a bird representing a kingfisher with initial point
    value and birds left set*)

val init_birds : Pigeon.bird list
(** [init_birds] is a list of all throwable birds with thier corresponding
    initial values*)

val init_state : state
(** [init_state] is the initial state of each player*)

val set_hole : Pigeon.coord -> state -> state
(**[set_hole coord state] places a hole at [coord] in the given [state.grid]
   when there isn't already a hole there and there aren't already 10 holes on
   the board*)

val update_bird_list :
  Pigeon.bird -> Pigeon.bird list -> Pigeon.bird list -> Pigeon.bird list
(**[update_bird_list bird bird_list res] returns a bird list after [bird] has
   been thrown*)

val num_holes_hit : 'a list -> int
(**[num_holes_hit hole_hit_list] is the number of holes that are in
   [hole_hit_list]*)

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
(**[shoot_grid bird grid coord state] returns a player's state after shooting a
   [bird] at [grid] at coordinate [coord]*)

val can_shoot :
  Pigeon.bird -> 'a * 'b -> (('a * 'b) * Pigeon.grid_square) list -> bool
(**[can_shoot bird coord grid] outputs whether a [bird] can be shot at [grid] at
   coordinate [coord]*)

val switch_turn : state -> state -> state * state
(**[switch_turn state_1 state_2] swaps [state.has_turn] for both states. Raises
   turn exception when both states have the same value for [state.has_turn]*)

val switch_mode : state -> state -> state * state
(**[switch_mode state_1 state_2] switches the game_mode of both [state_1] and
   [state_2] to [Gameplay] when set to [Setup] and [Setup] when set to gameplay*)

val get_bird_from_species :
  Pigeon.bird list -> Pigeon.bird_species -> Pigeon.bird
(**Returns bird from [bird_list] with the same species as [spec]*)

val win_condition : state -> state -> bool
val winner : state -> state -> string
