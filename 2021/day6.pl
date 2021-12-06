latern_fish(F, Days, 0):-
  Days =< F.
latern_fish(F, Days, N):-
  RemDays is Days - F - 1,
  NewFish is RemDays div 7 + 1,
  all_latern_fish(RemDays, 0, RemN),
  N is NewFish + RemN,
  !.

all_latern_fish(Days, Acc, Acc):-
  Days < 0.
all_latern_fish(Days, Acc, N):-
  latern_fish(8, Days, NewN),
  NewAcc is NewN + Acc,
  NewDays is Days - 7,
  all_latern_fish(NewDays, NewAcc, N),
  !.

latern_fish_list(Days, N):-
  Ls = [3,4,3,1,2],
  %Ls = [5,1,2,1,5,3,1,1,1,1,1,2,5,4,1,1,1,1,2,1,2,1,1,1,1,1,2,1,5,1,1,1,3,1,1,1,3,1,1,3,1,1,4,3,1,1,4,1,1,1,1,2,1,1,1,5,1,1,5,1,1,1,4,4,2,5,1,1,5,1,1,2,2,1,2,1,1,5,3,1,2,1,1,3,1,4,3,3,1,1,3,1,5,1,1,3,1,1,4,4,1,1,1,5,1,1,1,4,4,1,3,1,4,1,1,4,5,1,1,1,4,3,1,4,1,1,4,4,3,5,1,2,2,1,2,2,1,1,1,2,1,1,1,4,1,1,3,1,1,2,1,4,1,1,1,1,1,1,1,1,2,2,1,1,5,5,1,1,1,5,1,1,1,1,5,1,3,2,1,1,5,2,3,1,2,2,2,5,1,1,3,1,1,1,5,1,4,1,1,1,3,2,1,3,3,1,3,1,1,1,1,1,1,1,2,3,1,5,1,4,1,3,5,1,1,1,2,2,1,1,1,1,5,4,1,1,3,1,2,4,2,1,1,3,5,1,1,1,3,1,1,1,5,1,1,1,1,1,3,1,1,1,4,1,1,1,1,2,2,1,1,1,1,5,3,1,2,3,4,1,1,5,1,2,4,2,1,1,1,2,1,1,1,1,1,1,1,4,1,5],
  length(Ls, L),
  latern_fish_list(Ls, Days, L, N).

latern_fish_list([], _, N, N).
latern_fish_list([H|T], Days, Acc, N):-
  latern_fish(H, Days, Num),
  NewAcc is Acc + Num,
  latern_fish_list(T, Days, NewAcc, N),
  !.
