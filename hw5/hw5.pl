% has_biological_child(Parent, Child) specifies that Parent
% is the biological father or mother of Child (versus adopted)
has_biological_child(father, me).
has_biological_child(father, sister).
has_biological_child(father, brother).
has_biological_child(wife, daughter_in_law).
has_biological_child(mother_in_law, wife).
has_biological_child(mother_in_law, brother_in_law).
has_biological_child(mother_in_law, sister_in_law).

% male(Person) specifies that Person is male
male(me).
male(father).
male(brother).
male(brother_in_law).

% female(Person) specifies that Person is female
female(wife).
female(daughter_in_law).
female(sister).           % corrected! was male(sister).
female(sister_in_law).    % corrected! was male(sister_in_law).

% has_spouse(Husband, Wife) specifies that Husband is the
% husband of the wife Wife.  A separate inference rule is
% used to infer has_spouse(Wife, Husband), so these should
% not be entered directly in the database
has_spouse(me, wife).
has_spouse(father, daughter_in_law).
has_spouse(X, Y) :- has_spouse(Y, X).

has_child(X, Y) :- has_biological_child(X, Y).
has_child(X ,Y) :- has_spouse(X, Z), has_biological_child(Z, Y).
has_grandchild(X, Z) :- has_child(X, Y), has_child(Y, Z).
has_son(X, Y) :- has_child(X, Y), male(Y).
has_daughter(X, Y) :- has_child(X, Y), female(Y).
has_grandson(X, Y) :- has_grandchild(X, Y), male(Y).
has_granddaughter(X, Y) :- has_grandchild(X, Y), female(Y).
has_parent(X, Y) :- has_child(Y, X).
has_father(X, Y) :- has_parent(X, Y), male(Y).
has_mother(X, Y) :- has_parent(X, Y), female(Y).
has_grandparent(X, Y) :- has_grandchild(Y, X).
has_grandfather(X, Y) :- has_grandparent(X, Y), male(Y).
has_grandmother(X, Y) :- has_grandparent(X, Y), female(Y).
has_sibling(X, Y) :- has_parent(X, Z), has_parent(Y, Z).
has_sister(X, Y) :- has_sibling(X, Y), female(Y).
has_brother(X, Y) :- has_sibling(X, Y), male(Y).
has_husband(X, Y) :- has_spouse(X, Y), male(Y).
has_wife(X, Y) :- has_spouse(X, Y), female(Y).


