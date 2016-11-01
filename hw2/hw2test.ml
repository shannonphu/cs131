type awksub_nonterminals =
  | Expr | Term | Lvalue | Incrop | Binop | Num

(* my tests *)

(* tests for convert_grammar *)
(* let hw1style_grammar0 = (Expr, 
                 [Expr, [T"("; N Expr; T")"];
                  Expr, [N Num];
                  Lvalue, [T"$"; N Expr];
                  Incrop, [T"++"];
                  Incrop, [T"--"];
                  Binop, [T"+"];
                  Binop, [T"-"];
                  Num, [T"0"];
                  Num, [T"1"];
                  Num, [T"2"];
                  Num, [T"3"];
                  Num, [T"4"];
                  Num, [T"5"];
                  Num, [T"6"];
                  Num, [T"7"];
                  Num, [T"8"];
                  Num, [T"9"]]
            );;

let my_convert_grammar_test0 = (snd (convert_grammar hw1style_grammar0)) Binop;;
let my_convert_grammar_test1 = (snd (convert_grammar hw1style_grammar0)) Expr;;
let my_convert_grammar_test2 = (snd (convert_grammar hw1style_grammar0)) Num;;
let my_convert_grammar_test3 = (snd (convert_grammar hw1style_grammar0)) Lvalue;; *)

(* tests for parse_prefix *)
let my_grammar0 =
  (Expr,
   function
     | Expr ->
        [[N Term; N Binop; N Expr];
        [N Term]]
     | Term ->
        [[N Num];
        [N Num; N Num]]
     | Lvalue -> []
     | Incrop -> []
     | Binop ->
        [[T"+"];
        [T"-"]]
     | Num ->
        [[T"0"]; [T"1"]; [T"2"]; [T"3"]; [T"4"];
        [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]]);;

let accept_all derivation string = Some (derivation, string)

let test_1 = ((parse_prefix my_grammar0 accept_all ["1"; "0"; "-"; "8"])
   = Some
       ([ (Expr, [N Term; N Binop; N Expr]); 
          (Term, [N Num; N Num]); 
          (Num, [T "1"]); (Num, [T "0"]);
          (Binop, [T "-"]); 
          (Expr, [N Term]); 
          (Term, [N Num]);
          (Num, [T "8"])],
        []))

let my_grammar1 =
  (Expr,
   function
     | Expr ->
        [[N Binop; N Term; N Binop]]
     | Term ->
        [[N Num];
        [N Num; N Term]]
     | Lvalue -> []
     | Incrop -> []
     | Binop ->
        [[T"+"];
        [T"-"]]
     | Num ->
        [[T"0"]; [T"1"]; [T"2"]; [T"3"]; [T"4"];
        [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]])

let test_2 = ((parse_prefix my_grammar1 accept_all ["-"; "4"; "4"; "+"; "6"; "9"])
   = Some
       ([ (Expr, [N Binop; N Term; N Binop]); 
          (Binop,[T "-"]); 
          (Term, [N Num; N Term]);
          (Num, [T "4"]); 
          (Term, [N Num]);
          (Num, [T "4"]);
          (Binop, [T "+"])],
        ["6"; "9"]))







