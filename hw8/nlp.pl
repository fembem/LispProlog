utterance(X, Sentence_graph) :-
    sentence(X, [ ], Sentence_graph).
sentence(Start, End , Sentence_graph) :-
    nounphrase(Start, Rest, Subject_graph),
    verbphrase(Rest, End, Predicate_graph),
    join([agent(Subject_graph)], Predicate_graph,
         Sentence_graph).
nounphrase([Noun | End], End, Noun_phrase_graph) :-
    noun(Noun, Noun_phrase_graph).
nounphrase([Article, Noun | End], End,
		   Noun_phrase_graph) :-
    article(Article),
    noun(Noun, Noun_phrase_graph).
verbphrase([Verb | End], End, Verb_phrase_graph) :-
    verb(Verb, Verb_phrase_graph).
verbphrase([Verb | Rest], End, Verb_phrase_graph) :-
    verb(Verb, Verb_graph),
    write('Verb_graph: '), write(Verb_graph), nl,
    nounphrase(Rest, End, Noun_phrase_graph),
    write('Noun_phrase_graph: '), write(Noun_phrase_graph), nl,
    join([object(Noun_phrase_graph)], Verb_graph,
         Verb_phrase_graph),
    write('Verb_phrase_graph: '), write(Verb_phrase_graph), nl, !. %only pare the sentence one way

%extra verbphrase rule  
verbphrase([Verb | Rest], End, Verb_phrase_graph) :-
    write('in new rule'), nl,
    verb(Verb, Verb_graph),
    write('Verb_graph: '), write(Verb_graph), nl,
    nounphrase(Rest, End1, Noun_phrase_graph_rec),
    write('recipient Noun_phrase_graph: '), write(Noun_phrase_graph_rec), nl,
    nounphrase(End1, End, Noun_phrase_graph_obj),
    write('object Noun_phrase_graph: '), write(Noun_phrase_graph_obj), nl,
    join([object(Noun_phrase_graph_rec)], Verb_graph,
         Verb_phrase_graph),
    join(Verb_phrase_graph1, Noun_phrase_graph_obj,
         Verb_phrase_graph).
         
join(X, X, X).
join(A, B, C) :-
    isframe(A), isframe(B), !,
    join_frames(A, B, C, not_joined).
join(A, B, C) :-
    isframe(A), is_slot(B), !,
    join_slot_to_frame(B, A, C).
join(A, B, C) :-
    isframe(B), is_slot(A), !,
    join_slot_to_frame(A, B, C).
join(A, B, C) :-
    is_slot(A), is_slot(B), !,
    join_slots(A, B, C).
join_frames([A | B], C, D, OK) :-
    join_slot_to_frame(A, C, E), !,
    join_frames(B, E, D, OK).
join_frames([A | B], C, [A |D], OK) :-
    join_frames(B, C, D, OK), !.
join_frames([], A, A, OK).
join_slot_to_frame(A, [B | C], [D | C]) :-
    join_slots(A, B, D).
join_slot_to_frame(A, [B | C], [B | D]) :-
    join_slot_to_frame(A, C, D).
join_slots(A, B, D) :-
    functor(A, FA, _), functor(B, FB, _),
    match_with_inheritance(FA, FB, FN),
    arg(1, A, Value_a), arg(1, B, Value_b),
    join(Value_a, Value_b, New_value),
    D =.. [FN | [New_value]].
isframe([_ | _]).
isframe([ ]).
is_slot(A) :- functor(A, _, 1).
match_with_inheritance(X, X, X).
match_with_inheritance(dog, animate, dog).
match_with_inheritance(animate, dog, dog).
match_with_inheritance(man, animate, man).
match_with_inheritance(animate, man, man).
article(a).
article(the).
noun(fido, [dog(fido)]).

%extra nouns for mary and john
noun(mary, [man(mary)]).
noun(john, [man(john)]).
%extra nouns for computer and car
noun(computer).
noun(car).

noun(man, [man(X)]).
noun(dog, [dog(X)]).
verb(likes, [action([liking(X)]),
         agent([animate(X)]), object([animate(Y)])]).
verb(bites, [action([biting(Y)]),
         agent([dog(X)]), object([animate(Z)])]).


%extra rule for sold
verb(sold, [action([selling(X)]),
         agent([animate(X)]), recipient([animate(Z)]), object([Y])]).
%extra rule for bought
verb(bought, [action([buying(X)]),
         agent([animate(X)]), object([Y]), source([animate(Z)])]).

%extra preposition
prep(by).

%%%nlp2.pro
sentence(Start, End , Sentence_graph) :-
    nounphrase(Start, Rest, Subject_graph),
    passiveverbphrase(Rest, End, Predicate_graph),
    join([object(Subject_graph)], Predicate_graph,
         Sentence_graph).
passiveverbphrase([Aux, Verb | End], End, Verb_phrase_graph) :-
    aux(Aux),
    verb_pp(Verb, Verb_phrase_graph).
passiveverbphrase([Aux, Verb | Rest], End, Verb_phrase_graph) :-
    aux(Aux),
    verb_pp(Verb, Verb_graph),
    prepphrase(Rest, End, Prep_phrase_graph),
    join([agent(Prep_phrase_graph)], Verb_graph,
         Verb_phrase_graph).
prepphrase([Prep | Rest], End, Prep_phrase_graph) :-
    prep(Prep),
    nounphrase(Rest, End, Prep_phrase_graph).
aux(is).
aux(was).
verb_pp(bitten, [action([biting(Y)]),
         agent([dog(X)]), object([animate(Z)])]).
prep(by).


test1(Meaning) :- utterance([mary, sold, john, a, car], Meaning).
test2(Meaning) :- utterance([john, sold, mary, a, car], Meaning).
test3(Meaning) :- utterance([john, sold, mary, a, computer], Meaning).
test4(Meaning) :- utterance([mary, sold, john, a, computer], Meaning).
test5(Meaning) :- utterance([mary, bought, a, car, from, john], Meaning).
test5(Meaning) :- utterance([mary, bought, a, computer, from, john], Meaning).
test6(Meaning) :- utterance([john , bought, a, car, from, mary], Meaning).
test6(Meaning) :- utterance([john , bought, a, computer, from, mary], Meaning).

