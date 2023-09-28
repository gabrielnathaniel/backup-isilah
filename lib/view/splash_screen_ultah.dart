import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';

class SplashScreenUltah extends StatefulWidget {
  const SplashScreenUltah({Key? key}) : super(key: key);

  @override
  State<SplashScreenUltah> createState() => _SplashScreenUltahState();
}

class _SplashScreenUltahState extends State<SplashScreenUltah> {
  startTime() async {
    Duration duration = const Duration(seconds: 3);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/MyApp');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.darkBlue,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/image/img_contour.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1),
              child: Image.asset(
                'assets/logo/logo_isilah.png',
                width: 90,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/image/img_bendera.png',
                width: MediaQuery.of(context).size.width * 0.4,
                fit: BoxFit.cover,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/image/img_hadiah_left.png',
                width: MediaQuery.of(context).size.width * 0.35,
                fit: BoxFit.cover,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              'assets/image/img_hadiah_right.png',
              width: MediaQuery.of(context).size.width * 0.45,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/gif/slamet_ulang_tahun.gif',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/gif/mas_slamet.gif',
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
