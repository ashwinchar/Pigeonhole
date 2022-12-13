type bird_species =
  | PigeonBird
  | CardinalBird
  | OwlBird
  | EagleBird
  | KingFisherBird
  | NoBird

type bird = {
  species : bird_species;
  points : int;
  birds_left : int;
}

type grid_square = {
  occupied : bool;
  shot_at : bool;
}

type coord = char * int

let rows = [ 0; 1; 2; 3; 4; 5; 6; 7; 8; 9 ]
let columns = [ 'A'; 'B'; 'C'; 'D'; 'E'; 'F'; 'G'; 'H'; 'I'; 'J' ]

exception HoleHere
exception Malformed

module BirdMapping = struct
  type t = (coord * grid_square) list
  (** AF: [[(k1,v1); (k2, v2); (k3, v3); ... ; (kn, vn)]] is an association list
  that represents the map {k1 : v1, k2 : v2, k3 :v3, ... , kn : vn}. If a key 
  is inserted but already bounded to the map we will remove the key and 
  replace it with a new binding. The empty map is just {}.
  RI: The map contains no dups. 
  *)

  let find k m = List.assoc_opt k m
  let remove k m = List.remove_assoc k m

  let rec insert k v m =
    match m with
    | [] -> [ (k, v) ]
    | (k', v') :: t -> if k = k' then (k, v) :: t else (k', v') :: insert k v t

  let is_empty d = d = []
  let empty = []

  let rec mem k m =
    match m with
    | [] -> false
    | (k', _) :: t -> if k' = k then true else mem k t

  let to_list (d : 'a list) = d
end

let rec pair (row : int list) (col : char) (out : (coord * grid_square) list) =
  match row with
  | [] -> out
  | h :: t ->
      pair t col
        (BirdMapping.insert (col, h) { occupied = false; shot_at = false } out)

let rec init_grid (row : int list) (col : char list)
    (out : (coord * grid_square) list) =
  match col with
  | [] -> out
  | h :: t -> init_grid row t (pair row h [] @ out)

let rec make_grid hole_coords grid out =
  match grid with
  | [] -> out
  | (coord, { occupied = false; shot_at }) :: t ->
      if List.mem coord hole_coords then
        make_grid hole_coords t
          (BirdMapping.insert coord { occupied = true; shot_at } out)
      else
        make_grid hole_coords t
          (BirdMapping.insert coord { occupied = false; shot_at } out)
  | (coord, { occupied = true; shot_at }) :: t ->
      make_grid hole_coords t
        (BirdMapping.insert coord { occupied = true; shot_at } out)

let rec get_col_list (row : int list) (col : char) (row1 : int) (row2 : int) out
    =
  match row with
  | [] -> out
  | h :: t when h >= row1 && h <= row2 ->
      get_col_list t col row1 row2 ((h, col) :: out)
  | h :: t -> get_col_list t col row1 row2 out

let rec get_row_list (row : int) (col : char list) (col1 : char) (col2 : char)
    outlist =
  match col with
  | [] -> outlist
  | h :: t when h >= col1 && h <= col2 ->
      get_row_list row t col1 col2 ((row, h) :: outlist)
  | h :: t -> get_row_list row t col1 col2 outlist
