%Leo deCandia
%ICS 361
%Assignment 6

% constrain(Tasks,       % list of tasks to assign
%			 %   Each task is of the form:
%			 %   [Task_name, Task_class, Task_time]
%	    Workers,	 % list of people, time left and skills
%			 %   Each list element is a list in the form:
%			 %   [Person_name,
%                        %    Time_left,
%                        %    [Task_class1, Task_class2, ...]]
%	    Assignments) % list of assignments
%			 %   Each element is of the form:
%			 %   [Task_name, Person_name]
% Tasks must be done by exactly one person who has
% both the skill to do it and time available to do it.
%
% Example use:
%

%utility functions for printing nested arrays 2 level deep
printAssignments(Assignments) :- write('{'), printAssignmentsRec(Assignments).
printAssignmentsRec([Assignment | []]) :- write(Assignment), write('}').
printAssignmentsRec([Assignment | OtherAssignments]) :- write(Assignment), write(','), 
														printAssignmentsRec(OtherAssignments).


%assign the first task to the first person in the people list
assign_first_task([Task_name, Task_class, Task_time], 						%the first task
			[ [Person_name, Time_left, Person_skills] | Other_people ], 	%the people
			Assignments,													%the present assignments
			New_people,											    		%the new assignments
			New_assignments) :-												%the 'new' people list
																			%the first person has less time left
    			%write('consider assigning '), write(Task_name), write(' to '), write(Person_name), nl,
    			member(Task_class, Person_skills), 
    			Task_time =< Time_left,
    			%write('assigned '), write(Task_name), write(' to '), write(Person_name), nl,
    			New_time_left is Time_left - Task_time,
    			%same partial people list as before but first person on the list has less time left
    			New_person = [Person_name, New_time_left, Person_skills],
    			New_people = [ New_person | Other_people ],
    			New_assignments = [ [Task_name, Person_name] | Assignments ].
    			%write('New_people '), write(New_people), nl.
    			%write('Assignments '), printAssignments(Assignments), nl,
    			%write('New_assignments '), printAssignments(New_assignments), nl.

%assign the first task to someone other than the first person in the people list
assign_first_task(Task, [Unsuitable_Person|Other_people], Assignments, New_people, New_assignments) :-
    assign_first_task(Task, Other_people, Assignments, New_people_2, New_assignments_2),
    New_people = [Unsuitable_Person | New_people_2],
    New_assignments = New_assignments_2.
    			

%when there are no tasks left to assign, there are no futher assignments that need to be made
constrain([], People, Assignments) :- write('success!! '), nl,
						write('Final people: '), write(People), nl,
						write('Final assignments: '), printAssignments(Assignments), nl.
%we can find a satisfying assignment if we can assign the first task, and then find
%a satisfying assignment for the other tasks to the people, of which the one assigned to the first task
%has his/her time available decreased by the time the first task took
constrain([ Task | Other_tasks], People, Assignments ) :-
    			assign_first_task(Task, People, Assignments, New_people, New_assignments),
    			constrain(Other_tasks, New_people, New_assignments ).
			
test1(Result) :-
  constrain([[t1,a,5],[t2,b,10],[t3,c,15],[t4,c,10],[t5,a,15],[t6,b,10]],
            [[p1,20,[a,c]],[p2,10,[a,b]],[p3,15,[b]],[p4,30,[c]]],
	    Result).
test2(Result) :-
  constrain([[frame, woodworking, 200], [pour, concrete, 25], [wall, woodworking, 100]],
            [[mary, 300,[woodworking, concrete]], [john, 50, [concrete]]],
	    Result).


