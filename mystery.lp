%List of characters
character(abby).
character(boris).
character(chris).
character(duncan).
character(ellie).
character(frank).
character(gina).
character(holly).
character(ivan).
character(jane).
character(kevin).
character(liz).
character(mike).
character(nick).
character(ophelia).
character(paul).
character(quincy).
character(rose).
character(susan).
character(tyler).
character(uther).
character(veronica).
character(wanda).
character(xavier).
character(yolanda).
character(zach).

%specialcharacters
character(murderer).
character(victim).


%List of attributes
attribute(man).
attribute(smoker).
attribute(drinker).
attribute(knewVictim).

%attributes can either be true or false
attrValue(true).
attrValue(false).

%Choose 7 characters and 4 attributes to work with
7{cast(X): character(X)}7.
:-cast(murderer).
:-cast(victim).
4{gameattribute(X): attribute(X)}4.

%For each member of the cast, give them a value for each of the attributes.
1 {hasAttr(X,A,V) : attrValue(V)} 1
  :- cast(X), gameattribute(A).

%Choose one person to be the murderer, and another to be victim
1{murderer(X):cast(X)}1.
1{victim(X):cast(X)}1.
:-victim(X),murderer(X).

hasAttr(murderer,A,V) :- cast(X),hasAttr(X,A,V),murderer(X).
hasAttr(victim,A,V) :- cast(X),hasAttr(X,A,V),victim(X).


%#show hasAttr/3.
%#show murderer/1.
%#show victim/1.

% clue specification - name, information gained

% all possible facts learnable in any mystery from twoEmptyWhiskeys
clueChoice(twoEmptyWhiskeys).
canLearn(twoEmptyWhiskeys, hasAttr(murderer, drinker, true)).
canLearn(twoEmptyWhiskeys, hasAttr(murderer, knewVictim, true)).

% all possible facts learnable in any mystery from receipt
clueChoice(receipt).
canLearn(receipt, hasAttr(murderer, boughtWhiskey, true)).
canLearn(receipt, hasAttr(murderer, boughtCigarettes, true)).

% choose a set of clues
2{ clue(X) : clueChoice(X) }2.

%#show clue/1.

% choose what information is learned from each clue
1 { learn(X, Y) : canLearn(X, Y)} 2
  :- clue(X).

#show learn/2.

% action specification

% clues obtainable by looking at the body
actionChoice(lookBody).
canFind(lookBody, twoEmptyWhiskeys).

% clues obtainable by digging through the trash
actionChoice(digTrash).

% choose a set of applications
1 { action(X) : actionChoice(X) } 1.

% choose what clues are obtained from which action
1 { find(X,Y) : clue(Y)} 2
  :- action(X).

#show find/2.
