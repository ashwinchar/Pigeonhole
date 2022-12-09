open Raylib
open Pigeonholegame

exception MalformedWindow of string
exception NotInGrid
exception NotBird

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

  [
    pigeon_texture; card_texture; owl_texture; eagle_texture; kingfisher_texture;
  ]

let window_id = ref 0
let highlighted = ref false

let rec draw_birds bird_textures y () =
  if !highlighted = false then (
    match bird_textures with
    | [] -> ()
    | h :: t ->
        draw_texture h 750 y Color.raywhite;
        draw_line 750 y 850 y Color.black;
        draw_line 750 (y + 100) 850 (y + 100) Color.black;
        draw_line 750 y 750 (y + 100) Color.black;
        draw_line 850 y 850 (y + 100) Color.black;
        draw_birds t (y + 100) ())
  else ()

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

let highlight_bird y =
  let get_y_coord =
    match y with
    | z when z >= 100 && z < 200 -> 100
    | z when z >= 200 && z < 300 -> 200
    | z when z >= 300 && z < 400 -> 300
    | z when z >= 400 && z < 500 -> 400
    | z when z >= 500 && z < 600 -> 500
    | _ -> raise NotBird
  in
  highlighted := true;
  draw_line 750 get_y_coord 850 get_y_coord Color.orange;
  draw_line 750 (get_y_coord + 100) 850 (get_y_coord + 100) Color.orange;
  draw_line 750 get_y_coord 750 (get_y_coord + 100) Color.orange;
  draw_line 850 get_y_coord 850 (get_y_coord + 100) Color.orange

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

let draw_hole coord () =
  match get_center coord with
  | x, y -> draw_circle x y 10. Color.black

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
     following values: Pigeon - 1, Cardinal - 5, Owl - 10, Eagle - 25,\n\
     KingFisher - 50. Each player is given 25 Pigeons, 10\n\
     Cardinals, 8 Owls, 5 Eagles, and 2 KingFishers" 50 50 30 Color.raywhite;
  draw_text "Press P to play" 350 650 30 Color.raywhite

let draw_player_1_setup () =
  create_grid 100 100;
  draw_text
    "Select 10 grid spaces to place your pigeon holes\n\
     or choose the random selection button. \n\
     After clicking on a grid space it cannot be changed\n\
     so choose carefully." 100 700 30 Color.black;
  draw_rectangle 675 300 250 100 Color.green;
  draw_text "Randomize" 725 335 30 Color.black

let draw_player_2_setup () =
  clear_background Color.raywhite;
  create_grid 100 100

let draw_player_1 bird_textures () =
  clear_background Color.raywhite;
  create_grid 100 100;
  draw_birds bird_textures 100 ()

let draw_player_2 bird_textures () =
  clear_background Color.raywhite;
  create_grid 100 100;
  draw_birds bird_textures 100 ()

let draw_switch () = clear_background Color.raywhite

(*Need to add commands for drawing birds and uncovered holes and whatnot*)
let draw_window bird_textures id =
  window_in_bounds id;
  match id with
  | 0 -> draw_main_page ()
  | 1 -> draw_player_1 bird_textures ()
  | 2 -> draw_player_2 bird_textures ()
  | 3 -> draw_switch ()
  | 4 -> draw_player_1_setup ()
  | 5 -> draw_player_2_setup ()
  | 6 -> draw_instructions ()
  | _ -> raise (MalformedWindow "window out of range")

let pp_int_pair ppf (x, y) = Printf.fprintf ppf "(%c,%d)" x y

let update id =
  match id with
  | 0 -> begin
      match get_key_pressed () with
      | P ->
          clear_background Color.raywhite;
          window_id := 1
      | I -> window_id := 6
      | _ -> ()
    end
  | 1 -> (
      if is_mouse_button_down MouseButton.Left then
        match get_board_position () with
        | x, y -> if click_on_birds x y then highlight_bird y)
  | 2 -> ()
  | 3 -> ()
  | 4 -> (
      if is_mouse_button_down MouseButton.Left then
        match get_board_position () with
        | x, y ->
            if click_on_grid x y then (
              print_endline
                ("Click on: " ^ string_of_int x ^ " " ^ string_of_int y);
              print_endline "Grid Position: ";
              Printf.printf "%a\n" pp_int_pair (get_grid_coordinate x y);
              draw_hole (get_grid_coordinate x y) ()))
  | 5 -> ()
  | 6 -> begin
      match get_key_pressed () with
      | P ->
          clear_background Color.raywhite;
          window_id := 1
      | _ -> ()
    end
  | _ -> raise (MalformedWindow "window out of range")

let rec main_loop () bird_textures =
  match window_should_close () with
  | true -> close_window ()
  | false ->
      begin_drawing ();
      draw_window bird_textures !window_id;
      update !window_id;
      end_drawing ();
      main_loop () bird_textures

let () = setup () |> main_loop ()
