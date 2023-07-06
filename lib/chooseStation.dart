import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracker/constants.dart';
import 'package:tracker/listofroutefinal.dart';
import 'package:tracker/routes.dart';
import 'package:http/http.dart' as http;

//import 'package:busroutemap/api.dart';
import 'dart:convert';

//import 'package:dropdown_search/dropdown_search.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../stations.dart';


class chooseStation extends StatefulWidget {
 
   chooseStation({super.key});

  @override
  State<chooseStation> createState() => _chooseStationState();
}

class _chooseStationState extends State<chooseStation> {
  List<Station> listStations = [];
   String?  selectedItem1;
   String? selectedItem2;
  List<Routes> listRoutes = [];
  
  late bool routefound = false;


  late LatLng initallocation;

  void fetchData() async {
    try {
      http.Response response = await http.get(Uri.parse("https://addisbuss.onrender.com/api/user/route/stations"));
      //http://Addisbuss.onrender.com/api/admin/stations
      var data = jsonDecode(response.body);
      data.forEach((listStat) {
        Station ls = Station(
            id: listStat['id'],
            station_name: listStat['station_name'],
            latitude: listStat['latitude'],
            longitude: listStat['longitude'],
            route: listStat['route']
            );
            setState(() {
                listStations.add(ls);
                
            });
      
      });
       print(data);
      print(response.body.runtimeType);
    } catch (e) {
      print("Error is $e");
    }
  }

  late String initialStationName;
  late String destiationStationName;

  final initStation = TextEditingController();
  final destinationStation = TextEditingController();

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
        ),
        body: Container(
          decoration: BoxDecoration(
            color: theamColor
          ),
          child: Container(
            width:  MediaQuery.of(context).size.width,
           height: MediaQuery.of(context).size.height * 0.83,
            child: Stack(
              children: [
          Center(
            child: Container(
                 width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.28),
                  // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.0, 
                  //   left: defaultPadding, 
                  //    right: 0,
                  // ),
                    decoration: const BoxDecoration(
                    color: Colors.white,
                               borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              )
                  ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.12,
                        ),
                         const DefaultTextStyle(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theamColor,
                                  //fontFamily: 'Dire_Dawa',
                                ),
                                textAlign: TextAlign.left,
                                child: Text("Enter your Initial Station"),
                              ),
                    
                              DropdownSearch<String>(
                            popupProps: PopupProps.menu(
                            showSelectedItems: true,
                            showSearchBox: true,
                              fit: FlexFit.loose,
                              disabledItemFn: (String s) => s.contains(selectedItem2.toString()),
                                  ),
                                items: List.from(listStations.map((element) => element.station_name)),
                                dropdownDecoratorProps: const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                              //labelText: "Menu mode",
                              hintText: "Century Mall_522 ",
                                  ),
                                ),
                              
                                
                              onChanged:(value) {
                              setState(() {
                                selectedItem1 = value;
                              });
                            },
                            
                            selectedItem: null,
                            
                              ),
                    
                    
                      
                      // Drop down button
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                      child: Text ("Enter your desrination station"),
                    ),
                    
                     DropdownSearch<String>(
                            popupProps: PopupProps.menu(
                            showSelectedItems: true,
                            showSearchBox: true,
                            fit: FlexFit.tight,
                               disabledItemFn: (String s) => s.contains(selectedItem1.toString()),
                            ),
                          items: List.from(listStations.map((element) => element.station_name)),
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                              //labelText: "Menu mode",
                              hintText: "Summit Mazoriya_1876",
                            ),
                          ),
                     
                          
                        onChanged:(value) {
                        setState(() {
                          selectedItem2 = value;
                        });
                      },
                      
                      selectedItem: null,
                      
                     ),
                               Center(
                             child: GestureDetector(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          height: MediaQuery.of(context).size.height * 0.04,
                                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.09),
                          decoration: const BoxDecoration(color: Colors.green,
                        borderRadius: BorderRadius.all (Radius.circular(24),
                      )
                          ),
                          child: const Center(
                            child: DefaultTextStyle(
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      //fontFamily: 'Dire_Dawa',
                                    ),
                                    textAlign: TextAlign.center,
                                    child: Text('Enter'),
                                  ),
                          ),
                      
                        ),
                        onTap: () async {
                              print(selectedItem1);
                          print(selectedItem2);
                            if(selectedItem1 ==null || selectedItem2 ==null){
                              _showMyDialog("All the fields are needed to be filled");
                            }
                            else{
                              sendrequest();
                                if(await sendrequest()){
                                    Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                    listroute(listRoutes),
                                )
                           );
                          }
                        }
                        },
                      ),
                    )                        
                                  ]),
                  ),
          ),
    
    
      Container(
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
      
          SizedBox(height: 65),
            Row(
              children: [
            RichText(text: TextSpan(
              children: [
                  TextSpan(text: "Enter \n"), 
                  TextSpan(
                    text: "Stations", 
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
            SizedBox(width:15), 
            Container(
              width: 230,
              height: 120,
              child: Image.asset("assests/789.png", 
              fit: BoxFit.contain,
              ),
            ), 
              ]
            )
          ]
        )
            ),
      )
    
    
          
    
        
              ],
            ),
          ),
        ),
      ),
    );
  }

  
  Future<bool> sendrequest() async{
  addinitaillocation();
    try{
    // var url = Uri.http("http://addisbuss.onrender.com", "api/user/route/stations" );
      var response =  await http.post(
        Uri.parse("https://addisbuss.onrender.com/api/user/route/stations"),
        body: json.encode([{"src":selectedItem1,"dest":selectedItem2}]) ,
          headers: {
              'Content-type' : 'application/json',
            },
      );
      print("try ${response.statusCode}");
        var data = jsonDecode(response.body);
        print(data);
        if (data == "no available route on ${selectedItem1} to ${selectedItem2}"){
          setState(() {
            _showMyDialog("no available route on ${selectedItem1} to ${selectedItem2}");
          });
         return false;
        }
        else{
      listRoutes.clear();
      data.forEach((listRoute) {
        Routes r = Routes(
          id: listRoute['id'], 
          route_name: listRoute['route_name'], 
          route_number: listRoute['route_number']);

          setState(() {
             listRoutes.add(r);
          });
       
      });

      return true;
    }
    }
    catch (e) {
      _showMyDialog("Unknown Error has occured plaease try again");
      print("Error ${e}");
      return false;
    }
  }

  addinitaillocation(){
      listStations.forEach((listStat){
      if(listStat.station_name == selectedItem1){
         initallocation =  LatLng(listStat.latitude, listStat.longitude);
      }
      });
     setState(() {

      initialStation(selectedItem1);
      initialStationloc(initallocation);   
 });

}
Future<void> _showMyDialog( String x) async {
  String message = x;
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('ERROR'),
        content:  SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
              Text('Press ok to try again'),
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
