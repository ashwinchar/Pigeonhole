open Raylib
open Pigeonholegame
open State
open Pigeon

exception MalformedWindow of string
exception NotInGrid
exception NotBird

type info_packet = {
  bird_textures : Texture2D.t list;
  p1_state : state;
  p2_state : state;
}

let setup () =
  init_window 1000 900 "Pigeonhole";
  set_target_fps 60;
  set_mouse_scale 1. 1.;
  let card_img = load_image "img/cardinal.png" in
  let eagle_img = load_image "img/eagle.png" in
  let kingfisher_img = load_image "img/kingfisher.png" in
  let owl_img = load_image "img/owl.png" in
  let pigeon_img = load_image "img/pigeon.png" in

  image_resize (addr card_img) 100 100;
  image_resize (addr eagle_img) 100 100;
  image_resize (addr kingfisher_img) 100 100;
  image_resize (addr owl_img) 100 100;
  image_resize (addr pigeon_img) 100 100;

  let card_texture = load_texture_from_image card_img in
  let eagle_texture = load_texture_from_image eagle_img in
  let kingfisher_texture = load_texture_from_image kingfisher_img in
  let owl_texture = load_texture_from_image owl_img in
  let pigeon_texture = load_texture_from_image pigeon_img in

  unload_image card_img;
  unload_image eagle_img;
  unload_image kingfisher_img;
  unload_image owl_img;
  unload_image pigeon_img;

  {
    bird_textures =
      [
        pigeon_texture;
        card_texture;
        owl_texture;
        eagle_texture;
        kingfisher_texture;
      ];
    p1_state = init_state;
    p2_state = { init_state with has_turn = false };
  }

type hl_box =
  | None
  | Some of int

let window_id = ref 0
let highlighted_box = ref None
let buffer = ref false
let double_buffer = ref false

let rec draw_birds bird_textures y () =
  match bird_textures with
  | [] -> ()
  | h :: t ->
      (draw_texture h 750 y Color.raywhite;
       draw_line 750 y 850 y Color.black;
       draw_line 750 (y + 100) 850 (y + 100) Color.black;
       draw_line 750 y 750 (y + 100) Color.black;
       draw_line 850 y 850 (y + 100) Color.black;
       match !highlighted_box with
       | None -> ()
       | Some x -> highlight_bird x ());
      draw_birds t (y + 100) ()

and highlight_bird y () =
  let get_y_coord =
    match y with
    | z when z >= 100 && z < 200 ->
        highlighted_box := Some 100;
        100
    | z when z >= 200 && z < 300 ->
        highlighted_box := Some 200;
        200
    | z when z >= 300 && z < 400 ->
        highlighted_box := Some 300;
        300
    | z when z >= 400 && z < 500 ->
        highlighted_box := Some 400;
        400
    | z when z >= 500 && z < 600 ->
        highlighted_box := Some 500;
        500
    | _ -> raise NotBird
  in
  draw_line_ex
    (Vector2.create 750.0 (float_of_int get_y_coord))
    (Vector2.create 850.0 (float_of_int get_y_coord))
    10.0 Color.orange;
  draw_line_ex
    (Vector2.create 750.0 (float_of_int (get_y_coord + 100)))
    (Vector2.create 850.0 (float_of_int (get_y_coord + 100)))
    10.0 Color.orange;
  draw_line_ex
    (Vector2.create 750.0 (float_of_int get_y_coord))
    (Vector2.create 750.0 (float_of_int (get_y_coord + 100)))
    10.0 Color.orange;
  draw_line_ex
    (Vector2.create 850.0 (float_of_int get_y_coord))
    (Vector2.create 850.0 (float_of_int (get_y_coord + 100)))
    10.0 Color.orange

let window_in_bounds win =
  if win < 0 && win > 6 then raise (MalformedWindow "window id out of range")

