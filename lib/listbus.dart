import 'package:flutter/material.dart';
import 'package:tracker/map.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'constants.dart';

class listbus extends StatefulWidget {
  final WebSocketChannel channel;
  const listbus({super.key, required this.channel});

  @override
  State<listbus> createState() => _listbusState();
}

class _listbusState extends State<listbus> {

late String busSelected;

  @override 
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:  Text('List of Buses'),
        ),
        body : Column(
          children: [
            MyMap(bus_id: busSelected),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
              child: StreamBuilder(
                  stream: widget.channel.stream,
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                    ?const Center(
                      child: CircularProgressIndicator(),
                    )
                        : Container(
                            padding: EdgeInsets.all(0),
                            child: GridView.builder(
                                itemCount: snapshot.data!.docs.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
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
                                                child: Text(snapshot.data!.docs[index].get('name')),
                                              style: const TextStyle(fontFamily: 'Dire_Dawa',
                                                      fontSize: 24, color: Colors.brown, fontWeight: FontWeight.bold),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: DefaultTextStyle(
                                                child:  Text(snapshot.data!.docs[index].get('soure') + "_" + snapshot.data!.docs[index].get('destination')),
                                                style: const TextStyle(fontFamily: 'Dire_Dawa',
                                                      fontSize: 24, color: Colors.brown, fontWeight: FontWeight.bold),
                                                ),  
                                              )
                                          ],
                                        )
                                        
                                            
                                      ),
                  onTap: () {
                   // widget.channel.sink.add(snapshot.data!.docs[index].get('id'));
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //    builder: (context) => 
                    //       MyMap(bus_id: snapshot.data!.docs[index].id),
                    //   )
                     //      );

                          setState(() {
                            busSelected = snapshot.data!.docs[index].id;
                          });

                                    },
                                  ),
                                );
                              })
                            );
                      } 
   )
            ),
          ],
        )
      ),
    );
  }
}