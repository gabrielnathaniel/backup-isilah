import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/view/page-challenger-room/page_challenger_leaderboard.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ChallengerResultPage extends StatefulWidget {
  const ChallengerResultPage({Key? key}) : super(key: key);

  @override
  State<ChallengerResultPage> createState() => _ChallengerResultPageState();
}

class _ChallengerResultPageState extends State<ChallengerResultPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _isShare = false;

  final GlobalKey _globalKey = GlobalKey();

  AnimationController? controller;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();

    onSubmit();
  }

  void onSubmit() async {
    setState(() {
      _isLoading = false;
    });

    Future.delayed(const Duration(milliseconds: 600)).then((values) {
      controller = AnimationController(
          duration: const Duration(milliseconds: 500), vsync: this);
      animation = Tween(begin: 0.0, end: 1.0).animate(controller!)
        ..addListener(() {
          setState(() {
            _isLoading = true;
          });
        });
      controller!.forward();
    });
  }

  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      setState(() {});
      return pngBytes;
    } on DioError catch (err) {
      return err.error;
    }
  }

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
      child: RepaintBoundary(
        key: _globalKey,
        child: Scaffold(
          backgroundColor: ColorPalette.darkBlue,
          body: _isLoading
              ? FadeTransition(
                  opacity: animation!,
                  child: Stack(
                    fit: StackFit.loose,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 5),
                          margin: const EdgeInsets.only(top: 102),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/icon/ic_done.png',
                                width: 24,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                '10 Benar',
                                style: TextStyle(
                                  fontSize: bodySmall,
                                  color: ColorPalette.neutral_90,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Image.asset(
                                'assets/icon/ic_close.png',
                                width: 24,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                '0 Salah',
                                style: TextStyle(
                                  fontSize: bodySmall,
                                  color: ColorPalette.neutral_90,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _isShare
                                ? Image.asset(
                                    'assets/icon/ic_piala.png',
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                  )
                                : Image.asset(
                                    'assets/gif/anim_piala.gif',
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ),
                            const SizedBox(
                              height: 78,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 60),
                              child: Text(
                                "Kamu telah menyelesaikan Challenge Room silahkan tunggu hasilnya.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final RenderBox? box =
                                    context.findRenderObject() as RenderBox?;
                                setState(() {
                                  _isShare = true;
                                });
                                await Future.delayed(
                                    const Duration(milliseconds: 300));

                                final directory = Platform.isIOS
                                    ? (await getApplicationDocumentsDirectory())
                                        .path
                                    : (await getExternalStorageDirectory())!
                                        .path;
                                File imgFile =
                                    File('$directory/result_quiz.png');
                                _capturePng().then((value) async {
                                  await imgFile.writeAsBytes(value);

                                  Share.shareXFiles([XFile(imgFile.path)],
                                          subject:
                                              "Selamat kamu mendapatkan star",
                                          text: "",
                                          sharePositionOrigin:
                                              box!.localToGlobal(Offset.zero) &
                                                  box.size)
                                      .then((value) {
                                    setState(() {
                                      _isShare = false;
                                    });
                                  });
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 43),
                                child: Text(
                                  'Bagikan',
                                  style: TextStyle(
                                    fontSize: bodyLarge,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ChallengerLeaderboardPage()));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 12),
                                decoration: const BoxDecoration(
                                    color: ColorPalette.mainColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10))),
                                child: const Text(
                                  'Leaderboard',
                                  style: TextStyle(
                                    fontSize: bodyLarge,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Image.asset(
                    'assets/gif/anim_congarts.gif',
                    width: MediaQuery.of(context).size.width * 0.7,
                  ),
                ),
        ),
      ),
    );
  }
}
