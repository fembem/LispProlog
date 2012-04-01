%ICS 361
%Leo deCandia
%HW 5

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
has_spouse_base(me, wife).
has_spouse_base(father, daughter_in_law).
%has_spouse(X, Y) is a dual relation true if either of
%the base relations is true
has_spouse(X, Y) :- has_spouse_base(X, Y).
has_spouse(X, Y) :- has_spouse_base(Y, X).

%a parent has a child if either the child is biological or if the
%child is a child through marriage to a biological parent
has_child(X, Y) :- has_biological_child(X, Y).
has_child(X ,Y) :- has_spouse(X, Z), has_biological_child(Z, Y).
%a grandchild is the child of the child of a person
has_grandchild(X, Z) :- has_child(X, Y), has_child(Y, Z).
%a son is a male child
has_son(X, Y) :- has_child(X, Y), male(Y).
%a daughter is a female child
has_daughter(X, Y) :- has_child(X, Y), female(Y).
% a grandson is a male grandchild
has_grandson(X, Y) :- has_grandchild(X, Y), male(Y).
% a granddaughter is a female grandchild
has_granddaughter(X, Y) :- has_grandchild(X, Y), female(Y).
%the has_parent relationship is the revese of the has_child relationship
has_parent(X, Y) :- has_child(Y, X).
% a father is a male parent
has_father(X, Y) :- has_parent(X, Y), male(Y).
%a mother is a female parent
has_mother(X, Y) :- has_parent(X, Y), female(Y).
%grandparanet is the reverse relationship of grandchild
has_grandparent(X, Y) :- has_grandchild(Y, X).
%a grandfather is a male garndparent
has_grandfather(X, Y) :- has_grandparent(X, Y), male(Y).
%a grandmother is a female garndparent
has_grandmother(X, Y) :- has_grandparent(X, Y), female(Y).

%siblings are two different people with a parent on common
%has_sibling(X, Y) :- has_parent(X, Z), has_parent(Y, Z), X \= Y.
%has_sibling(X,Y) :- has_parent(X, P), has_parent(Y, P), \+X=Y.
%found this code to elimiate duplicates in a set at 
%http://www.csee.umbc.edu/~finin/prolog/sibling/siblings.html
has_sibling(X,Y) :- setof((X,Y), P^(has_parent(X, P),has_parent(Y, P), \+X=Y), Sibs), member((X,Y), Sibs).

% a sister is a female sibling
has_sister(X, Y) :- has_sibling(X, Y), female(Y).
%a brother is a male sibling
has_brother(X, Y) :- has_sibling(X, Y), male(Y).
% a husband is a male spouse
has_husband(X, Y) :- has_spouse(X, Y), male(Y).
% a wife is a female spouse
has_wife(X, Y) :- has_spouse(X, Y), female(Y).

