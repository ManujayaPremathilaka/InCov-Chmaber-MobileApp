import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:incov_chamber/Animation/FadeAnimation.dart';
import 'package:incov_chamber/screens/HeartRate/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:incov_chamber/screens/commons/opaque_image.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
class ScanScreen extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}
class _ScanState extends State<ScanScreen> {
  String barcode = "";
  @override
  initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
//        backgroundColor: Colors.white,
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
                child:Padding(
                    padding: const EdgeInsets.all(0),
           child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 150,
                child: Stack(
                children: <Widget>[
//              Positioned(
//                child: FadeAnimation(
//              1,
//              Container(
//                decoration: BoxDecoration(
//                image: DecorationImage(
//                fit: BoxFit.cover,
//                image: AssetImage("assets/images/3.png"),
//                ),
//                ),
//                ),
//                ))
              ],
              ),
          ),
//              SizedBox(
//                height: 10.0,
//              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 80),
                child:Image(image: AssetImage("assets/images/logo.png"),height: 250) ,
              ),
              SizedBox(
                height: 50.0,
              ),
              FadeAnimation(
                1,
                InkWell(
                  onTap: scan,
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 60),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:  Color(0xff31B27E)
//                          .fromRGBO(49, 39, 79, 1),
                    ),
                    child: Center(
                      child: Text(
                        "START CAMERA SCAN",
                        style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),

                      ),
                    ),
                  ),
                ),
              ),

         new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                child: RaisedButton(
//                    color: Color(0xff37735C),
//                    textColor: Colors.white,
//                    splashColor: Colors.blueGrey,
//                    onPressed: scan,
//                    child: const Text('START CAMERA SCAN')
//                ),
//              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(barcode, textAlign: TextAlign.center,),
              )
              ,
            ],
          )
         ),
            ],
           )
            )
            )
        ]
    )
    )
    ]
    )
    ]
            )

    );
  }
  Future scan() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {

      ScanResult qrScanResult = await BarcodeScanner.scan();
      String barcode = qrScanResult.rawContent;
      setState(() => this.barcode = barcode);

      sharedPreferences.setString("url", this.barcode);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => HeartRateMainPage()),
              (Route<dynamic> route) => false);

    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}