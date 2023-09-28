import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/answer.dart';
import 'package:isilahtitiktitik/model/result_quiz.dart';
import 'package:isilahtitiktitik/resource/quiz_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';
import 'package:isilahtitiktitik/view/page-quiz/page_detail_result_quiz.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart' as just_audio;

class ResultQuizPage extends StatefulWidget {
  final List<AnswerModel>? answerModel;
  final int? quizId;
  final String? eventName;
  const ResultQuizPage(
      {Key? key, this.answerModel, this.quizId, this.eventName})
      : super(key: key);

  @override
  State<ResultQuizPage> createState() => _ResultQuizPageState();
}

class _ResultQuizPageState extends State<ResultQuizPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;

  final GlobalKey _globalKey = GlobalKey();
  final _player = just_audio.AudioPlayer();

  ResultQuizModel? resultQuizModel;

  AnimationController? controller;
  Animation<double>? animation;

  String headerReactionText = '';

  @override
  void initState() {
    onSubmitQuiz();
    super.initState();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
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

  void onSubmitQuiz() async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    QuizApi quizApi = QuizApi(http: chttp);

    setState(() {
      _isLoading = false;
    });

    await quizApi.postAnswer(widget.quizId, widget.answerModel).then((value) {
      quizApi
          .fetchReaction(value.data!.header!.correct! <= 5
              ? 'finish_fail'
              : 'finish_success')
          .then(
        (reaction) {
          Future.delayed(const Duration(milliseconds: 600)).then((values) {
            controller = AnimationController(
                duration: const Duration(milliseconds: 500), vsync: this);
            animation = Tween(begin: 0.0, end: 1.0).animate(controller!)
              ..addListener(() {
                if (reaction.data!.audio!.isNotEmpty) {
                  _player
                      .setAsset('assets/audio/${reaction.data!.audio}')
                      .then((value) {
                    _player.play();
                  });
                }
                setState(() {
                  resultQuizModel = value;
                  headerReactionText = reaction.data!.word!
                      .replaceAll('<p>', "")
                      .replaceAll("</p>", "");
                  _isLoading = true;
                });
              });
            controller!.forward();
          });
        },
      ).catchError((onError) {
        setState(() {
          _isLoading = true;
        });

        flushbarError(onError is String ? onError : onError['message']['title'])
            .show(context);
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = true;
      });

      flushbarError(onError is String ? onError : onError['message']['title'])
          .show(context);
    });
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
              ? FadeTransition(
                  opacity: animation!,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 90,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icon/ic_check.png',
                                  width: 18,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  '${resultQuizModel!.data!.header!.correct} Benar',
                                  style: const TextStyle(
                                    color: ColorPalette.success,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icon/ic_close.png',
                                  width: 18,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  '${resultQuizModel!.data!.header!.wrong} Salah',
                                  style: const TextStyle(
                                    color: ColorPalette.danger,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Expanded(
                        child: SizedBox(
                          height: 40,
                        ),
                      ),
                      Image.asset(
                        'assets/image/img_result_quiz.png',
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
                      const Expanded(
                        child: SizedBox(
                          height: 40,
                        ),
                      ),
                      Text(
                        headerReactionText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 14, fontFamily: 'PlusJakartaSans'),
                          children: [
                            const TextSpan(
                              text: "Kamu berhasil dapetin ",
                              style: TextStyle(
                                fontSize: bodyLarge,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "${resultQuizModel!.data!.header!.point.toString()} Star!",
                              style: const TextStyle(
                                fontSize: bodyLarge,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                      ),
                      const Expanded(
                        child: SizedBox(
                          height: 68,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailResultQuizPage(
                                        detailResultQuiz:
                                            resultQuizModel!.data!.detail,
                                        headerResultQuiz:
                                            resultQuizModel!.data!.header,
                                        eventName: widget.eventName,
                                      )));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(8)),
                          child: const Center(
                            child: Text(
                              'Lihat Hasil',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final RenderBox? box =
                              context.findRenderObject() as RenderBox?;
                          setState(() {});
                          await Future.delayed(
                              const Duration(milliseconds: 300));

                          final directory = Platform.isIOS
                              ? (await getApplicationDocumentsDirectory()).path
                              : (await getExternalStorageDirectory())!.path;
                          File imgFile = File('$directory/result_quiz.png');
                          _capturePng().then((value) async {
                            await imgFile.writeAsBytes(value);

                            Share.shareXFiles([XFile(imgFile.path)],
                                    subject: "Selamat kamu mendapatkan star",
                                    text:
                                        "Selamat kamu mendapatkan star ${resultQuizModel!.data!.header!.point.toString()}",
                                    sharePositionOrigin:
                                        box!.localToGlobal(Offset.zero) &
                                            box.size)
                                .then((value) {
                              setState(() {});
                            });
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              color: ColorPalette.mainColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: const Center(
                            child: Text(
                              'Bagikan ke Temanmu',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
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
