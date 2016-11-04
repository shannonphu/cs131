% list helper rules
len([ ], 0).
len([H|T], N) :- len(T, N1), N is N1 + 1.

    dih(Bit,Count) :- Bit==1, Count==1.
    dih(Bit,Count) :- Bit==1, Count==2.
    dah(Bit,Count) :- Bit==1, Count==3.
    delim(Bit,Count) :- Bit==0, Count==1.
    boundry(Bit,Count) :- Bit==0, Count==3.
    space(Bit,Count) :- Bit==0, Count==7.
    
    signal_to_morse((B,N), .) :- dih(B,N), !.
    signal_to_morse((B,N), -) :- dah(B,N), !.
    signal_to_morse((B,N), #) :- space(B,N), !.
    signal_to_morse((B,N), ^) :- boundry(B,N), !.
    signal_to_morse((B,N), delimiter) :- delim(B,N), !.

    compress(L, C) :- pre_compress(L, 1, C).
    pre_compress([], _, []).
    pre_compress([H], Count, [Sym]) :- signal_to_morse((H,Count), Sym), !.
    pre_compress([H,H|T], Count, TC) :- Cnt2 is Count + 1, pre_compress([H|T], Cnt2, TC), !.
    % compresses to [[0,3],[1,3]]
    % pre_compress([H1,H2|T], Count, [[H1,Count]|TC]) :- pre_compress([H2|T], 1, TC).
    % compresses and translates to morse
    pre_compress([H1,H2|T], Count, [Sym|TC]) :- signal_to_morse((H1,Count), Sym), pre_compress([H2|T], 1, TC).

    remove_delim([],[]).
    remove_delim([delimiter|T], L) :- remove_delim(T, L), !.
    remove_delim([H|T], [H|T2]) :- remove_delim(T, T2).

    morse(Bits, Res) :- compress(Bits, Temp), remove_delim(Temp, Res).
