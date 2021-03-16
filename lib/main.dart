import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(app());
}

class app extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print('error bro!!!');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WordFinder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xffF40009),
        accentColor: Color(0xff1E1E1E),
        scaffoldBackgroundColor: Color(0xff898F9C),
      ),
      home: Finder(),
    );
  }
}
class Finder extends StatefulWidget {
  @override
  _FinderState createState() => _FinderState();
}

class _FinderState extends State<Finder> {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

