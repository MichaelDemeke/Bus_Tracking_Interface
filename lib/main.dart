import 'package:flutter/material.dart';
import 'package:tracker/constants.dart';
import 'package:tracker/driver.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:web_socket_channel/io.dart';

import 'chooseStation.dart';



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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(bodyColor: theamColor),
       visualDensity: VisualDensity.adaptivePlatformDensity,),
      home: 
    chooseStation()
    
   // MyMap(bus_id: "2")
    
    
    );
  }
}




