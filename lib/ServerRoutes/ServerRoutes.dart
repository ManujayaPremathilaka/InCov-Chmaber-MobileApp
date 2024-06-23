import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:incov_chamber/Models/User.Model.dart';

class ServerRoutes{

  bool _isLoading = false;

  Future<http.Response> addHeartRate(String _id, int heartRate, String url) async {

    var res = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "_id" : _id,
        "dailyReadings" : {
          "heartRate": heartRate
        }
      })
    );

    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    print(res);
    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    return res;
  }

  Future<http.Response> addUser(UserModel userModel) async {
    String _URL = 'https://incovbackend.herokuapp.com/employee/addEmployee';

    var jsonresponse;

    var res = await http.post(
        'https://incovbackend.herokuapp.com/employee/addEmployee',
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "empID" : userModel.emp_id,
          "fullName": userModel.full_name,
          "username": userModel.user_name,
          "password": userModel.password,
          "organization": userModel.organization,
          "position": userModel.position,
          "dailyReadings": [],
          "photo": userModel.base64Image
        })
    );

    print(userModel.base64Image);
    print(res.body);
    return res;


    // if (res.statusCode == 200){
    //   jsonresponse = json.decode(res.body);
    //
    //   if(jsonresponse != null){
    //     _isLoading = false;
    //   }
    //
    //   print('success');
    //
    // } else {
    //
    //   print(res.body);
    // }


  }
}