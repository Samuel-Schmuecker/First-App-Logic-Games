
import 'package:flutter/material.dart';

// add provider for state management
import 'package:provider/provider.dart';
// local pages
import 'package:wordel/04_Bagels/bagels_page.dart';
import 'package:wordel/01_Home/home_page.dart';
import 'package:wordel/04_Bagels/bagels_provider.dart';
import 'package:wordel/app_state.dart';
import 'package:wordel/03_Kniffel/kniffel_page.dart';
import 'package:wordel/01_Home/user_page.dart';
import '02_Wordle/wordle_page.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (context) => MyAppState()),
      ChangeNotifierProvider(create: (context) => BagelsProvider())
      ],
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






