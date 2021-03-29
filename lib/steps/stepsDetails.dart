import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginapp/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/homepage.dart';

class StepsDetails extends StatefulWidget {
  @override
  _StepsDetailsState createState() => _StepsDetailsState();
}

class _StepsDetailsState extends State<StepsDetails> {
  // List<String> _stepsEachDay = [];
  // Future<List<String>> _stepsData() async {
  //   var i = 0;
  //   FirebaseFirestore.instance
  //       .collection('stats')
  //       .orderBy("date")
  //       .snapshots()
  //       .listen(
  //     (data) {
  //       print('start');
  //       data.docs.forEach(
  //         (element) {
  //           print(i);
  //           _stepsEachDay.add((element['date'].toDate().toString()));
  //           i++;
  //         },
  //       );
  //     },
  //   );
  //   return _stepsEachDay;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('stats').snapshots(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (streamSnapshot.hasData) {
            return Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      MaterialButton(
                        child: Text('Home'),
                        onPressed: () {
                          Navigator.pop(
                            context,
                            MaterialPageRoute(builder: (context) => Homepage())
                          );
                        },
                      ),
                      MaterialButton(
                        onPressed: () async {
                          Navigator.pop(
                            context,
                            MaterialPageRoute(builder: (context) => Loginpage())
                          );
                          await FirebaseAuth.instance.signOut();
                        },
                        child: Text('Sign out'),
                      ),
                    ],
                  ),
                  Text('Lungimea este ' +
                      streamSnapshot.data.docs.length.toString()),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: streamSnapshot.data.docs.length,
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.all(8),
              child: Text('This works'),
            ),
          );
        },
      ),
    );

  }
}

