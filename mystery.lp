%Characters: List of 26 characters possible in the game.
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


%special characters: One will be the murderer and one will be the victim.
character(murderer).
character(victim).


%List of 13 currently implemented attributes.
attribute(drinker).
attribute(inLoveWithVictim).
attribute(isLeftHanded).
attribute(knewVictim).
attribute(man).
attribute(ownsGun).
%attribute(ownsKnife).
attribute(lightHair).
attribute(smoker).
attribute(tall).
attribute(wantsInheritance).

%List of unimplemented attributes
%attribute(fat).
%attribute(hasCane).
%attribute(wearsGlasses).
%attribute(frequentsBar).
%attribute(shopCustomer).

%Attribute Values: Either True or False.
attrValue(true).
attrValue(false).


%Choose 7 characters and 4 attributes to work with
7{cast(X): character(X)}7.

%same up here
:- not cast(abby).
:- not cast(boris).
:- not cast(chris).
:- not cast(duncan).
:- not cast(ellie).
:- not cast(frank).
:- not cast(gina).

%Do not choose the murderer or the victim as part of the cast. Those will be assigned later.
:-cast(murderer).
:-cast(victim).

%Choose 4 attributes to focus on in the game.
4{gameattribute(X): attribute(X)}7.


%For each member of the cast, give them a value for each of the attributes.
1 {hasAttr(X,A,V) : attrValue(V)} 1
  :- cast(X), gameattribute(A).


%Choose one person to be the murderer, and another to be victim
1{murderer(X):cast(X)}1.
1{victim(X):cast(X)}1.

%There are no two people that have identical Values
:- attribute(A), not gameattribute(A) ; cast(X), cast(Y), murderer(X), X!=Y, attrValue(V), hasAttr(X,A,V), hasAttr(Y,A,V).

% We are using this to severly limit the search space
:- not murderer(abby).
:- not victim(boris).

%The person cannot be both the victim and the murderer.
:-victim(X),murderer(X).

%The victim and murderer cast member have all of the attributes of the cast member associated with them
hasAttr(murderer,A,V) :- cast(X),hasAttr(X,A,V),murderer(X).
hasAttr(victim,A,V) :- cast(X),hasAttr(X,A,V),victim(X).


% 13 clue specification - name, information gained

%Cigarette Smoke
clueChoice(cigaretteSmoke).
willLearn(cigaretteSmoke, hasAttr(murderer,smoker,true)).

%Cut out Face
clueChoice(cutOutFace).
willLearn(cutOutFace, hasAttr(murderer,knewVictim,true)).
%willLearn(cutOutFace,hasAttr(murderer,ownsKnife,true)).

%Diary
clueChoice(diary).
canLearn(diary,hasAttr(murderer,knewVictim,true)).
canLearn(diary,hasAttr(murderer,wantsInheritance,true)).

%GunShotWound
clueChoice(gunShotWound).
willLearn(gunShotWound, hasAttr(murderer,ownsGun,true)).
canLearn(gunShotWound, hasAttr(murderer,tall,true)).
canLearn(gunShotWound,hasAttr(murderer,tall,false)).
canLearn(gunShotWound, hasAttr(murderer,isLeftHanded,true)).
canLearn(gunShotWound, hasAttr(murderer,isLeftHanded,false)).

%Box Key
clueChoice(key).

%Lipstick
clueCoice(lipstick).
willLearn(lipstick,hasAttr(murderer,man,false)).
canLearn(lipstick,hasAttr(murderer,smoker,true)).
canLearn(lipstick, hasAttr(murderer,smoker,false)).

%Glove
clueChoice(glove).
canLearn(glove, hasAttr(murderer, man, true)).
canLearn(glove, hasAttr(murderer, man, false)).
canLearn(glove, hasAttr(murderer,smoker,true)).
canLearn(glove, hasAttr(murderer,smoker,false)).

%Love Letter
clueChoice(loveLetter).
canLearn(loveLetter,hasAttr(murderer,inLoveWithVictim,true)).

%Receipt
clueChoice(receipt).
canLearn(receipt, hasAttr(murderer, drinker, true)).
canLearn(receipt, hasAttr(murderer, smoker, true)).
canLearn(receipt, hasAttr(murderer, ownsGun, true)).


%Hair Strand
clueChoice(hairStrand).
canLearn(hairStrand,hasAttr(murderer,lightHair,true)).
canLearn(hairStrand,hasAttr(murderer,lightHair,false)).

%Revolver
clueChoice(revolver).
willLearn(revolver,hasAttr(murderer,ownsGun,true)).

%SafeCombination
clueChoice(safeCombination).

%Stabwound
clueChoice(stabWound).
%willLearn(stabWound, hasAttr(murderer,ownsKnife,true)).
canLearn(stabWound, hasAttr(murderer,tall,true)).
canLearn(stabWound,hasAttr(murderer,tall,false)).
canLearn(stabWound, hasAttr(murderer,isLeftHanded,true)).
canLearn(stabWound, hasAttr(murderer,isLeftHanded,false)).

