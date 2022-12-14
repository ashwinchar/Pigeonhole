open OUnit2
(** Test Plan: Wrote tests for the majority of functions written inside of the
    Pigeon and State compilation units. Decided to test those functions because
    we wanted to focus on testing the backend of our game to ensure the
    functionality is working properly. We decided to omit testing functions
    inside of the graphics folder (ray.ml) because a better way for us to test
    the frontend and drawing is to play and try to break the game while testing,
    since we can see what it does. Since we can't physically see what the
    functions defined inside of state and pigeon do we need to test them to see
    if they follow desired behavior. Used a glass-box testing strategy to test
    program correctness by trying to hit all branches of program flow. We
    believe this test unit demonstrates the correctness by attempting to
    extensively test all branches of the important backend functions. *)

open Pigeonholegame
open State
open Pigeon

let update_bird_list_test (name : string) (bd : bird) (bdl : bird list)
    (re : bird list) (expected_output : bird list) : test =
  name >:: fun _ -> assert_equal expected_output (update_bird_list bd bdl re)

let switch_turn_test_noexn (name : string) (s1 : state) (s2 : state)
    (expected_output : state * state) : test =
  name >:: fun _ -> assert_equal expected_output (switch_turn s1 s2)

let switch_turn_test_exn (name : string) (s1 : state) (s2 : state)
    (expected_output : exn) : test =
  name >:: fun _ -> assert_raises expected_output (fun () -> switch_turn s1 s2)

let set_hole_test (name : string) (point : coord) (st : state)
    (expected_output : state) : test =
  name >:: fun _ -> assert_equal expected_output (set_hole point st)

let switch_mode_test (name : string) (s1 : state) (s2 : state)
    (expected_output : state * state) : test =
  name >:: fun _ -> assert_equal expected_output (switch_mode s1 s2)

let win_condition_test (name : string) (s1 : state) (s2 : state)
    (expected_output : bool) : test =
  name >:: fun _ -> assert_equal expected_output (win_condition s1 s2)

let get_bird_from_species_test (name : string) (bdl : bird list)
    (bds : bird_species) (expected_output : bird) : test =
  name >:: fun _ -> assert_equal expected_output (get_bird_from_species bdl bds)

let winner_test (name : string) (s1 : state) (s2 : state)
    (expected_output : string) : test =
  name >:: fun _ -> assert_equal expected_output (winner s1 s2)

