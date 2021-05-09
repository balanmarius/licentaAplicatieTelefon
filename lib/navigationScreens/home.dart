import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loginapp/hrDetails.dart';
import 'package:loginapp/liveStepsPanel.dart';
import '../gpsDetails.dart';
import '../stepsDetails.dart';
import 'package:loginapp/stepsDetails.dart';
import 'package:geolocator/geolocator.dart';
import '../hrDetails.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        LiveStepsPanel(),
        Container(
          color: Colors.blue[100],
          height: MediaQuery.of(context).size.height * 0.4,
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
                          borderRadius: BorderRadius.circular(22.0)),
                      elevation: 18.0,
                      clipBehavior: Clip.antiAlias,
                      color: Colors.blue[400],
                      child: MaterialButton(
                        height: 50,
                        minWidth: double.infinity,
                        child: Text(
                          'View your steps statistics',
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
                          borderRadius: BorderRadius.circular(22.0)),
                      elevation: 18.0,
                      clipBehavior: Clip.antiAlias,
                      color: Colors.blue[400],
                      child: MaterialButton(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        minWidth: double.infinity,
                        child: Text(
                          'HR',
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
                          borderRadius: BorderRadius.circular(22.0)),
                      elevation: 18.0,
                      clipBehavior: Clip.antiAlias,
                      color: Colors.blue[400],
                      child: MaterialButton(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        minWidth: double.infinity,
                        child: Text(
                          'GPS',
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
                                builder: (context) => GpsDetails()),
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
}
