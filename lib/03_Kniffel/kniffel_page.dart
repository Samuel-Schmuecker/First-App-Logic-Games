import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wordel/app_state.dart';
import 'package:provider/provider.dart';




class KniffelPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Color colorPlayer1 = appState.player1.color;    // da serh oft benutzt und so kürzer 
    Color colorPlayer2 = appState.player2.color;

    void showGewonnenDialog(){
      String anzeigeTitel = "";
      if(appState.player1.gesamtPunkte == appState.player2.gesamtPunkte){
        anzeigeTitel = "Es ist ein Unentschieden!?!?!";
      } else if (appState.player1.gesamtPunkte > appState.player2.gesamtPunkte){
        anzeigeTitel = "${appState.player1.name} hat Gewonnen!";
      } else{
        anzeigeTitel = "${appState.player2.name} hat Gewonnen!";
      }

      showDialog(context: context, builder: (BuildContext content){
        return AlertDialog(
          title: Text(anzeigeTitel),
        );
      });
    }
    

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer ,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20,),
        
              // Row mit den Spielern und deren Score
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  // Player 1
                  Card( 
                    color: appState.player1.active ? Colors.lightGreen.withValues(alpha: 0.5) : Colors.black26,
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0,right: 5),
                      child: Column( children: [
                        Text(appState.player1.name,style: TextStyle(color: colorPlayer1),),
                        Text(appState.player1.gesamtPunkte.toString(),style: TextStyle(color: colorPlayer1),) //Score
                      ],),
                    ),
                  ),
        
                  SizedBox(width: 10),
        
                  // VS anzeige
                  Card(
                    color: Colors.black26,
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 13,right: 13,top: 10,bottom: 10),
                      child:
                  Text("vs"),
                    )),
        
                  SizedBox(width: 10),
                  
                  // Player 2
                  Card( 
                    color: appState.player2.active ? Colors.lightGreen.withValues(alpha: 0.5) : Colors.black26,
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0,right: 5),
                      child: Column( children: [
                        Text(appState.player2.name,style: TextStyle(color: colorPlayer2),),
                        Text(appState.player2.gesamtPunkte.toString(),style: TextStyle(color: colorPlayer2),) //Score
                      ],),
                    ),
                  ),
                  
                ],
              ),
        
// Grid mit den Eintragepunkten
              Expanded(child:
              Card(
                elevation: 5,
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                  child: GridView.count(
                    childAspectRatio: 3.5,
                    crossAxisCount: 2,
                    
                    children: [
                      for(int i =0;i<14;i++)
                        Builder(builder: (context){
                          int row = i~/2;
                          int col = i%2;
                          
                            return Row(crossAxisAlignment: CrossAxisAlignment.center,
                            
                              children: [
                              // icon der reihe
                              IconButton(
                                onPressed:()async{ 
                                  final wurdeEingetragen = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context){
                                      return appState.kniffelAuswerteButtonpressed(context, col,row);
                                    }
                                  );
                                  //prüfen ob das Spiel vorbei ist 
                                  if(wurdeEingetragen == true){
                                    if(appState.eingetrageneFelder == 26){
                                      showGewonnenDialog();
//Siege zählen
                                      }
                                  }
                                }, 
                                icon: appState.knAuswahlIcon(col, row),
                                iconSize: 45,
                                padding: EdgeInsets.zero,
                              ),
        
                              SizedBox(width: 5),
        
                              // Player 1
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: colorPlayer1.withValues(alpha: 0.75),
                                  border: Border.all(color: colorPlayer1,width: 4),
                                ),
                                child: Text(appState.player1.anzeigePunkte[col][row],textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
                              ),
        
                              SizedBox(width: 7.5),
        
                              // Player 2
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),         
                                  color: colorPlayer2.withValues(alpha: 0.75),
                                  border: Border.all(color: colorPlayer2,width: 4),
                                ),
                                child: Text(appState.player2.anzeigePunkte[col][row],textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),

                              )
                            ]);
                          
                          
                        }),
                        
                    ],
                    )
                
                ),
              ),
        
// Aktuelle Würfel        
              Card(
                elevation: 5,
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int k =0;k<5;k++)
                        Builder(builder: (context){
                          return IconButton(
                            onPressed: (){appState.keepDice(k);}, 
                            icon: Icon(appState.aktuellerWurf[k]),
                            iconSize: 50,
                            color: appState.wurfelBehalten[k] ? Colors.brown.withValues(alpha: 0.7) : null,
                            
                              
                            
                          );
                        }
                        )
                    ],
                  ),
                
              ),

// Menü
              Card(
                elevation: 5,
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Restart
                      IconButton(
                            onPressed: (){ showDialog(context: context,
                             builder: (BuildContext context){
                              return AlertDialog(
                                title: Text("Reset Kniffel??"),
                                actions: [
                                  TextButton(onPressed:()=> Navigator.of(context).pop(), child: Text("NEIN")),
                                  TextButton(onPressed:(){ appState.resetKniffel(); Navigator.of(context).pop();}, child: Text("JA"))
                                ],
                              );
                             } 
                            );}, //onPressed
                            icon: Icon(FontAwesomeIcons.trash),
                            iconSize: 40,
                      ),

                      //Spielerauswahl
                      IconButton(
                            onPressed: (){
                              // benutzerauswahl nur möglich wenn spiel noch nicht begonnenhat
                              if(appState.spielBegonnen == false){ 
                              showDialog(context: context,
                               builder: (BuildContext context){
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      content: SizedBox(
                                        width: double.maxFinite,
                                        child: 
                                        ListView.builder(
                                          itemCount: appState.users.length,
                                          itemBuilder: (context, index){
                                            var user = appState.users[index];
                                            return ListTile(
                                              leading: Icon(user.icon),
                                              title: Text(user.name),
                                              onTap: () {appState.spielerAuswahl(user.name);setState((){});},
                                              onLongPress:(){appState.spielerAbwahl(user.name);setState((){});},
                                              trailing: Text(appState.getPlayer1oder2(user.name)),
                                            );
                                          },
                                        )
                                      )
                                    );
                               });
                                  });

                             }}, 
                            icon: Icon(FontAwesomeIcons.user),
                            iconSize: 40,
                      ),

                      // Würfeln 
                      IconButton(
                            onPressed: (){appState.wuerfeln();}, 
                            icon: Icon(FontAwesomeIcons.dice),
                            iconSize: 40,
                          ),
                        
                        
                    ],
                  ),
                
              )
          
            ],
            ),
          )
        ),

// Home Button
        Positioned(
          top: 28,
          left: 7.5,
          child: IconButton(
                      onPressed: (){appState.setPageIndex(0);},
                      icon: Icon(Icons.arrow_back),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,),
                        
              ),
        )
      ],
    );
  }
}
