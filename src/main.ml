open Graphics
let rec horizontal_lines (count : int) (x : int) (y : int) (offset : int) = 
  if count = 0 then () 
  else (
    moveto x y;
    lineto (size_x () - offset) y;
    horizontal_lines (count - 1) x (y + 50) offset
  )
let rec vertical_lines (count : int) (x : int) (y : int) (offset : int) =
  if count = 0 then ()
  else (
    moveto x y;
    lineto x (size_y () - offset);
    vertical_lines (count - 1) (x + 50) y offset)

let create_grid (x : int) (y : int) (offset : int) =
  clear_graph ();
  vertical_lines 10 x y offset;
  horizontal_lines 10 x y offset

let rec interactive () =
  let event = wait_next_event [ Key_pressed ] in
  if event.key == 'q' then exit 0
  else if event.key == 'p' then create_grid 0 0 20
  else print_char event.key;
  print_newline ();
  interactive ()

let init () =
  open_graph "";
  set_window_title "Pigeon Hole";
  resize_window 1200 720;
  draw_rect ((size_x () / 2) - 90) ((size_y () / 2) - 40) 180 80;
  set_color green;
  fill_rect ((size_x () / 2) - 90) ((size_y () / 2) - 40) 180 80;
  set_color black;
  moveto ((size_x () / 2) - 75) ((size_y () / 2) - 5);
  draw_string "Press P to Play, Q to Quit";
  interactive ()

let () = init ()