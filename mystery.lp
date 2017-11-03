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
