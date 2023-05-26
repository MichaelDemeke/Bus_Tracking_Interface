import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:tracker/constants.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'constants.dart';

class MyMap extends StatefulWidget {
  final String bus_id;
  // final WebSocketChannel channel;
 // MyMap(this.bus_id,this.channel);
//  const MyMap({super.key, required this.bus_id, required this.channel});
 const MyMap({super.key, required this.bus_id});
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;
late LatLng buslocation;
late LatLng initiallocation;


//static  const LatLng sourcelocation = LatLng();
//static const LatLng buslocation = LatLng();

List <LatLng> polylineCoordinates = [];

WebSocketChannel channel = new IOWebSocketChannel.connect("ws://echo.websocket.org");

request(){
    channel.sink.add(widget.bus_id);
}

late var locationBus;

void getPolyPoints() async {
  PolylinePoints polylinePoints = PolylinePoints();
  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  google_api_key, 
  PointLatLng(buslocation.latitude, buslocation.longitude),
  PointLatLng(initiallocation.latitude, initiallocation.longitude),
  );
  if (result.points.isNotEmpty){
    result.points.forEach((PointLatLng point) => 
    polylineCoordinates.add(LatLng(point.latitude, point.longitude))
    );
  setState(() {});
  }
}

@override
void initState() {
  request();
  initiallocation = sourcelocation();
  getPolyPoints();
  super.initState();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: StreamBuilder(
      stream: channel.stream,             //FirebaseFirestore.instance.collection('location').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) { //  AsyncSnapshot <QuerySnapshot> snapshot)
        if (_added) {
          mymap( snapshot);
        }
        setState(() {
             buslocation = LatLng(snapshot.data!.docs.singleWhere((element) => element.id == widget.bus_id)['latitude'], 
             snapshot.data!.docs.singleWhere((element) => element.id == widget.bus_id)['longitude']);
                             
        });
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return GoogleMap(
          // mapType: MapType.normal,
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
                position: LatLng(
                 snapshot.data!.docs.singleWhere((element) => element.id == widget.bus_id)['latitude'],
                  snapshot.data!.docs.singleWhere((element) => element.id == widget.bus_id)['longitude'],
                ),
                markerId: MarkerId('bus'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta)
            ),
          
              Marker(
                position: sourcelocation,
                markerId: MarkerId('initial'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta)
            ),
          },
          initialCameraPosition: CameraPosition(
              target: LatLng(
                snapshot.data!.docs.singleWhere((element) => element.id == widget.bus_id)['latitude'],
                snapshot.data!.docs.singleWhere((element) => element.id == widget.bus_id)['longitude'],
              ),
              zoom: 14.5),
          onMapCreated: (GoogleMapController controller) async {
            setState(() {
              _controller = controller;
              _added = true;
            });
          },
        );
      },
    ));
  }
//  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
  Future<void> mymap(AsyncSnapshot snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere((element) => element.id == widget.bus_id)['latitude'],
              snapshot.data!.docs.singleWhere((element) => element.id == widget.bus_id)['longitude'],
            ),
            zoom: 14.47)));
  }
  assign() {

  }
}