%Two Empty Whiskey glasses
clueChoice(twoEmptyWhiskeys).
willLearn(twoEmptyWhiskeys, hasAttr(murderer, drinker, true)).
willLearn(twoEmptyWhiskeys, hasAttr(murderer, knewVictim, true)).

%Will
clueChoice(will).
canLearn(will, hasAttr(murderer,wantsInheritance,true)).
canLearn(will,hasAttr(murderer,knewVictim,true)).

%Ashes (fire has been put out)
clueChoice(ashes).

%Fire
clueChoice(fire).

% choose a set of clues
3{ clue(X) : clueChoice(X) }13.


%Always learn some things
learn(X,Y):- clue(X),willLearn(X,Y).

% choose what information is learned from each clue
1 { learn(X, Y) : canLearn(X, Y)} 5
  :- clue(X).


%Talking to people once you know murderer has attribute allows you to learn these attributes
  %learn(talkedTo(Char,Attr),hasAttr(Char,Attr,Val)):-
  %cast(Char),hasAttr(Char,Attr,Val),clue(X),learn(X,hasAttr(murderer,Attr,true)).


%% If we select a set of clues that include attributes we did not select, halt.
:- clue(X), attribute(A), attrValue(V), not hasAttr(murderer,A,V), learn(X,hasAttr(murderer,A,V)).

%% Ensure that what is learned from clues is not contradictory
:- clue(X), clue(Y), cast(murderer), gameattribute(A), learn(X,hasAttr(murderer,A,false)), learn(Y,hasAttr(murderer,A,true)).

%% Ensure that the set of attributes is covered by the set of clues
covered(A) :- gameattribute(A), learn(X, hasAttr(murderer, A, V)), clue(X).
:- gameattribute(A), not covered(A).







% 8 action specification

%Put out fire
actionChoice(putOutFire).
willFind(putOutFire, ashes).
clueReq(putOutFire, fire).

%Dig Through Fireplace
actionChoice(digThroughFireplace).
canFind(digThroughFireplace,loveLetter).
canFind(digThroughFireplace,will).
canFind(digThroughFireplace,diary).
clueReq(digThroughFireplace, ashes).

% Dig through Trash
actionChoice(digTrash).
canFind(digTrash, twoEmptyWhiskeys).
canFind(digTrash,receipt).
canFind(lookBody,cigarette).
canFind(digTrash,lipstick).
canFind(digTrash,diary).

%Inspect Bust
actionChoice(inspectBust).
canFind(inspectBust, cigaretteSmoke).
canFind(inspectBust, button).

%Inspect Chair
canFind(inspectChair, lipstick).
canFind(inspectChair, receipt).
canFind(inspectChair, hairStrand).

%Inspect Desk
actionChoice(inspectDesk).
canFind(inspectDesk, diary).
canFind(inspectDesk, will).
canFind(inspectDesk, lipstick).
canFind(inspectDesk, receipt).

%Inspect Drawer
actionChoice(inspectDrawer).
canFind(inspectDrawer, diary).
canFind(inspectDrawer, will).

%Inspect Picture
actionChoice(inspectPicture).
canFind(inspectPortrait,cutOutFace).

%Inspect Portrait
actionChoice(inspectPortrait).
canFind(inspectPortrait,cutOutFace).
canFind(inspectPortrait,safe).

%Inspect Rug
actionChoice(inspectRug).
canFind(inspectRug,hairStrand).
canFind(inspectRug,cigaretteSmoke).

%Look at Bookshelf
actionChoice(lookAtBookshelf).
canFind(lookAtBookshelf, diary).
canFind(lookAtBookshelf, will).

%Look at Body
actionChoice(lookBody).
canFind(lookBody, twoEmptyWhiskeys).
canFind(lookBody,receipt).
canFind(lookBody,cigarette).
canFind(lookBody,stabWound).
canFind(lookBody,gunShotWound).
canFind(lookBody,lipstick).
canFind(lookBody,redHair).

%Open Clock
actionChoice(openClock).
canFind(openClock,will).
canFind(openClock,diary).

%Unlock Box
actionChoice(unlockingBox).
canFind(unlockingBox,revolver).
canFind(unlockingBox,loveLetter).
clueReq(unlockingBox, boxKey).
clueReq(unlockingBox, box).

%Unlock Safe
actionChoice(unlockSafe).
canFind(unlockSafe,will).
clueReq(unlockSafe, safeCombination).
clueReq(unlockSafe, safe).


% choose a set of actions from action choices
2 { action(X) : actionChoice(X) } 700.


% Always find some things from actions
find(X,Y) :- action(X),willFind(X,Y).

% choose what clues are obtained from which action
0 { find(X,Y) : clue(Y)} 500
  :- action(X),canFind(X,Y).


% Can't find the same clue through two different actions.
:- clue(Y),action(X),action(Z),X != Z, find(X,Y),find(Z,Y).

%If I generated an action that requires a clue but I did not generate that clue fail
:- action(X),clueReq(X,Y), not clue(Y).

%Every clue we chose is findable
findable(Y) :- clue(Y), action(X), find(X,Y).
:- clue(Y), not findable(Y).
