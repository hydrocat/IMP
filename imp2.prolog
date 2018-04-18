%% This program creates a ast from a mathematical
%% expression
%% === How  to use ===
%% Query for : exp( <list of tokens>, [], Tree).
%%
%% ===== Example =====
%% exp(['(',1,+,3,')',*,2],[],X).
%% X =  mul(sum(1, 3), 2)
%%
%% ====== Notes ======
%% Doesn't work on reverse
%% exp(X,[],mul(sum(1,2),4)).
%%     ERROR: Out of local stack
%% It's due to the recursion on pnum callin exp/3

mul([*|T],T).
div([/|T],T).
sub([-|T],T).
sum([+|T],T).
lpar(['('|T],T).
rpar([')'|T],T).

pnum(I,O,V) :- lpar(I,A), exp(A,B,V), rpar(B,O).
pnum(I,O,V) :- signum(I,O,V).

signum([-|T],O,negative(Val)) :- num(T,O,Val).
signum([+|T],O,positive(V)) :- num(T,O,V).
signum(I,O,V) :- num(I,O,V).
num([H|T],T,H) :- number(H).

exp(I,O,sum(R0,R1)) :- term(I,A,R0), sum(A,B), exp(B,O,R1).
exp(I,O,sub(R0,R1)) :- term(I,A,R0), sub(A,B), exp(B,O,R1).
exp(I,O,V) :- term(I,O,V).

term(I,O,mul(R0,R1)) :- pnum(I,A,R0), mul(A,B), term(B,O,R1).
term(I,O,div(R0,R1)) :- pnum(I,A,R0), div(A,B), term(B,O,R1).
term(I,O,V) :- pnum(I,O,V).

