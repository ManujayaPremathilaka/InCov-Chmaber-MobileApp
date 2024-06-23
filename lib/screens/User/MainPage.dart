import 'dart:convert';
import 'dart:io';

import 'package:incov_chamber/Animation/FadeAnimation.dart';
import 'package:incov_chamber/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:incov_chamber/screens/styleguide/text_style.dart';
import 'package:incov_chamber/screens/commons/my_info.dart';
import 'package:incov_chamber/screens/commons/opaque_image.dart';
import 'package:incov_chamber/screens/QR_Code/ScanScreen.dart';
import 'package:incov_chamber/screens/HeartRate/homePage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class MainPage extends StatefulWidget{

  @override
  _MainPageState createState() => _MainPageState();
}


class _MainPageState extends State <MainPage> {

  String name;
  String position;
  String ID;
  String photo;
  bool isLoading = true;
  var users;

  Future<String> getUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance() ;

    String userId = sharedPreferences.getString('token');
    print(userId);
    getUserDetails(userId);
    setState(() {
      ID:userId;
    });
    return userId;
  }

  @override
  void initState(){

    getUser();
//    getUser().then((value) {
//      ID =  value;
//    });
//    getUserDetails(ID);
    super.initState();
  }



  void getUserDetails(String eid) async {
    print("eid:-  "+ eid);
    String myurl =
        "https://incovbackend.herokuapp.com/employee/";
    http.get(myurl, headers: {
      'Accept': 'application/json',
      'authorization': 'pass your key(optional)'
    }).then((response) {
      print(response.body);
      users = json.decode(response.body) as List;
//      print("Full Name - " +user['fullName']);
      for (var x = 0; x < users.length; x++) {
        if(eid == users[x]['empID']){
          setState(() {
            name = users[x]['fullName'];
            position = users[x]['position'];
            photo = users[x]['photo'];
            isLoading = false;

          });
        }
      }

//      print(mapRes['fullName']);
//        print(response.);

    });
  }



  @override
  Widget build(BuildContext context) {
    // SQLiteDbProvider.db.getUserbyEmail('nuwana24@gmail.com');

    return Scaffold(

        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xff0C915E),
      body: Stack(
        children: <Widget>[
      Column(
      children: <Widget>[
        Expanded(
        flex: 1,
        child: Stack(
          children: <Widget>[

            OpaqueImage(
              imageUrl: "assets/images/back.jpg",
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
//                        this.name,
                        "My Profile",
                        textAlign: TextAlign.left,
                        style: headingTextStyle,
                      ),
                    ),

                   isLoading? CircularProgressIndicator():
                    MyInfo(name,position,photo),
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ScanScreen()));
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 60),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xff31B27E)
//                          .fromRGBO(49, 39, 79, 1),
                        ),
                        child: Center(
                          child: Text(
                            'SCAN QR CODE',
                            style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),

                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HeartRateMainPage()));
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 60),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xff31B27E)
//                          .fromRGBO(49, 39, 79, 1),
                        ),
                        child: Center(
                          child: Text(
                            'CHECK HEART RATE',
                            style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),

                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                  ],

                ),
              ),
            ),

          ],
        ),

      ),
//        Expanded(
//          child:
//            InkWell(
//              onTap: (){
//                Navigator.pop(context);
//                Navigator.push(context, MaterialPageRoute(builder: (context) => ScanScreen()));
//              },
//              child: Container(
//                height: 10,
//                margin: EdgeInsets.symmetric(horizontal: 60),
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(50),
//                    color: Color(0xff31B27E)
////                          .fromRGBO(49, 39, 79, 1),
//                ),
//                child: Center(
//                  child: Text(
//                    'SCAN QR CODE',
//                    style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
//
//                  ),
//                ),
//              ),
//            ),
//          ),


      ],
    ),
    ],
      )
    );
  }
  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('User added')));
  }
}
