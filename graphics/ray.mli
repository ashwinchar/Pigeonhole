exception MalformedWindow of string
exception NotInGrid
exception NotBird

type info_packet = {
  bird_textures : Raylib.Texture.t list;
  p1_state : Pigeonholegame.State.state;
  p2_state : Pigeonholegame.State.state;
}

val setup : unit -> info_packet

type hl_box =
  | None
  | Some of int

val window_id : int ref
val highlighted_box : hl_box ref
val buffer : bool ref
val double_buffer : bool ref
val draw_birds : Raylib.Texture.t list -> int -> unit -> unit
val highlight_bird : int -> unit -> unit
val window_in_bounds : int -> unit
val horizontal_lines : int -> int -> int -> int -> unit
val vertical_lines : int -> int -> int -> int -> unit
val create_grid : int -> int -> unit
val click_on_grid : int -> int -> bool
val click_on_birds : int -> int -> bool
val get_board_position : unit -> int * int
val get_grid_coordinate : int -> int -> char * int
val get_center : char * int -> int * int
val get_corner : char * int -> int * int
val get_bird_selection : int -> int -> Pigeonholegame.Pigeon.bird_species
val get_bird_corner : Pigeonholegame.Pigeon.bird_species -> int * int
val draw_hole : char * int -> unit -> unit

val draw_grid :
  ((char * int) * Pigeonholegame.Pigeon.grid_square) list -> unit -> unit

val draw_birds_left : Pigeonholegame.Pigeon.bird list -> unit -> unit
val draw_main_page : unit -> unit
val draw_instructions : unit -> unit
val draw_player_1_setup : Pigeonholegame.State.state -> unit -> unit
val draw_player_2_setup : Pigeonholegame.State.state -> unit -> unit

val draw_score_board :
  Pigeonholegame.State.state -> Pigeonholegame.State.state -> unit -> unit

val draw_player_1 :
  Raylib.Texture.t list ->
  Pigeonholegame.State.state ->
  Pigeonholegame.State.state ->
  unit ->
  unit

val draw_player_2 :
  Raylib.Texture.t list ->
  Pigeonholegame.State.state ->
  Pigeonholegame.State.state ->
  unit ->
  unit

val draw_switch : unit -> unit

val draw_window :
  Raylib.Texture.t list ->
  int ->
  Pigeonholegame.State.state ->
  Pigeonholegame.State.state ->
  unit

val pp_int_pair : out_channel -> char * int -> unit

val update_set_holes :
  int ->
  int ->
  Pigeonholegame.State.state ->
  'a ->
  int ->
  Pigeonholegame.State.state * 'a

val update :
  int ->
  Pigeonholegame.State.state ->
  Pigeonholegame.State.state ->
  Pigeonholegame.State.state * Pigeonholegame.State.state

val main_loop : unit -> info_packet -> unit
