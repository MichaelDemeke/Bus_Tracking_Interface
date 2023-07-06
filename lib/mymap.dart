import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'constants.dart';

class MyMap extends StatefulWidget {
  final String user_id;
  MyMap(this.user_id);
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  LatLng initallocation = LatLng(9.02240,38.80004); //Adey Abeba
  LatLng destinationlocation = LatLng(9.06264,38.76127); //Arada
 // LatLng currentLocation = LatLng(8.96339,38.76319) ;
  //final loc.Location location = loc.Location();
  //late GoogleMapController _controller;
  bool _added = false;
  List <LatLng> polylineCoordinates = [];
  //LatLng currentLocation = LatLng(8.95373,38.76347);
  final Completer <GoogleMapController> _controller = Completer();
 LocationData? currentLocation;

  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

void getCurrentLocation() async{
  
  Location location = Location();
  
    location.getLocation().then((location){
    currentLocation = location;
  },
  );

GoogleMapController googleMapController = await _controller.future;

  location.onLocationChanged.listen((newLoc) {
    setState(() {
      currentLocation = newLoc;
    });
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        zoom: 14.5,
        target: LatLng(
        newLoc.latitude!, newLoc.longitude!))
    )
    );
    setState(() {});
    }
  );
}



void getPolyPoints() async {
  PolylinePoints polylinePoints = PolylinePoints();
  
  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  google_api_key, 
  PointLatLng(initallocation.latitude , initallocation.longitude) ,
  PointLatLng(destinationlocation.latitude , destinationlocation.longitude)
  );
  if (result.points.isNotEmpty){
    result.points.forEach((PointLatLng point) => 
    polylineCoordinates.add(LatLng(point.latitude, point.longitude))
    );
  setState(() {});
  }
}

  @override
  void initState(){
    getCurrentLocation();
     _listenLocation();
     getPolyPoints();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
   
    super.initState();
  }

  @override
  // Future<void>dispose() async {
  //       await FirebaseFirestore.instance.collection('location').doc('bus80').set({
  //       'latitude': currentLocation?.latitude,
  //       'longitude': currentLocation?.longitude,
  //       'isActive': false,
  //     }, SetOptions(merge: true));
  //   super.dispose();
  // }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Addis Ababa City Bus Enterprise", style:TextStyle(color: Colors.white),),
        backgroundColor: theamColor,
      ),
    body: currentLocation == null
    ? Center(child: const CircularProgressIndicator())
    :GoogleMap(
          mapType: MapType.normal,
        polylines: {
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: primaryColor,
            width: 6,  
          )
        },
          markers: {
            Marker(
                position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
                markerId: MarkerId('currentLoc'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue)),


             Marker(
                position: initallocation,
                markerId: MarkerId('initialRoute'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueViolet)),


             Marker(
                position: destinationlocation,
                markerId: MarkerId('DestinationRoute'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueMagenta)),
          },
          initialCameraPosition: CameraPosition(
              target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
              zoom: 14.47),
          onMapCreated: (mapController) {
            _controller.complete(mapController);
          },
        ),
   );
   
  }
    Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(" the error on the firebase is ${onError}");
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('location').doc('bus80').set({
        'latitude': currentLocation?.latitude,
        'longitude': currentLocation?.longitude,
        'isActive': true
      }, SetOptions(merge: true));
    });
  }
}
