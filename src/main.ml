open Graphics
let create_grid () = 
  clear_graph()

let rec interactive () = let event = wait_next_event [ Key_pressed ] in if
  event.key == 'q' then exit 0 else if event.key == 'p' then create_grid () else print_char event.key; print_newline ();
  interactive ()

(* let rec loop () = loop () *)

let init () =
  open_graph "";
  set_window_title "Pigeon Hole";
  draw_rect ((size_x () / 2) - 150) ((size_y () / 2) - 100) 300 200;
  set_color blue;
  fill_rect ((size_x () / 2) - 150) ((size_y () / 2) - 100) 300 200;
  set_color black;
  moveto (size_x()/2 - 75) ((size_y () - 100));
  draw_string "Press P to Play, Q to Quit";
  interactive ()

let () = init ()