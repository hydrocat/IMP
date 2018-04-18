use_module(library(apply)).

 %% sentence --> noun_phrase, verb_phrase.
 %% noun_phrase --> det, noun.
 %% verb_phrase --> verb, noun_phrase.
 %% det --> [the].
 %% det --> [a].
 %% noun --> [cat].
 %% noun --> [bat].
 %% verb --> [eats].

%% sentence(A,Z) :- noun_phrase(A,B), verb_phrase(B,Z).
%% noun_phrase(A,Z) :- det(A,B), noun(B,Z).
%% verb_phrase(A,Z) :- verb(A,B), noun_phrase(B,Z).
%% det([the|X], X).
%% det([a|X], X).
%% noun([cat|X], X).
%% noun([bat|X], X).
%% verb([eats|X], X).
n([N|T], T) :- number_string(_,N).
n(I,O) :- loc(I,O).

loc([_|T],T).
bool(["false"|T],T).
bool(["true"|T],T).
bool(["not"|T],O) :- bool(T,O).
bool(I,O) :- abexp(I,O).

bop(["and"|T],T).
bop(["or"|T],T).
abop(["<="|T],T).
abop(["="|T],T).

aop(["+"|T],T).
aop(["-"|T],T).
aop(["x"|T],T).

aexp(I,O) :- n(I,O).
aexp(I,O) :- n(I,A), aop(A,B), n(B,O).
aexp(I,O) :- n(I,A), aop(A,B), n(B,C), aop(C,D), aexp(D,O).

bexp(I,O) :- bool(I,O).
bexp(I,O) :- bool(I,A), bop(A,B), bool(B,O).
bexp(I,O) :- bool(I,A), bop(A,B), bool(B,C), bop(C,D), bexp(D,O).

abexp(I,O) :- aexp(I,A), abop(A,B), aexp(B,O).

cop([":="|T],T).
com(I,O) :- command(I,O).
com(I,O) :- command(I,A), nextcommand(A,O).
command(["skip"|T],T).
command(["if"|T],O) :- bexp(T,A), cthen(A,O).
command(["while"|T],O) :- bexp(T,A), cdo(A,O).
command(I,O) :- loc(I,A), cop(A,B), aexp(B,O).
%% note, : is used instead of ; because it's reseved in prolog
nextcommand([":"|T],O) :- com(T,O).
cthen(["then"|T],O) :- com(T,A), celse(A,O).
celse(["else"|T],O) :- com(T,O).
cdo(["do"|T],O) :- com(T,O).

good_syntax(I,O) :- com(I,O).

%% statements are separated by :
%% the check is done by calling good_syntax([<source-code>],[]).
%% example programs:
%% asd := 1
%% : while asd <= 1 do
%%   asd := asd - 1
%% : asd := asd + 1
%% : if asd = 0 then
%% 	   abc := 10
%% 	   else
%% 	   skip
%% becomes
%% good_syntax([asd,:=,1,:,while,asd,<=,1,do,asd,:=,asd,-,1,:,asd,:=,asd,+,1,:,if,asd,=,0,then,abc,:=,10,else,skip],[]).
blank(S) :- S = " ".
blank(S) :- S = "".
blank(S) :- S = "\n".
blank(S) :- S = "\t".
test_file(Fname) :- open(Fname,read,Fd), read_string(Fd,_,Source), split_string(Source,"\n \t"," ",L), exclude(blank,L,LO), trace, good_syntax(LO,[]).

%% Identical expression check

%% leftpar(["("|T],T).
%% rightpar([")"|T],T).

%%op(Ia,Ib,O) :- O.

