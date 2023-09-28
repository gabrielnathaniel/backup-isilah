import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppWidget extends StatelessWidget {
  final String? link;
  const UpdateAppWidget({super.key, @required this.link});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
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
                    _launchInBrowser(Uri.parse(link!));
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
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
