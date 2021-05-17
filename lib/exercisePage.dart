import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;

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
      PointLatLng(originlat, originlong), //Starting LATLANG
      PointLatLng(destinationlat, destinationlong), //End LATLANG
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

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference exerciseStart =
        FirebaseFirestore.instance.collection('exercise');
    Future<void> startExercise(lat, long, now) {
      // Call the user's CollectionReference to add a new user
      return exerciseStart
          .add({'latitude': lat, 'longitude': long, 'date': now})
          .then((value) => print("Started!"))
          .catchError((error) => print("$error"));
    }

    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('stats')
              .orderBy('date', descending: true)
              .limit(2)
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
              var lat1 = lastCoordinates['latitude'];
              var long1 = lastCoordinates['longitude'];
              var lat2, long2;

              void _getData() async {
                await FirebaseFirestore.instance
                    .collection("exercise")
                    .limit(1)
                    .get()
                    .then((QuerySnapshot snapshot) {
                  snapshot.docs.forEach((DocumentSnapshot document) {
                    lat2 = document.data()['latitude'];
                    long2 = document.data()['longitude'];
                  });
                });
              }

              _getData();

              _addMarker(
                  LatLng(lastCoordinates['latitude'],
                      lastCoordinates['longitude']),
                  "origin",
                  BitmapDescriptor.defaultMarker);
              return Container(
                // margin: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Text("EXERCISE PAGE!"),
                    Expanded(
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
                        ElevatedButton(
                          child: Text("Start!"),
                          onPressed: () {
                            polylineCoordinates.clear();
                            // polylines.remove('poly');
                            var now = new DateTime.now();
                            startExercise(lat1, long1, now);
                          },
                        ),
                        ElevatedButton(
                          child: Text("Stop!"),
                          onPressed: () {
                            print(lat2);
                            print(long2);
                            _addMarker(LatLng(lat2, long2), "destination",
                                BitmapDescriptor.defaultMarker);
                            _makeLines(lat1, long1, lat2, long2);
                          },
                        ),
                      ],
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
