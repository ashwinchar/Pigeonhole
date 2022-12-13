open OUnit2
open Pigeonholegame
open State
open Pigeon

let update_bird_list_test (name : string) (bd : bird) (bdl : bird list)
    (re : bird list) (expected_output : bird list) : test =
  name >:: fun _ -> assert_equal expected_output (update_bird_list bd bdl re)

let testing =
  [
    update_bird_list_test "Test empty bird list" init_pigeons [] [] [];
    update_bird_list_test "Test on 50 Pigeons" init_pigeons [ init_pigeons ] []
      [ { species = PigeonBird; points = 10; birds_left = 49 } ];
    update_bird_list_test "Test on 49 Pigeons" init_pigeons
      [ { species = PigeonBird; points = 10; birds_left = 49 } ]
      []
      [ { species = PigeonBird; points = 10; birds_left = 48 } ];
    update_bird_list_test "Test on 25 Cardinals" init_cards [ init_cards ] []
      [ { species = CardinalBird; points = 50; birds_left = 24 } ];
    update_bird_list_test "Test on 24 Cardinals" init_cards
      [ { species = CardinalBird; points = 50; birds_left = 24 } ]
      []
      [ { species = CardinalBird; points = 50; birds_left = 23 } ];
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
  ]

let tests = "Pigeonhole tests" >::: List.flatten [ testing ]
let _ = run_test_tt_main tests