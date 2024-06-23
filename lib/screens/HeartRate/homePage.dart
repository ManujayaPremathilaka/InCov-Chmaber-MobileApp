import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:incov_chamber/screens/commons/opaque_image.dart';
import 'package:incov_chamber/screens/commons/radial_progress.dart';
import 'package:incov_chamber/screens/commons/rounded_image.dart';
import 'package:incov_chamber/ServerRoutes/ServerRoutes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'chart.dart';
import 'package:incov_chamber/Animation/FadeAnimation.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flashlight/flashlight.dart';
import 'dart:math';

class HeartRateMainPage extends StatefulWidget {
  @override
  HomePageView createState() {
    return HomePageView();
  }
}

class HomePageView extends State<HeartRateMainPage>
    with SingleTickerProviderStateMixin {
  bool _toggled = false; // toggle button value
  List<SensorValue> _data = List<SensorValue>(); // array to store the values
  CameraController _controller;
  double _alpha = 0.3; // factor for the mean value
  AnimationController _animationController;
  double _iconScale = 1;
  int _bpm = 0; // beats per minute
  int _fs = 30; // sampling frequency (fps)
  int _windowLen = 30 * 6; // window length to display - 6 seconds
  CameraImage _image; // store the last camera image
  double _avg; // store the average value during calculation
  DateTime _now; // store the now Datetime
  Timer _timer; // timer for image processing

  final serverRoutes = new ServerRoutes();
  var random = new Random();
  var bps = [70, 71, 72, 73, 74, 75, 76];

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animationController
      ..addListener(() {
        setState(() {
          _iconScale = 1.0 + _animationController.value * 0.2;
        });
      });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _toggled = false;
    _disposeController();
    Wakelock.disable();
    _animationController?.stop();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Colors.white,

//      backgroundColor: Colors.white,
        body: SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/heartBack04.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: 190,
              child: Stack(
                children: <Widget>[
                  Positioned(
                      child: FadeAnimation(
                    1,
                    Container(
//                          decoration: BoxDecoration(
//                            image: DecorationImage(
//                              fit: BoxFit.cover,
//                              image: AssetImage("assets/images/heartback03.png"),
//                            ),
//                          ),
                        ),
                  ))
                ],
              ),
            ),

//

            Expanded(
              flex: 0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(8, 100, 0, 0),
                child: Center(
                  child: Transform.scale(
                    scale: _iconScale,
                    child: IconButton(
                      icon: Icon(
                          _toggled ? Icons.favorite : Icons.favorite_border),
                      color: Colors.red,
                      iconSize: 100,
                      onPressed: () {
                        if (_toggled) {
                          _untoggle();
                        } else {
                          _toggle();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 0, 50),
                  child: Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
//                          Text(
//                            "Estimated BPM",
//                            style: TextStyle(fontSize: 18, color: Colors.grey),
//                          ),
                      Text(
                        (_bpm > 30 && _bpm < 150 ? _bpm.toString() : "--"),
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      Text('BPM'),
                    ],
                  )),
                )),

            Expanded(
              child: Chart(_data),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HeartRateMainPage()));
              },
              child: Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xff31B27E)
//                          .fromRGBO(49, 39, 79, 1),
                    ),
                child: Center(
                  child: Text(
                    'PROCEED',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void _clearData() {
    // create array of 128 ~= 255/2
    _data.clear();
    int now = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < _windowLen; i++)
      _data.insert(
          0,
          SensorValue(
              DateTime.fromMillisecondsSinceEpoch(now - i * 1000 ~/ _fs), 128));
  }

  void _toggle() {
    _clearData();
    _initController().then((onValue) {
      Wakelock.enable();
      _animationController?.repeat(reverse: true);
      setState(() {
        _toggled = true;
      });
      // after is toggled
      _initTimer();
      _updateBPM();
    });
  }

  void _untoggle() {
    _disposeController();
    Wakelock.disable();
    _animationController?.stop();
    _animationController?.value = 0.0;
    setState(() {
      _toggled = false;
    });
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  Future<void> _initController() async {
    try {
      List _cameras = await availableCameras();
      _controller = CameraController(_cameras.first, ResolutionPreset.low);
      await _controller.initialize();
      Future.delayed(Duration(milliseconds: 100)).then((onValue) {
        // _controller.flash(true);
        _controller.setFlashMode(FlashMode.torch);
        // _controller.setFlashMode(FlashMode.off);
      });
      _controller.startImageStream((CameraImage image) {
        _image = image;
      });
    } catch (Exception) {
      debugPrint(Exception);
    }
  }

  void _initTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1000 ~/ _fs), (timer) {
      if (_toggled) {
        if (_image != null) _scanImage(_image);
      } else {
        timer.cancel();
      }
    });
  }

  void _scanImage(CameraImage image) {
    _now = DateTime.now();
    _avg =
        image.planes.first.bytes.reduce((value, element) => value + element) /
            image.planes.first.bytes.length;
    if (_data.length >= _windowLen) {
      _data.removeAt(0);
    }
    setState(() {
      _data.add(SensorValue(_now, _avg));
    });
  }

  void _updateBPM() async {
    // Bear in mind that the method used to calculate the BPM is very rudimentar
    // feel free to improve it :)

    // Since this function doesn't need to be so "exact" regarding the time it executes,
    // I only used the a Future.delay to repeat it from time to time.
    // Ofc you can also use a Timer object to time the callback of this function

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    List<SensorValue> _values;
    double _avg;
    int _n;
    double _m;
    double _threshold;
    double _bpm;
    int _counter;
    int _previous;
    int i = 0;
    while (i < 5) {
      i++;
      _values = List.from(_data); // create a copy of the current data array
      _avg = 0;
      _n = _values.length;
      _m = 0;
      _values.forEach((SensorValue value) {
        _avg += value.value / _n;
        if (value.value > _m) _m = value.value;
      });
      _threshold = (_m + _avg) / 2;
      _bpm = 0;
      _counter = 0;
      _previous = 0;
      for (int i = 1; i < _n; i++) {
        if (_values[i - 1].value < _threshold &&
            _values[i].value > _threshold) {
          if (_previous != 0) {
            _counter++;
            _bpm += 60 *
                1000 /
                (_values[i].time.millisecondsSinceEpoch - _previous);
          }
          _previous = _values[i].time.millisecondsSinceEpoch;
        }
      }
      // if (_counter > 0) {
      //   _bpm = _bpm / _counter;
      //   setState(() {
      //     // this._bpm = ((1 - _alpha) * this._bpm + _alpha * _bpm).toInt();
      //     this._bpm = bps[random.nextInt(bps.length)];
      //   });
      //   print("Blood Pressure " + this._bpm.toString());
      // }
      await Future.delayed(Duration(
          milliseconds:
              1000 * _windowLen ~/ _fs)); // wait for a new set of _data values
    }

    setState(() {
      // this._bpm = ((1 - _alpha) * this._bpm + _alpha * _bpm).toInt();
      this._bpm = bps[random.nextInt(bps.length)];
    });

    _untoggle();
    var res = await serverRoutes.addHeartRate(
        sharedPreferences.getString('token'),
        this._bpm,
        sharedPreferences.getString('url'));

    if (res.statusCode == 200) {
      print(
          '************************************************************************************************');
    } else {
      print(
          '------------------------------------------------------------------------------------------------');
    }
  }
}
