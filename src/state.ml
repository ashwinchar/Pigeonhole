open Pigeon

exception TurnException

type game_mode =
  | Setup
  | Gameplay

type state = {
  bird_list : bird list;
  grid : BirdMapping.t;
  holes_on_board : int;
  hit_list : coord list;
  has_turn : bool;
  score : int;
  mode : game_mode;
}

let init_pigeons = { species = Pigeon; points = 10; birds_left = 50 }
let init_cards = { species = Cardinal; points = 50; birds_left = 25 }
let init_owls = { species = Owl; points = 100; birds_left = 14 }
let init_eagles = { species = Eagle; points = 250; birds_left = 8 }
let init_kingfisher = { species = KingFisher; points = 500; birds_left = 4 }

let init_birds =
  [ init_pigeons; init_cards; init_owls; init_eagles; init_kingfisher ]

let init_state =
  {
    bird_list = init_birds;
    grid = Pigeon.init_grid Pigeon.rows Pigeon.columns [];
    holes_on_board = 0;
    hit_list = [];
    has_turn = true;
    score = 0;
    mode = Setup;
  }

let set_hole coord state =
  match BirdMapping.find coord state.grid with
  | Some x ->
      if state.holes_on_board < 10 && x.occupied = false then
        {
          bird_list = init_birds;
          grid = make_grid [ coord ] state.grid [];
          holes_on_board = state.holes_on_board + 1;
          hit_list = [];
          has_turn = state.has_turn;
          score = 0;
          mode = Setup;
        }
      else
        {
          bird_list = init_birds;
          grid = state.grid;
          holes_on_board = state.holes_on_board;
          hit_list = [];
          has_turn = state.has_turn;
          score = 0;
          mode = Setup;
        }
  | None ->
      {
        bird_list = init_birds;
        grid = state.grid;
        holes_on_board = state.holes_on_board;
        hit_list = [];
        has_turn = state.has_turn;
        score = 0;
        mode = Setup;
      }

let rec update_bird_list bird bird_list res =
  match bird_list with
  | [] -> res
  | { species = spc; points = pts; birds_left = bdl } :: t
    when spc = bird.species ->
      update_bird_list bird t
        ({ species = bird.species; points = bird.points; birds_left = bdl - 1 }
        :: res)
  | h :: t -> update_bird_list bird t (h :: res)

let rec num_holes_hit hole_hit_list =
  match hole_hit_list with
  | [] -> 0
  | h :: t -> 1 + num_holes_hit t

let rec hit_hole bird grid row col res (s : state) =
  match grid with
  | [] -> res
  | ((row', col'), { occupied = true; shot_at = false }) :: t
    when row = row' && col = col' ->
      hit_hole bird grid row col
        (((row', col'), { occupied = true; shot_at = true }) :: res)
        { s with hit_list = (row, col) :: s.hit_list }
  | ((row', col'), { occupied; shot_at }) :: t ->
      hit_hole bird grid row col
        (((row', col'), { occupied; shot_at }) :: res)
        s

let rec can_shoot bird row col grid =
  match grid with
  | [] -> if bird.birds_left > 0 then true else false
  | ((row', col'), { occupied; shot_at = true }) :: t
    when row = row' && col = col' -> false
  | ((row', col'), { occupied; shot_at }) :: t -> can_shoot bird row col t

let switch_turn state_1 state_2 =
  match state_1.has_turn with
  | true -> begin
      match state_2.has_turn with
      | true -> raise TurnException
      | false ->
          ({ state_1 with has_turn = false }, { state_2 with has_turn = true })
    end
  | false -> begin
      match state_2.has_turn with
      | true ->
          ({ state_1 with has_turn = true }, { state_2 with has_turn = false })
      | false -> raise TurnException
    end

let switch_mode state_1 state_2 =
  match state_1.mode with
  | Setup ->
      if state_2.has_turn then
        ( { state_1 with mode = Gameplay; has_turn = true },
          { state_2 with mode = Gameplay; has_turn = false } )
      else ({ state_1 with mode = Gameplay }, { state_2 with mode = Gameplay })
  | Gameplay -> ({ state_1 with mode = Setup }, { state_2 with mode = Setup })
