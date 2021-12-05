process:-
    read_input(Lines),
    foldl(mark_line, Lines, pair([], 0), pair(Marked, NumOfOverlaps)),
    write(NumOfOverlaps),
    halt.

mark_line(Line, pair(MarkedAcc, AccNum), pair(MarkedCoorsLine, NewNumOfOverlaps)):-
    coordinates_line(Coordinates, Line),
    marked_coors(MarkedAcc, Coordinates, MarkedCoorsLine, NumOfOverlaps),
    NewNumOfOverlaps is AccNum + NumOfOverlaps.

coordinates_line(Coordinates, pair(pair(X1, Y1), pair(X2, Y2))):-
    valid_line(pair(X1, Y1), pair(X2, Y2)),
    findall(Coordinate, is_between(pair(X1, Y1), pair(X2, Y2), Coordinate), Coordinates);
    Coordinates = [].

valid_line(pair(X1, Y1), pair(X2, Y2)):-
    X1 =:= X2; Y1 =:= Y2.

is_between(pair(X, Y1), pair(X, Y2), pair(X, Y)):-
    num_between(Y1, Y2, Y).
is_between(pair(X1, Y), pair(X2, Y), pair(X, Y)):-
    num_between(X1, X2, X).
num_between(X1, X2, X):-
    write(X1), nl, write(X2), nl, write(X), nl,
    number(X1), number(X2),
    MinX is min(X1, X2), MaxX is max(X1, X2),
    between(MinX, MaxX, X).

marked_coors(MarkedCoors, Coordinates, NewMarkedCoors, NumOfOverlaps):-
    exclude(overlaps(MarkedCoors), Coordinates, NotMarked),
    append(MarkedCoors, NotMarked, NewMarkedCoors),
    length(Coordinates, L),
    length(NotMarked, UnmakredL),
    NumOfOverlaps is L - UnmakredL.

overlaps(MarkedCoors, Coordinate):-
    member(Coordinate, MarkedCoors).

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