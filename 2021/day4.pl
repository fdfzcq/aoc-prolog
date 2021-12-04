%% part1

play:-
    read_input(DrawNumList, Boards),
    play_bingo(DrawNumList, Boards),
    halt.

play_bingo(DrawNumList, Boards):-
    play_bingo(DrawNumList, Boards, []).

play_bingo([], _Boards, _N):-
    write("error, no winners"), halt.
play_bingo([NumStr|Tail], Boards, CheckList):-
    include(wins([NumStr|CheckList]), Boards, Winners),
    subtract(Boards, Winners, NewBoards),
    play_bingo(Tail, NewBoards, [NumStr|CheckList]);
    play_bingo(Tail, Boards, [NumStr|CheckList]).

calc_res(CheckList, Board):-
    [NumStr|_] = CheckList,
    flatten(Board, FlattenBoard),
    maplist(number_codes, NumList, FlattenBoard),
    sum_list(NumList, BoardSum),
    maplist(number_codes, NumCheckList, CheckList),
    intersection(NumCheckList, NumList, Marked),
    sum_list(Marked, MarkedSum),
    ResSum is BoardSum - MarkedSum,
    number_codes(Num, NumStr),
    Res is Num * ResSum,
    write("result:"),nl,
    write(Res), nl,
    !.

wins(DrawNumList, Board):-
    win_by_row(DrawNumList, Board),
    calc_res(DrawNumList, Board);
    win_by_column(DrawNumList, Board),
    calc_res(DrawNumList, Board).

win_by_row(DrawNumList, [R|T]):-
    subset(R, DrawNumList);
    win_by_row(DrawNumList, T).

win_by_column(DrawNumList, Board):-
    win_by_column(DrawNumList, Board, 0).

win_by_column(DrawNumList, Board, N):-
    N < 5,
    maplist(nth0(N), Board, ColToCheck),
    subset(ColToCheck, DrawNumList);
    N < 5,
    NewN is N + 1,
    win_by_column(DrawNumList, Board, NewN).

%% util


%% read input

read_input(DrawNumList, Boards):-
    open("day4.txt", read, Stream),
    read_input(Stream, [], [], RawInput),
    draw_num_list(RawInput, DrawNumList),
    boards(RawInput, Boards),
    close(Stream).

draw_num_list([H|_], DrawNumList):-
    split_string(H, ",", "", DrawNumList).

boards([_|T], Boards):-
    boards(T, [], [], Boards).

boards([end_of_file], BAcc, Acc, B):-
    reverse(B, [BAcc|Acc]).
boards([H|T], BAcc, Acc, B):-
    H == "",
    BAcc \= [],
    boards(T, [], [BAcc|Acc], B);
    H == "",
    boards(T, [], Acc, B).
boards([H|T], BAcc, Acc, B):-
    split_string(H, " ", " ", NumStrList),
    boards(T, [NumStrList|BAcc], Acc, B).

read_input(_, Input, end_of_file, Input).

read_input(Stream, Lines, _, Input):-
    read_line_to_string(Stream,Line1),
    append(Lines, [Line1], Lines1),
    read_input(Stream, Lines1, Line1, Input).