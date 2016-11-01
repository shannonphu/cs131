(* TA Link: https://github.com/relue2718/ucla-cs131-16f *)

(* iterate over list OCaml
sum [1:2:3] = 1 + sum [2:3];;
sum [2:3] = 2 + sum [3];;
sum [3] = 3 + sum [];;
				-> 0 *)

(* rec = recursive keyword *)

let rec sum lst = match lst with
	| h :: t -> h + (sum t)
	| [] -> 0;;
let remove_first_elem lst = match lst with
	| [] -> []
	| head::tail -> tail;;
let rec remove_last_elem lst = match lst with
	| [] -> []
	| [_] -> [] (* match single element list *)
	| h::t -> h::(remove_last_elem t);;

(* not annotated vs. annotated *)
(* add first and second if function, test, is true *)
# let sum_if_true test first second =
    (if test first then first else 0)
    + (if test second then second else 0)
  ;;
val sum_if_true : (int -> bool) -> int -> int -> int = <fun>

# let sum_if_true (test : int -> bool) (x : int) (y : int) : int =
     (if test x then x else 0)
     + (if test y then y else 0)
  ;;
val sum_if_true : (int -> bool) -> int -> int -> int = <fun>


(* 
parametric polymorphism 
	'a is a generic type that is unknown by the interpretator till runtime
*)
# let first_if_true test x y =
    if test x then x else y
  ;;
val first_if_true : ('a -> bool) -> 'a -> 'a -> 'a = <fun>


type Btree = Node of Btree * int * Btree | Leaf of int 




