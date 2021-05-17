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
    return StreamBuilder(
      stream: channel.stream,
      builder: (context, snapshot) {
        // return Text(snapshot.hasData ? '${snapshot.data}' : '');
        return Column(
          children: [
            MaterialButton(
              onPressed: () async {
                Navigator.pop(context,
                    MaterialPageRoute(builder: (context) => Loginpage()));
                await FirebaseAuth.instance.signOut();
              },
              child: Text('Sign out'),
            ),
          ],
        );
      },
    );
  }
}