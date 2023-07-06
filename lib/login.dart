import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'mymap.dart';

import 'package:http/http.dart' as http ;
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
final platnumberController = TextEditingController();
final passwordController = TextEditingController();
String password = '';
bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
        backgroundColor: theamColor,
        elevation: 0,
        // leading: IconButton(
        //   icon: SvgPicture.asset('assets/icons/back.svg'),
        //   color: Colors.black,
        //   onPressed: () => Navigator.pop(context),
        // ),      
      
        ),
        body:  
         Container(
          decoration: BoxDecoration(
            color: theamColor
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
               height: MediaQuery.of(context).size.height * 0.80,

                child: Stack(
                  children: [

              Center(
                child: Container(
                      // height: MediaQuery.of(context).size.height * 0.25,
                    // width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.0, 
                        left: defaultPadding, 
                         right: defaultPadding,
                      ),
                        decoration: BoxDecoration(
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
                              height: MediaQuery.of(context).size.height * 0.10,
                            ),
                        SingleChildScrollView(
                          child: TextField(
                            controller: platnumberController,
                            decoration: InputDecoration(
                              labelText: 'Plate Number',
                             // prefixIcon: Icon(Icons.playlist_add_check),
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(onPressed: () {
                                platnumberController.clear();
                              }, icon: const Icon(Icons.clear))
                            ),
                            keyboardType: TextInputType.text,
                            cursorHeight: 2.3,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        SizedBox(
                          height:  MediaQuery.of(context).size.height * 0.02,
                        ),
                        
                        SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                                     bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: TextField(
                             controller: passwordController, 
                              onChanged: (value) => setState(() {
                                this.password = value;
                              }),
                              onSubmitted: (value) => setState(() {
                                this.password = value;
                              }),
                             // controller: passwordController,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                labelText: 'Password',
                                //errorText: 'Password is Incorrect',
                                suffixIcon: IconButton(
                                  icon: isPasswordVisible
                                  ?Icon(Icons.visibility_off)
                                  :Icon(Icons.visibility), 
                                  onPressed: () { 
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                   },
                              ),
                                border: OutlineInputBorder(),
                              ),
                              cursorHeight: 1.3,
                              obscureText: isPasswordVisible,
                             // keyboardType: TextInputType.visiblePassword,
                             // textInputAction: TextInputAction.done,
                            ),
                          ),
                        ),
                                   Center(
                                     child: GestureDetector(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              height: MediaQuery.of(context).size.height * 0.04,
                                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.09),
                              decoration: BoxDecoration(color: Colors.green,
                            borderRadius: BorderRadius.all (Radius.circular(24),
                          )
                              ),
                          
                              child: Center(
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
                        
                              if(platnumberController.text == "" || passwordController.text == ""){
                                  _showMyDialog("Please enter the platenumber and password");
                              }
                              else {
                                         sendrequest();
                        
                              if(await sendrequest()){
                                passwordcheck();
                                if (await passwordcheck()){
                                     Navigator.of(context).push(MaterialPageRoute(
                                     builder: (context) =>
                                      MyMap(platnumberController.text),
                                     // map()       
                              ));
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                              
                              }
                              }
                              else{
                                _showMyDialog("Incorrect PlatNumber");
                              }
                              }
                                           
                            },
                          ),
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

        SizedBox(height: 40),
          Row(
            children: [
              RichText(text: TextSpan(
                children: [
                    TextSpan(text: "Enter \n"), 
                    TextSpan(
                      text: "Login", 
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
              SizedBox(width:50), 
              Container(
                width: 240,
                height: 120,
                child: Image.asset("assets/789.png", 
                fit: BoxFit.fill,
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
  Future<bool> sendrequest() async {
    try {
    var collectionRef = FirebaseFirestore.instance.collection('location');
    var docu = await collectionRef.doc(platnumberController.text).get();
    return docu.exists;
  } 
  catch (e) {
    _showMyDialog("Unknow error has occured");
    return false;
  }
   }


Future <bool> passwordcheck() async{
var collection = FirebaseFirestore.instance.collection('location');
var docSnapshot = await collection.doc(platnumberController.text).get();
if (docSnapshot.exists) {
  Map<String, dynamic> data = docSnapshot.data()!;
  var name = data['password'];
  if (name == passwordController.text){
    return true;
  }
  else{
   _showMyDialog("Incorrect Passowrd");
    return false;
  }
}
else {
  _showMyDialog("Unknow error has occured");
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