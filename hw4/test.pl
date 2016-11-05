    dih(Bit,Count) :- Bit==1, Count==1.
    dih(Bit,Count) :- Bit==1, Count==2.
    dah(Bit,Count) :- Bit==1, Count>3.    
    dah(Bit,Count) :- Bit==1, Count==3.
    dah(Bit, Count) :- Bit==1, Count==2.
    
    delim(Bit,Count) :- Bit==0, Count==1.
    delim(Bit, Count) :- Bit==0, Count==2.
    boundry(Bit,Count) :- Bit==0, Count==3.
    boundry(Bit,Count) :- Bit==0, Count==4.
    boundry(Bit,Count) :- Bit==0, Count==5.
    boundry(Bit,Count) :- Bit==0,Count==2.
    space(Bit,Count) :- Bit==0, Count>5.    
    space(Bit,Count) :- Bit==0, Count==7.
    space(Bit,Count) :- Bit==0, Count==5.
    
    signal_to_morse((B,N), .) :- dih(B,N), !.
    signal_to_morse((B,N), -) :- dah(B,N), !.
    signal_to_morse((B,N), delimiter) :- delim(B,N), !.
    signal_to_morse((B,N), ^) :- boundry(B,N), !.
    signal_to_morse((B,N), #) :- space(B,N), !.

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

    signal_morse(Bits, Res) :- compress(Bits, Temp), remove_delim(Temp, Res).

    convert([], Curr, [Res]) :- morse(Res, Curr).
    convert([^|T], Curr, [R|Res]) :- morse(R, Curr), convert(T, [], Res).
    convert([H|T], Curr, Res) :- convert(T, [H|Curr], Res), !.
    
    signal_message(Z, Res) :- convert(Z, [], Res).
        

morse(a, [.,-]) :- !.           % A
morse(b, [-,.,.,.]) :- !.	   % B
morse(c, [-,.,-,.]) :- !.	   % C
morse(d, [-,.,.]) :- !.	   % D
morse(e, [.]) :- !.		   % E
morse('e''', [.,.,-,.,.]) :- !. % É (accented E)
morse(f, [.,.,-,.]) :- !.	   % F
morse(g, [-,-,.]) :- !.	   % G
morse(h, [.,.,.,.]) :- !.	   % H
morse(i, [.,.]) :- !.	   % I
morse(j, [.,-,-,-]) :- !.	   % J
morse(k, [-,.,-]) :- !.	   % K or invitation to transmit
morse(l, [.,-,.,.]) :- !.	   % L
morse(m, [-,-]) :- !.	   % M
morse(n, [-,.]) :- !.	   % N
morse(o, [-,-,-]) :- !.	   % O
morse(p, [.,-,-,.]) :- !.	   % P
morse(q, [-,-,.,-]) :- !.	   % Q
morse(r, [.,-,.]) :- !.	   % R
morse(s, [.,.,.]) :- !.	   % S
morse(t, [-]) :- !.	 	   % T
morse(u, [.,.,-]) :- !.	   % U
morse(v, [.,.,.,-]) :- !.	   % V
morse(w, [.,-,-]) :- !.	   % W
morse(x, [-,.,.,-]) :- !.	   % X or multiplication sign
morse(y, [-,.,-,-]) :- !.	   % Y
morse(z, [-,-,.,.]) :- !.	   % Z
morse(0, [-,-,-,-,-]) :- !.	   % 0
morse(1, [.,-,-,-,-]) :- !.	   % 1
morse(2, [.,.,-,-,-]) :- !.	   % 2
morse(3, [.,.,.,-,-]) :- !.	   % 3
morse(4, [.,.,.,.,-]) :- !.	   % 4
morse(5, [.,.,.,.,.]) :- !.	   % 5
morse(6, [-,.,.,.,.]) :- !.	   % 6
morse(7, [-,-,.,.,.]) :- !.	   % 7
morse(8, [-,-,-,.,.]) :- !.	   % 8
morse(9, [-,-,-,-,.]) :- !.	   % 9
morse(., [.,-,.,-,.,-]) :- !.   % . (period)
morse(',', [-,-,.,.,-,-]) :- !. % , (comma)
morse(:, [-,-,-,.,.,.]) :- !.   % : (colon or division sign)
morse(?, [.,.,-,-,.,.]) :- !.   % ? (question mark)
morse('''',[.,-,-,-,-,.]) :- !. % ' (apostrophe)
morse(-, [-,.,.,.,.,-]) :- !.   % - (hyphen or dash or subtraction sign)
morse(/, [-,.,.,-,.]) :- !.     % / (fraction bar or division sign)
morse('(', [-,.,-,-,.]) :- !.   % ( (left-hand bracket or parenthesis)
morse(')', [-,.,-,-,.,-]) :- !. % ) (right-hand bracket or parenthesis)
morse('"', [.,-,.,.,-,.]) :- !. % " (inverted commas or quotation marks)
morse(=, [-,.,.,.,-]) :- !.     % = (double hyphen)
morse(+, [.,-,.,-,.]) :- !.     % + (cross or addition sign)
morse(@, [.,-,-,.,-,.]) :- !.   % @ (commercial at)

% Error.
morse(error, [.,.,.,.,.,.,.,.]) :- !. % error - see below

% Prosigns.
morse(as, [.,-,.,.,.]) :- !.          % AS (wait A Second)
morse(ct, [-,.,-,.,-]) :- !.          % CT (starting signal, Copy This)
morse(sk, [.,.,.,-,.,-]) :- !.        % SK (end of work, Silent Key)
morse(sn, [.,.,.,-,.]) :- !.          % SN (understood, Sho' 'Nuff)

