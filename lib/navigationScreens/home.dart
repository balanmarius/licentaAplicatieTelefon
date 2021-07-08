import 'package:FitbitApp/accelPage.dart';
import 'package:FitbitApp/exercisePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web_socket_channel/io.dart';
import '../findWatch.dart';
import '../stepsDetails.dart';
import 'package:geolocator/geolocator.dart';
import '../hrDetails.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final channel = IOWebSocketChannel.connect('ws://127.0.0.1:3000/');

  Future _showNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'FitbitApp',
      'HR too big',
      platformChannelSpecifics,
      payload: 'You may want to slow down',
    );
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  initState() {
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("Details"),
          content: Text("$payload"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('stats')
            .orderBy('date', descending: true)
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            var steps;
            var lastHR;
            snapshot.data.docs.forEach(
              (DocumentSnapshot document) {
                if (document.data()['HR'] == "unavailable") {
                  lastHR = 0;
                } else {
                  lastHR = document.data()['HR'];
                }

                if (lastHR > 170) {
                  // print(lastHR);
                  _showNotification();
                } else {
                  // print(lastHR);
                }
                steps = document.data()['steps'];
              },
            );

            return ListView(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/steps.png',
                            filterQuality: FilterQuality.high),
                        Text(
                          steps.toString(),
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900]),
                        ),
                        Text(
                          'STEPS',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900]),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  // color: Colors.blue[100],
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                      child: ListView(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Material(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              elevation: 18.0,
                              clipBehavior: Clip.antiAlias,
                              color: Colors.blue[400],
                              child: MaterialButton(
                                height: 50,
                                minWidth: double.infinity,
                                child: Text(
                                  'Steps data',
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                                textColor: Colors.white,
                                color: Colors.blue[400],
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StepsDetails()),
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                                  'Heart Rate data',
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                                textColor: Colors.white,
                                color: Colors.blue[400],
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HrDetails()),
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                                  'Accelerometer data',
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                                textColor: Colors.white,
                                color: Colors.blue[400],
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AccelPage()),
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                                  'Find my watch!',
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                                textColor: Colors.white,
                                color: Colors.blue[400],
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FindWatch()),
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                                  'Create an exercise!',
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                                textColor: Colors.white,
                                color: Colors.blue[400],
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ExercisePage()),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            itemCount: snapshot.data.docs.length,
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
