len([ ], 0).
len([H|T], N) :- len(T, N1), N is N1 + 1.

    dih(Bit,Count) :- Bit==1, Count==1.
    dah(Bit,Count) :- Bit==1, Count==3.
    boundry(Bit,Count) :- Bit==0, Count==3.
    space(Bit,Count) :- Bit==0, Count==7.
    
    signal_to_morse((B,N), .) :- dih(B,N), !.
    signal_to_morse((B,N), -) :- dah(B,N), !.
    signal_to_morse((B,N), #) :- space((B,N)), !.
    signal_to_morse((B,N), ^) :- boundry(B,N), !.

    compress(L, C) :- compress(L, 1, C).
    compress([], _, []).
    compress([H], Count, [Sym]) :- signal_to_morse((H,Count), Sym).
    compress([H,H|T], Count, TC) :- Cnt2 is Count + 1, compress([H|T], Cnt2, TC), !.
    %compress([H1,H2|T], Count, [[H1,Count]|TC]) :- compress([H2|T], 1, TC). 
    compress([H1,H2|T], Count, [Sym|TC]) :- signal_to_morse((H1,Count), Sym), compress([H2|T], 1, TC).


