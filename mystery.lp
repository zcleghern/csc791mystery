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
attribute(isLeftHanded).
attribute(ownsGun).
attribute(ownsKnife).
attribute(tall).
attribute(fat).
attribute(hasWound).
attribute(wearsGlasses).
attribute(hasCane).
attribute(frequentsBar).
attribute(shopCustomer).
attribute(redHair).
attribute(inLoveWithVictim).
attribute(wantsInheritance).
attribute(hasKey).


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

clueChoice(diary).
canLearn(diary,hasAttr(murderer,knewVictim,true)).
%canLearn(diary,hasAttr(X,knewVictim,true)).
canLearn(diary,hasAttr(murderer,wantsInheritance,true)).


clueChoice(will).
canLearn(will, hasAttr(murderer,wantsInheritance,true)).
canLearn(will,hasAttr(murderer,knewVictim,true)).


clueChoice(gunShotWound).
canLearn(gunShotWound, hasAttr(murderer,ownsGun,true)).
canLearn(gunShotWound, hasAttr(murderer,tall,true)).
canLearn(gunShotWound,hasAttr(murderer,tall,false)).
canLearn(gunShotWound, hasAttr(murderer,isLeftHanded,true)).
canLearn(gunShotWound, hasAttr(murderer,isLeftHanded,false)).

clueCoice(lipstick).
canLearn(lipstick,hasAttr(murderer,man,false)).
canLearn(lipstick,hasAttr(murderer,smoker,true)).


clueChoice(stabWound).
canLearn(gunShotWound, hasAttr(murderer,ownsKnife,true)).
canLearn(gunShotWound, hasAttr(murderer,tall,true)).
canLearn(gunShotWound,hasAttr(murderer,tall,false)).
canLearn(gunShotWound, hasAttr(murderer,isLeftHanded,true)).
canLearn(gunShotWound, hasAttr(murderer,isLeftHanded,false)).


clueChoice(redHair).
canLearn(murderer,hasAttr(murderer,redHair,true)).

clueChoice(loveLetter).
canLearn(loveLetter,hasAttr(murderer,inLoveWithVictim,true)).

clueChoice(revolver).
canLearn(revolver,hasAttr(murderer,ownsGun,true)).

clueChoice(key).
canLearn(key,hasAttr(victim,hasKey,true)).

% all possible facts learnable in any mystery from twoEmptyWhiskeys
clueChoice(twoEmptyWhiskeys).
canLearn(twoEmptyWhiskeys, hasAttr(murderer, drinker, true)).
canLearn(twoEmptyWhiskeys, hasAttr(murderer, knewVictim, true)).

%
clueChoice(cigaretteSmoke).
canLearn(cigaretteSmoke, hasAttr(murderer,smoker,true)).


% all possible facts learnable in any mystery from receipt
clueChoice(receipt).
canLearn(receipt, hasAttr(murderer, drinker, true)).
canLearn(receipt, hasAttr(murderer, smoker, true)).

% choose a set of clues
2{ clue(X) : clueChoice(X) }2.

%#show clue/1.

% choose what information is learned from each clue
1 { learn(X, Y) : canLearn(X, Y)} 2
  :- clue(X).
 
%Talking to people learns you stuff 
  learn(talkedTo(Char,Attr),hasAttr(Char,Attr,Val)):-
  cast(Char),hasAttr(Char,Attr,Val),clue(X),learn(X,hasAttr(murderer,Attr,true)).
  
%% If we select a set of clues that include attributes we did not select, halt.

%% If we cannot use the set of 
actionChoice(digThroughFireplace).
canFind(digThroughFireplace,loveLetter).
canFind(digThroughFireplace,will).
canFind(digThroughFireplace,diary).

#show learn/2.
action(inspectRug).
canFind(inspectRug,redHair).
canFind(inspectRug,cigarette).

% action specification
actionChoice(unlockingBox).
canFind(unlockingBox,revolver).
canFind(unlockingBox,loveLetter).


% clues obtainable by looking at the body
actionChoice(lookBody).
canFind(lookBody, twoEmptyWhiskeys).
canFind(lookBody,receipt).
canFind(lookBody,cigarette).
canFind(lookBody,stabWound).
canFind(lookBody,gunShotWound).
canFind(lookBody,lipstick).
canFind(lookBody,redHair).


% clues obtainable by digging through the trash
actionChoice(digTrash).
canFind(digTrash, twoEmptyWhiskeys).
canFind(digTrash,receipt).
canFind(digTrash,cigarette).
canFind(digTrash,lipstick).
canFind(digTrash,diary).

action(inspectDesk).
canFind(inspectDesk, diary).
canFind(inspectDesk, will).
canFind(inspectDesk, lipstick).
canFind(inspectDesk, receipt).

action(unlockSafe).


action(lookAtBookshelf).
canFind(lookAtBookshelf, diary).
canFind(lookAtBookshelf, will).


% choose a set of applications
1 { action(X) : actionChoice(X) } 1.

% choose what clues are obtained from which action
1 { find(X,Y) : clue(Y)} 2
  :- action(X),canFind(X,Y).
  
% Can't find the same clue through two different actions.
:- clue(Y),action(X),action(Z),dif(X,Z),find(X,Y),find(Z,Y).

#show find/2.

