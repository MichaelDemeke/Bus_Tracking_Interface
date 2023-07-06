import 'package:flutter/material.dart';
import 'package:tracker/bus.dart';
import 'mymapfinal.dart';

import 'constants.dart';

class listofbuses2 extends StatefulWidget {
  final List<Buses> listBuses;
  const listofbuses2(this.listBuses, {super.key});

  @override
  State<listofbuses2> createState() => _listofbuses2State();
}

class _listofbuses2State extends State<listofbuses2> {

  @override
  void initState() {
 // fetchData();
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
                  child: ListView.builder(
                      itemCount: widget.listBuses.length,
                        itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Container(
                             decoration: BoxDecoration(border: Border.all(width: 1)), 
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.12,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: DefaultTextStyle(
                                    child: Text("Bus PlatNumber:  ${widget.listBuses[index].plateNumber} " ),
                                    style: TextStyle(
                                            fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  
                                  Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: DefaultTextStyle(
                                    child: Text("Location: ${widget.listBuses[index].location}"),
                            
                                    style: const TextStyle(
                                          fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
                                    ),  
                                  ),
                                Row(
                                  children: [ 
                                  DefaultTextStyle(
                                    child: Text("Distance: ${widget.listBuses[index].distance} " ),
                                  style: const TextStyle(
                                          fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                  
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: DefaultTextStyle(
                                    child: Text("Duration: ${widget.listBuses[index].duration}"),
                            
                                    style: const TextStyle(
                                          fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                                    ),  
                                  ),
                                  ],
                                )  
                              ],
                            )
                            
                                
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyMap(widget.listBuses[index].plateNumber, widget.listBuses, index)
                                  
                            ),
                            );
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
                    TextSpan(text: "List of\n"), 
                    TextSpan(
                      text: "Buses ", 
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
                )
              ],
            ),
              
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
}