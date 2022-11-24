let setup () =
  Raylib.init_window 1000 1000 "Pigeonhole";
  Raylib.set_target_fps 60

let rec horizontal_lines (count : int) (x : int) (x' :int)(y : int) = 
  if count = 0 then () 
  else (
    Raylib.draw_line x y x' y Raylib.Color.black;
    horizontal_lines (count - 1) x (x+500) (y + 50)
  )
let rec vertical_lines (count : int) (x : int) (y : int) (y':int) =
  if count = 0 then ()
  else (
    Raylib.draw_line x y x y' Raylib.Color.black;
    vertical_lines (count - 1) (x + 50) y (y+500))
  
let create_grid (x : int) (y : int) =
  vertical_lines 11 x y (y+500);
  horizontal_lines 11 x (x+500) y

(*Need to add commands for drawing birds and uncovered holes and whatnot*)
let draw_game_board () =
  create_grid 100 100 

let rec game_loop () =
  match Raylib.window_should_close () with
  | true -> Raylib.close_window ()
  | false ->
      let open Raylib in
      begin_drawing ();
      clear_background Color.raywhite;
      draw_game_board ();
      end_drawing ();
      game_loop ()

let rec main_loop () =
  match Raylib.window_should_close () with
  | true -> Raylib.close_window ()
  | false ->
      let open Raylib in
      begin_drawing ();
      clear_background Color.orange;
      draw_text "Pigeonhole" 220 300 100 Color.raywhite;
      draw_text "Press P to Play" 240 440 60 Color.raywhite;
      if get_key_pressed () = P then game_loop();
      end_drawing ();
      main_loop ()

let () = setup () |> main_loop