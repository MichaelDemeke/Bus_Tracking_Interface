import 'package:flutter/material.dart';
import 'package:tracker/chooseStation.dart';
import 'package:tracker/constants.dart';
import 'package:tracker/driver.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tracker/map.dart';
import 'package:web_socket_channel/io.dart';



// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
//   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//     if (Platform.isAndroid) {
//       FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
//     }
//   });
// }

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(bodyColor: theamColor),
       visualDensity: VisualDensity.adaptivePlatformDensity,),
      home: 
    chooseStation(channel: new IOWebSocketChannel.connect("ws://echo.websocket.org"),)
    
   // MyMap(bus_id: "2")
    
    
    );
  }
}




