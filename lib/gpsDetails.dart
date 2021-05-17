import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart' as latLng;
import 'package:location/location.dart';

import 'exercisePage.dart';
import 'main.dart';

class GpsDetails extends StatefulWidget {
  @override
  _GpsDetailsState createState() => _GpsDetailsState();
}

class _GpsDetailsState extends State<GpsDetails> {
  GoogleMapController _controller;
  Marker marker;
  Circle circle;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              var lastCoordinates = {};
              lastCoordinates['latitude'] = snapshot.data.docs[0]['latitude'];
              lastCoordinates['longitude'] = snapshot.data.docs[0]['longitude'];
              print(lastCoordinates);
              return Container(
                margin: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Text("Your actual position is here!"),
                    Expanded(
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target: LatLng(47.16663166666667, 27.560335),
                            zoom: 15),
                        myLocationEnabled: true,
                        tiltGesturesEnabled: true,
                        compassEnabled: true,
                        scrollGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                        },
                        markers: Set<Marker>.of(
                          <Marker>[
                            Marker(
                              onTap: () {
                                print('Tapped');
                              },
                              draggable: true,
                              markerId: MarkerId('Marker'),
                              position: LatLng(lastCoordinates['latitude'],
                                  lastCoordinates['longitude']),
                              onDragEnd: ((newPosition) {
                                print(newPosition.latitude);
                                print(newPosition.longitude);
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      child: Text("Create an exercise!"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExercisePage()),
                        );
                      },
                    )
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

  Widget getTextField(
      String inputBoxName, TextEditingController inputBoxController) {
    var loginBtn = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        controller: inputBoxController,
        decoration: new InputDecoration(
          hintText: inputBoxName,
        ),
      ),
    );

    return loginBtn;
  }
}
