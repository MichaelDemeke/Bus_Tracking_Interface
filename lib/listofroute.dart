import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tracker/routes.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'api.dart';
import 'constants.dart';
import 'listbus.dart';
import 'package:http/http.dart' as http;
import '../routes.dart';

class listroute extends StatefulWidget {
  const listroute({super.key});

  @override
  State<listroute> createState() => _listrouteState();
}

class _listrouteState extends State<listroute> {
 late Map mapRespons;

List<Routes> listRoutes = [];

  void fetchData() async {
    try {
      http.Response response = await http.get(Uri.parse(api));
      var data = jsonDecode(response.body);
      data['route'].forEach((listRoute) {
        Routes r = Routes(
          route: listRoute['route'], 
          duration: listRoute['duration'], 
          distance: listRoute['distance']);
        listRoutes.add(r);
      });
      print(response.body.runtimeType);
    } catch (e) {
      print("Error is $e");
    }
    setState(() { });
  }
@override
  void initState() {
  
  fetchData();
  super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
      backgroundColor: theamColor,
      elevation: 0,
      leading: IconButton(
        // ignore: deprecated_member_use
        icon: SvgPicture.asset('assets/icons/back.svg', color: Colors.white),
        onPressed: () => Navigator.pop(context),
        ),  
      ),
        body : Container(
          decoration: BoxDecoration(
          color: theamColor
        ),
          child: Column(
            children: [
              SizedBox(
                 height: MediaQuery.of(context).size.height * 0.90,
                child: Stack(
                  children: [
                    Container(
                     margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.28),
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12, 
                  left: kDefaultPaddin, 
                  right: 0,
                ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  )
                ),
                      child: GridView.builder(
                          itemCount: listRoutes.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                child: Container(
                                  
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height * 0.25,
                                  margin: EdgeInsets.all(0),
                                  child: Column(
                                    children: [
                                        
                                        DefaultTextStyle(
                                          child: Text(listRoutes[index].route),
                                        style: const TextStyle(fontFamily: 'Dire_Dawa',
                                                fontSize: 24, color: Colors.brown, fontWeight: FontWeight.bold),
                                        ),
                                        
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DefaultTextStyle(
                                          child: Text(listRoutes[index].distance as String),
                                  
                                          style: const TextStyle(fontFamily: 'Dire_Dawa',
                                                fontSize: 24, color: Colors.brown, fontWeight: FontWeight.bold),
                                          ),  
                                        ),
                                        
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DefaultTextStyle(
                                          child: Text(listRoutes[index].duration as String),
                                  
                                          style: const TextStyle(fontFamily: 'Dire_Dawa',
                                                fontSize: 24, color: Colors.brown, fontWeight: FontWeight.bold),
                                          ),  
                                        )
                                    ],
                                  )
                                  
                                      
                                ),
                                onTap: () {
                                  sendrequest(index);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => 
                                          listbus(channel: channelweb),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                    ),


                            Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              // DefaultTextStyle(
              //          style: TextStyle(
              //               fontSize: 20,
              //              color: Colors.black,
              //                   fontWeight: FontWeight.normal),
              //                     textAlign: TextAlign.left,
              //                       child: Text('Addis Ababa City Bus Enterprise'),
              //       ),
       // SizedBox(height: kDefaultPaddin),
          Row(
            children: [
              RichText(text: TextSpan(
                children: [
                    TextSpan(text: "Welcome\n"), 
                    TextSpan(
                      text: "Addis Ababa City \n Bus Enterprise ", 
                      style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                                ),
                    )
                ],
              ),
              ),
            ]
          ), 

        SizedBox(height: 5),
          Row(
            children: [
              RichText(text: TextSpan(
                children: [
                    TextSpan(text: "List of\n"), 
                    TextSpan(
                      text: "Routes ", 
                      style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                                ),
                    )
                ],
              ),
              ),
              SizedBox(width:0), 
              Container(
                width: 250,
                height: 260,
                child: Expanded(child: 
                    Image.asset("assests/5.png", 
                    fit: BoxFit.fill,
                    ), 
                          ),
              ), 
            ]
          )
        ]
      )
              )
       ],
                
                ),
              ),
            ],
          )
        )
      ),
    );

    
  }
    sendrequest(int index) async{
    try{
      var request = await http.post(
        Uri.parse("http://Addisbuss.onrender.com/api/distance"),
        body: {"route": listRoutes[index].route}
      );
      print(request.body);
    }
    catch (e) {
      print(e);
    }
  }
}