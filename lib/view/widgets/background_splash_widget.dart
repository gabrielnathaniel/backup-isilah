import 'package:flutter/material.dart';

class BackgroundSplashWidget extends StatelessWidget {
  const BackgroundSplashWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 32,
            ),
            Image.asset(
              'assets/image/img_splash_7.png',
              width: 28,
            ),
            const SizedBox(
              height: 65,
            ),
            Image.asset(
              'assets/image/img_splash_2.png',
              width: 75,
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/image/img_splash_1.png',
                width: 75,
              ),
              const SizedBox(
                height: 65,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Image.asset(
                  'assets/image/img_splash_4.png',
                  width: 24,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Image.asset(
            'assets/image/img_splash_5.png',
            width: 32,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Image.asset(
              'assets/image/img_splash_8.png',
              width: 24,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Image.asset(
              'assets/image/img_splash_3.png',
              width: 55,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Image.asset(
            'assets/image/img_splash_9.png',
            width: 42,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 50),
                child: Image.asset(
                  'assets/image/img_splash_6.png',
                  width: 48,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
