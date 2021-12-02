part1:-
    read_input(Ls),
    move(Ls, -(0, 0)),
    halt.

move([end_of_file], -(X, Y)):-
    Res is X * Y,
    write(Res).
move([H|T], -(X, Y)):-
    split_string(H, " ", "", [Dir, DistanceStr]),
    number_codes(Dist, DistanceStr),
    move_sub(Dir, Dist, -(X, Y), -(NewX, NewY)),
    move(T, -(NewX, NewY)).

move_sub("forward", Dist, -(X, Y), -(NewX, NewY)):-
    NewX is X + Dist, NewY is Y.
move_sub("down", Dist, -(X, Y), -(NewX, NewY)):-
    NewY is Y + Dist, NewX is X.
move_sub("up", Dist, -(X, Y), -(NewX, NewY)):-
    NewY is Y - Dist, NewX is X.

%% part2

part2:-
    read_input(Ls),
    move2(Ls, [0, 0, 0]),
    halt.

move2([end_of_file], [X, Y, _Aim]):-
    Res is X * Y,
    write(Res).
move2([H|T], [X, Y, Aim]):-
    split_string(H, " ", "", [Dir, DistanceStr]),
    number_codes(Dist, DistanceStr),
    move_sub2(Dir, Dist, [X, Y, Aim], [NewX, NewY, NewAim]),
    move2(T, [NewX, NewY, NewAim]).

move_sub2("forward", Dist, [X, Y, Aim], [NewX, NewY, NewAim]):-
    NewX is X + Dist, NewY is Y + Aim * Dist, NewAim is Aim.
move_sub2("down", Dist, [X, Y, Aim], [NewX, NewY, NewAim]):-
    NewY is Y, NewX is X, NewAim is Aim + Dist.
move_sub2("up", Dist, [X, Y, Aim], [NewX, NewY, NewAim]):-
    NewY is Y, NewX is X, NewAim is Aim - Dist.

%% read input

read_input(Input):-
    open("day2.txt", read, Stream),
    read_input(Stream, [], [], Input),
    close(Stream).

read_input(_, Input, end_of_file, Input).

read_input(Stream, Lines, _, Input):-
    read_line_to_string(Stream,Line1),
    append(Lines, [Line1], Lines1),
    read_input(Stream, Lines1, Line1, Input).