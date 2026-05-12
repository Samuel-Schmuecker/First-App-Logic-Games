class KniffelLogic {

  

  static String getAnzeigetextAuswertung(int pos){
    List<String> anzeigeTextAuswertung = ["1er","2er","3er","4er","5er","6er","Bonus",
          "3er Pasch","4er Pasch","Full House","kleine Straße","große Straße","Kniffel","Chance"];
    return anzeigeTextAuswertung[pos];
  }

  static int punkteAuswertung(List wurf, int col, int row){
    int pos = row+col*7; // gibt pos 0-13
    switch (pos){
      case 0: case 1: case 2: case 3: case 4: case 5:
        return punkteAuswertung1_6(wurf, (pos+1)); 
      case 7: case 8:
        return punkteAuswertung3_4Pasch(wurf, (pos-4));
      case 9:
        return punkteAuswertungFullHouse(wurf);
      case 10:
        return punkteAuswertungKleineStrasse(wurf);
      case 11:
        return punkteAuswertungGrosseStrasse(wurf);
      case 12:
        return punkteAuswertungKniffel(wurf);
      case 13:
        return punkteAuswertungChance(wurf);
      default:
        return 0;
    }
  }

  static int punkteAuswertung1_6(List wurf, int zahl){
    int auswertung = 0;

    for (int dice in wurf){
      if (dice==zahl){
        auswertung += zahl;
      }
    }
    return auswertung;
  }

  static int punkteAuswertung3_4Pasch(List wurf,int pasch){
    int auswertung = 0;
    int count =0;
    int vergleich =0;

    for(int dice in wurf){
      vergleich = dice;
      for(int d in wurf){
        if (d == vergleich){
          count++;
        }
      }
      if (count >= pasch){break;} else {count = 0;}
    }
    if (count >= pasch){
      for(int dice in wurf){
        auswertung += dice;
      }
    }
    return auswertung;
  }

  static int punkteAuswertungFullHouse(List wurf){
    int auswertung = 0;
    int count =0;
    int vergleich =0;
    int paschZahl = 0;

    //prüfen ob drei gleich sind wie bei 3er Pasch
    for(int dice in wurf){
      vergleich = dice;
      for(int d in wurf){
        if (d == vergleich){
          count++;
          paschZahl = d;
        }
      }
      if (count == 3){break;} else {count = 0;}
    }    

    if (count == 3){
    // prüfen ob die anderen 2 auch gleich sind
      List coppywurf = wurf.toList();
      coppywurf.removeWhere((dice) => dice==paschZahl);//die drei gleichen löschen
      if (coppywurf.length==2) {   // sicherstellen, dass noch zwei elemente das sind
        if(coppywurf[0]==coppywurf[1]){
            auswertung = 25;
        }
      }
    }
    return auswertung;
  }

  static int punkteAuswertungKleineStrasse(List wurf){
    int auswertung = 0;
    if (wurf.contains(3) && wurf.contains(4)){
      if ((wurf.contains(1) && wurf.contains(2))||
          wurf.contains(2) && wurf.contains(5)||
          wurf.contains(5) && wurf.contains(6)){
            auswertung = 30;
          }
    } 
    return auswertung;
  }

  static int punkteAuswertungGrosseStrasse(List wurf){
    int auswertug =0;
    if(wurf.contains(2)&&wurf.contains(3)&&wurf.contains(4)&&wurf.contains(5)){
      if(wurf.contains(1)||wurf.contains(6)){
        auswertug = 40;
      }
    }
    return auswertug;
  }

  static int punkteAuswertungKniffel(List wurf){
    int auswertug =50;
    int vergleich = wurf[0];
      for (int d in wurf){
        if (vergleich != d){
          auswertug = 0;
          break;
        }
      }
    return auswertug;
  }

  static int punkteAuswertungChance(List wurf){
    int auswertug = 0;
    for (int d in wurf){
      auswertug += d;
    }
    return auswertug;
  }


}