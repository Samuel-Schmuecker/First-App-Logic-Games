import 'package:flutter/material.dart';
import 'package:wordel/app_state.dart';
import 'package:provider/provider.dart';



class BagelsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer ,
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Text("coming soon",style: TextStyle(fontSize: 30)),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: (){appState.setPageIndex(0);},
            child: Text("Home"))
      
        ],
      ),
    )
    );
  }
}
