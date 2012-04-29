%noun(mary, [man(mary)]).
%noun(john, [man(john)]).

%test1(Meaning) :- utterance([mary, sold, john, a, car], Meaning).
%test2(Meaning) :- utterance([john, sold, mary, a, car], Meaning).
%test3(Meaning) :- utterance([john, sold, mary, a, computer], Meaning).
%test4(Meaning) :- utterance([mary, sold, john, a, computer], Meaning).
%test5(Meaning) :- utterance([mary, bought, a, car, from, john], Meaning).
%test5(Meaning) :- utterance([mary, bought, a, computer, from, john], Meaning).
%test6(Meaning) :- utterance([john , bought, a, car, from, mary], Meaning).
%test6(Meaning) :- utterance([john , bought, a, computer, from, mary], Meaning).

