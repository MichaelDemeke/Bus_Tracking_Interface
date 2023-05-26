import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:web_socket_channel/io.dart';

const String google_api_key = "AIzaSyBHlhe_UE7UVQ4m580F_H4XNigtfjldJOQ";
const Color primaryColor = Color(0xFF7B61FF);
const Color theamColor = Color(0XFF3D82AE);
const double defaultPadding = 16.0;
IOWebSocketChannel channelweb = IOWebSocketChannel.connect("ws://echo.websocket.org");
const kDefaultPaddin = 28.0;
const picpaddin= 25.0;


late LatLng locationinitialStation;

void initialStation(x){
  locationinitialStation= x;
}

get sourcelocation{
  return locationinitialStation;
}