import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:starflut/starflut.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:math' show cos, sqrt, asin;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  GoogleMapController mapController;

  Map<MarkerId, Marker> markers = {};

  @override
  void initState() {
    super.initState();

    /// origin marker
    _addMarker(
        LatLng(6.2514, 80.7642), "origin", BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(6.9271, 79.8612), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    makeLines();
  }

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

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

  void makeLines() async {
    await polylinePoints
        .getRouteBetweenCoordinates(
      'AIzaSyCXWqU2ungN9ZlraT9M-2HfoJYG7nd-3OA',
      PointLatLng(47.16663166666667, 27.560335), //Starting LATLANG
      PointLatLng(47.161550009661596, 27.560575380921364), //End LATLANG
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
    var _placeDistance;
    double totalDistance = 0.0;
    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += _coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }
    setState(() {
      _placeDistance = totalDistance.toStringAsFixed(2);
      print('DISTANCE: $_placeDistance km');
    });

    return SafeArea(
      child: Scaffold(
          body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(47.16663166666667, 27.560335), zoom: 15),
        myLocationEnabled: true,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: _onMapCreated,
        markers: Set<Marker>.of(markers.values),
        polylines: Set<Polyline>.of(polylines.values),
      )),
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
