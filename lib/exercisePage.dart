import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/src/painting/text_style.dart' as style;

class ExercisePage extends StatefulWidget {
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
  }

  void deleteMarkersAndPolyline() {
    polylineCoordinates.clear();
    polylines.remove('poly');
    polylines.clear();
    markers.remove('origin');
    markers.remove('destination');
    markers.clear();
    setState(() {});
  }

  void addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 3);
    polylines[id] = polyline;
    setState(() {});
  }

  void _makeLines(
      originlat, originlong, destinationlat, destinationlong) async {
    await polylinePoints
        .getRouteBetweenCoordinates(
      'AIzaSyCXWqU2ungN9ZlraT9M-2HfoJYG7nd-3OA',
      PointLatLng(originlat, originlong),
      PointLatLng(destinationlat, destinationlong),
      travelMode: TravelMode.walking,
    )
        .then((value) {
      value.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }).then((value) {
      addPolyLine();
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  var _placeDistance;

  @override
  Widget build(BuildContext context) {
    var counter = 0;
    CollectionReference exerciseStart =
        FirebaseFirestore.instance.collection('exercise');
    Future<void> startExercise(lat, long, now) {
      counter = counter + 1;
      return exerciseStart
          .add({'latitude': lat, 'longitude': long, 'date': now})
          .then((value) => print("Started!"))
          .catchError((error) => print("$error"));
    }

    return SafeArea(
      child: Scaffold(
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
              var lastCoordinates = {};
              lastCoordinates['latitude'] = snapshot.data.docs[0]['latitude'];
              lastCoordinates['longitude'] = snapshot.data.docs[0]['longitude'];
              // print(lastCoordinates);
              var lat1 = lastCoordinates['latitude'];
              var long1 = lastCoordinates['longitude'];
              var lat2, long2, firsttime;

              void _getData() async {
                await FirebaseFirestore.instance
                    .collection("exercise")
                    .orderBy('date', descending: true)
                    .limit(1)
                    .get()
                    .then((QuerySnapshot snapshot) {
                  snapshot.docs.forEach((DocumentSnapshot document) {
                    lat2 = document.data()['latitude'];
                    long2 = document.data()['longitude'];
                    firsttime = document.data()['date'];
                  });
                });
              }

              void _drawRoute(counter) {
                for (var i = 1; i <= counter; ++i) {
                  _makeLines(
                    snapshot.data.docs[i - 1]['latitude'],
                    snapshot.data.docs[i - 1]['longitude'],
                    snapshot.data.docs[i]['latitude'],
                    snapshot.data.docs[i]['longitude'],
                  );
                }
              }

              _getData();

              _addMarker(LatLng(lat1, long1), "origin",
                  BitmapDescriptor.defaultMarker);

              String _textAfterWorkout() {
                if (_placeDistance != null) {
                  return "Workout finished! Your average route distance is " +
                      _placeDistance.toString() +
                      "km !";
                } else {
                  return "Press start and then stop to register the workout!";
                }
              }

              var lasttime;

              return Container(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(18),
                      child: Text(
                        "This is the exercise page! Here you can track your workout and watch the traveled route during your exercise.",
                        style: style.TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target: LatLng(lastCoordinates['latitude'],
                                lastCoordinates['longitude']),
                            zoom: 15),
                        myLocationEnabled: true,
                        tiltGesturesEnabled: true,
                        compassEnabled: true,
                        scrollGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                        onMapCreated: _onMapCreated,
                        markers: Set<Marker>.of(markers.values),
                        polylines: Set<Polyline>.of(polylines.values),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          child: ElevatedButton(
                            child: Text("Start!"),
                            onPressed: () {
                              deleteMarkersAndPolyline();
                              firsttime = new DateTime.now();
                              startExercise(lat1, long1, firsttime);
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: ElevatedButton(
                            child: Text("Stop!"),
                            onPressed: () {
                              lasttime = new DateTime.now();
                              counter =
                                  lasttime.second - firsttime.toDate().second;
                              var diff = lasttime
                                  .difference(firsttime.toDate())
                                  .inSeconds;
                              // print(diff);
                              double totalDistance = 0.0;
                              totalDistance +=
                                  calculateDistance(lat1, long1, lat2, long2);
                              setState(() {
                                _placeDistance =
                                    totalDistance.toStringAsFixed(2);
                                // print('DISTANCE: $_placeDistance km');
                              });
                              _addMarker(LatLng(lat2, long2), "destination",
                                  BitmapDescriptor.defaultMarker);
                              _makeLines(lat1, long1, lat2, long2);
                              // _drawRoute(diff);
                              // diff=0;
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: ElevatedButton(
                            child: Text("Clear!"),
                            onPressed: () {
                              deleteMarkersAndPolyline();
                            },
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        _textAfterWorkout(),
                        style: style.TextStyle(
                          color: Colors.black,
                          fontSize: 20,
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

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }
}
