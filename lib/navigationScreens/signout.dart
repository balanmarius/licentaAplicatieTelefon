import 'package:FitbitApp/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../loginpage.dart';

class Signout extends StatefulWidget {
  @override
  _SignoutState createState() => _SignoutState();
}

class _SignoutState extends State<Signout> {
  final channel = IOWebSocketChannel.connect('ws://127.0.0.1:3000/');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          // return Text(snapshot.hasData ? '${snapshot.data}' : '');
          return ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(30),
                child: Text(
                  "If you choose to sign out, next time you will need to write the credentials again when entering the app! Are you sure you want to sign out?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 18.0,
                  clipBehavior: Clip.antiAlias,
                  color: Colors.blue[400],
                  child: MaterialButton(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    minWidth: double.infinity,
                    child: Text(
                      'Sign out',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    textColor: Colors.white,
                    color: Colors.blue[400],
                    onPressed: () async {
                      Navigator.pop(context,
                          MaterialPageRoute(builder: (context) => Loginpage()));
                      await FirebaseAuth.instance.signOut();
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
