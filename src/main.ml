open Graphics

(*let rec interactive () = let event = wait_next_event [ Key_pressed ] in if
  event.key == 'q' then exit 0 else print_char event.key; print_newline ();
  interactive ()*)

let rec loop () = loop ()

let init () =
  open_graph "";
  set_window_title "Pigeon Hole";
  draw_rect ((size_x () / 2) - 150) ((size_y () / 2) - 100) 300 200;
  set_color red;
  fill_rect ((size_x () / 2) - 150) ((size_y () / 2) - 100) 300 200;
  loop ()

let () = init ()