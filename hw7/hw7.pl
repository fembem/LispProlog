%Leo deCandia
%ICS 361
%Assignment 7

%import useful predicates like set_diff and change_state
:- [planner].

%this is the base case, the goal predicates are satisfied at the current state 
%so return an empty list as the plan, ie a null plan
me_plan(Start, Goal, _, [], Start) :- 	%when we reach the goal the final end state will be our present 'start'
	subset(Goal, Start), !, %only look for the first solution
	write('Goal '), print_stack(Goal), 
    write('a subset of Start '), print_stack(Start), nl.

%this is the case where we pick a move to achieve a predicate in the goal
%but not satisfied in the current state, and we have the preconditions to take that move
me_plan(Start, Goal, Been_list, [Name|Plan], End_state) :-
    write('plan from '), print_stack(Start), 
    write(' to '), print_stack(Goal), nl,
    set_diff(Goal, Start, Diff_set),
    write('Diff_set = '), print_stack(Diff_set), nl,
    member(Diff, Diff_set),				%just find first predicate we are missing
    %write('Diff = '), write(Diff), nl,
    move(Name, Preconditions, Actions),
    member(add(Diff), Actions), 		%more than one postcondition matching doesn't help
    write(add(Diff)), write(' in actions'), nl,
    subset(Preconditions, Start),
    %write('Preconditions < Start'), nl,
    write('Satisfying move = '), write(Name), nl,
    change_state(Start, Actions, Child_state),
    write('Child_state = '), print_stack(Child_state), nl,
    not(member_state(Child_state, Been_list)),
    write('Child_state not in been list'), nl, 
    stack(Child_state, Been_list, New_been_list),
    me_plan(Child_state, Goal, New_been_list, Plan, End_state),!.	%just find first plan

%this is the case where we pick a move to achieve a predicate in the goal
%but not satisfied in the current state, and we lack at least one precondition to take that move
%in this case plan from the current state to the preconditions of that move
%then plan from the resulting state to the current goal, 
%then append the first plan with the second plan, with the original move in between.
me_plan(Start, Goal, Been_list, Plan, End_state) :-
    %write('2--plan from ['), print_stack(Start), 
    %write('] to ['), print_stack(Goal), write(']'), nl,
    set_diff(Goal, Start, Diff_set),
    %write('2--Diff_set = '), print_stack(Diff_set), nl,
    member(Diff, Diff_set),				%just find first predicate we are missing
    %write('2--Diff = '), write(Diff), nl,
    move(Name, Preconditions, Actions),
    member(add(Diff), Actions), 		%more than one postcondition matching doesn't help
    %assume subset(Preconditions, Start) is false
    not(subset(Preconditions, Start)),
    write('2--preconditions '), print_stack(Preconditions), 
    write(' not a subset of start '), print_stack(Start), nl,
    me_plan(Start, Preconditions, Been_list, Sub_plan, Sub_end_state),!,	%just find first plan
    %write('2--Diff_set = '), print_stack(Diff_set), nl,
    write('2--Sub_plan = '), print_stack(Sub_plan), nl,
    write('2--Sub_end_state = '), print_stack(Sub_end_state), nl,
    change_state(Sub_end_state, Actions, Child_state),
    write('2--Child_state = '), print_stack(Child_state), nl,
    stack(Child_state, Been_list, New_been_list),
    append(Sub_plan, [Name], Pre_moves),
    write('2--Pre_moves = '), print_stack(Pre_moves), nl,
    me_plan(Child_state, Goal, New_been_list, Post_moves, End_state),!,	%just find first plan
    write('2--Post_moves = '), print_stack(Post_moves), nl,
    append(Pre_moves, Post_moves, Plan),
    write('2--append '), print_stack(Pre_moves), 
    write(' and '), print_stack(Post_moves), nl.

%print a list as [1, 2, 3, 4], i.e comma delimited and surrounded by brackets
print_stack(S) :- write('['), print_stack_rec(S), write(']').
print_stack_rec(S) :- 	empty_stack(S).
print_stack_rec(S) :- 	stack(E, [R|Rest], S), !,	%print a non-final element
		 		write(E), write(', '),
		 		print_stack_rec([R|Rest]).
print_stack_rec(S) :- 	stack(E, [], S), 	%print a final element
		 		write(E).


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

test4(P) :-
	go([ontable(c), on(b, c), on(a,b), clear(a)],
	   [on(a,b), on(b, c)], P).

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

:- set_prolog_flag(toplevel_print_options,[max_depth(0)]).

:- noprotocol.
:- protocol('C:\\Users\\Leo\\ICS361\\LispProlog\\hw7\\leo_hw7_log.txt').
:- write('----------------- test0 ----------------------'), nl .
:- test0(P), write('-------->plan is : '), print_stack(P), nl, nl .
:- write('----------------- test1 ----------------------'), nl.
:- test1(P), write('-------->plan is : '), print_stack(P), nl, nl .
:- write('----------------- test2 ----------------------'), nl.
:- test2(P), write('-------->plan is : '), print_stack(P), nl, nl .
:- write('----------------- test3 ----------------------'), nl.
:- test3(P), write('-------->plan is : '), print_stack(P), nl .
:- noprotocol.


