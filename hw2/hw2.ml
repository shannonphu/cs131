type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

let rec build_new_grammar_format sym rules_list res = match rules_list with
	| [] -> res
	| (start, rules) :: t -> 
	     if start = sym then (build_new_grammar_format sym t (rules :: res)) 
	     else build_new_grammar_format sym t res;;

let convert_grammar gram1 = match gram1 with
	| (start, rules) -> (start, fun sym -> (build_new_grammar_format sym rules []));;


(*  *)
(*  *)
(*  *)

(* if all symbols in rule have matched with frag then test with the acceptor *) 
(* if terminal current symbol in frag matches with current symbol in rule then keep checking the next symbols *)
(* if the current terminal symbols don't match, return None and check next rule *)
(* if the symbol is nonterminal then skip and continue checking next symbols in rule in addition to checking 
	other rules starting from that nonterminal symbol *)
let rec check_single_rule grammar_rule rules_func accept derivation frag = match grammar_rule with
	| [] -> accept derivation frag
	| _ -> (match frag with
		    | [] -> None
	       	| f_h :: f_t -> (match grammar_rule with
	       			   | [] -> None
					   | T sym :: g_t -> 
				             if sym = f_h then (check_single_rule g_t rules_func accept derivation f_t)
					         else None
					   | N sym :: g_t ->
					         check_all_rules_of_start sym rules_func (rules_func sym) (check_single_rule g_t rules_func accept) derivation frag
					)
	       )

(* check all the rules based from starting symbol and check each rule individually by calling check_single_rule *)
(* if no match found for rule, move onto check the next rule *)
(* start_rules : list of rules(lists) for each nonterminal symbol *)
and check_all_rules_of_start start rules_func start_rules accept derivation frag = match start_rules with
	| [] -> None
	| h :: t -> (match (check_single_rule h rules_func accept (derivation @ [start, h]) frag) with 
		         | None -> check_all_rules_of_start start rules_func t accept derivation frag
		       	 | Some(d, s) -> Some(d, s)
		    );;

(* actual function *)
let parse_prefix gram accept frag = match gram with
	| (start, rules_func) -> check_all_rules_of_start start rules_func (rules_func start) accept [] frag;;





