process:-
    read_input(Lines),
    foldl(mark_line, Lines, pair([], []), pair(Marked, Overlaps)),
    length(Overlaps, NumOfOverlaps),
    write(NumOfOverlaps),
    halt.

mark_line(Line, pair(MarkedAcc, OverlapAcc), pair(MarkedCoorsLine, Overlaps)):-
    coordinates_line(Coordinates, Line),
    marked_coors(MarkedAcc, Coordinates, MarkedCoorsLine, NewOverlaps),
    union(OverlapAcc, NewOverlaps, Overlaps).

coordinates_line(Coordinates, pair(pair(X1, Y1), pair(X2, Y2))):-
    valid_line(pair(X1, Y1), pair(X2, Y2)),
    findall(Coordinate, is_between(pair(X1, Y1), pair(X2, Y2), Coordinate), Coordinates);
    diagonal_coors(pair(X1, Y1), pair(X2, Y2), [], Coordinates).

diagonal_coors(P, P, Acc, Coordinates):-
    Coordinates = [P|Acc].
diagonal_coors(pair(X1, Y1), pair(X2, Y2), Acc, Coordinates):-
    next_coor(Coordinate, pair(X1, Y1), pair(X2, Y2)),
    diagonal_coors(Coordinate, pair(X2, Y2), [pair(X1, Y1)|Acc], Coordinates).

next_coor(pair(X, Y), pair(X1, Y1), pair(X2, Y2)):-
    next_value(X, X1, X2),
    next_value(Y, Y1, Y2).

next_value(V, V1, V2):-
    V1 < V2, V is V1 + 1;
    V is V1 - 1.

valid_line(pair(X1, Y1), pair(X2, Y2)):-
    X1 =:= X2; Y1 =:= Y2.

is_between(pair(X, Y1), pair(X, Y2), pair(X, Y)):-
    num_between(Y1, Y2, Y).
is_between(pair(X1, Y), pair(X2, Y), pair(X, Y)):-
    num_between(X1, X2, X).
num_between(X1, X2, X):-
    number(X1), number(X2),
    MinX is min(X1, X2), MaxX is max(X1, X2),
    between(MinX, MaxX, X).

marked_coors(MarkedCoors, Coordinates, NewMarkedCoors, Overlaps):-
    union(Coordinates, MarkedCoors, NewMarkedCoors),
    intersection(Coordinates, MarkedCoors, Overlaps).

%% struct

pair(X, Y).

%% read input

read_input(Lines):-
    open("day5.txt", read, Stream),
    read_input(Stream, [], [], RawInput),
    lines(RawInput, Lines),
    close(Stream).

lines(RawInput, Lines):-lines(RawInput, [], Lines).

lines([end_of_file], Lines, Lines).
lines([Str|T], Acc, L):-
    split_string(Str, "->", " ", [EndStr1, _, EndStr2]),
    string_pair_coordinate(EndStr1, Coordinates1),
    string_pair_coordinate(EndStr2, Coordinates2),
    lines(T, [pair(Coordinates1, Coordinates2)|Acc], L).

string_pair_coordinate(Str, pair(Coor1, Coor2)):-
    split_string(Str, ",", "", [CoorStr1, CoorStr2]),
    number_codes(Coor1, CoorStr1),
    number_codes(Coor2, CoorStr2).

read_input(_, Input, end_of_file, Input).

read_input(Stream, Lines, _, Input):-
    read_line_to_string(Stream,Line1),
    append(Lines, [Line1], Lines1),
    read_input(Stream, Lines1, Line1, Input).