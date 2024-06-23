import 'dart:convert';
import 'dart:io';

import 'package:incov_chamber/Animation/FadeAnimation.dart';
import 'package:incov_chamber/Models/User.Model.dart';
import 'package:incov_chamber/ServerRoutes/ServerRoutes.dart';
import 'package:incov_chamber/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SingUpPageState createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SignUpPage> {
  String _selectedOrganization = "Select Organization";
  var organizations = ['Select Organization', 'SLIIT', 'IIT', 'Pearson Lanka'];
  final _formKey = GlobalKey<FormState>();
  final _user = UserModel();
  final _serverRoutes = ServerRoutes();

  // File _image;
  // final picker = ImagePicker();
  //
  // Future getImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.camera);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

//  final formKey = GlobalKey <FormState> ();
//  final user = UserModel ();
  /**
   * Varibales related to image
   */
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMsg = 'Error Uploading Image';

  /**
   * Method to capture image
   */
  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 12);
    });
  }

  /**
   * Method to handle dropdown
   */
  void _OnChangeDropOrganization(String value) {
    setState(() {
      _selectedOrganization = value;
    });

    _user.organization = this._selectedOrganization;
  }

  /**
   * Method to Handle register click
   */
  handleRegisterClick(UserModel userModel, BuildContext context) async {
    var res = await _serverRoutes.addUser(_user);

    if(res.statusCode == 200){
      _showDialog(context);

      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login())
      );
      
    } else{
      print('Fail');
    }
  }

  /**
   * Widget to display image
   */
  Widget showImage() {
    return FutureBuilder<File>(

      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());

          _user.base64Image = this.base64Image;
          return Flexible(
            fit: FlexFit.loose,
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // SQLiteDbProvider.db.getUserbyEmail('nuwana24@gmail.com');

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xff0C915E),
        body: SingleChildScrollView(
          child:
            Column(
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
                                    image: AssetImage("assets/images/2.png"),
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  SingleChildScrollView(
                    child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        FadeAnimation(
                          1,
                          Text(
                            "Get Registered!",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        FadeAnimation(
                          1,
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.transparent,
                            ),
                            child: Builder(
                              builder: (context) => Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey[100],
                                          ),
                                        ),
                                      ),
                                      child: TextFormField(
                                        style: TextStyle(color: Color(0xffD6F112)),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "EmployeeID",
                                          hintStyle:
                                          TextStyle(color: Color(0xffD6F1ED)),
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter Employee ID';
                                          }
                                          return null;
                                        },
                                        onSaved: (val) => setState(
                                                () => _user.emp_id = val
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey[100],
                                          ),
                                        ),
                                      ),
                                      child: TextFormField(
                                        style: TextStyle(color: Color(0xffD6F112)),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Full Name",
                                          hintStyle:
                                          TextStyle(color: Color(0xffD6F1ED)),
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter Full name';
                                          }
                                          return null;
                                        },
                                        onSaved: (val) => setState(
                                                () => _user.full_name = val
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   padding: EdgeInsets.all(10.0),
                                    //   decoration: BoxDecoration(
                                    //     border: Border(
                                    //       bottom: BorderSide(
                                    //         color: Colors.grey[100],
                                    //       ),
                                    //     ),
                                    //   ),
                                    //   child: TextFormField(
                                    //     style: TextStyle(color: Color(0xffD6F112)),
                                    //     decoration: InputDecoration(
                                    //         border: InputBorder.none,
                                    //         hintText: "Email",
                                    //         hintStyle: TextStyle(
                                    //             color: Color(0xffD6F1ED))),
                                    //     validator: (value) {
                                    //       if (value.isEmpty) {
                                    //         return 'Please enter email';
                                    //       }
                                    //       return null;
                                    //     },
                                    //    onSaved: (val) => setState(
                                    //             () => _user.email = val
                                    //     ),
                                    //   ),
                                    // ),
                                    Container(
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.grey[100],
                                            ),
                                          ),
                                        ),
                                        child: DropdownButton<String>(
                                          hint: Text('Select Organization',
                                              style: TextStyle(
                                                  color: Color(0xffD6F1ED))),
                                          isExpanded: true,
//                style: TextStyle(color: Colors.red),
                                          underline: Container(
                                            color: Color(0xffD6F1ED),
                                          ),
                                          value: _selectedOrganization,
                                          focusColor: Color(0xffD6F1ED),
                                          // this remo
//                value: _selectedPayee,
                                          icon: Icon(Icons.keyboard_arrow_right),
                                          iconEnabledColor: Color(0xffD6F1ED),
                                          dropdownColor: Color(0xff0C915E),
                                          items: organizations
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value,
                                                      style: TextStyle(
                                                          color: Color(0xffD6F1ED),
                                                          decorationColor:
                                                          Color(0xffD6F112))),
                                                );
                                              }).toList(),
                                          onChanged: _OnChangeDropOrganization,
                                        )),
                                    Container(
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey[100],
                                          ),
                                        ),
                                      ),
                                      child: TextFormField(
                                        style: TextStyle(color: Color(0xffD6F112)),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Position",
                                          hintStyle:
                                          TextStyle(color: Color(0xffD6F1ED)),
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter Position';
                                          }
                                          return null;
                                        },
                                        onSaved: (val) => setState(
                                                () => _user.position = val
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey[100],
                                          ),
                                        ),
                                      ),
                                      child: TextFormField(
                                        style: TextStyle(color: Color(0xffD6F112)),
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Username",
                                            hintStyle: TextStyle(
                                                color: Color(0xffD6F1ED))),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter Username ';
                                          }
                                          return null;
                                        },
                                       onSaved: (val) => setState(
                                                () => _user.user_name = val
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey[100],
                                          ),
                                        ),
                                      ),
                                      child: TextFormField(
                                        style: TextStyle(color: Color(0xffD6F112)),
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Password",
                                            hintStyle: TextStyle(
                                                color: Color(0xffD6F1ED))),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter password';
                                          }
                                          return null;
                                        },
                                        onSaved: (val) => setState(
                                                () => _user.password = val
                                        ),
                                      ),
                                    ),
                                    FloatingActionButton(
                                      onPressed: chooseImage,
                                      tooltip: 'Pick Image',
                                      child: Icon(Icons.add_a_photo),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    showImage(),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 80.0),
                                      child: RaisedButton(
                                        textColor: Colors.blueGrey,
                                        color: Color(0xff7FF29C),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(50)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 60, vertical: 12),

                                        onPressed: () {
                                          final form = _formKey.currentState;
                                          if(form.validate()){
                                            form.save();
                                            // _user.save();
                                            handleRegisterClick(_user, context);
                                          }
                                        },

                                        child: Text(
                                          'Sign up',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ),
                          ),
                        ),
                        // Center(
                        //   child: _image == null
                        //       ? Text('No image selected.')
                        //       : Image.file(_image),
                        // ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Already Have an Account ?',
                              style: TextStyle(fontFamily: 'Montserrat'),
                            ),
                            SizedBox(width: 5.0),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                      ])))
        ])));

  }

  _showDialog(BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Registration Success')));
  }
}
