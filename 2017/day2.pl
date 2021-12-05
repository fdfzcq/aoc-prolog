process:-
    input(Numbers),
    maplist(diff2, Numbers, Diffs),
    sumlist(Diffs, Sum),
    write(Sum),
    halt.

%% part 1

diff1(Nums, Diff):-
    min_list(Nums, Min),
    max_list(Nums, Max),
    Diff is Max - Min.

%% part 2

diff2(Nums, Diff):-
    divisible_pair([X, Y], Nums),
    Diff is X/Y.

divisible_pair([X, Y], Nums):-
    member(X, Nums), member(Y, Nums),
    X > Y,
    R is X rem Y,
    R =:= 0.

%% read input
input(Numbers):-
    read_input(RawInput),
    maplist(str_numbers, RawInput, Numbers).

str_numbers(Str, Nums):-
    split_string(Str, " ", " ", StrL),
    maplist(number_codes, Nums, StrL).

read_input(Input):-
    open("day2.txt", read, Stream),
    read_input(Stream, [], Input),
    close(Stream).

read_input(Stream, Lines, Input):-
    read_line_to_string(Stream,Line1),
    append(Lines, [Line1], Lines1),
    Line1 \= end_of_file,
    read_input(Stream, Lines1, Input);
    Input = Lines.
