import 'package:incov_chamber/screens/commons/radial_progress.dart';
import 'package:incov_chamber/screens/commons/rounded_image.dart';
import 'package:incov_chamber/screens/styleguide/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
class MyInfo extends StatelessWidget {
  MyInfo(this.name,this.position,this.photo) : super();
  String name;
  String position;
  String photo;

  @override
  Widget build(BuildContext context) {

    var bytes = Base64Codec().decode(photo);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RadialProgress(
            width: 4,
            goalCompleted: 1,
            child: RoundedImage(
             bytes: bytes,
//            "assets/images/avatar.jpg",
              size: Size.fromWidth(120.0),
            ),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                name,
                style: whiteNameTextStyle,
              ),

            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
//              Image.asset(
//                "assets/icons/location_pin.png",
//                width: 20.0,
//                color: Colors.white,
//              ),
              Text(
               position,
                style: whiteSubHeadingTextStyle,
              )
            ],
          ),
        ],
      ),
    );
  }
}