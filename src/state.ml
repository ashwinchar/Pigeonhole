open Pigeon

type state = {
  bird_list : bird list;
  grid : BirdMapping.t;
  holes_left : int;
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
    holes_left = 10;
  }
