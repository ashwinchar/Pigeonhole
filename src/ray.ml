open Raylib

exception MalformedWindow of string

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

let rec draw_birds bird_textures y () =
  match bird_textures with
  | [] -> ()
  | h :: t ->
      draw_texture h 750 y Color.raywhite;
      draw_birds t (y + 100) ()

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

let draw_main_page () =
  clear_background Color.orange;
  draw_text "Pigeonhole" 220 300 100 Color.raywhite;
  draw_text "Press P to Play" 240 440 60 Color.raywhite;
  draw_text "Press I for instructions" 300 800 30 Color.raywhite

let draw_instructions () =
  clear_background Color.orange;
  draw_text "Instructions: " 300 400 30 Color.raywhite

let draw_player_1_setup () =
  clear_background Color.raywhite;
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

let click_on_grid x y =
  if x >= 100. && x <= 600. && y >= 100. && x <= 600. then true else false

let get_board_position =
  print_endline (string_of_int (get_mouse_x ()));
  get_mouse_position ()

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

let update id =
  match id with
  | 0 -> begin
      match get_key_pressed () with
      | P -> window_id := 4
      | I -> window_id := 6
      | _ -> ()
    end
  | 1 -> if is_mouse_button_down MouseButton.Left then begin
      match Vector2.x get_board_position, Vector2.y get_board_position with
      | x, y -> if click_on_grid x y then print_endline "click on grid"
    end
  | 2 -> ()
  | 3 -> ()
  | 4 -> begin
      match Vector2.x get_board_position, Vector2.y get_board_position with
      | _ -> ()(*print_endline ("click on grid" ^ string_of_float x ^ string_of_float y)*)
    end
  | 5 -> ()
  | 6 -> ()
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