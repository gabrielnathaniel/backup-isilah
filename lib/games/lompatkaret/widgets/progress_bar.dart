import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class ProgressBar extends StatelessWidget {
  static const String id = 'ProgressBar';

  const ProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TestApp(),
    );
  }
}

class TestApp extends StatefulWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  TestAppState createState() => TestAppState();
}

class TestAppState extends State<TestApp> {
  double _currentValue = 0;

  late Timer _timer;

  bool zero = true;

  setEndPressed(double value) {
    setState(() {
      _currentValue = value;
    });
  }

  setStart() {
    const oneSec = Duration(milliseconds: 5);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (zero == true) {
        setState(() {
          _currentValue++;
          if (_currentValue == 100) {
            zero = false;
          }
        });
      } else if (zero == false) {
        setState(() {
          _currentValue--;
          if (_currentValue == 0) {
            zero = true;
          }
        });
      }
    });
  }

  setStop() {
    _timer.cancel();
  }

  Widget buildFloatingButton(String text, VoidCallback callback) {
    TextStyle roundTextStyle =
        const TextStyle(fontSize: 16.0, color: Colors.white);
    return FloatingActionButton(
        onPressed: callback, child: Text(text, style: roundTextStyle));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                  height: 450,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Row(
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            FAProgressBar(
                              size: 40,
                              progressColor: Colors.black54,
                              backgroundColor: Colors.white,
                              currentValue: _currentValue,
                              animatedDuration: const Duration(milliseconds: 0),
                              direction: Axis.vertical,
                              verticalDirection: VerticalDirection.up,
                              displayText: '%',
                            ),
                            Container(
                              width: 50,
                              margin: const EdgeInsets.symmetric(vertical: 150),
                              // padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.blueAccent, width: 5)),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(bottom: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    buildFloatingButton("start", () => setStart()),
                    buildFloatingButton("stop", () => setStop()),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
