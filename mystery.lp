character(a).
character(b).
character(c).
character(d).
character(e).
character(f).
character(g).
character(h).
character(i).
character(j).

attribute(man).
attribute(smoker).
attribute(drinker).
attribute(knewVictim).

attrValue(true).
attrValue(false).

1 {hasAttr(X,A,V) : attrValue(V)} 1
  :- character(X), attribute(A).

#show hasAttr/3.

% clue specification - name, information gained

% all possible facts learnable in any mystery from twoEmptyWhiskeys
clue(twoEmptyWhiskeys, hasAttr(culprit, drinker, true)).
clue(twoEmptyWhiskeys, hasAttr(culprit, knewVictim, true)).

% all possible facts learnable in any mystery from receipt
clue(receipt, hasAttr).
