//import 'package:flutter/material.dart';

import 'package:flutter/src/material/dropdown.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Station {
   int id;
   String station_name;
   double longitude;
   double latitude; 
   int route;
   
  Station({
    required this.id,
    required this.station_name,
    required this. longitude,
    required this.latitude,
    required this.route

  });

}
