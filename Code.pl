%Definicao de Regras de Cenario



%CENARIO


dk([9,5]).
objetivo([10,5]).
martelo([1,5]).

escada([1,3]).
escada([3,2]).
escada([3,4]).
escada([8,4]).
escada([9,1]).
escada([10,3]).

barril([6,3]).
barril([6,5]).
barril([7,2]).
barril([7,4]).
barril([8,3]).

parede([4,4]).
parede([7,5]).





%Definicao de Estados

s([X,Y],[X1,Y]):- X<10 ,X1 is X+1,not(parede([X1,Y])),not(barril([X1,Y])). %% movimentação livre em X : sujeito a paredes e barril
s([X,Y],[X1,Y]):- X>1 ,X1 is X-1,not(parede([X1,Y])),not(barril([X1,Y])).

s([X,Y],[X1,Y]):- X<9 ,X1 is X+2,X2 is X+1,Y1 is Y-1,barril([X2,Y]),not(parede([X1,Y])),not(barril([X1,Y])),not(escada([X1,Y])),not(escada([X1,Y1])), not(dk([X1,Y])). %% movimentação em X de salto  de barris: sujeito a restricoes
s([X,Y],[X1,Y]):- X>2 ,X1 is X-2,X2 is X-1,Y1 is Y-1,barril([X2,Y]),not(parede([X1,Y])),not(barril([X1,Y])),not(escada([X1,Y])),not(escada([X1,Y1])), not(dk([X1,Y])).

s([X,Y],[X,Y1]):- Y<5 ,Y1 is Y+1,escada([X,Y]),not(barril([X,Y1])). %% movimentacao em Y pelas escadas: bloqueado quando tem barril na ponta
s([X,Y],[X,Y1]):- Y>1 ,Y1 is Y-1,escada([X,Y1]),not(barril([X,Y1])).


%Verifica se tem martelo para enfrentar DK

tem_martelo([Cabeca|_]):-martelo(Cabeca).
tem_martelo([_|Cauda]):-tem_martelo(Cauda).

%% Inicia a busca

%iniciar(X,Y) :- bo([[[X,Y]]],Solucao), reverse(Solucao,Solucao2),write(['Caminho:',Solucao2]).
iniciar(X,Y) :- bm([[[X,Y]]],[Cabeca|Cauda]),bo([[Cabeca]],Solucao), concatena(Solucao,Cauda,Solucao1),reverse(Solucao1,Solucao2),write(['Caminho:',Solucao2]).
%% busca martelo

bm([[Estado|Caminho]|_],[Estado|Caminho]) :- martelo(Estado).
bm([Primeiro|Outros], Solucao) :- estende2(Primeiro,Sucessores), concatena(Outros,Sucessores,NovaFronteira), bm(NovaFronteira,Solucao).
% busca objetivo
bo([[Estado|Caminho]|_],[Estado|Caminho]) :- objetivo(Estado).
bo([Primeiro|Outros], Solucao) :- estende1(Primeiro,Sucessores), concatena(Outros,Sucessores,NovaFronteira), bo(NovaFronteira,Solucao).

estende1([Estado|Caminho],ListaSucessores):-
	bagof(
		[Sucessor,Estado|Caminho],
		(s(Estado,Sucessor),not((pertence(Sucessor,[Estado|Caminho])))),
		ListaSucessores),!.
estende1( _ ,[]).

estende2([Estado|Caminho],ListaSucessores):-
	bagof(
		[Sucessor,Estado|Caminho],
		(s(Estado,Sucessor),not((pertence(Sucessor,[Estado|Caminho]));(dk(Sucessor),(not(tem_martelo([Estado|Caminho])))))),
		ListaSucessores),!.
estende2( _ ,[]).


pertence(X,[X|_]).
pertence(X,[_|Cauda]) :- pertence(X,Cauda).

concatena([],L,L).
concatena([Cabeca|Cauda],L,[Cabeca|Resultado]):- concatena(Cauda,L,Resultado).








