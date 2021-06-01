import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart' as latLng;
import 'package:location/location.dart';
import 'package:permission/permission.dart';

import 'exercisePage.dart';
import 'main.dart';

class FindWatch extends StatefulWidget {
  @override
  _GpsDetailsState createState() => _GpsDetailsState();
}

class _GpsDetailsState extends State<FindWatch> {
  Marker marker;
  Circle circle;
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

  var phonePosition;
  Future<Position> _determinePosition() async {
    phonePosition = await Geolocator.getCurrentPosition();
    return phonePosition;
  }

  @override
  Widget build(BuildContext context) {
    _determinePosition();
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
              _addMarker(
                  LatLng(lastCoordinates['latitude'],
                      lastCoordinates['longitude']),
                  "origin",
                  BitmapDescriptor.defaultMarker);
              return Container(
                margin: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Text(
                      "Your actual position is shown on the map below.\nClick on the the button so you can navigate to the Fitbit Versa 2 watch.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
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
                    Container(
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton(
                        child: Text("Take me there!"),
                        onPressed: () {
                          _addMarker(
                              LatLng(phonePosition.latitude,
                                  phonePosition.longitude),
                              "destination",
                              BitmapDescriptor.defaultMarker);
                          print(phonePosition.latitude);
                          print(phonePosition.longitude);
                          _makeLines(
                              lastCoordinates['latitude'],
                              lastCoordinates['longitude'],
                              phonePosition.latitude,
                              phonePosition.longitude);
                          setState(() {});
                        },
                      ),
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
