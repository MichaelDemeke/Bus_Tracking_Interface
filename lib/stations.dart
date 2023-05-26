//import 'package:flutter/material.dart';

import 'package:flutter/src/material/dropdown.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Station {
   int id;
   String name;
  //  LatLng location {
  //   latitude;
  //   longitude;
  //  }
   LatLng longitude;
   LatLng latitude; 
   
  Station({
    required this.id,
    required this.name,
    required this. longitude,
    required this.latitude
  });

  map(DropdownMenuItem<String> Function(dynamic item) param0) {}

}
