vaccine(File, Answers) :-
    read_input(File, L),
    !,
    solveAll(L, Answers).


read_input(File, Inplist) :-
    open(File, read, Stream),
    read_number(Stream, N),
    read_lines(Stream, Inplist, N),
    close(Stream).


read_number(Stream, N) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atom_number(Atom, N).
    
read_str(Stream, Str) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atom_string(Atom, Str).


read_lines(_, [], 0).
read_lines(Stream, [Inp | Rest], N) :-
    N > 0,
    NewN is N - 1,
    read_str(Stream, Inp),
    read_lines(Stream, Rest, NewN).
    

solveAll([] , []).
solveAll([Inp | Rest], [Answer | Answers]) :-
    solve(Inp, Answer),
    solveAll(Rest, Answers).


solve(Inpstring, Movatom) :-
    string_chars(Inpstring, Inp),
    reverse(Inp, Rna),
    length(Rna, M),
    complement(Rna, Comp),
    !,
    length(Moves, N),
    N >= M,
    N =< 3 * M,
    nth0(0, Rna, R),
    solution(Rna, Comp, 1, 'N', R, n, [], Moves),
    string_chars(Movstring, Moves),
    atom_string(Movatom, Movstring),
    !.


complement([], []).
complement(['A' | X], ['U' | Y]) :-
    complement(X, Y).
complement(['U' | X], ['A' | Y]) :-
    complement(X, Y).
complement(['C' | X], ['G' | Y]) :-
    complement(X, Y).
complement(['G' | X], ['C' | Y]) :-
    complement(X, Y).


pvalid(Ch, Gr, Ch, Gr).
pvalid(Ch, Gr, _, [Ch | Gr]) :-
    \+ member(Ch, Gr).

compFlag(1, 0).
compFlag(0, 1).

solution([], _, _, _, _, _, _, _).

solution(Rna, Comp, Flag, Top, Bot, p, Gr, [c | Moves]) :-
    compFlag(Flag, NewFlag),
    solution(Rna, Comp, NewFlag, Top, Bot, c, Gr, Moves).

solution([R | Na], [_ | Omp], 1, Top, Bot, _, Gr, [p | Moves]) :-
    pvalid(R, Gr, Top, NewGr),
    solution(Na, Omp, 1, R, Bot, p, NewGr, Moves).

solution([_ | Na], [C | Omp], 0, Top, Bot, _, Gr, [p | Moves]) :-
    pvalid(C, Gr, Top, NewGr),
    solution(Na, Omp, 0, C, Bot, p, NewGr, Moves).

solution(Rna, Comp, Flag, Top, Bot, c, Gr, [r | Moves]) :-
    solution(Rna, Comp, Flag, Bot, Top, r, Gr, Moves).

solution(Rna, Comp, Flag, Top, Bot, p, Gr, [r | Moves]) :-
    solution(Rna, Comp, Flag, Bot, Top, r, Gr, Moves).
