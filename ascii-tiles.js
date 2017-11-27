// Code for translating AnsProlog answer sets to a readable format. Original code at https://github.com/chrisamaphone/atomsets

// Reading input

var reader;
function readFileAndDisplay(evt) {
  //Retrieve the first (and only!) File from the FileList object
  var f = evt.target.files[0];

  if (f) {
    console.log("Got file");
    var r = new FileReader();
    r.readAsText(f);
    r.onload = function(e) {
      var contents = e.target.result;
      console.log( "Got the file.\n"
            +"name: " + f.name + "\n"
            +"type: " + f.type + "\n"
            +"size: " + f.size + " bytes\n"
            + "starts with: " + contents.substr(0, contents.indexOf("\n"))
      );
      reader = r;
      source = reader.result;
     // console.log("New source: "+source);
      document.getElementById("source").innerHTML = JSON.stringify(source);
    }
  } else {
    alert("Failed to load file");
  }
}



// UI stuff
window.onload = function() {

var generateButton = document.getElementById("generateButton");
generateButton.addEventListener("click", function () {
  source = document.getElementById('predicates').value;
  var generated = generate();
  document.getElementById("generated").innerHTML = "<pre>"+generated+"</pre>";
});

document.getElementById('predicates').innerHTML = source;
// document.getElementById('fileinput').addEventListener('change', readFileAndDisplay, false);
}

// Utils
function tokenize(s) {
  // var csv = s.split(/\)\,\s*/);
  var preds = s.split(" ");
  var tokens = [];
  for (var i = 0; i < preds.length; i++) {
    var pred_args = preds[i].split(/\s*\(|\)\s*/);
    var pred = pred_args[0];
    var args = [];
    for(var j=1; j < pred_args.length; j++) {
      if(pred_args[j] != undefined && pred_args[j] != "") {
        var terms = pred_args[j].split(/\s*\,\s*/);
        for(var k=0; k < terms.length; k++) {
          if(terms[k] != "") args.push(terms[k]);
        } // looping over terms within arguments
      } // looping over predicate arguments
    } // looping over atoms
    tokens.push({pred: pred, args: args});
  }
  return tokens;
}


