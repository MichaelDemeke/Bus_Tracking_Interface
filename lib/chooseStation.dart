import 'dart:math';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:tracker/constants.dart';
import 'package:tracker/listofroute.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../api.dart';
import 'package:http/http.dart' as http;
//import 'package:busroutemap/api.dart';
import 'dart:convert';

import '../stations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'constants.dart';

class chooseStation extends StatefulWidget {
  final WebSocketChannel channel;
   chooseStation({super.key, required this.channel});

  @override
  State<chooseStation> createState() => _chooseStationState();
}

class _chooseStationState extends State<chooseStation> {
  final items = [
      'Asco Addis Sefer',
      'Bercheko',
      'Kawojj', 
      'Awoliya',
      'Winget',
      'fenans',
  ];
    final items2 = [
      'Asco Addis Sefer',
      'Bercheko',
      'Kawojj', 
      'Awoliya',
      'Winget',
      'fenans',
  ];
  List<Station> listStations = [];
  String?  selectedItem1;
  String?  selectedItem2;


  late LatLng initallocation;

  void fetchData() async {
    try {
      http.Response response = await http.get(Uri.parse(api));
      var data = jsonDecode(response.body);
      data.forEach((listStat) {
        // listStations.add(listStat);
        Station ls = Station(
            id: listStat['id'],
            name: listStat['name'],
            latitude: listStat['latitude'],
            longitude: listStat['longitude']);
        listStations.add(ls);
       // stationnames.add(listStat['name']);
      });
      // var data = response.body;
      // data = json.decode(data);
      // print(data);
      print(response.body.runtimeType);
    } catch (e) {
      print("Error is $e");
    }
    setState(() {
      selectedItem1 = "Asco Addis Sefer";
      selectedItem2 = "winget";
    });
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
          icon: SvgPicture.asset('assets/icons/back.svg'),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),      
      
        ),
        body:  
         Container(
          decoration: BoxDecoration(
            color: theamColor
          ),
          child: Column(

            children: [

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.90,
                child: Stack(
                  children: [

              Center(
                child: Container(
                      // height: MediaQuery.of(context).size.height * 0.25,
                     width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.28),
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.0, 
                        left: kDefaultPaddin, 
                         right: kDefaultPaddin,
                      ),
                        decoration: BoxDecoration(
                        color: Colors.grey,
                                   borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  )
                      ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             DefaultTextStyle(
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      //fontFamily: 'Dire_Dawa',
                                    ),
                                    textAlign: TextAlign.left,
                                    child: Text("Enter your Initial Point"),
                                  ),
                       
                          DropdownButton(
                            value: selectedItem1,
                            dropdownColor: primaryColor,
                            iconSize: 10.0,
                            items: listStations.map((item) => DropdownMenuItem<String>(
                                  value: item.name,
                                  child: Center(
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(
                                            fontSize: 19,
                                           // fontFamily: 'Dire_Dawa',
                                            color: Colors.brown,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                              onChanged: (item) => setState(() {
                              selectedItem1 = item;
                  
                            }),
                          ),
                          
                          // Drop down button
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                          child: Text ("Enter your desrination"),
                        ),
                          Container(
                            // width: MediaQuery.of(context).size.width * 0.50,
                            // height: MediaQuery.of(context).size.height * 0.10,
                            width: MediaQuery.of(context).size.width * 0.70,
                            height: MediaQuery.of(context).size.height * 0.04,
                         
                            child: DropdownButton<String>(
                              key: GlobalKey(debugLabel: selectedItem2),
                              value: selectedItem2,
                              dropdownColor: primaryColor,
                              iconSize: 10.0,
                              items: listStations.map((item) => DropdownMenuItem<String>(
                                      value: item.name,
                                    child: Center(
                                        child: Text(
                                          item.name,
                                          // style: const TextStyle(
                                          //     fontSize: 19,
                                          //    // fontFamily: 'Dire_Dawa',
                                          //     color: Colors.brown,
                                          //     fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                                onChanged: (item) => setState(() {
                                selectedItem2 = item;
                              }),
                            ),
                            
                          ),
             GestureDetector(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.55,
                            height: MediaQuery.of(context).size.height * 0.04,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.16),
                            decoration: BoxDecoration(color: Colors.green,
                          borderRadius: BorderRadius.all (Radius.circular(24),
                        )
                            ),
                        
                            child: DefaultTextStyle(
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      //fontFamily: 'Dire_Dawa',
                                    ),
                                    textAlign: TextAlign.center,
                                    child: Text('Enter'),
                                  ),
                        
                          ),
                          onTap: () {
                  
                            sendrequest();
                             Navigator.of(context).push(MaterialPageRoute(
                                 builder: (context) =>
                                    listroute(),
                                           
                            )
                                              );
                          },
                        )


                        
                        ]),
                      ),
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
          ),
        ),
      ),
    );
  }

  checkifselected(String? item) {
    if (item == selectedItem1) {
      return 1;
    } else {
      return 0;
    }
  }
  sendrequest() async{
 listStations.forEach((listStat){
      if(listStat.name == selectedItem1){
         initallocation =  LatLng(listStat.latitude as double, listStat.longitude as double);
      }
 });

initialStation(initallocation);
    try{
      var response = await http.post(
        Uri.parse("http://Addisbuss.onrender.com/api/distance"),
        body: {"initial": selectedItem1, "destination": selectedItem2}
      );
      print(response.body);
    }
    catch (e) {
      print(e);
    }
  }
}


            // GestureDetector(
            //               child: Container(
            //                 width: MediaQuery.of(context).size.width * 0.55,
            //                 height: MediaQuery.of(context).size.height * 0.04,
            //       margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.16),
            //                 decoration: BoxDecoration(color: Colors.green,
            //               borderRadius: BorderRadius.all (Radius.circular(24),
            //             )
            //                 ),
                        
            //                 child: DefaultTextStyle(
            //                         style: TextStyle(
            //                           fontSize: 15,
            //                           color: Colors.black,
            //                           //fontFamily: 'Dire_Dawa',
            //                         ),
            //                         textAlign: TextAlign.center,
            //                         child: Text('Enter'),
            //                       ),
                        
            //               ),
            //               onTap: () {
                  
            //                 sendrequest();
            //                  Navigator.of(context).push(MaterialPageRoute(
            //                      builder: (context) =>
            //                         listroute(),
                                           
            //                 )
            //                                   );
            //               },
            //             )
