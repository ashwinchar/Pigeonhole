open Raylib

exception MalformedWindow of string

let setup () =
  init_window 1000 900 "Pigeonhole";
  set_target_fps 60

let window_id = ref 0

let window_in_bounds win =
  if win < 0 && win > 3 then raise (MalformedWindow "window id out of range")

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
  draw_text "Press P to Play" 240 440 60 Color.raywhite

let draw_player_1 () =
  clear_background Color.raywhite;
  create_grid 100 100;
  let image = load_image "img/cardinal.png" in
  (*let image_resized = image_resize (image, Ctypes.ptr) 100 100 in*)
  let texture = load_texture_from_image image in
  unload_image image;
  draw_texture texture 500 500 Color.raywhite

let draw_player_2 () =
  clear_background Color.raywhite;
  create_grid 100 100

let draw_switch () = clear_background Color.raywhite

let click_on_grid x y =
  if x >= 100 && x <= 600 && y >= 100 && x <= 600 then true else false

let get_board_position =
  let x = get_mouse_x () in
  let y = get_mouse_y () in
  (x, y)

(*Need to add commands for drawing birds and uncovered holes and whatnot*)
let draw_window id =
  window_in_bounds id;
  match id with
  | 0 -> draw_main_page ()
  | 1 -> draw_player_1 ()
  | 2 -> draw_player_2 ()
  | 3 -> draw_switch ()
  | _ -> raise (MalformedWindow "window out of range")

let update id =
  match id with
  | 0 -> if get_key_pressed () = P then window_id := 1
  | 1 -> begin
      match get_board_position with
      | x, y -> if click_on_grid x y then print_endline "click on grid"
    end
  | 2 -> ()
  | 3 -> ()
  | _ -> raise (MalformedWindow "window out of range")

let rec main_loop () =
  match window_should_close () with
  | true -> close_window ()
  | false ->
      begin_drawing ();
      draw_window !window_id;
      update !window_id;
      end_drawing ();
      main_loop ()

let () = setup () |> main_loop