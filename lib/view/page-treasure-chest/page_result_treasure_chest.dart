import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';
import 'package:isilahtitiktitik/view/page-treasure-chest/page_leaderboard_treasure_chest.dart';
import 'package:isilahtitiktitik/view/page-treasure-chest/page_result_question_treasure_chest.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Page ini bertujuan untuk menampilkan hasil dari [Treasure Chest]
///
class ResultTreasureChestPage extends StatefulWidget {
  final int? eventId;
  final String? resultFlag;
  final int? indexSoal;
  const ResultTreasureChestPage(
      {Key? key, this.resultFlag, this.eventId, this.indexSoal})
      : super(key: key);

  @override
  State<ResultTreasureChestPage> createState() =>
      _ResultTreasureChestPageState();
}

class _ResultTreasureChestPageState extends State<ResultTreasureChestPage>
    with SingleTickerProviderStateMixin {
  final bool _isLoading = true;

  final GlobalKey _globalKey = GlobalKey();

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
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return const HomeWidget(
            showBanner: false,
          );
        }), (Route<dynamic> route) => false);
        return true;
      },
      child: RepaintBoundary(
        key: _globalKey,
        child: Scaffold(
          backgroundColor: ColorPalette.darkBlue,
          body: _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      widget.resultFlag == 'win'
                          ? Container()
                          : Stack(
                              children: [
                                Text(
                                  'Eitss',
                                  style: GoogleFonts.baloo2(
                                    fontSize: 60,
                                    fontWeight: FontWeight.w700,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeCap = StrokeCap.round
                                      ..strokeJoin = StrokeJoin.round
                                      ..strokeWidth = 20
                                      ..color = Colors.white,
                                    decoration: TextDecoration.none,
                                    decorationStyle: TextDecorationStyle.wavy,
                                  ),
                                ),
                                Text(
                                  'Eitss',
                                  style: GoogleFonts.baloo2(
                                    fontSize: 60,
                                    color: ColorPalette.mainColor,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.none,
                                    decorationStyle: TextDecorationStyle.wavy,
                                  ),
                                ),
                              ],
                            ),
                      const SizedBox(
                        height: 25,
                      ),
                      widget.resultFlag == 'win'
                          ? Image.asset(
                              'assets/image/img_result_quiz.png',
                              width: MediaQuery.of(context).size.width * 0.5,
                            )
                          : Image.asset(
                              'assets/image/img_mas_slamet.png',
                              width: MediaQuery.of(context).size.width * 0.6,
                            ),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          widget.resultFlag == 'win'
                              ? 'Kamu berhasil menyelesaikan Treasure Chest\nsilahkan tunggu hasilnya.'
                              : 'Kamu gagal menyelesaikan Treasure Chest nih. tapi jangan sedih, pantengin terus Treasure Chest berikutnya ya',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LeaderboardTreasureChestPage(
                                                eventId: widget.eventId,
                                                navigate: true,
                                              )));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: const Center(
                                    child: Text(
                                      'Lihat Rank',
                                      style: TextStyle(
                                        fontSize: bodySmall,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ResultQuestionTreasureChestPage(
                                                eventId: widget.eventId,
                                              )));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: const Center(
                                    child: Text(
                                      'Lihat Jawaban',
                                      style: TextStyle(
                                        fontSize: bodySmall,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final RenderBox? box =
                              context.findRenderObject() as RenderBox?;
                          await Future.delayed(
                              const Duration(milliseconds: 300));

                          final directory = Platform.isIOS
                              ? (await getApplicationDocumentsDirectory()).path
                              : (await getExternalStorageDirectory())!.path;
                          File imgFile = File('$directory/result_quiz.png');
                          _capturePng().then((value) async {
                            await imgFile.writeAsBytes(value);

                            Share.shareXFiles([XFile(imgFile.path)],
                                    subject: "",
                                    text: "",
                                    sharePositionOrigin:
                                        box!.localToGlobal(Offset.zero) &
                                            box.size)
                                .then((value) {});
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: ColorPalette.mainColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: const Center(
                            child: Text(
                              'Bagikan ke Temanmu',
                              style: TextStyle(
                                fontSize: bodySmall,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
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
