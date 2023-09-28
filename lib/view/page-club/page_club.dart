import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';

class ClubPage extends StatefulWidget {
  const ClubPage({Key? key}) : super(key: key);

  @override
  State<ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const HomeWidget(
            showBanner: false,
          );
        }));
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: ColorPalette.neutral_90),
          title: const Text(
            'Kembali',
            style: TextStyle(
                fontSize: titleSmall,
                color: ColorPalette.neutral_90,
                fontWeight: FontWeight.w600),
          ),
          leading: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return const HomeWidget(
                    showBanner: false,
                  );
                }));
              },
              child: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: ColorPalette.neutral_90,
              )),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                'assets/image/img_maintenance.png',
                width: 243,
              ),
              const SizedBox(
                height: 88,
              ),
              const Text(
                'Eits.. kamu ngga salah pencet ko, hanya saja\nfitur ini masih dalam tahap perbaikan.',
                style: TextStyle(
                  color: ColorPalette.neutral_90,
                  fontWeight: FontWeight.w300,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const HomeWidget(
                        showBanner: false,
                      );
                    }));
                  },
                  child: const Center(
                    child: Text(
                      'Kembali ke beranda',
                      style: TextStyle(
                        fontSize: 13,
                        color: ColorPalette.mainColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
