let rec inSubset num subset = match subset with
	| [] -> false
	| h :: t -> if h = num then true else inSubset num t;;

let rec subset a b =  match a, b with
	| [], _ -> true
	| _, [] -> false
	| h_a :: t_a, _ -> if inSubset h_a b then subset t_a b else false;;

let equal_sets a b = subset a b && subset b a;;

let rec set_union a b = a @ b;;

let rec set_intersection a b = match a with
	| [] -> []
	| h :: t -> 
		if inSubset h b then 
			h::(set_intersection t b)
		else
			set_intersection t b;;

let rec set_diff a b = match a with
	| [] -> []
	| h :: t -> 
		if inSubset h b then 
			set_diff t b
		else
			h :: set_diff t b

let rec computed_fixed_point eq f x = 
	if (eq x (f x))
	then
		x
	else
		computed_fixed_point eq f (f x)

let rec while_away s p x = 
	if p x
	then
		x :: while_away s p (s x)
	else
		[]

let rec rle_decode lp = match lp with
	| [] -> []
	| h :: t -> 
		(match h with
		| (0, item) -> rle_decode t
		| (1, item) -> item :: rle_decode t
		| (count, item) -> item :: rle_decode ((count - 1, item) :: t));;

let rec find_periodic_point eq f p x = 
	if p = 0
	then
		x
	else
		find_periodic_point eq f (p - 1) (f x);;

let rec computed_periodic_point eq f p x = match p with
	| 0 -> x
	| _ ->
		if (find_periodic_point eq f p x) = x
		then
			x
		else
			computed_periodic_point eq f p (f x);;

type ('nonterminal, 'terminal) symbol =
| N of 'nonterminal
| T of 'terminal


let rec getSymbol res pairs = match pairs with
| [] -> res
| h :: t -> (match h with 
	     | (start, rules) -> start :: (getSymbol res t));;

let ruleGood rule validSym = match rule with
	| T sym -> true
	| N sym -> subset [sym] (getSymbol [] validSym);;

let rec rulesGood validSym rules = match rules with
	| [] -> true
	| h :: t -> if (ruleGood h validSym) then rulesGood validSym t else false;;

let compareGrammar a b = match a, b with
	| (a_sym, _), (b_sym, _) -> equal_sets a_sym b_sym;;

let rec getNonterminalsThatTerminate terminating_sym all_rules = match all_rules with
	| [] -> terminating_sym
	| (start, rules) :: t -> 
		if (rulesGood terminating_sym rules) && not (subset [(start, rules)] terminating_sym) then
			getNonterminalsThatTerminate ((start, rules) :: terminating_sym) t
		else
			getNonterminalsThatTerminate terminating_sym t;;


let formatNonterminalsThatTerminate (terminating_sym, all_rules) =
       ((getNonterminalsThatTerminate terminating_sym all_rules), all_rules);;

(* 
computed_fixed_point
stopping condition: is if 2 grammars' left of pairs are same type 
function for next step: get elems in list of right side of pair
initial input: (empty list, current rules)
*)

let getValidRules rules = fst(computed_fixed_point compareGrammar formatNonterminalsThatTerminate ([], rules));;

let rulesEqual r_a r_b = match r_a, r_b with
| (_, []), (_, []) -> true
| (_, []), (_, _) -> false
| (_, _), (_, []) -> false
| (sym_a, rules_a), (sym_b, rules_b) -> sym_a = sym_b && (equal_sets rules_a rules_b);;

let rec containsRule rule all_rules = match all_rules with
| [] -> false
| h :: t -> if (rulesEqual h rule) then true else containsRule rule t;;

let rec sortRulesToOriginalOrder filtered_rules original_rules sorted_rules = match original_rules with
| [] -> sorted_rules
| h :: t -> 
        if (containsRule h filtered_rules) then 
               h :: sortRulesToOriginalOrder filtered_rules t sorted_rules 
        else 
               sortRulesToOriginalOrder filtered_rules t sorted_rules;;

let filter_blind_alleys g = match g with
	| (start, rules) -> (start, sortRulesToOriginalOrder (getValidRules rules) rules []);;

