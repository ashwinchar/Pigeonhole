open Pigeon

type state = {
  bird_list : bird list;
  grid : BirdMapping.t;
  holes_on_board : int;
  hit_list : coord list;
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
  }

let set_hole coord state =
  if state.holes_on_board < 10 then
    {
      bird_list = init_birds;
      grid = make_grid [ coord ] state.grid [];
      holes_on_board = state.holes_on_board + 1;
      hit_list = [];
    }
  else
    {
      bird_list = init_birds;
      grid = state.grid;
      holes_on_board = state.holes_on_board;
      hit_list = [];
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