let num_holes_hit_test (name : string) (lst : 'a list) (expected_output : int) :
    test =
  name >:: fun _ -> assert_equal expected_output (num_holes_hit lst)

module M = BirdMapping

let mockstate1 =
  {
    bird_list = init_birds;
    grid = Pigeon.init_grid Pigeon.rows Pigeon.columns [];
    holes_on_board = 10;
    hit_list = [];
    has_turn = true;
    score = 0;
    mode = Gameplay;
    selected_bird = NoBird;
  }

let mockstate2 =
  {
    bird_list = init_birds;
    grid = Pigeon.init_grid Pigeon.rows Pigeon.columns [];
    holes_on_board = 10;
    hit_list = [];
    has_turn = false;
    score = 0;
    mode = Gameplay;
    selected_bird = NoBird;
  }

let mockstate3 =
  {
    bird_list = init_birds;
    grid = [ (('a', 2), { occupied = false; shot_at = false }) ];
    holes_on_board = 9;
    hit_list = [];
    has_turn = false;
    score = 0;
    mode = Setup;
    selected_bird = NoBird;
  }

let mockstate4 =
  {
    bird_list = init_birds;
    grid = [ (('a', 2), { occupied = false; shot_at = false }) ];
    holes_on_board = 10;
    hit_list = [];
    has_turn = false;
    score = 0;
    mode = Setup;
    selected_bird = NoBird;
  }

let mockstate5 =
  {
    bird_list = init_birds;
    grid = [ (('a', 2), { occupied = true; shot_at = false }) ];
    holes_on_board = 6;
    hit_list = [];
    has_turn = false;
    score = 0;
    mode = Setup;
    selected_bird = NoBird;
  }

let mockstate6 =
  {
    bird_list = init_birds;
    grid = [ (('a', 2), { occupied = false; shot_at = false }) ];
    holes_on_board = 10;
    hit_list = [];
    has_turn = true;
    score = 100;
    mode = Setup;
    selected_bird = NoBird;
  }

let mockstate7 =
  {
    bird_list = init_birds;
    grid = Pigeon.init_grid Pigeon.rows Pigeon.columns [];
    holes_on_board = 10;
    hit_list =
      [
        ('a', 2);
        ('a', 3);
        ('a', 4);
        ('b', 9);
        ('c', 8);
        ('d', 10);
        ('e', 1);
        ('b', 9);
        ('g', 1);
        ('e', 5);
      ];
    has_turn = true;
    score = 100;
    mode = Gameplay;
    selected_bird = NoBird;
  }

let testing =
  [
    update_bird_list_test "Test empty bird list" init_pigeons [] [] [];
    update_bird_list_test "Test on 50 Pigeons" init_pigeons [ init_pigeons ] []
      [ { species = PigeonBird; points = 10; birds_left = 49 } ];
    update_bird_list_test "Test on 49 Pigeons" init_pigeons
      [ { species = PigeonBird; points = 10; birds_left = 49 } ]
      []
      [ { species = PigeonBird; points = 10; birds_left = 48 } ];
    update_bird_list_test "Test on 0 Pigeons" init_pigeons
      [ { species = PigeonBird; points = 10; birds_left = 0 } ]
      []
      [ { species = PigeonBird; points = 10; birds_left = -1 } ];
    update_bird_list_test "Test on 25 Cardinals" init_cards [ init_cards ] []
      [ { species = CardinalBird; points = 50; birds_left = 24 } ];
    update_bird_list_test "Test on 24 Cardinals" init_cards
      [ { species = CardinalBird; points = 50; birds_left = 24 } ]
      []
      [ { species = CardinalBird; points = 50; birds_left = 23 } ];
    update_bird_list_test "Test on 0 Cardinals" init_cards
      [ { species = CardinalBird; points = 50; birds_left = 0 } ]
      []
      [ { species = CardinalBird; points = 50; birds_left = -1 } ];
    update_bird_list_test "Test on 14 Owls" init_owls [ init_owls ] []
      [ { species = OwlBird; points = 100; birds_left = 13 } ];
    update_bird_list_test "Test on 7 Eagles" init_eagles [ init_eagles ] []
      [ { species = EagleBird; points = 250; birds_left = 6 } ];
    update_bird_list_test "Test on 4 KingFishers" init_kingfisher
      [ init_kingfisher ] []
      [ { species = KingFisherBird; points = 500; birds_left = 3 } ];
    update_bird_list_test "Tests unmatched bird" init_pigeons
      [ init_kingfisher ] []
      [ { species = KingFisherBird; points = 500; birds_left = 4 } ];
    update_bird_list_test "Test on 6 Eagles" init_eagles
      [ { species = EagleBird; points = 250; birds_left = 6 } ]
      []
      [ { species = EagleBird; points = 250; birds_left = 5 } ];
    update_bird_list_test "Test on 3 KingFishers" init_kingfisher
      [ { species = KingFisherBird; points = 500; birds_left = 3 } ]
      []
      [ { species = KingFisherBird; points = 500; birds_left = 2 } ];
    update_bird_list_test "Test on 14 Owls" init_owls
      [ { species = OwlBird; points = 100; birds_left = 13 } ]
      []
      [ { species = OwlBird; points = 100; birds_left = 12 } ];
    ("Empty map outputs []" >:: fun _ -> assert_equal [] M.(empty |> to_list));
    ( "is_empty on empty map outputs true" >:: fun _ ->
      assert_equal true M.(empty |> is_empty) );
    ( "Insert a grid_square" >:: fun _ ->
      assert_equal
        [ ("a2", { occupied = false; shot_at = false }) ]
        M.(empty |> insert "a2" { occupied = false; shot_at = false }) );
    ( "Empty on a non-empy map returns false" >:: fun _ ->
      assert_equal false
        M.(
          empty |> insert "a2" { occupied = false; shot_at = false } |> is_empty)
    );
    ( "Inserting a new entry on a non-empty map" >:: fun _ ->
      assert_equal
        [
          ("a2", { occupied = false; shot_at = false });
          ("a3", { occupied = false; shot_at = false });
        ]
        M.(
          empty
          |> insert "a2" { occupied = false; shot_at = false }
          |> insert "a3" { occupied = false; shot_at = false }
          |> to_list) );
    ( "Changing an entry in the map" >:: fun _ ->
      assert_equal
        [ ("a2", { occupied = true; shot_at = false }) ]
        M.(
          empty
          |> insert "a2" { occupied = false; shot_at = false }
          |> insert "a2" { occupied = true; shot_at = false }) );
    ( "Find on non-empty map" >:: fun _ ->
      assert_equal
        (Some { occupied = true; shot_at = false })
        M.(
          empty |> insert "a2" { occupied = true; shot_at = false } |> find "a2")
    );
    ( "Mem on non-empty map should output true" >:: fun _ ->
      assert_equal true
        M.(
          empty |> insert "a2" { occupied = true; shot_at = false } |> mem "a2")
    );
    ("Find on empty map" >:: fun _ -> assert_equal None M.(empty |> find "a2"));
    ( "Mem on map without key expecting false output" >:: fun _ ->
      assert_equal false
        M.(
          empty |> insert "a2" { occupied = true; shot_at = false } |> mem "a3")
    );
    ( "Remove from an empty list" >:: fun _ ->
      assert_equal [] M.(empty |> remove "a2") );
    ( "Remove from a list containing the desired key" >:: fun _ ->
      assert_equal []
        M.(
          empty
          |> insert "a2" { occupied = false; shot_at = false }
          |> remove "a2") );
    switch_turn_test_noexn
      "Switch turn when player1 has_turn = true and player2 has_turn = false"
      mockstate1 mockstate2
      ({ mockstate1 with has_turn = false }, { mockstate2 with has_turn = true });
    switch_turn_test_noexn
      "Switch turn when player1 has_turn = false and player2 has_turn = true"
      mockstate2 mockstate1
      ({ mockstate2 with has_turn = true }, { mockstate1 with has_turn = false });
    switch_turn_test_exn
      "Both player1 and player2 state have has_turn set to true expects a \
       Turning Exception"
      mockstate1 mockstate1 TurnException;
    switch_turn_test_exn
      "Both player1 and player2 state have has_turn set to false expects a \
       Turning Exception"
      mockstate2 mockstate2 TurnException;
    set_hole_test "Expecting valid new hole insertion" ('a', 2) mockstate3
      {
        bird_list = init_birds;
        grid = [ (('a', 2), { occupied = true; shot_at = false }) ];
        holes_on_board = 10;
        hit_list = [];
        has_turn = false;
        score = 0;
        mode = Setup;
        selected_bird = NoBird;
      };
    set_hole_test "Expecting invalid new hole insertion. Coord not contained"
      ('a', 3) mockstate3 mockstate3;
    set_hole_test "Expecting invalid new hole insertion. Holes on board >= 10"
      ('a', 2) mockstate4 mockstate4;
    set_hole_test
      "Expecting invalid new hole insertion. Hole already set to occupied"
      ('a', 2) mockstate5 mockstate5;
    switch_mode_test "Both are in gameplay mode with state_2.has_turn = false"
      mockstate1 mockstate2
      ({ mockstate1 with mode = Setup }, { mockstate2 with mode = Setup });
    switch_mode_test "Both are in setup mode with state_2.has_turn = false"
      mockstate3 mockstate4
      ({ mockstate3 with mode = Gameplay }, { mockstate4 with mode = Gameplay });
    switch_mode_test "Both are in setup mode with state_2.has_turn = true"
      mockstate4 mockstate6
      ( { mockstate4 with mode = Gameplay; has_turn = true },
        { mockstate6 with mode = Gameplay; has_turn = false } );
    win_condition_test "No winner" mockstate1 mockstate2 false;
    win_condition_test "Player1 finished" mockstate7 mockstate1 true;
    win_condition_test "Player2 finished" mockstate1 mockstate7 true;
    get_bird_from_species_test
      "Empty list outputs {species = NoBird; points = 0; birds_left = 1}" []
      PigeonBird
      { species = NoBird; points = 0; birds_left = 1 };
    get_bird_from_species_test "Look for pigeons" init_birds PigeonBird
      { species = PigeonBird; points = 10; birds_left = 50 };
    get_bird_from_species_test "Look for cards" init_birds CardinalBird
      { species = CardinalBird; points = 50; birds_left = 25 };
    get_bird_from_species_test "Look for owls" init_birds OwlBird
      { species = OwlBird; points = 100; birds_left = 14 };
    get_bird_from_species_test "Look for eagles" init_birds EagleBird
      { species = EagleBird; points = 250; birds_left = 7 };
    get_bird_from_species_test "Look for kingfishers" init_birds KingFisherBird
      { species = KingFisherBird; points = 500; birds_left = 4 };
    get_bird_from_species_test
      "Bird not in birdlist outputs {species = NoBird; points = 0; birds_left \
       = 1}"
      [ init_cards; init_eagles ]
      PigeonBird
      { species = NoBird; points = 0; birds_left = 1 };
    winner_test "Expected player1 winner message" mockstate7 mockstate5
      "victory p1";
    winner_test "Expected player2 winner message" mockstate5 mockstate7
      "victory p2";
    winner_test "Expected tie" mockstate7 mockstate6 "tie";
    num_holes_hit_test "No holes hit test" [] 0;
    num_holes_hit_test "1 hole hit" [ ('a', 2) ] 1;
    num_holes_hit_test "2 holes hit" [ ('a', 2); ('b', 2) ] 2;
  ]

let tests = "Pigeonhole tests" >::: List.flatten [ testing ]
let _ = run_test_tt_main tests