var source = "character(abby) character(boris) character(chris) character(duncan) character(ellie) character(frank) character(gina) character(holly) character(ivan) character(jane) character(kevin) character(liz) character(mike) character(nick) character(ophelia) character(paul) character(quincy) character(rose) character(susan) character(tyler) character(uther) character(veronica) character(wanda) character(xavier) character(yolanda) character(zach) character(murderer) character(victim) attribute(man) attribute(smoker) attribute(drinker) attribute(knewVictim) attribute(isLeftHanded) attribute(ownsGun) attribute(tall) attribute(fat) attribute(hasWound) attribute(wearsGlasses) attribute(hasCane) attribute(frequentsBar) attribute(shopCustomer) attribute(redHair) attribute(inLoveWithVictim) attrValue(true) attrValue(false) clueChoice(loveLetter) canLearn(loveLetter,hasAttr(murderer,inLoveWithVictim,true)) clueChoice(revolver) canLearn(revolver,hasAttr(murderer,ownsGun,true)) clueChoice(twoEmptyWhiskeys) canLearn(twoEmptyWhiskeys,hasAttr(murderer,drinker,true)) canLearn(twoEmptyWhiskeys,hasAttr(murderer,knewVictim,true)) clueChoice(cigaretteSmoke) canLearn(cigaretteSmoke,hasAttr(murderer,smoker,true)) clueChoice(receipt) canLearn(receipt,hasAttr(murderer,drinker,true)) canLearn(receipt,hasAttr(murderer,smoker,true)) actionChoice(unlockingBox) canFind(unlockingBox,revolver) canFind(unlockingBox,loveLetter) actionChoice(lookBody) canFind(lookBody,twoEmptyWhiskeys) canFind(lookBody,receipt) canFind(lookBody,cigarette) actionChoice(digTrash) canFind(digTrash,twoEmptyWhiskeys) canFind(digTrash,receipt) victim(abby) murderer(ophelia) hasAttr(victim,man,true) hasAttr(abby,man,true) cast(abby) cast(ellie) hasAttr(ellie,man,false) cast(liz) hasAttr(liz,man,false) cast(nick) hasAttr(nick,man,false) cast(ophelia) hasAttr(ophelia,man,false) cast(tyler) hasAttr(tyler,man,false) cast(uther) hasAttr(uther,man,false) hasAttr(murderer,man,false) hasAttr(victim,ownsGun,true) hasAttr(abby,ownsGun,true) hasAttr(ellie,ownsGun,true) hasAttr(liz,ownsGun,true) hasAttr(nick,ownsGun,true) hasAttr(ophelia,ownsGun,false) hasAttr(tyler,ownsGun,false) hasAttr(uther,ownsGun,true) hasAttr(murderer,ownsGun,false) hasAttr(victim,frequentsBar,true) hasAttr(abby,frequentsBar,true) hasAttr(ellie,frequentsBar,false) hasAttr(liz,frequentsBar,false) hasAttr(nick,frequentsBar,false) hasAttr(ophelia,frequentsBar,false) hasAttr(tyler,frequentsBar,false) hasAttr(uther,frequentsBar,false) hasAttr(murderer,frequentsBar,false) hasAttr(victim,redHair,false) hasAttr(abby,redHair,false) hasAttr(ellie,redHair,false) hasAttr(liz,redHair,false) hasAttr(nick,redHair,false) hasAttr(ophelia,redHair,true) hasAttr(tyler,redHair,false) hasAttr(uther,redHair,false) hasAttr(murderer,redHair,true) learn(loveLetter,hasAttr(murderer,inLoveWithVictim,true)) clue(loveLetter) learn(talkedTo(abby,ownsGun),hasAttr(abby,ownsGun,true)) learn(revolver,hasAttr(murderer,ownsGun,true)) clue(revolver) learn(talkedTo(ellie,ownsGun),hasAttr(ellie,ownsGun,true)) learn(talkedTo(liz,ownsGun),hasAttr(liz,ownsGun,true)) learn(talkedTo(nick,ownsGun),hasAttr(nick,ownsGun,true)) learn(talkedTo(ophelia,ownsGun),hasAttr(ophelia,ownsGun,false)) learn(talkedTo(tyler,ownsGun),hasAttr(tyler,ownsGun,false)) learn(talkedTo(uther,ownsGun),hasAttr(uther,ownsGun,true)) gameattribute(man) gameattribute(ownsGun) gameattribute(frequentsBar) gameattribute(redHair) action(unlockingBox) find(unlockingBox,revolver) find(unlockingBox,loveLetter)"

// expects m[i][j] = "token" where "token" is a key in the table
function draw_map(m, width, height, cast) {
  mapstring = "";

  for(var i=0; i<height; i++) {
    mapstring += cast[i] + "   ";
    for(var j=0; j<width; j++) {
      if(m[i] != undefined && m[i][j] != undefined) {
        var entity = m[i][j];
        //var ch = token_table[entity];
        var ch = m[i][j] == "true" ? "1 " : "0 ";
        mapstring += ch;
        if(ch == undefined) {
          console.log("Unable to find a char for ["+entity+"]");
        }
      } else {
        mapstring += "."
      }
    }
    mapstring+="\n";
  }
  mapstring += "\n";

  return mapstring;
}

/* Generate something same size as the source, starting from the same word
 * as the source. */
function generate () {

  var atoms = tokenize(source);
  var {map, width, height, cast, attrs} = atoms_to_tables(atoms);
  var map_string = draw_map(map, width, height, cast);

  return map_string + attrs;
}

//converts atoms to tiles. Relevant atoms are cast/1, gameattribute/1, hasAttr/3
function atoms_to_tables(atoms) {
  hasAttr = [];

  const cast = atoms.filter(a => a.pred == "cast" && a.args[0] != "victim" && a.args[0] != "murderer").map(a => a.args[0]);
  const attrs = atoms.filter(a => a.pred == "gameattribute").map(a => a.args[0]);

  var hasAttr = new Array(cast.length);
  for (var i = 0; i < hasAttr.length; i++) {
    hasAttr[i] = []
  }

  const hasAttrs = atoms.filter(a => a.pred == "hasAttr" && a.args[0] != "victim" && a.args[0] != "murderer");
  for (var i = 0; i < hasAttrs.length; i++) {
     var args = hasAttrs[i].args;
     var c = cast.indexOf(args[0]);
     var a = attrs.indexOf(args[1]);
     var v = args[2];
     hasAttr[c][a] = v
  }
  return {map:hasAttr, width:attrs.length, height:cast.length, cast:cast, attrs:attrs};
}
