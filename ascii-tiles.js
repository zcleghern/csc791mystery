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

function atoms_to_tiles(atoms) {
  var max_x = 0;
  var max_y = 0;
  var m = [];
  for (var i = 0; i < atoms.length; i++) {
    var p = atoms[i].pred;
    if (p == "sprite" || p == "at") {
      var args = atoms[i].args;
      var x = parseInt(args[0], 10);
      var y = parseInt(args[1], 10);
      // console.log("x= "+x+"; y = "+y);
      if(x > max_x) { max_x = x; }
      if(y > max_y) { max_y = y; }
      var entity = args[2];
      if(entity == undefined) {
        console.log("Atom number " + i);
        console.log("Args: " + args.toString());
        console.log("Undefined entity at "+x+", "+y+"!");
      }
      if(m[x] == undefined){
        var xrow = [];
        xrow[y] = entity;
        m[x] = xrow;
      } else {
        m[x][y] = entity;
      }
    }
  }
  console.log("Width: "+(max_x+1)+", Height: "+(max_y+1));
  return {map:m, width:max_x+1, height:max_y+1};
}


var source = "at(0,0,player) at(0,1,wall) at(0,2,gem) at(1,0,gem) at(1,1,wall) at(2,0,wall)  at(2,2,gem)"


token_table = 
{ "player": "@", 
  "wall":"W", 
  "gem":"*",
  "altar":"A",
  "":"."
}

// expects m[i][j] = "token" where "token" is a key in the table
function draw_map(m, width, height) {
  mapstring = "";

  for(var i=0; i<height; i++) {
    for(var j=0; j<width; j++) {
      if(m[i] != undefined && m[i][j] != undefined){
        var entity = m[i][j];
        var ch = token_table[entity];
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
  return mapstring;
}


/* Generate something same size as the source, starting from the same word
 * as the source. */
function generate () {

  var atoms = tokenize(source);
  var {map, width, height} = atoms_to_tiles(atoms);
  var map_string = draw_map(map, width, height);

  return map_string;

}
