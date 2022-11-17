let setup () =
  Raylib.init_window 1000 1000 "Pigeonhole";
  Raylib.set_target_fps 60

let rec loop () =
  match Raylib.window_should_close () with
  | true -> Raylib.close_window ()
  | false ->
      let open Raylib in
      begin_drawing ();
      clear_background Color.orange;
      draw_text "Pigeonhole" 220 300 100 Color.raywhite;
      draw_text "Press P to Play" 240 440 60 Color.raywhite;
      if get_key_pressed () = P then clear_background Color.raywhite;
      end_drawing ();
      loop ()

let () = setup () |> loop