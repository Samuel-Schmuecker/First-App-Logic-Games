def punkteAuswertungFullHouse (wurf:list):
  auswertung = 0
  count =0
  vergleich =0
  paschZahl = 0

#    prüfen ob drei gleich sind wie bei 3er Pasch
  for dice in wurf:
    vergleich = dice;
    for d in wurf:
      if d == vergleich:
        count+=1
        paschZahl = d
      
    if (count == 3):
      break
    else:
      count = 0
    

  if (count == 3):
    # prüfen ob die anderen 2 auch gleich sind
      for w in wurf:
        wurf.remove(paschZahl)   #//die drei gleichen löschen

      if (len(wurf)==2): #  // sicherstellen, dass noch zwei elemente das sind
        if(wurf[0]==wurf[1]):
          for dice in wurf:
            auswertung += dice
          
      


  return auswertung;
  

wurf = [1,1,1,3,3]

print(punkteAuswertungFullHouse(wurf))