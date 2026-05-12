
import 'package:flutter/material.dart';

// add provider for state management
import 'package:provider/provider.dart';
// local pages
import 'package:wordel/bagels_page.dart';
import 'package:wordel/home_page.dart';
import 'package:wordel/app_state.dart';
import 'package:wordel/kniffel_page.dart';
import 'package:wordel/user_page.dart';
import 'wordle_page.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wordl',
        theme: ThemeData(          
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: MyHomePage(),
        
      ),
    );
  }
}




class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Widget page;
    switch(appState.pageIndex) {
      case 0:
        page = HomePage();
        break;
      case 1:
        page = WordlePage();
        break;
      case 2:
        page = KniffelPage();
        break;
      case 3:
        page = UserPage();
        break;
      case 4:
        page = BagelsPage();
      default:
        // should never happen, but guard anyway
        throw UnimplementedError('no widget for ${appState.pageIndex}');
    }

    return Scaffold(
      body: page, // Hier wird die Seite "ausgetauscht"
    );
  }
}






