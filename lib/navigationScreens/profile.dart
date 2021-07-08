import 'package:FitbitApp/goals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController myController = new TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

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

                if (user != null) {
                  return SafeArea(
                    child: Scaffold(
                      body: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('stats')
                            .orderBy('date', descending: true)
                            .limit(1)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasData) {
                            var steps;
                            var calories;
                            var floors;
                            var distance;
                            var activeMinutes;
                            snapshot.data.docs
                                .forEach((DocumentSnapshot document) {
                              steps = document.data()['steps'];
                              calories = document.data()['calories'];
                              floors = document.data()['floors'];
                              distance = document.data()['distance'];
                              activeMinutes = document.data()['active minutes'];
                            });

                            return Scaffold(
                              backgroundColor: Colors.blue[100],
                              body: ListView(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                    child: Center(
                                      child: Text(
                                        "Hello,",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 28,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child: Center(
                                      child: Text(
                                        user.email,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                                    child: Text(
                                      "Let's see some facts about your today's activity:",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('goals')
                                        .doc('steps goal')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        // print(snapshot.data['value']);
                                        var currentstepsgoal =
                                            snapshot.data['value'];
                                        var diffsteps =
                                            int.parse(currentstepsgoal) - steps;
                                        String messageStepsGoal() {
                                          if (diffsteps > 0) {
                                            return diffsteps.toString() +
                                                " steps to reach daily goal!";
                                          } else {
                                            return "Daily goal completed!";
                                          }
                                        }

                                        return Container(
                                          margin: EdgeInsets.all(20),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.directions_walk,
                                                      size: 40,
                                                      color: Colors.orange[800],
                                                    ),
                                                    Text(
                                                      'Total steps: ' +
                                                          steps.toString(),
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Current goal: " +
                                                            currentstepsgoal,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        messageStepsGoal(),
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            image: new DecorationImage(
                                              fit: BoxFit.cover,
                                              colorFilter: new ColorFilter.mode(
                                                  Colors.black.withOpacity(0.5),
                                                  BlendMode.dstATop),
                                              image: new ExactAssetImage(
                                                  "assets/images/stepsanimation.gif"),
                                            ),
                                            border: Border.all(
                                              color: Colors.blue[300],
                                              width: 5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                  StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('goals')
                                        .doc('calories goal')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        // print(snapshot.data['value']);
                                        var currentCaloriesGoal =
                                            snapshot.data['value'];
                                        var diffcalories =
                                            int.parse(currentCaloriesGoal) -
                                                calories;
                                        String messageCaloriesGoal() {
                                          if (diffcalories > 0) {
                                            return diffcalories.toString() +
                                                " calories to reach daily goal!";
                                          } else {
                                            return "Daily goal completed!";
                                          }
                                        }

                                        return Container(
                                          margin: EdgeInsets.all(20),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .local_fire_department,
                                                      size: 40,
                                                      color: Colors.orange[900],
                                                    ),
                                                    Text(
                                                      'Burned calories: ' +
                                                          calories.toString(),
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Current goal: " +
                                                            currentCaloriesGoal,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        messageCaloriesGoal(),
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            image: new DecorationImage(
                                              fit: BoxFit.cover,
                                              colorFilter: new ColorFilter.mode(
                                                  Colors.black.withOpacity(0.5),
                                                  BlendMode.dstATop),
                                              image: new ExactAssetImage(
                                                  "assets/images/caloriesanimation.gif"),
                                            ),
                                            border: Border.all(
                                              color: Colors.blue[300],
                                              width: 5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.stairs_outlined,
                                            size: 40,
                                            color: Colors.yellow[600],
                                          ),
                                          Text(
                                            'Total floors: ' +
                                                floors.toString(),
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        colorFilter: new ColorFilter.mode(
                                            Colors.black.withOpacity(0.6),
                                            BlendMode.dstATop),
                                        image: new ExactAssetImage(
                                            "assets/images/stairsanimation.gif"),
                                      ),
                                      border: Border.all(
                                        color: Colors.blue[300],
                                        width: 5,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.directions_walk,
                                            size: 40,
                                            color: Colors.red[400],
                                          ),
                                          Text(
                                            'Total distance: ' +
                                                distance.toString() +
                                                "m",
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        colorFilter: new ColorFilter.mode(
                                            Colors.black.withOpacity(0.5),
                                            BlendMode.dstATop),
                                        image: new ExactAssetImage(
                                            "assets/images/walkinganimation.gif"),
                                      ),
                                      border: Border.all(
                                        color: Colors.blue[300],
                                        width: 5,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.directions_run,
                                            size: 40,
                                            color: Colors.red[800],
                                          ),
                                          Text(
                                            'Total Active Minutes: ' +
                                                activeMinutes.toString(),
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        colorFilter: new ColorFilter.mode(
                                            Colors.black.withOpacity(0.5),
                                            BlendMode.dstATop),
                                        image: new ExactAssetImage(
                                            "assets/images/runaanimation.gif"),
                                      ),
                                      border: Border.all(
                                        color: Colors.blue[300],
                                        width: 5,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                                    child: Material(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      elevation: 18.0,
                                      clipBehavior: Clip.antiAlias,
                                      color: Colors.blue[400],
                                      child: MaterialButton(
                                        height: 50,
                                        minWidth: double.infinity,
                                        child: Text(
                                          'Set up daily goals!',
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
                                                builder: (context) => Goals()),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                    ),
                  );
                }
              }

              return Scaffold(
                body: Center(
                  child: Text('Loading...'),
                ),
              );
            },
          );
        }

        return Scaffold(
          body: Center(
            child: Text('Loading...'),
          ),
        );
      },
    );
  }
}
