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


#show hasAttr/3.
<<<<<<< HEAD

% clue specification - name, information gained

% all possible facts learnable in any mystery from twoEmptyWhiskeys
clue(twoEmptyWhiskeys, hasAttr(culprit, drinker, true)).
clue(twoEmptyWhiskeys, hasAttr(culprit, knewVictim, true)).

% all possible facts learnable in any mystery from receipt
clue(receipt, hasAttr).
=======
#show murderer/1.
#show victim/1.
>>>>>>> 1775ddc11452682a81e95a4ea17f0e065660a9fb
