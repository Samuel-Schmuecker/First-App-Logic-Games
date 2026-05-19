import 'package:wordel/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordlePage extends StatelessWidget{
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    
    void zeigeVerloren(BuildContext context, String loesung){
      showDialog(context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text("Leider verloren 😞"),
          content: Text("$loesung wäre die Lösung geswesen"),
          actions: <Widget>[
            TextButton(
              child: Text("Try again!"),
              onPressed: (){
                Navigator.of(context).pop();
                appState.addScore();
                appState.getWord();
                
              }
              )
          ],
        );
      }
      );
    }
    void zeigeGewonnenDialog(BuildContext context, String loesung) {
      showDialog(              // Erzeugt das Fenster mit abgedunkeltem hintegrund
        context: context,
        barrierDismissible: false, // Macht, dass man nicht rausklicken kann
        builder: (BuildContext context){
          return AlertDialog(     // Standar widget von flutter
          title: const Text('Glückwunsch! 🎉'),
          content: Text('Du hast das Wort $loesung erraten!'),
          actions: <Widget>[    // Liste von buttons die unten rechts erscheint
            TextButton(
              child: Text("Restart"),
              onPressed: (){
                appState.addScore();
                appState.getWord();
                Navigator.of(context).pop(); // schließt das feld
                

              }, 
            ),
          ], 
          );
        }
      );
    }
    
    

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Stack(
      children: [
        Column(         
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.all(20),
              child: 
              
              // Row mit Text und Playbutton
              Row(
               mainAxisAlignment: MainAxisAlignment.center,
                children: [ 
                  // Zurück zu home
                  IconButton(
                    onPressed: (){appState.setPageIndex(0);},
                    icon: Icon(Icons.arrow_back),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,),
                    ),
                  SizedBox(width: 50),

                  Text("Generate a Word",),
        
                  SizedBox(width: 50),

                  //Anzeigen des Benutzers
                  IconButton(
                    // Dialogfeld mit Nutzername anzeigen  
                    onPressed: (){showDialog(context: context, builder: (BuildContext conntext){
                      return AlertDialog(
                          title: Text(appState.activeUser.name),
                      );
                    });}, 

                    icon: appState.getIcon(context, appState.users.indexOf(appState.activeUser)))

                  // Word generieren 
                  /*
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                  
                    onPressed: () {
                      appState.word = appState.getWord();
                    },
        
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,),
                    )
                    */
                   
                ],
                
                )
            ),
        
            Expanded(
              child: 
              
              // Das Grid
              GridView.count(
                crossAxisCount: 5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              
                padding: EdgeInsets.only(left: 20,right: 20),
                children: [
                  for(int i =0;i<30;i++)
                    Builder(builder: (context){
                      int row = i ~/5;
                      int col = i%5;

                      String buchstabe = "";
                      // Erst prüfen, ob die Zeile überhaupt da ist
                      if (row < appState.guesses.length) {
                        // Dann prüfen, ob das Wort in der Zeile lang genug ist
                        if (col < appState.guesses[row].length) {
                            buchstabe = appState.guesses[row][col];
                        }
                      }
                    
                    return Container(
                      
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius:BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                          width: 2
                        )
                      ),
                      child: Center(
                        child: Text(
                          buchstabe.toUpperCase(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                              color: appState.farbwahlListe[row][col],
                            ),
                          ),
                      ),
                    );  
                    },
                    )
                ],
              ) 
            ),
          
          
        

        // Eingabebutton
        ElevatedButton(
          
            child: Text("Input",style: TextStyle(fontSize: 20)),
            
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true, // Wichtig, damit die Tastatur das Fenster nicht verdeckt
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom, // Schiebt alles über die Tastatur
                        left: 20, right: 20, top: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: myController,
                          maxLength: 5, 
                          autofocus: true,
                          decoration: InputDecoration(hintText: "5 Letters..."),
                          ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            appState.addGuess(myController.text);
                            // Prüfen ob das Word korekt ist 
                            if (appState.word.toUpperCase() == myController.text.toUpperCase()){
                              Navigator.pop(context);
                              zeigeGewonnenDialog(context, appState.word.toLowerCase());
                              myController.clear();
                            }
                            // Prüfen ob man schon verloren hat 
                            else if (appState.versuch >=6) {
                              myController.clear();
                              Navigator.pop(context);
                              zeigeVerloren(context, appState.word.toUpperCase());
                            }else 
                            {
                            myController.clear();
                            Navigator.pop(context); // um eingabefeld zu schließen
                            }
                             },
                             child: Text("submit"),
                              ),
                        
                        SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              );
            },

            ),
            SizedBox(height: 50,)
          ]
        ),
      ],
    ),

    );

  } 
}