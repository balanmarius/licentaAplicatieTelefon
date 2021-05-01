import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/gpsBar.dart';
import 'package:loginapp/liveStepsPanel.dart';
import '../stepsBar.dart';


class Home extends StatelessWidget {
  // var _totalSteps = 0;
  //pentru a arata datele si a calcula nr total pasi din vector
  // void _sumSteps() {
  //   FirebaseFirestore.instance
  //       .collection('stats')
  //       .orderBy("date")
  //       .snapshots()
  //       .listen((data) {
  //     data.docs.forEach((element) {
  //       print(DateTime.parse(element['date'].toDate().toString()));
  //       setState(() {
  //         _totalSteps += element['steps'];
  //       });
  //     });
  //     print(_totalSteps);
  //   });
  // }

  // void _resetSteps() {
  //   _totalSteps = 0;
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            LiveStepsPanel(),
            StepsBar(),
            GpsBar(),
            // MaterialButton(
            //   onPressed: () async {
            //     await FirebaseAuth.instance.signOut();
            //   },
            //   child: Text('Sign out'),
            // ),
          ],
        ),
      ),
    );
  }

  void setState(Null Function() param0) {}
}
