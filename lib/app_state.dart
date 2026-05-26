

import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wordel/02_Wordle/database_helper.dart';
import 'package:wordel/03_Kniffel/kniffel_logic.dart';
import 'package:wordel/03_Kniffel/player.dart';
import 'package:flutter/foundation.dart';

class User {
  String name;
  int scoreWordle;
  IconData icon;
  User(this.name, this.scoreWordle,  {this.icon=Icons.person} );
}

class MyAppState extends ChangeNotifier {

  // DAS HIER IST DER KONSTRUKTOR
  MyAppState() {
    getWord(); // Wird sofort beim Start ausgeführt
    if (kIsWeb) {
      // Wenn wir im Web sind, überspringen wir die sqflite-Initialisierung
      debugPrint("Web-Modus: sqflite wird übersprungen!");
      users = [User("Guest",0)];
      activeUser = users[0];
    } else {
      // Nur auf Android/iOS wird die Datenbank geladen
      readUsers();
      _forceOpenDB();
    }
    
  }
  void _forceOpenDB() async {
  final db = await DatabaseHelper.instance.database;
  debugPrint("Datenbank Pfad: ${db.path}"); // Das zwingt die App, die DB zu laden
  }

  // Seite wecheseln/auswählen
    int pageIndex = 0;
    void setPageIndex(int newIndex){
      pageIndex = newIndex;
      notifyListeners();
    }

  // Users
  void readUsers()async{
    users = await DatabaseHelper.instance.readAllUsers();
    if (users.isEmpty){
      users = [User("Guest",0)];
      await DatabaseHelper.instance.createUser(User("Guest",0));
      
    }
    activeUser = users[0];
  }

  var users =<User> [];
  User activeUser =User("name", 99);

  void addUser(String name) async {
    var  newUser = User(name,0);
    users.add(newUser);
    if (kIsWeb == false) {await DatabaseHelper.instance.createUser(newUser);}
    notifyListeners();
  }
  void deleteUser(int index)async{
     if (kIsWeb == false) {await DatabaseHelper.instance.deleteUserDB(users[index]);}
    users.removeAt(index);
   
  }

  void setIcon(IconData icon, int userIndex){
    users[userIndex].icon = icon;
    notifyListeners();
  }
  
  void setActiveUser(int index){
    activeUser = users[index];
  }

  // iconAnzeige
  CircleAvatar getIcon(BuildContext context, int userIndex){
    if (users[userIndex].icon == Icons.person){
      return CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Text(
          users[userIndex].name[0], // Nimmt den ersten Buchstaben
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      );
    }
    else{
      return CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(users[userIndex].icon),
      );
       
    }
   
  }

  // Wordle
  String aktuelleEingabe = "";
  var guesses = <String>[]; 
  
  var versuch = 0; // In welcher Zeile sind wir gerade?
  String word = "AAAAA";

  List wordListe = List.generate(6, (_) => "AAAAA".split('').map((b) => b.toUpperCase()).toList());
  List farbwahlListe = List.generate(6, (_) => List.filled(5, Colors.black));


  String getWord(){ 
    //Zurücksetzen
    guesses.clear();
    versuch = 0;

    var einZufallsWort = WordPair.random().first;
    word = "";
    bool generate = true;
    while (generate){
      if (einZufallsWort.length == 5){
        word = einZufallsWort;
        generate = false;
      } else{
        einZufallsWort = WordPair.random().first;
      }
    }
    // Erzeugt eine Liste in für jeden guess 
    //eine Liste mit de maktuellen wort(gesplittet) ist
    wordListe = List.generate(6, (_) => word.split('').map((b) => b.toUpperCase()).toList());
    farbwahlListe = List.generate(6, (_) => List.filled(5, Colors.black));
    /*wordListe = [[],[],[],[],[],[]]; 
    for(List l in wordListe ){
      for (var b in word.split('')){
        l.add(b.toUpperCase());
      }
    }
    

    // Erzeuge eine standard Farbliste
    farbwahlListe = [[],[],[],[],[],[]]; 
    for(List fl in farbwahlListe ){
      for (int b = 0; b<5;b++ ){ // um es fünf mal zu machen
        fl.add( Colors.black);
      }
    }
    notifyListeners();*/
    debugPrint(word);
    return word;
  
  }

  // Eingegebenes Wort zu guesses hinzufügen
  void addGuess(String eingabe){
    if (versuch < 6 ){
      guesses.add(eingabe.toUpperCase());
      
      notifyListeners();
    
    

    // Farbe festlegen:
    int i = 0;
    
    while (i<5){
      if (guesses[versuch][i] == wordListe[versuch][i]){
        farbwahlListe[versuch][i] = Colors.green;
        wordListe[versuch][i] = "0";
      } 
      i++;
    }
    i = 0;
    while (i<5){
       if (wordListe[versuch].contains(guesses[versuch][i])){
        int index = wordListe[versuch].indexOf(guesses[versuch][i]);
        wordListe[versuch][index]="0";
        farbwahlListe[versuch][i] = Colors.orange;
      
      }
      i++;
    } 
    versuch++;
  }
  }

  // Wordl score
  void addScore()async{
    if (versuch == 1){
      activeUser.scoreWordle+= 100;
    }else if (versuch == 2){
      activeUser.scoreWordle+= 50;
    }else if (versuch == 3){
      activeUser.scoreWordle+= 40;
    }else if (versuch == 4){
      activeUser.scoreWordle+= 30;
    }else if (versuch == 5){
      activeUser.scoreWordle+= 20;
    }else if (versuch == 6){
      activeUser.scoreWordle+= 10;
    }
    if (kIsWeb == false){
      await DatabaseHelper.instance.addScoreDB(activeUser);
      debugPrint(versuch.toString());
    }
    notifyListeners();
  }



