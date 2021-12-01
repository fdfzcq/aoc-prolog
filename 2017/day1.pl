%day1.pl

checksum(N):-
    atom_codes(N, [H|Tail]),
    checksum(Tail, H, H, 0).

checksum([], V, V, Sum):-
    nl,
    S is Sum + V - 48,
    write(S).
checksum([], V1, V2, Sum):-
    nl,
    write(Sum).
checksum([H|Tail], H, First, Sum):-
    S is Sum + H - 48,
    checksum(Tail, H, First, S).
checksum([V|Tail], H, First, Sum):-
    checksum(Tail, V, First, Sum).

% part2
checksum2(N):-
    atom_codes(N, List),
    length(List, Length),
    Loop is Length / 2,
    checksum2(List, 0, Loop, Length, 0).

checksum2(List, L, CheckIndex, L, Sum):-
    nl,
    write(Sum).
checksum2(List, Index, CheckIndex, Length, Sum):-
    Index < Length,
    CheckIndex < Length,
    nth0(Index, List, V1),
    nth0(CheckIndex, List, V2),
    maybe_sum(V1, V2, Sum, NewSum),
    NewIndex is Index + 1,
    NewCheckIndex is CheckIndex + 1,
    checksum2(List, NewIndex, NewCheckIndex, Length, NewSum).
checksum2(List, Index, LongCheckIndex, Length, Sum):-
    Index < Length,
    CheckIndex is LongCheckIndex - Length,
    checksum2(List, Index, CheckIndex, Length, Sum).

maybe_sum(V, V, Sum, S):-
    S is Sum + V - 48.
maybe_sum(V1, V2, Sum, S):-
    S is Sum.

main(Number):-
    checksum2(Number),
    nl,
    halt.