
part1:-
    read_input(Ls),
    count(Ls),
    halt.

count(Ls):-count(Ls, 9999, 0).

count([end_of_file], _, N):-write(N).
count([H|T], Prev, Sum):-
    number_codes(Num, H),
    Num > Prev,
    NewSum is Sum + 1,
    count(T, Num, NewSum).
count([H|T], Prev, Sum):-
    number_codes(Num, H),
    count(T, Num, Sum).

%% part 2
part2:-
    read_input(Ls),
    part2(Ls),
    halt.

part2(Ls):- part2(Ls, 99999999, 0).

part2([V1, V2, end_of_file], _, N):-write(N).

part2([V1, V2, V3|T], Prev, Sum):-
    number_codes(N1, V1), number_codes(N2, V2), number_codes(N3, V3),
    Total is N1 + N2 + N3,
    Total > Prev,
    NewSum is Sum + 1,
    part2([V2, V3|T], Total, NewSum).
part2([V1, V2, V3|T], Prev, Sum):-
    number_codes(N1, V1), number_codes(N2, V2), number_codes(N3, V3),
    Total is N1 + N2 + N3,
    part2([V2, V3|T], Total, Sum).    

%% read input

read_input(Input):-
    open("day1.txt", read, Stream),
    read_input(Stream, [], [], Input),
    close(Stream).

read_input(_, Input, end_of_file, Input).

read_input(Stream, Lines, _, Input):-
    read_line_to_string(Stream,Line1),
    append(Lines, [Line1], Lines1),
    read_input(Stream, Lines1, Line1, Input).