//
//
//
// Kniffel
  List<IconData> aktuellerWurf = [FontAwesomeIcons.diceOne,FontAwesomeIcons.diceOne,FontAwesomeIcons.diceOne,FontAwesomeIcons.diceOne,FontAwesomeIcons.diceOne];
  List<int> aktuellerWurfAlsZahl =[1,1,1,1,1];
  bool amWuerfel = false;
  bool gewuerfelt =false;
  List<bool> wurfelBehalten = [false,false,false,false,false];
  int anzahlWuerfe = 0;
  List<IconData> dices = [FontAwesomeIcons.diceOne,
    FontAwesomeIcons.diceTwo,
    FontAwesomeIcons.diceThree,
    FontAwesomeIcons.diceFour,
    FontAwesomeIcons.diceFive,
    FontAwesomeIcons.diceSix];

  var player1 = Player(name: "Player 1", color: Colors.deepOrange,active: true);
  var player2 = Player(name: "Player 2", color: Colors.deepPurple);

  bool spielBegonnen = false;
  int eingetrageneFelder = 0;



  Widget knAuswahlIcon(int col,int row){
    List kniffelIcons = 
      [FaIcon(FontAwesomeIcons.diceOne),
      FaIcon(FontAwesomeIcons.diceTwo),
      FaIcon(FontAwesomeIcons.diceThree),
      FaIcon(FontAwesomeIcons.diceFour),
      FaIcon(FontAwesomeIcons.diceFive),
      FaIcon(FontAwesomeIcons.diceSix),
      Text("BONUS\n   +35"),
      Icon(Icons.looks_3_outlined),
      Icon(Icons.looks_4_outlined),
      Icon(Icons.home),
      Text("SMALL"),
      Text("LARGE"),
      Icon(Icons.looks_5_outlined),
      Icon(Icons.question_mark_rounded)
      ];
    return kniffelIcons[row+7*(col)] ;
  }  

  void wuerfeln()async{
    spielBegonnen = true;
    if (anzahlWuerfe<3) { 
      amWuerfel = true;
      for (int i=0;i<6;i++){
        for (int k=0;k<5;k++){
          if (wurfelBehalten[k] == false){
            int wuerfel = Random().nextInt(6);
            aktuellerWurf[k] = dices[wuerfel];
            aktuellerWurfAlsZahl[k] = wuerfel+1;  // da 0-5 zu 1-6
          }
          notifyListeners();
        }
          await Future.delayed(Duration(milliseconds: 500));
      }
      amWuerfel = false;
      gewuerfelt =true;
      anzahlWuerfe++;
    }
  }

  void keepDice(int k){
    if (amWuerfel == false && gewuerfelt){
      if (wurfelBehalten[k]){
        wurfelBehalten[k] = false;
      }else{
        wurfelBehalten[k] = true;
      }
    }
    notifyListeners();
  }

  AlertDialog kniffelAuswerteButtonpressed (BuildContext context, int col,int row){
    int pos = row+(col*7);  //für die erste reihe spalte icht col immer null
    int punktezahl = 0;
    String anzeigeText = "";

    if(pos!=6){
      // prüfen ob übehaut gewürfelt wurde
      if(gewuerfelt == true&& amWuerfel == false){ 
        //prüfen ob feld schon belegt
        if ((player1.active && (player1.belegteFelder[pos]==false))||
            player2.active && (player2.belegteFelder[pos]==false)){
          
          punktezahl = KniffelLogic.punkteAuswertung(aktuellerWurfAlsZahl,col,row); 
          anzeigeText = KniffelLogic.getAnzeigetextAuswertung(pos);
          return AlertDialog( 
            title: Text("Are you sure?"),
            content: Text("$punktezahl Points in $anzeigeText eintagen?"),
            actions: [
              TextButton(onPressed: (){punkteEintragen(punktezahl,row,col);Navigator.of(context).pop(true);}, child: Text("Yes")),  // Punkte eintragen
              TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Cancel")) //Abbrechen
            ],  
          );
        }else{
          return AlertDialog(
          title: Text("Feld schon belegt!!"),
          actions: [TextButton(onPressed:(){ Navigator.of(context).pop();}, child: Text("Exit"))],
        );
        }

      // Falls noch nicht gewürfelt wurde 
      }else{
        return AlertDialog(
          title: Text("Erst würfeln!!"),
          actions: [TextButton(onPressed:(){ Navigator.of(context).pop();}, child: Text("Exit"))],
        );
      }

      //Dialog für Bonus
    }else{
      return AlertDialog(
          title: Text("Bonus ab 63 Punkten"),
          actions: [TextButton(onPressed:(){ Navigator.of(context).pop();}, child: Text("Exit"))],
        );
    }
  }

  

  // Punkte in das Grid eintragen
  void punkteEintragen(int punkte, int row, int col){
    int pos = row+(col*7);  //für die erste reihe spalte icht col immer null

    if (player1.active){
      player1.anzeigePunkte[col][row] = punkte.toString();
      player1.punkteInt[col][row] = punkte;
      player1.gesamtPunkte += punkte;
      player1.belegteFelder[pos] = true;
      player1.active = false;
      player2.active = true;
      resetWurf();
    }else if (player2.active){
      player2.anzeigePunkte[col][row] = punkte.toString();
      player2.punkteInt[col][row] = punkte;
      player2.gesamtPunkte += punkte;
      player2.belegteFelder[pos] = true;
      player2.active = false;
      player1.active = true;
      resetWurf();
    }
    eingetrageneFelder++;
    pruefenObBonus();
    notifyListeners();
  }

  void spielerAuswahl(String name){
    if (player1.nameGewaehlt == false){
      player1.name = name;
      player1.nameGewaehlt = true;
    } else if(player2.nameGewaehlt == false){
      player2.name = name;
      player2.nameGewaehlt = true;
    }
    notifyListeners();
  }

  void spielerAbwahl(String name){
    if (player1.name == name){
      player1.name = "Player 1";
      player1.nameGewaehlt = false;
    } else if (player2.name == name){
      player2.name = "Player 2";
      player2.nameGewaehlt = false;
    }
    notifyListeners();

  }

  String getPlayer1oder2(String name){
    String playerName = "";
    if (player1.name == name){
      playerName = "Player 1";
    } else if (player2.name == name){
      playerName = "Player 2";
    } else{
      playerName = "";
    }
    return playerName;
  }

  void resetWurf(){
    anzahlWuerfe = 0;
    aktuellerWurf = List.filled(5,FontAwesomeIcons.diceOne);
    aktuellerWurfAlsZahl = [1,1,1,1,1];
    wurfelBehalten = List.filled(5, false);
    gewuerfelt = false;
  }

  void resetKniffel(){
    resetWurf();
    player1 = Player(name: "Player 1", color: Colors.deepOrange,active: true);
    player2 = Player(name: "Player 2", color: Colors.deepPurple);
    spielBegonnen = false;
    eingetrageneFelder = 0;
    notifyListeners();
  }

  void pruefenObBonus(){
    if (player1.active){
      int count=0;
      for(int i=0;i<6;i++){
        if(player1.belegteFelder[i]){
          count++;
        }
      }
      if(count==6){
        int summe =0;
        for(int punkte in player1.punkteInt[0]){
          summe+=punkte;
        }
        if(summe>=63){
          player1.anzeigePunkte[0][6]= "35";
        }else{
          player1.anzeigePunkte[0][6] = "0";
        }
      }
    }else if (player2.active){
      int count=0;
      for(int i=0;i<6;i++){
        if(player2.belegteFelder[i]){
          count++;
        }
      }
      if(count==6){
        int summe =0;
        for(int punkte in player2.punkteInt[0]){
          summe+=punkte;
        }
        if(summe>=63){
          player2.anzeigePunkte[0][6]= "35";
        }else{
          player2.anzeigePunkte[0][6] = "0";
        }
      }
    }
  
  }

}