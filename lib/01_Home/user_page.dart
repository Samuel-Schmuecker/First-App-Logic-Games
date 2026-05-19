import 'package:flutter/material.dart';
import 'package:wordel/app_state.dart';
import 'package:provider/provider.dart';



class UserPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer ,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Stack(
              children: [
                Column(           
                  children: [
                    // Die obere zwile mit überschrift und zurck
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                      
                      onPressed: (){appState.setPageIndex(0);},
                      icon: Icon(Icons.arrow_back),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,),
                      ),
                      SizedBox(width: 100),
                      Text("User",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),  
                      ),
                      SizedBox(width: 100),
                      SizedBox(width: 24 )// soll einen zweiten button darstellen
                  ]),
                
                  // liste der Benutzer
                    Expanded(
                      child: ListView.builder(
                        itemCount: appState.users.length,
                        itemBuilder: (context, index){
                          var user = appState.users[index];
                          return Card(
                            
                            child: 
                            
                          Dismissible( 

                            key: Key(user.name),
                            direction: user.name == "Guest"
                            ? DismissDirection.none
                            : DismissDirection.startToEnd,
                            
                            onDismissed: (direction) {
                              
                                appState.deleteUser(index);
                                // infotext
                                ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${user.name} gelöscht")));
                              
                            },

                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),

                            child: ListTile(

                              // Avater oder Buchstabe
                               
                              leading: appState.getIcon(context, index),
                
                              // Name des Users
                              title: Text(user.name),
                              subtitle: Text("Wordlescore: ${user.scoreWordle.toString()}"),
                
                              trailing: Icon(Icons.chevron_right),
                
                              onTap: () {
                                
                                appState.setActiveUser(index);
                                appState.setPageIndex(0);
                                debugPrint(appState.activeUser.name);
                              },

                              // Custom Icon einfügen
                              onLongPress: () {
                                showDialog(
                                  context: context, 
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: Text("Choose an Icon"),
                                      content: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.min,
                                        children:[
                                          IconButton(
                                            onPressed: (){ 
                                             appState.setIcon(Icons.wb_sunny, index); 
                                             Navigator.pop(context);} , 
                                            icon: Icon(Icons.wb_sunny)
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              appState.setIcon(Icons.sentiment_very_satisfied,index);
                                              Navigator.pop(context);}, 
                                            icon: Icon(Icons.sentiment_very_satisfied)
                                          ),
                                          IconButton(
                                          onPressed: () {
                                            appState.setIcon(Icons.android,index);
                                            Navigator.pop(context);}, 
                                          icon: Icon(Icons.android)
                                          ),
                                        ],
                                      ),
                                    ); // Schließt AlertDialog
                                  }, // Schließt Builder
                                ); // Schließt showDialog
                              }, // Schließt onLongPress
                
                            )
                          )
                          );
                        }
                        
                        )
                      
                    )
                
                  ],
                ),

                // User hinzufügen
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // Wir brauchen einen Controller, um den Text später auszulesen
                          TextEditingController userController = TextEditingController();

                          return AlertDialog(
                            title: Text("New User"),
                            content: TextField(
                              controller: userController,
                              decoration: InputDecoration(hintText: "Enter Name..."),
                              autofocus: true, // Tastatur öffnet sich sofort
                            ),
                            actions: [
                              TextButton(
                                child: Text("cancel"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              ElevatedButton(
                                child: Text("save"),
                                onPressed: () {
                                  // Hier die Logik zum Speichern:
                                  String name = userController.text;
                                  if (name.isNotEmpty) {
                                    appState.addUser(name); // Nutzer hinzufügen
                                    Navigator.pop(context); // Fenster schließen
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },

                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                    child: Icon(Icons.add)
                  )
                )

              ],
            )
          ),
      )
    );
  }
}
