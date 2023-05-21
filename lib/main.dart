
import 'package:flutter/material.dart';
import 'package:tracker/driver.dart';
import 'package:firebase_core/firebase_core.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: driver()
    );
  }
}




