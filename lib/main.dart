import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'homepage.dart';
import 'package:dcdg/dcdg.dart';
import 'loginpage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    new MaterialApp(home: new MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                User user = snapshot.data;

                if (user == null) {
                  return Loginpage();
                } else {
                  return Homepage();
                }
              }

              return Scaffold(
                body: Center(
                  child: Text('Checking authentication...'),
                ),
              );
            },
          );
        }

        return Scaffold(
          body: Center(
            child: Text('Connecting to the app..'),
          ),
        );
      },
    );
  }
}
