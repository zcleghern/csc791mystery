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


%special character: one character is the murderer
character(murderer).


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


%Choose characters and attributes to work with
8{cast(X): character(X)}8.

%Do not choose the murderer as part of the cast. That will be assigned later.
:-cast(murderer).

%Choose attributes to focus on in the game.
8{gameattribute(X): attribute(X)}8.

%For each member of the cast, give them a value for each of the attributes.
1 {hasAttr(X,A,V) : attrValue(V)} 1
  :- cast(X), gameattribute(A).

%Choose one person to be the murderer
1{murderer(X):cast(X)}1.

%There are no two people that have identical Values
:- attribute(A), not gameattribute(A) ; cast(X), cast(Y), murderer(X), X!=Y, attrValue(V), hasAttr(X,A,V), hasAttr(Y,A,V).

%The murderer cast member have all of the attributes of the cast member associated with them
hasAttr(murderer,A,V) :- cast(X),hasAttr(X,A,V),murderer(X).

% clue specification - name, information gained

%Cigarette Smoke
clueChoice(cigaretteSmoke).
willLearn(cigaretteSmoke, hasAttr(murderer,smoker,true)).

%Cigarette
clueChoice(cigarette).
willLearn(cigarette, hasAttr(murderer, smoker, true)).

%Cut out Face
clueChoice(cutOutFace).
willLearn(cutOutFace, hasAttr(murderer,knewVictim,true)).

%Locked Diary
clueChoice(lockedDiary).

%Diary Key
clueChoice(diaryKey).

%Button
clueChoice(button).

%Diary
clueChoice(openedDiary).
canLearn(openedDiary,hasAttr(murderer,knewVictim,true)).
canLearn(openedDiary,hasAttr(murderer,wantsInheritance,true)).

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

%water
clueChoice(water).

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

%Photograph
clueChoice(photograph).

%Safe
clueChoice(safe).

%Fire
clueChoice(fire).

% choose a set of clues
5{ clue(X) : clueChoice(X) }17.


%Always learn some things
learn(X,Y):- clue(X),willLearn(X,Y).

% choose what information is learned from each clue
0 { learn(X, Y) : canLearn(X, Y)} 2
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

%Look at Fireplace
actionChoice(lookAtFireplace).
canFind(lookAtFireplace, fire).

%Put out fire
actionChoice(putOutFire).
willFind(putOutFire, ashes).
clueReq(putOutFire, fire).
clueReq(putOutFire, water).

%Dig Through Fireplace
actionChoice(digThroughFireplace).
canFind(digThroughFireplace,loveLetter).
canFind(digThroughFireplace,will).
canFind(digThroughFireplace,glove).
canFind(digThroughFireplace,lockedDiary).
canFind(digThroughFireplace,openedDiary).
clueReq(digThroughFireplace, ashes).

%Open the Diary
actionChoice(openDiary).
canFind(openDiary, openedDiary).
canFind(openDiary, safeCombination).
clueReq(openDiary, lockedDiary).
clueReq(openDiary, diaryKey).

% Dig through Trash
actionChoice(digTrash).
canFind(digTrash, twoEmptyWhiskeys).
canFind(digTrash,receipt).
canFind(digTrash,cigarette).
canFind(digTrash,lipstick).
canFind(digTrash,lockedDiary).

%Inspect Bust
actionChoice(inspectBust).
canFind(inspectBust, cigaretteSmoke).
canFind(inspectBust, button).

%Push button
actionChoice(pushButton).
canFind(pushButton, diaryKey).
clueReq(pushButton, button).

%Inspect Chair
canFind(inspectChair, lipstick).
canFind(inspectChair, receipt).
canFind(inspectChair, hairStrand).

%Inspect Desk
actionChoice(inspectDesk).
canFind(inspectDesk, lockedDiary).
canFind(inspectDesk, will).
canFind(inspectDesk, lipstick).
canFind(inspectDesk, receipt).
canFind(inspectDesk, water).
canFind(inspectDesk, photograph).

%Inspect Drawer
actionChoice(inspectDrawer).
canFind(inspectDrawer, lockedDiary).
canFind(inspectDrawer, will).

%Inspect Picture
actionChoice(inspectPicture).
canFind(inspectPicture,cutOutFace).
clueReq(inspectPicture, photograph).

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
canFind(lookAtBookshelf, lockedDiary).
canFind(lookAtBookshelf, will).

%Look at table
actionChoice(lookAtTable).
canFind(lookAtTable, twoEmptyWhiskeys).

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
canFind(openClock,lockedDiary).

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
11 { action(X) : actionChoice(X) } 16.


% Always find some things from actions
find(X,Y) :- action(X),willFind(X,Y).

% choose what clues are obtained from which action - Changed this, see rule below
%0 { find(X,Y) : clue(Y)} 17
  %:- action(X),canFind(X,Y).

% For each action, choose what clues are obtained
0 { find(X,Y) : canFind(X,Y)} 2
  :- action(X).

% Can't find the same clue through two different actions.
:- clue(Y),action(X),action(Z),X != Z, find(X,Y),find(Z,Y).

%If I generated an action that requires a clue but I did not generate that clue fail
:- action(X), clueReq(X,Y), not clue(Y).

%Every clue we chose is findable
findable(Y) :- clue(Y), action(X), find(X,Y).
:- clue(Y), not findable(Y).

:- not find(openDiary, safeCombination).
:- not find(digTrash, receipt).
:- not find(inspectChair, hairStrand).

:- not clue(hairStrand).
:- not clue(safe).
:- not clue(receipt).
:- not clue(water).
:- not clue(fire).
:- not clue(photograph).
:- not clue(ashes).
:- not clue(glove).
:- not clue(lockedDiary).
:- not clue(openedDiary).
:- not clue(safeCombination).
:- not clue(twoEmptyWhiskeys).
:- not clue(button).
:- not clue(diaryKey).
:- not clue(will).
:- not clue(cigaretteSmoke).
:- not clue(stabWound).
