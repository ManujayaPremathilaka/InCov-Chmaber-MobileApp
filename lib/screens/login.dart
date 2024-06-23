import 'package:flutter/material.dart';
import 'package:incov_chamber/Animation/FadeAnimation.dart';
import 'package:incov_chamber/screens/signUp.dart';
import 'package:incov_chamber/screens/HeartRate/homePage.dart';
import 'package:incov_chamber/screens/QR_Code/temp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:incov_chamber/screens/User/MainPage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  var id = null;
  bool _isloading = false;

  Future<String> getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String userId = sharedPreferences.getString('token');
    print(userId);
    return userId;
  }

  signIn(String username, String pass) async {
//    String url = "https://incovbackend.herokuapp.com/employee/login/";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//    Map body = {"username":username, "password": pass};
    var jsonResponse;
    // var res = await http.post(url, body: body);

    var res = await http.post(
      'https://incovbackend.herokuapp.com/employee/login',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "username" : username.trim(),
        "password" : pass.trim()
      })
    );

    if (res.statusCode == 200) {
      jsonResponse = json.decode(res.body);

//      print("Response Status: ${res.statusCode}");
//      print("Response Status: ${res.body}");

      if (jsonResponse != null) {
        setState(() {
          _isloading = false;
        });

        sharedPreferences.setString("token", jsonResponse['_id']);
        print(sharedPreferences.getString('token'));
        var sId = sharedPreferences.getString('token');



        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) =>  MainPage()),
                (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isloading = false;
      });
      print("Response Status: ${res.body}");
    }
  }

  authenticate(String username, String pass) async {
    String myurl =
        "https://incovbackend.herokuapp.com/employee/login/";
    http.post(myurl, headers: {
      'Accept': 'application/json',
      'authorization': 'pass your key(optional)'
    }, body: {
      "username": username,
      "password": pass
    }).then((response) {
      print(response.statusCode);
      print(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
//      resizeToAvoidBottomInset: false,
//      backgroundColor: Color(0xff37735C),
      backgroundColor:Colors.white,
      body: SingleChildScrollView(
        child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 200,
            child: Stack(
              children: <Widget>[
                Positioned(
                    child: FadeAnimation(
                      1,
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/3.png"),
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),

          FadeAnimation(1,
            Image(image: AssetImage("assets/images/logo.png"),height: 80 )
           ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FadeAnimation(
                  1,
                  Text(
                    "Hello there, \nwelcome back",
                    style: TextStyle(
                      fontSize: 30,
                      color: Color(0xff37735C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                FadeAnimation(
                  1,
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.transparent,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xff37735C),
                              ),
                            ),
                          ),
                          child: TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Username",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xff37735C),
                              ),
                            ),
                          ),
                          child: TextField(
                            controller: _passController,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                FadeAnimation(
                  1,
                  InkWell(
                    onTap: ()=> signIn(usernameController.text.trim(), _passController.text.trim()),
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
                          "Login",
                          style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),

                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: FadeAnimation(
                    1,
                    Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Color(0xff37735C),
                        fontSize: 15
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
            FadeAnimation(
              1,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Not Registered ?',
                      style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff37735C)),
                    ),
                    SizedBox(width: 2.0),
                    InkWell(
                      onTap:
                          () {
                        Navigator.pop(context);
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => SignUpPage())
                        )
                        ;
                      },
                      child:  Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff31B27E),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    )
                  ],
                ),
            ),
              ],
            ),
          )
        ],
      ),
    )),
    );
  }
}
