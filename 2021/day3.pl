part1:-
  read_input(Ls),
  calculate_gamma_epsilon(Ls),
  halt.

calculate_gamma_epsilon([H|T]):-
  atom_codes(H, Ls),
  maplist(number_code(), Ls, NumList),
  calculate_gamma_epsilon(T, NumList, 1).
  
calculate_gamma_epsilon([end_of_file], NumList, N):-
write(NumList), nl,
  result(NumList, N).
calculate_gamma_epsilon([H|T], NumList1, N):-
  atom_codes(H, Ls),
  maplist(number_code(), Ls, NumList2),
  NewN is N + 1,
  maplist(sum, NumList1, NumList2, NumList),
  calculate_gamma_epsilon(T, NumList, NewN).

sum(X, Y, Z):- Z is X + Y.

result(NumList, L):-
  N is L / 2,
  result(NumList, N, [], []).

result([], N, RevGamma, RevEpsilon):-
  reverse(RevGamma, Gamma), reverse(RevEpsilon, Epsilon),
  binary_number(Gamma, GNum), binary_number(Epsilon, ENum),
  write(Gamma), nl, write(Epsilon), nl,
  Res is GNum * ENum,
  write(Res).
result([H|T], N, Tail1, Tail2):-
  H > N,
  result(T, N, [1|Tail1], [0|Tail2]).
result([_|T], N, Tail1, Tail2):-
  result(T, N, [0|Tail1], [1|Tail2]).

%% part 2

part2:-
  read_input(Ls),
  oxygen_generator_rating(Ls, OxygenL),
  scrubber_rating(Ls, ScrubberL),
  binary_number(OxygenL, Oxygen),
  binary_number(ScrubberL, Scrubber),
  Res is Oxygen * Scrubber,
  write(Res),
  halt.

oxygen_generator_rating(Ls, Oxygen):-
  oxygen_generator_rating(Ls, 0, [], Oxygen).

oxygen_generator_rating(Ls0, I, Acc, O):-
  I < 12,
  include(valid, Ls0, Ls),
  input_rating(Ls, I, Rating, oxygen),
  include(valid(Rating, I), Ls, Filtered),
  NewI is I + 1,
  oxygen_generator_rating(Filtered, NewI, [Rating|Acc], O).
oxygen_generator_rating(_, _, RevOxygen, Oxygen):-
  reverse(RevOxygen, Oxygen).

scrubber_rating(Ls, Oxygen):-
  scrubber_rating(Ls, 0, [], Oxygen).

scrubber_rating(Ls0, I, Acc, O):-
  I < 12,
  include(valid, Ls0, Ls),
  input_rating(Ls, I, Rating, scrubber),
  include(valid(Rating, I), Ls, Filtered),
  NewI is I + 1,
  scrubber_rating(Filtered, NewI, [Rating|Acc], O).
scrubber_rating(_, _, RevOxygen, Oxygen):-
  reverse(RevOxygen, Oxygen).

input_rating([Str], I, Rating, _Type):-
  atom_codes(Str, CharList),
  maplist(number_code, CharList, NumList),
  nth0(I, NumList, Rating).
input_rating(Ls, I, Rating, Type):-
  length(Ls, Length),
  Length > 1,
  Check is Length / 2,
  maplist(atom_codes, Ls, ListOfList),
  maplist(nth0(I), ListOfList, CharList),
  maplist(number_code, CharList, NumList),
  list_sum(NumList, 0, Sum),
  rating(Sum, Check, Rating, Type),
  !.

%% utils

number_code(C, N) :- N is C - 48.

binary_number(Bin, N):-
    binary_number(Bin, 0, N).

binary_number([], N, N).
binary_number([Bit|Bits], Acc, N):-
    Acc1 is Acc*2 + Bit,
    binary_number(Bits, Acc1, N).

rating(S, C, R, oxygen):-
  S > C, R is 1.
rating(S, C, R, _):-
  S > C, R is 0.
rating(S, C, R, oxygen):-
  S < C, R is 0.
rating(S, C, R, _):-
  S < C, R is 1.
rating(_, _, R, oxygen):-
  R is 1.
rating(_, _, R, _):-
  R is 0.

valid(Rating, I, Str):-
  atom_codes(Str, CharList),
  maplist(number_code, CharList, NumList),
  nth0(I, NumList, Value),
  Rating =:= Value.

valid(V):-
  V \= end_of_file, !.

list_sum([], Sum, Sum).
list_sum([H|T], Acc, S):-
  NewAcc is H + Acc,
  list_sum(T, NewAcc, S).

%% read input

read_input(Input):-
    open("day3.txt", read, Stream),
    read_input(Stream, [], [], Input),
    close(Stream).

read_input(_, Input, end_of_file, Input).

read_input(Stream, Lines, _, Input):-
    read_line_to_string(Stream,Line1),
    append(Lines, [Line1], Lines1),
    read_input(Stream, Lines1, Line1, Input).