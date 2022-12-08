open OUnit2

let tests = "pigeonhole test suite" >::: List.flatten []

let _ = run_test_tt_main tests