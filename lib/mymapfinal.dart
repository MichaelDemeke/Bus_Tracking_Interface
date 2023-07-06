import 'dart:math' show cos, sqrt, asin;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:tracker/bus.dart';
import 'constants.dart';
import 'directions_model.dart';
import 'directions_repository.dart';

class MyMap extends StatefulWidget {
  final String user_id;
  final List<Buses> listBuses;
  final int index;
  MyMap(this.user_id, this.listBuses,this.index);
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;
LatLng initallocation = initialStationlocreturn; //Adey Abeba
 //LatLng currentLocation = LatLng(8.95373,38.76347); 
List <LatLng> polylineCoordinates = [];
Directions? _info;
late LatLng currentLoc;
String? distance;
String? duration;




Future<void> getPolyPoints(AsyncSnapshot<QuerySnapshot> snapshot) async {    
        
   PolylinePoints polylinePoints = PolylinePoints();

  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  google_api_key, 
  PointLatLng(initialStationlocreturn.latitude , initialStationlocreturn.longitude) ,
  PointLatLng( snapshot.data!.docs.singleWhere((element) => element.id == widget.user_id)['latitude'],
   snapshot.data!.docs.singleWhere((element) => element.id == widget.user_id)['longitude']
   )
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
 // currentbuslocation();
  //getPolyPoints();
  super.initState();
}

void dispose (){
  _controller.dispose();
  super.dispose();
}

Future<void> directions() async {
  final directions =  await DirectionsRepository()
     .getDirections(origin: currentLoc, destination: initialStationlocation);
        setState(() => _info = directions!);    


}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Addis Ababa City Bus Enterprise"),
      ),
        body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection('location').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (_added) {
          
    
           currentLoc = LatLng(
          snapshot.data!.docs.singleWhere((element) => element.id == widget.user_id)['latitude'],
         snapshot.data!.docs.singleWhere((element) => element.id == widget.user_id)['longitude'],
              );    
          
          mymap(snapshot); 
          directions();
                    // Get direction
            if(_info != null){
            distance = _info!.totalDistance;
            duration = _info!.totalDuration;
            }

            if (currentLoc == initialStationlocreturn || distance == "0 km") {
                _showMyDialog("The bus has arrivied to your location");
            }
            
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
            polylines: {
              if(_info != null)
              Polyline(
                polylineId: PolylineId("route"),
                points: _info!.polylinePoints.map((e) => 
                LatLng(e.latitude,e.longitude)).toList(),
                color: primaryColor,
                width: 6,  
              )
            },
              markers: {
            
                Marker(
                    position: LatLng(
                      snapshot.data!.docs.singleWhere((element) => element.id == widget.user_id)['latitude'],
                      snapshot.data!.docs.singleWhere((element) => element.id == widget.user_id)['longitude'],
                    ),
                    markerId: MarkerId('current '),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen),
                    infoWindow: InfoWindow(
                      title: double.parse( getDistance(
                        LatLng(
                      snapshot.data!.docs.singleWhere((element) => element.id == widget.user_id)['latitude'],
                      snapshot.data!.docs.singleWhere((element) => element.id == widget.user_id)['longitude'],
                    )
                      ).toStringAsFixed(2)).toString()
                    )
                        
                        ),
                  
                  
                  Marker(
                    position: initialStationlocreturn,
                    markerId: MarkerId('id'),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueMagenta)),
              },
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                    snapshot.data!.docs.singleWhere((element) => element.id == widget.user_id)['latitude'],
                    snapshot.data!.docs.singleWhere((element) => element.id == widget.user_id)['longitude'],
                  ),
                  zoom: 14.47),
              onMapCreated: (GoogleMapController controller) async {
                setState(() {
                  _controller = controller;
                  _added = true;
                });
              },
            ),
        if (_info != null)
        Container(
          child: Positioned(
            top: 20.0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 12.0,
              ),
              decoration: BoxDecoration(
                color: Colors.yellowAccent,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  )
                ],
              ), 
                   child: Text('${distance} , ${duration}',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              )
              ,
            )
          ),
        ) 
          ],
        
        );
        
      },
    )
  );
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere((element) => element.id == widget.user_id)['latitude'],
              snapshot.data!.docs.singleWhere((element) => element.id == widget.user_id)['longitude'],
            ),
            zoom: 14.47)));
  }
  double getDistance(LatLng destposition){
    return calculateDistance(initialStationlocation.latitude,initialStationlocation.longitude,
    destposition.latitude,destposition.longitude); 
  }
  double calculateDistance(lat1,lon1,lat2,lon2){
    var p = 0.0174532925199443295;
    var c = cos;
    var a = 0.5 - 
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 -lon1) * p)) /2;
        return 12742 * asin(sqrt(a)); 
  }
  Future<void> _showMyDialog( String x) async {
  String message = x;
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Success'),
        content:  SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
              Text('Press ok'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
}
          // decoration: BoxDecoration(
          //   image: DecorationImage(image: AssetImage("assets/5.png"))
          // )