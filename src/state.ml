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
  selected_bird : bird_species;
}

let init_pigeons = { species = PigeonBird; points = 10; birds_left = 50 }
let init_cards = { species = CardinalBird; points = 50; birds_left = 25 }
let init_owls = { species = OwlBird; points = 100; birds_left = 14 }
let init_eagles = { species = EagleBird; points = 250; birds_left = 7 }
let init_kingfisher = { species = KingFisherBird; points = 500; birds_left = 4 }

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
    selected_bird = NoBird;
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
          selected_bird = NoBird;
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
          selected_bird = NoBird;
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
        selected_bird = NoBird;
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

let rec shoot_grid_helper bird grid coord res (s : state) =
  match coord with
  | row, col -> (
      match grid with
      | [] -> res
      | ((row', col'), { occupied = true; shot_at = false }) :: t
        when row = row' && col = col' ->
          shoot_grid_helper bird t coord
            (((row', col'), { occupied = true; shot_at = true }) :: res)
            s
      | ((row', col'), { occupied = false; shot_at = false }) :: t
        when row = row' && col = col' ->
          shoot_grid_helper bird t coord
            (((row', col'), { occupied = false; shot_at = true }) :: res)
            s
      | ((row', col'), { occupied; shot_at }) :: t ->
          shoot_grid_helper bird t coord
            (((row', col'), { occupied; shot_at }) :: res)
            s)

and shoot_grid bird grid coord state =
  match BirdMapping.find coord state.grid with
  | Some { occupied = true; shot_at = false } ->
      {
        state with
        grid = shoot_grid_helper bird grid coord [] state;
        bird_list = update_bird_list bird state.bird_list [];
        hit_list = coord :: state.hit_list;
        score = state.score + bird.points;
      }
  | Some { occupied = false; shot_at = false } ->
      {
        state with
        grid = shoot_grid_helper bird grid coord [] state;
        bird_list = update_bird_list bird state.bird_list [];
      }
  | Some { occupied; shot_at } -> state
  | None -> state

let rec can_shoot bird coord grid =
  if bird.species = NoBird then false
  else
    match coord with
    | row, col -> (
        match grid with
        | [] -> if bird.birds_left > 0 then true else false
        | ((row', col'), { occupied; shot_at = true }) :: t
          when row = row' && col = col' -> false
        | ((row', col'), { occupied; shot_at }) :: t ->
            can_shoot bird (row, col) t)

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

let rec get_bird_from_species bird_list spec =
  match bird_list with
  | [] -> { species = NoBird; points = 0; birds_left = 1 }
  | { species; points; birds_left } :: t when species = spec ->
      { species; points; birds_left }
  | h :: t -> get_bird_from_species t spec

let win_condition p1 p2 =
  match (num_holes_hit p1.hit_list, num_holes_hit p2.hit_list) with
  | 10, _ | _, 10 -> true
  | _, _ -> false

let winner p1 p2 =
  match win_condition p1 p2 with
  | true ->
      if p1.score > p2.score then "victory p1"
      else if p2.score > p1.score then "victory p2"
      else "tie"
  | false -> failwith "should not be called unless someone won/tied"
