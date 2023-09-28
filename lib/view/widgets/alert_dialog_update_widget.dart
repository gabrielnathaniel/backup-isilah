import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:url_launcher/url_launcher.dart';

Stack showAlertUpdate(BuildContext context) => Stack(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 16, bottom: 16, left: 24, right: 24),
          child: Column(
            children: [
              Image.asset(
                'assets/image/img_update.png',
                width: 180,
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Yuk, Update ke versi terbaru!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: titleLarge,
                    color: ColorPalette.neutral_90,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Update ke versi terbaru yuk, supaya kamu bisa nikmatin fitur - fitur terbaru dari Isilah",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: bodyMedium,
                    color: ColorPalette.neutral_90,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _launchInBrowser(
                    Uri.parse(Platform.isAndroid ? androidUrl : iOSUrl));
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorPalette.mainColor),
                child: const Center(
                  child: Text(
                    'Update',
                    style: TextStyle(
                        fontSize: bodyMedium,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}
