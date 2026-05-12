import 'package:flutter/material.dart';
import 'package:wordel/app_state.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer ,
      body: SafeArea(
        child: Stack(
          children: [Column(
            
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Games",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.primary
              ),
              ),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                    
                    // Wordlpage
                        ElevatedButton( 
                          onPressed: (){appState.setPageIndex(1);},
                          style: ElevatedButton.styleFrom(
                            iconSize: 75,
                            padding: EdgeInsets.symmetric(horizontal: 40,vertical: 40),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                          ),
                          child: Icon(Icons.abc),
                          ),
                    
                          SizedBox(width: 20),
                          
//Kniffel page
                          ElevatedButton( 
                          onPressed: (){appState.setPageIndex(2);},
                          style: ElevatedButton.styleFrom(
                            iconSize: 75,
                            padding: EdgeInsets.symmetric(horizontal: 40,vertical: 40),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                          ),
                          child: Icon(FontAwesomeIcons.dice),
                          )
                      ]
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
//Bagels page
                      children: [
                        ElevatedButton( 
                          onPressed: (){appState.setPageIndex(4);},
                          style: ElevatedButton.styleFrom(
                            iconSize: 75,
                            padding: EdgeInsets.symmetric(horizontal: 40,vertical: 40),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                          ),
                          child: Icon(Icons.pin),
                          ),

                          SizedBox(width: 20),    

                          ElevatedButton( 
                          onPressed: (){appState.setPageIndex(4);},
                          style: ElevatedButton.styleFrom(
                            iconSize: 75,
                            padding: EdgeInsets.symmetric(horizontal: 40,vertical: 40),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                          ),
                          child: Icon(Icons.cancel),
                          ),
                  ])
                  ],
                ),
              )
            ],
            
          ),

// Userauswahl
          Positioned(
            right: 15,
            height: 60,
            child: IconButton(
              onPressed: ()=> appState.setPageIndex(3), 
              icon: Icon(Icons.people),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                shape: CircleBorder()
              ),

              )
          )

          ], 
        )
      

    )
    );
  }
}
