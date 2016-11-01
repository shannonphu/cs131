let my_subset_test0 = subset [] []
let my_subset_test1 = subset [1;4;5;5;5] [5;5;5;4;1]
let my_subset_test2 = subset [5;4;1] [1;4;5;5;5]
let my_subset_test3 = not (subset [1] [])

let my_equal_sets_test2 = equal_sets [1;2;4] [1;2;4]
let my_equal_sets_test3 = equal_sets [1;4;2;4;4] [4;1;2;4;4;4;4;4;]
let my_equal_sets_test4 = equal_sets [1;2;3;4] [4;3;2;1]

let my_set_union_test0 = equal_sets (set_union [1;6;2;2;2] []) [1;6;2;2;2]

let my_set_intersection_test0 = equal_sets (set_intersection [] []) []
let my_set_intersection_test1 = equal_sets (set_intersection [3;2;5;0;0] [0;0]) [0;0]

let my_set_diff_test0 = equal_sets (set_diff [1;3] [1]) [3]
let my_set_diff_test1 = equal_sets (set_diff [3] []) [3]

let my_computed_fixed_point_test0 =
	computed_fixed_point (fun x y -> y - x > 100) (fun x -> x * 2) 5 = 160

let my_computed_periodic_point_test0 =
	computed_periodic_point (=) (fun x -> x / 3) 3 100 = 0

let my_while_away_test0 = equal_sets (while_away ((+) 3) ((>) 10) 0) [0; 3; 6; 9]
let my_while_away_test1 = equal_sets (while_away (fun x -> x - 3) ((<) 0) 15) [15; 12; 9; 6; 3]

let my_rle_decode_test0 = equal_sets (rle_decode [2,"water"; 3,"duck"]) ["water"; "water"; "duck";"duck";"duck"]
let my_rle_decode_test4 = equal_sets (rle_decode [0,5; 0,6]) []
let my_rle_decode_test1 = equal_sets (rle_decode [2,0; 1,6]) [0; 0; 6]
let my_rle_decode_test2 = equal_sets (rle_decode [3,"w"; 1,"x"; 0,"y"; 2,"z"]) ["w"; "w"; "w"; "x"; "z"; "z"]
let my_rle_decode_test3 = equal_sets (rle_decode [1,0; 1,6]) [0; 6]

type awksub_nonterminals =
  | Expr | Lvalue | Incrop | Binop | Num												  
let my_filter_blind_alleys_test0 =
  filter_blind_alleys (Expr,
      [Expr, [N Lvalue];
       Expr, [N Expr; N Lvalue];
       Expr, [N Lvalue; N Expr];
       Expr, [N Expr; N Binop; N Expr];
       Lvalue, [N Lvalue; N Expr];
       Lvalue, [N Expr; N Lvalue];
       Binop, [T"+"]; Binop, [T"-"];
       Num, [T"0"]])
  = (Expr,
     [Binop, [T "+"]; Binop, [T "-"];
      Num, [T "0"];])
let my_filter_blind_alleys_test1 = filter_blind_alleys (Expr, []) = (Expr, [])
