colors(F, Answer) :-
    read_input(F, N, K, C),
    solve(Answer, N, K, C),
    !.

powers2(Inp, Answers) :-
    read_input(Inp, L),
    !,
    solvePairs(L, Answers).

solvePairs([], Answers) :-
    Answers = [].
solvePairs([N, K | Y], [Answer | Answers]) :-
    solution(N, K, Answer),
    solvePairs(Y, Answers).


read_input(File, Pairs) :-
    open(File, read, Stream),
    read_line(Stream, T),
    read_pairs(Stream, T, Pairs).

read_pairs(_, T, X) :- T =:= 0, X = [].
read_pairs(Stream, T, Pairs) :-
    read_line(Stream, [N, K]),
    Pairs = ([N, K | X]),
    read_pairs(Stream, T-1, X).

read_input(File, N, K, C) :-
    open(File, read, Stream),
    read_line(Stream, [N, K]),
    read_line(Stream, C).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

countAces([], C) :- C is 0.
countAces([X | Y], C) :-
    countAces(Y, R),
    C is X + R.

convertToBin(0, Bin) :- 
    Bin = [],
    !.
convertToBin(N, Bin) :-
    Temp is N//2,
    convertToBin(Temp, Y),
    X is mod(N,2),
    Bin = [X | Y].


findNextAce(L, 0, P) :-
    findNextAce(L, P),
    !.
findNextAce([_ | Y], N, P) :-
    R is N-1,
    findNextAce(Y, R, P).
findNextAce([1 | _], P) :-
    P = 0,
    !.
findNextAce([_ | Y], P) :-
    findNextAce(Y, R),
    P is R+1.

decrP([X | Y], 0, NewArr) :- 
    NewX is X - 1,
    NewArr = [NewX | Y],
    !.
decrP([X | Y], P, NewArr) :-
    NewP is P - 1,
    decrP(Y, NewP, NewY),
    NewArr = [X | NewY].

incrP2([X | Y], 0, NewArr) :-
    NewX is X + 2,
    NewArr = [NewX | Y],
    !.
incrP2([X | Y], P, NewArr) :-
    NewP is P - 1,
    incrP2(Y, NewP, NewY),
    NewArr = [X | NewY].

convToUnits([X | Y], P, NewArr) :-
    NewX is X + (2 ** P),
    NewP is P - 1,
    decrP(Y, NewP, DecrArr),
    NewArr = [NewX | DecrArr].

splitInTwo(Arr, P, NewArr) :-
    decrP(Arr, P, DecrArr),
    NewP is P - 1,
    incrP2(DecrArr, NewP, NewArr).

doTheThing(Arr, _, K, Answer) :-
    K =< 0,
    Answer = Arr,
    !.
doTheThing(Arr, P, K, Answer) :-
    T is 2**P,
    T - 1 =< K,
    convToUnits(Arr, P, NewArr),
    NewK is K - (T - 1),
    findNextAce(NewArr, P, F),
    NewP is P + F,
    doTheThing(NewArr, NewP, NewK, Answer),
    !.
doTheThing(Arr, P, K, Answer) :-
    T is 2**P,
    T - 1 > K,
    splitInTwo(Arr, P, NewArr),
    NewP is P - 1,
    NewK is K - 1,
    doTheThing(NewArr, NewP, NewK, Answer),
    !.


popLeadingZeros([0 | Y], Res) :-
    popLeadingZeros(Y, Res).
popLeadingZeros(L, Res) :-
    Res = L.

popEndZeros(L, Res) :-
    reverse(L, X),
    popLeadingZeros(X, Y),
    reverse(Y, Res).


solution(1, 1, [1]) :- !.
solution(N, K, Answer) :-
    N < K, Answer = [],
    !.
solution(N, K, Answer) :-
    convertToBin(N, Bin),
    countAces(Bin, C),
    C > K,
    Answer = [],
    !.
solution(N, K, Answer) :-
    convertToBin(N, Bin),
    countAces(Bin, C),
    findNextAce(Bin, 1, P),
    NewP is P + 1,
    NewK is K - C,
    doTheThing(Bin, NewP, NewK, TmpAnswer),
    popEndZeros(TmpAnswer, Answer),
    !.