let rec horizontal_lines (count : int) (x : int) (x' : int) (y : int) =
  if count = 0 then ()
  else (
    draw_line x y x' y Color.black;
    horizontal_lines (count - 1) x (x + 500) (y + 50))

let rec vertical_lines (count : int) (x : int) (y : int) (y' : int) =
  if count = 0 then ()
  else (
    draw_line x y x y' Color.black;
    vertical_lines (count - 1) (x + 50) y (y + 500))

let create_grid (x : int) (y : int) =
  vertical_lines 11 x y (y + 500);
  horizontal_lines 11 x (x + 500) y

let click_on_grid x y =
  if x >= 100 && x <= 600 && y >= 100 && x <= 600 then true else false

let click_on_birds x y =
  if x >= 750 && x <= 850 && y >= 100 && y <= 600 then true else false

let get_board_position () = (get_mouse_x (), get_mouse_y ())

let get_grid_coordinate x y =
  let get_x_coord =
    match x with
    | z when z >= 100 && z <= 150 -> 'A'
    | z when z > 150 && z <= 200 -> 'B'
    | z when z > 200 && z <= 250 -> 'C'
    | z when z > 250 && z <= 300 -> 'D'
    | z when z > 300 && z <= 350 -> 'E'
    | z when z > 350 && z <= 400 -> 'F'
    | z when z > 400 && z <= 450 -> 'G'
    | z when z > 450 && z <= 500 -> 'H'
    | z when z > 500 && z <= 550 -> 'I'
    | z when z > 550 && z <= 600 -> 'J'
    | _ -> raise NotInGrid
  in
  let get_y_coord =
    match y with
    | z when z >= 100 && z <= 150 -> 0
    | z when z > 150 && z <= 200 -> 1
    | z when z > 200 && z <= 250 -> 2
    | z when z > 250 && z <= 300 -> 3
    | z when z > 300 && z <= 350 -> 4
    | z when z > 350 && z <= 400 -> 5
    | z when z > 400 && z <= 450 -> 6
    | z when z > 450 && z <= 500 -> 7
    | z when z > 500 && z <= 550 -> 8
    | z when z > 550 && z <= 600 -> 9
    | _ -> raise NotInGrid
  in
  (get_x_coord, get_y_coord)

let get_center coord =
  let x_center x =
    match x with
    | z when z = 'A' -> 125
    | z when z = 'B' -> 175
    | z when z = 'C' -> 225
    | z when z = 'D' -> 275
    | z when z = 'E' -> 325
    | z when z = 'F' -> 375
    | z when z = 'G' -> 425
    | z when z = 'H' -> 475
    | z when z = 'I' -> 525
    | z when z = 'J' -> 575
    | _ -> raise NotInGrid
  in
  let y_center y =
    match y with
    | z when z = 0 -> 125
    | z when z = 1 -> 175
    | z when z = 2 -> 225
    | z when z = 3 -> 275
    | z when z = 4 -> 325
    | z when z = 5 -> 375
    | z when z = 6 -> 425
    | z when z = 7 -> 475
    | z when z = 8 -> 525
    | z when z = 9 -> 575
    | _ -> raise NotInGrid
  in
  match coord with
  | x', y' -> (x_center x', y_center y')

let get_corner coord =
  let x_corner x =
    match x with
    | z when z = 'A' -> 100
    | z when z = 'B' -> 150
    | z when z = 'C' -> 200
    | z when z = 'D' -> 250
    | z when z = 'E' -> 300
    | z when z = 'F' -> 350
    | z when z = 'G' -> 400
    | z when z = 'H' -> 450
    | z when z = 'I' -> 500
    | z when z = 'J' -> 550
    | _ -> raise NotInGrid
  in
  let y_corner y =
    match y with
    | z when z = 0 -> 100
    | z when z = 1 -> 150
    | z when z = 2 -> 200
    | z when z = 3 -> 250
    | z when z = 4 -> 300
    | z when z = 5 -> 350
    | z when z = 6 -> 400
    | z when z = 7 -> 450
    | z when z = 8 -> 500
    | z when z = 9 -> 550
    | _ -> raise NotInGrid
  in
  match coord with
  | x', y' -> (x_corner x', y_corner y')

let get_bird_selection x y =
  if click_on_birds x y then
    match y with
    | z when z >= 100 && z < 200 -> PigeonBird
    | z when z >= 200 && z < 300 -> CardinalBird
    | z when z >= 300 && z < 400 -> OwlBird
    | z when z >= 400 && z < 500 -> EagleBird
    | z when z >= 500 && z < 600 -> KingFisherBird
    | z -> NoBird
  else NoBird

let get_bird_corner species =
  match species with
  | PigeonBird -> (820, 170)
  | CardinalBird -> (820, 270)
  | OwlBird -> (820, 370)
  | EagleBird -> (820, 470)
  | KingFisherBird -> (820, 570)
  | NoBird -> raise NotBird

let draw_hole coord () =
  match get_center coord with
  | x, y -> draw_circle x y 10. Color.black

let rec draw_grid grid () =
  match grid with
  | [] -> ()
  | (coord, { occupied = true; shot_at = true }) :: t ->
      draw_rectangle
        (fst (get_corner coord))
        (snd (get_corner coord))
        50 50 Color.green;
      draw_hole coord ();
      draw_grid t ()
  | (coord, { occupied = false; shot_at = true }) :: t ->
      draw_rectangle
        (fst (get_corner coord))
        (snd (get_corner coord))
        50 50 Color.green;
      draw_grid t ()
  | (coord, { occupied; shot_at }) :: t -> draw_grid t ()

let rec draw_birds_left bird_list () =
  match bird_list with
  | [] -> ()
  | bird :: t ->
      (match get_bird_corner bird.species with
      | x, y ->
          draw_rectangle x y 30 30 Color.lightgray;
          draw_text
            (string_of_int bird.birds_left)
            (x + 5) (y + 5) 20 Color.black);
      draw_birds_left t ()

let species_to_string spec =
  match spec with
  | PigeonBird -> "Pigeon"
  | CardinalBird -> "Cardinal"
  | OwlBird -> "Owl"
  | EagleBird -> "Eagle"
  | KingFisherBird -> "King Fisher"
  | NoBird -> "None"

let rec draw_bird_selection bird_spec bird_list () =
  draw_text
    ("Bird selected: \n"
    ^ species_to_string bird_spec
    ^ "\n"
    ^ string_of_int (get_bird_from_species bird_list bird_spec).points
    ^ " pts")
    650 650 30 Color.black

let draw_main_page () =
  clear_background Color.orange;
  draw_text "Pigeonhole" 220 300 100 Color.raywhite;
  draw_text "Press P to Play" 240 440 60 Color.raywhite;
  draw_text "Press I for instructions" 300 800 30 Color.raywhite

let draw_instructions () =
  clear_background Color.orange;
  draw_text
    "Instructions: Please click where you would like to place your\n\
     10 holes on the grid. After choosing your holes, pass this\n\
     computer onto the other player and let them choose their\n\
     10 holes. Each person will be given a certain number of birds,\n\
     with each species worth a different number of points. If a\n\
     hole is hit by a specific bird, the worth of that bird is added\n\
     to the player's score. There are 5 species of birds with the\n\
     following values: Pigeon - 10, Cardinal - 50, Owl - 100, Eagle\n\
     - 250, KingFisher - 500. Each player is given 50 Pigeons,\n\
     25 Cardinals, 14 Owls, 7 Eagles, and 4 KingFishers" 50 50 30 Color.raywhite;
  draw_text "Press P to play" 350 650 30 Color.raywhite

let draw_player_1_setup p2_state () =
  if p2_state.holes_on_board = 0 then clear_background Color.raywhite;
  create_grid 100 100;
  draw_text
    "Select 10 grid spaces to place your pigeon holes\n\
     or choose the random selection button. \n\
     After clicking on a grid space it cannot be changed\n\
     so choose carefully." 100 700 30 Color.black;
  draw_rectangle 675 300 250 100 Color.green;
  draw_text "Randomize" 725 335 30 Color.black;
  draw_text "Player 1" 675 100 60 Color.red;
  if p2_state.holes_on_board = 10 then (
    clear_background Color.raywhite;
    window_id := 5)

let draw_player_2_setup p1_state () =
  if p1_state.holes_on_board = 0 then clear_background Color.raywhite;
  create_grid 100 100;
  draw_text
    "Select 10 grid spaces to place your pigeon holes\n\
     or choose the random selection button. \n\
     After clicking on a grid space it cannot be changed\n\
     so choose carefully." 100 700 30 Color.black;
  draw_rectangle 675 300 250 100 Color.green;
  draw_text "Randomize" 725 335 30 Color.black;
  draw_text "Player 2" 675 100 60 Color.blue;
  if p1_state.holes_on_board = 10 then (
    clear_background Color.raywhite;
    window_id := 3)

let draw_score_board p1_state p2_state () =
  draw_rectangle 100 650 500 200 Color.lightgray;
  draw_text "Scoreboard: " 100 650 40 Color.black;
  draw_text ("Player 1: " ^ string_of_int p1_state.score) 100 700 40 Color.red;
  draw_text ("Player 2: " ^ string_of_int p2_state.score) 100 750 40 Color.blue

let draw_player_1 bird_textures p1_state p2_state () =
  clear_background Color.raywhite;
  create_grid 100 100;
  draw_birds bird_textures 100 ();
  draw_text "Player 1" 10 10 30 Color.red;
  draw_score_board p1_state p2_state ();
  draw_grid p1_state.grid ();
  draw_bird_selection p1_state.selected_bird p1_state.bird_list ();
  draw_birds_left p1_state.bird_list ()

let draw_player_2 bird_textures p1_state p2_state () =
  clear_background Color.raywhite;
  create_grid 100 100;
  draw_birds bird_textures 100 ();
  draw_text "Player 2" 10 10 30 Color.blue;
  draw_score_board p1_state p2_state ();
  draw_grid p2_state.grid ();
  draw_bird_selection p2_state.selected_bird p2_state.bird_list ();
  draw_birds_left p2_state.bird_list ()

let draw_switch () =
  clear_background Color.green;
  draw_text "pass computer" 300 350 60 Color.white;
  draw_text "to opponent" 325 420 60 Color.white;
  draw_text "press enter to continue" 270 700 40 Color.white

(*Need to add commands for drawing birds and uncovered holes and whatnot*)
let draw_window bird_textures id p1_state p2_state =
  window_in_bounds id;
  match id with
  | 0 -> draw_main_page ()
  | 1 ->
      draw_player_1 bird_textures p1_state p2_state ();
      if !double_buffer then (
        wait_time 1000.;
        window_id := 3;
        double_buffer := false)
      else if !buffer then (
        double_buffer := true;
        buffer := false)
  | 2 ->
      draw_player_2 bird_textures p1_state p2_state ();
      if !double_buffer then (
        wait_time 1000.;
        window_id := 3;
        double_buffer := false)
      else if !buffer then (
        double_buffer := true;
        buffer := false)
  | 3 -> draw_switch ()
  | 4 -> draw_player_1_setup p2_state ()
  | 5 -> draw_player_2_setup p1_state ()
  | 6 -> draw_instructions ()
  | _ -> raise (MalformedWindow "window out of range")

let pp_int_pair ppf (x, y) = Printf.fprintf ppf "(%c,%d)" x y

let update_set_holes x y player_state opponent_state next_window =
  if click_on_grid x y then (
    print_endline ("Click on: " ^ string_of_int x ^ " " ^ string_of_int y);
    print_endline "Grid Position: ";
    Printf.printf "%a\n" pp_int_pair (get_grid_coordinate x y);
    print_endline "";
    print_int opponent_state.holes_on_board;
    match BirdMapping.find (get_grid_coordinate x y) player_state.grid with
    | Some t ->
        if opponent_state.holes_on_board < 10 && t.occupied = false then (
          draw_hole (get_grid_coordinate x y) ();
          if opponent_state.holes_on_board = 9 then (
            window_id := next_window;
            (player_state, set_hole (get_grid_coordinate x y) opponent_state))
          else (player_state, set_hole (get_grid_coordinate x y) opponent_state))
        else (player_state, opponent_state)
    | None -> (player_state, opponent_state))
  else (player_state, opponent_state)

let update id p1_state p2_state =
  match id with
  | 0 -> begin
      match get_key_pressed () with
      | P ->
          clear_background Color.raywhite;
          window_id := 4;
          (p1_state, p2_state)
      | I ->
          window_id := 6;
          (p1_state, p2_state)
      | _ -> (p1_state, p2_state)
    end
  | 1 ->
      if is_mouse_button_pressed MouseButton.Left then
        match get_board_position () with
        | x, y when click_on_birds x y ->
            highlight_bird y ();
            ({ p1_state with selected_bird = get_bird_selection x y }, p2_state)
        | x, y when click_on_grid x y ->
            if
              can_shoot
                (get_bird_from_species p1_state.bird_list p1_state.selected_bird)
                (get_grid_coordinate x y) p1_state.grid
            then (
              buffer := true;
              ( shoot_grid
                  (get_bird_from_species p1_state.bird_list
                     p1_state.selected_bird)
                  p1_state.grid (get_grid_coordinate x y) p1_state,
                p2_state ))
            else (p1_state, p2_state)
        | x, y -> (p1_state, p2_state)
      else (p1_state, p2_state)
  | 2 ->
      if is_mouse_button_pressed MouseButton.Left then
        match get_board_position () with
        | x, y when click_on_birds x y ->
            highlight_bird y ();
            (p1_state, { p2_state with selected_bird = get_bird_selection x y })
        | x, y when click_on_grid x y ->
            if
              can_shoot
                (get_bird_from_species p2_state.bird_list p2_state.selected_bird)
                (get_grid_coordinate x y) p2_state.grid
            then (
              buffer := true;
              ( p1_state,
                shoot_grid
                  (get_bird_from_species p2_state.bird_list
                     p2_state.selected_bird)
                  p2_state.grid (get_grid_coordinate x y) p2_state ))
            else (p1_state, p2_state)
        | x, y -> (p1_state, p2_state)
      else (p1_state, p2_state)
  | 3 -> (
      match get_key_pressed () with
      | Enter -> (
          match p1_state.mode with
          | Setup -> begin
              match p1_state.has_turn with
              | true ->
                  window_id := 5;
                  switch_turn p1_state p2_state
              | false ->
                  window_id := 1;
                  switch_mode p1_state p2_state
            end
          | Gameplay ->
              begin
                match p1_state.has_turn with
                | true -> window_id := 2
                | false -> window_id := 1
              end;
              clear_background Color.raywhite;
              switch_turn p1_state p2_state)
      | _ -> (p1_state, p2_state))
  | 4 ->
      if is_mouse_button_pressed MouseButton.Left then
        match get_board_position () with
        | x, y -> update_set_holes x y p1_state p2_state 3
      else (p1_state, p2_state)
  | 5 ->
      if is_mouse_button_pressed MouseButton.Left then
        match get_board_position () with
        | x, y ->
            ( snd (update_set_holes x y p2_state p1_state 3),
              fst (update_set_holes x y p2_state p1_state 3) )
      else (p1_state, p2_state)
  | 6 -> begin
      match get_key_pressed () with
      | P ->
          clear_background Color.raywhite;
          window_id := 4;
          (p1_state, p2_state)
      | _ -> (p1_state, p2_state)
    end
  | _ -> raise (MalformedWindow "window out of range")

let rec main_loop () packet =
  match window_should_close () with
  | true -> close_window ()
  | false -> (
      begin_drawing ();
      draw_window packet.bird_textures !window_id packet.p1_state
        packet.p2_state;
      let new_state = update !window_id packet.p1_state packet.p2_state in
      end_drawing ();
      match new_state with
      | s1, s2 ->
          main_loop ()
            {
              bird_textures = packet.bird_textures;
              p1_state = s1;
              p2_state = s2;
            })

let () = setup () |> main_loop ()