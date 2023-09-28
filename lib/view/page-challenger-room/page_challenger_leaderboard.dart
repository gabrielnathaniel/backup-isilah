import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/ranks.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ChallengerLeaderboardPage extends StatefulWidget {
  const ChallengerLeaderboardPage({Key? key}) : super(key: key);

  @override
  State<ChallengerLeaderboardPage> createState() =>
      _ChallengerLeaderboardPageState();
}

class _ChallengerLeaderboardPageState extends State<ChallengerLeaderboardPage> {
  final GlobalKey _globalKey = GlobalKey();

  int? hours;
  int? minutes;
  int? seconds;

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

  final List<DataRanks> _listDataRanksDummy = [
    DataRanks(
        userId: 1,
        fullName: 'John Lennon',
        photo: 'https://picsum.photos/id/0/5000/3333',
        point: 100,
        rank: 1),
    DataRanks(
        userId: 2,
        fullName: 'Paul Jarvis',
        photo: 'https://picsum.photos/id/10/2500/1667',
        point: 90,
        rank: 2),
    DataRanks(
        userId: 3,
        fullName: 'Aleks Dorohovich',
        photo: 'https://picsum.photos/id/20/3670/2462',
        point: 80,
        rank: 3),
    DataRanks(
        userId: 4,
        fullName: 'Yoni Kaplan-Nadel',
        photo: 'https://picsum.photos/id/27/3264/1836',
        point: 70,
        rank: 4),
    DataRanks(
        userId: 5,
        fullName: 'Jerry Adney',
        photo: 'https://picsum.photos/id/28/4928/3264',
        point: 60,
        rank: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.darkBlue,
      appBar: AppBar(
        backgroundColor: ColorPalette.darkBlue,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Kembali',
          style: TextStyle(
              fontSize: titleSmall,
              color: Colors.white,
              fontWeight: FontWeight.w500),
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
            color: Colors.white,
          ),
        ),
      ),
      body: RepaintBoundary(
        key: _globalKey,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Rank Room',
                    style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Image.asset(
                    'assets/icon/ic_one_star.png',
                    width: 56,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Waktu Tersisa : ",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      TweenAnimationBuilder<Duration>(
                          duration: const Duration(seconds: 18000),
                          tween: Tween(
                              begin: const Duration(seconds: 18000),
                              end: Duration.zero),
                          onEnd: () {},
                          builder: (BuildContext context, Duration value,
                              Widget? child) {
                            hours = value.inHours;
                            minutes = value.inMinutes % 60;
                            seconds = value.inSeconds % 60;

                            return Row(
                              children: [
                                Text(
                                  '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: ColorPalette.colorTextYellow,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            );
                          }),
                    ],
                  ),
                  const SizedBox(
                    height: 51,
                  ),
                  ..._listDataRanksDummy.map((data) {
                    return Container(
                      decoration: BoxDecoration(
                        color: ColorPalette.colorListRanks,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.only(
                          bottom: 12, left: 16, right: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(
                            width: 4,
                          ),
                          SizedBox(
                            width: 25,
                            child: Text(
                              data.rank!.toString(),
                              style: const TextStyle(
                                color: ColorPalette.neutral_90,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          data.photo == null
                              ? Image.asset(
                                  'assets/image/default_profile.png',
                                  width: 32,
                                )
                              : CachedNetworkImage(
                                  width: 32,
                                  height: 32,
                                  imageUrl: data.photo!,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/image/default_profile.png',
                                    width: 32,
                                  ),
                                ),
                          const SizedBox(
                            width: 14,
                          ),
                          Expanded(
                            child: Text(
                              data.fullName!,
                              style: const TextStyle(
                                color: ColorPalette.neutral_90,
                                fontWeight: FontWeight.w300,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 14,
                          ),
                          Text(
                            "${IsilahHelper.formatCurrencyWithoutSymbol(data.point == null ? 0 : data.point!.toDouble())} Pts",
                            style: const TextStyle(
                              color: ColorPalette.greenColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Lihat Semua",
                    style: TextStyle(
                      color: ColorPalette.colorTextYellow,
                      fontWeight: FontWeight.w300,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 42,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    child: Text(
                      "Star yang di beli dari tiket dikumpulkan menjadi hadiah.",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    final RenderBox? box =
                        context.findRenderObject() as RenderBox?;
                    await Future.delayed(const Duration(milliseconds: 300));

                    final directory = Platform.isIOS
                        ? (await getApplicationDocumentsDirectory()).path
                        : (await getExternalStorageDirectory())!.path;
                    File imgFile = File('$directory/result_quiz.png');
                    _capturePng().then((value) async {
                      await imgFile.writeAsBytes(value);

                      Share.shareXFiles([XFile(imgFile.path)],
                              subject: "Selamat kamu mendapatkan star",
                              text: "",
                              sharePositionOrigin:
                                  box!.localToGlobal(Offset.zero) & box.size)
                          .then((value) {});
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 43),
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
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                      return const HomeWidget(
                        showBanner: false,
                      );
                    }), (Route<dynamic> route) => false);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 26),
                    decoration: const BoxDecoration(
                        color: ColorPalette.mainColor,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(10))),
                    child: const Text(
                      'Beranda',
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
          ],
        ),
      ),
    );
  }
}
