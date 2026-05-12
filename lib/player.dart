import 'dart:ui';

class Player {
  String name;
  Color color;
  List<List<String>> anzeigePunkte;
  List<List<int>> punkteInt;
  int gesamtPunkte;
  bool active;
  List<bool> belegteFelder;
  bool nameGewaehlt;
  int scoreKniffel;

  Player({required  this.name, required this.color, this.active =false})
    : punkteInt = [[0,0,0,0,0,0,0],[0,0,0,0,0,0,0]],
     anzeigePunkte = [["","","","","","",""],["","","","","","",""]],
     gesamtPunkte = 0,
     belegteFelder = List.filled(14, false),
     nameGewaehlt = false,
     scoreKniffel =0
    ;
  
 

}