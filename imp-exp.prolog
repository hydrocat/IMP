%% parser(I,O,S) Input,Structure
%% [1,*,3,+,4] - lets try to parse this
%% Expected result:
%% sum(mul(1,3),4)

mul([*|T],T).
div([/|T],T).
sub([-|T],T).
sum([+|T],T).
lpar(['('|T],T).
rpar([')'|T],T).

pnum(I,O,V) :- lpar(I,A), exp(A,B,V), rpar(B,O).
pnum(I,O,V) :- signum(I,O,V).

signum([-|T],O,V) :- num(T,O,Val), V is -1 * Val .
signum([+|T],O,V) :- num(T,O,V).
signum(I,O,V) :- num(I,O,V).
num([H|T],T,H) :- number(H).


exp(I,O,V) :- term(I,A,R0), sum(A,B), exp(B,O,R1), V is R0 + R1.
exp(I,O,V) :- term(I,A,R0), sub(A,B), exp(B,O,R1), V is R0 - R1.
exp(I,O,V) :- term(I,O,V).

term(I,O,V) :- pnum(I,A,R0), mul(A,B), term(B,O,R1), V is R0 * R1.
term(I,O,V) :- pnum(I,A,R0), div(A,B), term(B,O,R1), V is R0 / R1.
term(I,O,V) :- pnum(I,O,V).




