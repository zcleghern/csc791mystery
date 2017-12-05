// Translates ASP answer sets into graph format readable by webgraphviz.com
//https://github.com/zcleghern/csc791mystery

//digraph g{
  //rankdir=LR;
  //"webgraphviz" -> "@" -> "gmail" -> "." -> "com"
  //"A" -> "B" [ label = "edge" ]

//}

function atoms_to_graph(atoms) {
  var graphStr = "digraph g{ ";

  const clues = atoms.filter(a => a.pred == "clue").map(a => a.args[0]);
  const actions = atoms.filter(a => a.pred == "action").map(a => a.args[0]);
  const finds = atoms.filter(a => a.pred == "find").map(a => a.args);
  const clueReqs = atoms.filter(a => a.pred == "clueReq").map(a => a.args);


  graphStr += clues.map(a => "\"" + a + "\"").join(" ");
  graphStr += " }";
  return graphStr;
}
