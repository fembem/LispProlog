
%the text's solution
%plan(State, Goal, _, Moves) :- 	equal_set(State, Goal), 
%				write('moves are'), nl,
%				reverse_print_stack(Moves).
%plan(State, Goal, Been_list, Moves) :- 	
%				move(Name, Preconditions, Actions),
%				conditions_met(Preconditions, State),
%				change_state(State, Actions, Child_state),
%				not(member_state(Child_state, Been_list)),
%				stack(Child_state, Been_list, New_been_list),
%				stack(Name, Moves, New_moves),
%			plan(Child_state, Goal, New_been_list, New_moves),!.

:- [planner].

me_plan(Start, Goal, _, Plan, Start) :- 	
	equal_set(Start, Goal), 
	write('plan is'), nl,
	reverse_print_stack(Plan).

me_plan(Start, Goal, Been_list, [Name|Plan], End_state) :-
    set_diff(Goal, Start, Diff_set),
    member(Diff, Diff_set),				%just find first predicate we are missing
    move(Name, Preconditions, Actions),
    member(add(Diff), Actions), 		%more than one postcondition matching doesn't help
    subset(Preconditions, Start),
    change_state(Start, Actions, Child_state),
    not(member_state(Child_state, Been_list)),
    stack(Child_state, Been_list, New_been_list),
    me_plan(Child_state, Goal, New_been_list, Plan, End_state),!.	%just find first plan


% plan(Start,     % the start state
%      Goal,	  % the goal state
%      Been_list, % a list of visited states to avoid infinite loops
%      Plan,      % the resulting plan, a series of moves
%      End_state  % the final state after executing the Plan

/* sample moves */
move(pickup2(X), [handempty, ontable(X), clear(X)],
		 [del(handempty), del(clear(X)), del(ontable(X)), add(holding(X))]).

move(pickup(X), [handempty, on(X, Y), clear(X)],
		[del(handempty), del(clear(X)), del(on(X, Y)), add(clear(Y)), add(holding(X))]).

move(putdown(X), [holding(X)],
		 [del(holding(X)), add(on(X, table)), add(clear(X)), add(handempty)]).

move(stack(X, Y), [holding(X), clear(Y)],
		  [del(holding(X)), del(clear(Y)), add(handempty), add(on(X, Y)), add(clear(X))]).

go(S, G, P) :- me_plan(S, G, [S], P, _).
test0(P) :-
	go([holding(a), ontable(c), on(b, c), clear(b)],
	   [on(a,b), on(b, c)], P).
test1(P) :-
	go([handempty, ontable(a), ontable(c), on(b, c), clear(a), clear(b)],
	   [on(a,b), on(b, c)], P).
test2(P) :-
	go([handempty, ontable(b), ontable(c), on(a, b), clear(c), clear(a)],
	   [handempty, ontable(c), on(a,b), on(b, c), clear(a)], P).
test3(P) :-
	go([handempty, ontable(a), ontable(b), on(c, a), clear(b), clear(c)],
	   [on(a, b), on(b, c)], P).


	   