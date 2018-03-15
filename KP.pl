% Автор:
% Дата: 04.12.2016

parent('Aleksandra Pustovalova', 'Andrej Pustovalov', 'Irina Serebryakova').
parent('Nikita Pustovalov', 'Andrej Pustovalov', 'Irina Serebryakova').
parent('Aleksej Serebryakov', 'Georgij Serebryakov', 'Anna Kudryavceva').
parent('Irina Serebryakova', 'Georgij Serebryakov', 'Anna Kudryavceva').
parent('Irina Pustovalova', 'Vyacheslav Pustovalov', 'Valentina Pisareva').
parent('Andrej Pustovalov', 'Vyacheslav Pustovalov', 'Valentina Pisareva').
parent('Anna Kudryavceva', 'Andrej Kudryavcev', 'Klavdiya Kudryavceva').
parent('Valentina Kudryavceva', 'Andrej Kudryavcev', 'Klavdiya Kudryavceva').
parent('Tatyana Kudryavceva', 'Andrej Kudryavcev', 'Klavdiya Kudryavceva').
parent('Georgij Serebryakov', 'Matvej Serebryakov', 'Evdokiya Pletneva').
parent('Petr Serebryakov', 'Matvej Serebryakov', 'Evdokiya Pletneva').
parent('Lyubov Serebryakova', 'Matvej Serebryakov', 'Evdokiya Pletneva').
parent('Valentina Pisareva', 'Pert Pisarev', 'Klavdiya Bobrishova').
parent('Mariya Pisareva', 'Pert Pisarev', 'Klavdiya Bobrishova').
parent('Nadezhda Pisareva', 'Pert Pisarev', 'Klavdiya Bobrishova').
parent('Nikolaj Pisarev', 'Pert Pisarev', 'Klavdiya Bobrishova').
parent('Aleksandr Pisarev', 'Pert Pisarev', 'Klavdiya Bobrishova').
parent('Pert Pisarev', 'Elistrat Pisarev', 'Anna Pisareva').
parent('Vyacheslav Pustovalov', 'Vasilij Pustovalov', 'Anastasiya Stepanova').
parent('Elena Pustovalova', 'Vasilij Pustovalov', 'Anastasiya Stepanova').
parent('Aleksej Dyachenko', 'Sergej Dyachenko', 'Irina Pustovalova').
parent('Ilya Serebryakov', 'Aleksej Serebryakov', 'Olga Serebryakova').
parent('Pavel Serebryakov', 'Aleksej Serebryakov', 'Olga Serebryakova').
parent('Igor Sokolov', 'Boris Sokolov', 'Valentina Kudryavceva').
parent('Denis Sokolov', 'Igor Sokolov', 'Larisa Sokolova').
parent('Sergej Hohlachev', 'Vladimir Hohlachev', 'Tatyana Kudryavceva').
parent('Aleksandr Hohlachev', 'Vladimir Hohlachev', 'Tatyana Kudryavceva').
parent('Elena Lisina', 'Genadij Lisin', 'Mariya Pisareva').
parent('Galina Lisina', 'Genadij Lisin', 'Mariya Pisareva').
parent('Natalya Pisareva', 'Viktor Menyaev', 'Nadezhda Pisareva').
parent('Svetlana Pisareva', 'Viktor Menyaev', 'Nadezhda Pisareva').
parent('YUrij Pisarev', 'Nikolaj Pisarev', 'Tatyana Pisareva').
parent('Galina Pisareva', 'Nikolaj Pisarev', 'Tatyana Pisareva').
parent('Ekaterina Krupnova', 'Aleksandr Krupnov', 'Galina Lisina').
parent('Anna Ovsyannikova', 'Konstantin Ovsyannikov', 'Elena Lisina').
parent('Aleksandra Ovsyannikova', 'Konstantin Ovsyannikov', 'Elena Lisina').
parent('Polina Vorobeva', 'Valerij Vorobev', 'Natalya Pisareva').
parent('Anna Gordeeva', 'YUrij Gordeev', 'Elena Pustovalova').
parent('Mariya SHiryaeva', 'Igor SHiryaev', 'Anna Gordeeva').
parent('Sofya SHiryaeva', 'Igor SHiryaev', 'Anna Gordeeva').

broser_sister(A, B):- parent(A, P1, P2), parent(B, P1, P2), not(B == A).
father(A, B):- parent(A, B, _).
mother(A, B):- parent(A, _, B).
grand_parent(A, B):- parent(A, P1, P2), (mother(P1, B); mother(P2, B); father(P1, B); father(P2, B)).
grand_daughter_son(A, B):- mother(P2, A), (father(B, P2); mother(B, P2)).
grand_daughter_son(A, B):- father(P2, A), (father(B, P2); mother(B, P2)).
cousin(A, B):- grand_parent(A, F), broser_sister(F, G), grand_daughter_son(G, B).

move(X, Y):- broser_sister(X, Y).
move(X, Y):- parent(_, X, Y), !; parent(_, Y, X), !.

move(X, Y, wife):- parent(_, X, Y), !.
move(X, Y, husband):- parent(_, Y, X), !.
move(X, Y, mother):- mother(X, Y), !.
move(X, Y, father):- father(X, Y), !.
move(X, Y, child):- mother(Y, X), !; father(Y, X), !.
move(X, Y, brother/sister):- broser_sister(X, Y).

list([A, B], [H]):- move(A, B, H).
list([A, B|T], [F|H]):- move(A, B, F), list([B|T], H).

dfs(A, B, P):- path_dfs([A], B, L), reverse(L, P).
path_dfs([Y|T], Y, [Y|T]).
path_dfs(P, Y, R):- prolong(P, P1), path_dfs(P1, Y, R).

relative(A, B, R):- dfs(A, B, R1), list(R1, R).



relatives('mother', mother).
relatives('father', father).
relatives('child', child).
relatives('children', child).
relatives('brother/sister', brother/sister).
relatives('brothers/sisters', brother/sister).
relatives('wife', wife).
relatives('husband', husband).


get_name('she', A):- name_person(A), !.
get_name('he', A):- name_person(A), !.
get_name('her', A):- name_person(A), !.
get_name('his', A):- name_person(A), !.
get_name(A, A):- retractall(name_person(_)), assert(name_person(A)).

path_person([T|T1], A, C):- relatives(T, T2), path_person(T1, A, C1),  append(C1, [T2], C).
path_person(['of'|T1], A, C):- path_person(T1, A, C).
path_person(['does'|T1], A, C):- path_person(T1, A, C).
path_person(['have'|T1], A, C):- path_person(T1, A, C).
path_person([T], T2, []):- get_name(T, T2).
path_person([T|T1], T2, C):- get_name(T, T2), path_person(T1, _, C).
path_person([], _, []).


ask(['Who', 'is'|T]):- path_person(T, A, C), findall(Relative, relative(A, Relative, C), S), write(T), write(' : '), write(S).
ask(['How many'|A]):- path_person(A, A1, C1), findall(L, relative(A1, L, C1), S), length(S, Number), writeln(Number).
ask(['Is', B|T]):- path_person(T, A, C), get_name(B, B1), relative(A, B1, C), writeln('yes'), !; writeln('no').
ask(['Does', A, 'have'|T]):- path_person(T, _, C), get_name(A, A1), relative(A1, _, C), writeln('yes'), !; writeln('no').


