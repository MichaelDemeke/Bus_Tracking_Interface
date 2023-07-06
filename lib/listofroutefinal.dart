import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tracker/bus.dart';
import 'package:tracker/routes.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'listofbusfinal.dart';


class listroute extends StatefulWidget {
 final List<Routes> listRoutes;
  const listroute(this.listRoutes, {super.key});

  @override
  State<listroute> createState() => _listrouteState();
}

class _listrouteState extends State<listroute> {
 late Map mapRespons;
  List<Buses> listBuses = [];

@override
  void initState() {
 // fetchData();
  super.initState();
  }
 late bool busfound = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
      backgroundColor: theamColor,
      elevation: 0,
      leading: IconButton(
        // ignore: deprecated_member_use
        icon: Icon(Icons.keyboard_backspace_outlined),
        onPressed: () => Navigator.pop(context),
        ),  
      ),
        body : Container(
          decoration: BoxDecoration(
          color: theamColor
        ),
          child: Stack(
              //  SizedBox(
          //  height: MediaQuery.of(context).size.height * 0.90,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.83,
                child: Container(
                 margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.28),
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08, 
                          left: kDefaultPaddin, 
                          right: kDefaultPaddin,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
                          )
                        ),
                  child:ListView.builder(
                      itemCount: widget.listRoutes.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(border: Border.all(width: 1)),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.10,
              
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  
                                  DefaultTextStyle(
                                    child: Text(widget.listRoutes[index].route_name as String),
                                  style: const TextStyle(
                                          fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                  
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DefaultTextStyle(
                                    child: Text("Route Number: ${widget.listRoutes[index].route_number}" ),
                            
                                    style: const TextStyle(
                                          fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
                                    ),  
                                  )
                              ],
                            )
                            
                                
                          ),
                          onTap: () async {
                             var check = sendrequest(widget.listRoutes[index].id as int);
                         if(await check){
                         Navigator.of(context).push(MaterialPageRoute(
                           builder: (context) =>
                               listofbuses2(listBuses),
                            )
                         );
                        }
                          },
                        );
                      }),
                ),
              ),
        
        
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  
                  SizedBox(height: 65),
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
          )
        )
      ),
    );

    
  }
  Future<bool> sendrequest(int index) async{
    try{
      var request = await http.post(
        Uri.parse("https://addisbuss.onrender.com/api/user/route/${index}"),
        body: json.encode([{"src": sourcelocation}]),
        headers: {
              'Content-type' : 'application/json',
            },
      );
      print(request.statusCode);
      var data = jsonDecode(request.body);
        print(request.body);
        if (request.body == "[]"){
          _showMyDialog("No active Bus has been found on this route");
            return false;
        }

        else{
      listBuses.clear();
      data.forEach((listBus) {
        Buses b = Buses(
          plateNumber: listBus['plateNumber'],
          distance: listBus['distance'],
          duration: listBus['duration'],
          location: listBus['location']
        );
        setState(() {
          listBuses.add(b);
        });
        
      });

      return true;
    }
    }
    catch (e) {
      print(e);
       _showMyDialog("Unknowen error has occured");
      return false;
    }
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