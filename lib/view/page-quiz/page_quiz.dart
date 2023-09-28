import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/model/answer.dart';
import 'package:isilahtitiktitik/model/play_quiz.dart';
import 'package:isilahtitiktitik/resource/quiz_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-auth/page-login/page_login_by_email.dart';
import 'package:isilahtitiktitik/view/page-quiz/page_result_quiz.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/stacked_card_widget.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class QuizPage extends StatefulWidget {
  final DataQuiz? dataQuiz;
  final String? eventName;
  const QuizPage({Key? key, this.dataQuiz, this.eventName}) : super(key: key);

  @override
  State<QuizPage> createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  PageController? _controller;
  YoutubePlayerController? _youtubeController;
  final _player = just_audio.AudioPlayer();

  bool answered = false;
  bool isAnswered = false;
  bool isLoadingAnswered = false;
  bool isActiveTime = true;
  bool isHeaderResult = false;

  String? headerResultTitle;
  String? headerResultAsset;
  String? answerOptions;

  int pages = 0;
  int score = 0;
  int _currentIndexOption = -1;
  int? playTime;
  int? minutes;
  int? seconds;

  List<AnswerModel> listAnswer = [];

  @override
  void initState() {
    _controller = PageController(initialPage: 0);

    /// init soal video
    /// questionTypeId [text == 0]
    /// questionTypeId [image == 1]
    /// questionTypeId [video == 2]
    if (widget.dataQuiz!.detail!.first.questionTypeId == 2) {
      _youtubeController = YoutubePlayerController.fromVideoId(
        videoId: YoutubePlayerController.convertUrlToId(
                widget.dataQuiz!.detail!.first.video!)
            .toString(),
        autoPlay: true,
        params: const YoutubePlayerParams(
          showFullscreenButton: false,
          strictRelatedVideos: false,
        ),
      );
      setState(() {
        isActiveTime = false;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  /// function untuk [check jawaban] dan [submit] jawaban
  void checkAnswer(
      int? quizDetailId,
      int? questionId,
      String? answerOptions,
      int time,
      String correctAnswer,
      List<OptionQuiz> optionList,
      int index,
      bool answered,
      int correctPoint,
      int inCorrectPoint,
      int notAnswerPoint) async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    QuizApi quizApi = QuizApi(http: chttp);
    final correctIndex =
        optionList.indexWhere((element) => element.code == correctAnswer);
    String reaction;

    setState(() {
      isLoadingAnswered = true;
    });

    if (answered) {
      if (index == correctIndex) {
        /// Jawab Benar
        reaction = 'correct_answer';
      } else {
        /// Jawab Salah
        reaction = 'wrong_answer';
      }
    } else {
      /// Tidak Menjawab
      reaction = 'not_answer';
    }

    await quizApi.fetchReaction(reaction).then((value) async {
      if (value.data != null) {
        setState(() {
          isAnswered = true;
        });
        setState(() {
          isHeaderResult = true;
          if (answered) {
            if (index == correctIndex) {
              score += correctPoint;
              headerResultAsset = 'assets/image/img_quiz_benar.png';
              headerResultTitle = '${value.data!.word}\n+$correctPoint star';
            } else {
              score += inCorrectPoint;
              headerResultAsset = 'assets/image/img_quiz_salah.png';
              headerResultTitle = '${value.data!.word}\n$inCorrectPoint star';
            }
          } else {
            score += notAnswerPoint;
            headerResultAsset = 'assets/image/img_quiz_tidak_tahu.png';
            headerResultTitle = '${value.data!.word}\n$notAnswerPoint star';
          }
        });

        if (value.data!.audio!.isNotEmpty) {
          await _player
              .setAsset('assets/audio/${value.data!.audio}')
              .then((value) {
            _player.play();
          });
        }

        AnswerModel answerModel = AnswerModel();
        answerModel.quizDetailId = quizDetailId;
        answerModel.questionId = questionId;
        answerModel.answerCode = answerOptions;
        answerModel.playTime = time;
        listAnswer.add(answerModel);

        await Future.delayed(const Duration(milliseconds: 2000));

        /// check pertanyaan terakhir, jika pertanyaan terakhir selesai
        /// maka Navigasi ke [ResultQuizPage] dengan param [list AnswerModel] dan
        /// [id quiz].
        if (_controller!.page?.toInt() == widget.dataQuiz!.detail!.length - 1) {
          if (!mounted) return;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ResultQuizPage(
                        answerModel: listAnswer,
                        quizId: widget.dataQuiz!.header!.quizId,
                        eventName: widget.eventName,
                      )));
        } else {
          _controller!.nextPage(
              duration: const Duration(milliseconds: 1),
              curve: Curves.easeInExpo);
        }
      }
    }).catchError((onError) {
      setState(() {
        isAnswered = false;
        isLoadingAnswered = false;
      });
      flushbarError(onError is String ? onError : onError['message']['title'])
          .show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);

    /// check if token user expired
    auth.isLoggedIn().then((value) {
      if (!value!) {
        auth.logout();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const LoginByEmailPage(),
            ),
            (route) => false);
      }
    });
    var dataQuiz = widget.dataQuiz;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: ColorPalette.darkBlue,
        body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          onPageChanged: (page) {
            setState(() {
              _currentIndexOption = -1;
              answerOptions = null;
              isAnswered = false;
              isLoadingAnswered = false;
              isHeaderResult = false;
              playTime = 0;
              minutes = 0;
              seconds = 0;
              pages = page;

              headerResultAsset = '';
              headerResultTitle = '';
            });

            /// Check pertanyaan video
            if (widget.dataQuiz!.detail![page].questionTypeId == 2) {
              _youtubeController = YoutubePlayerController.fromVideoId(
                videoId: YoutubePlayerController.convertUrlToId(
                        widget.dataQuiz!.detail![page].video!)
                    .toString(),
                autoPlay: true,
                params: const YoutubePlayerParams(
                  showFullscreenButton: false,
                  strictRelatedVideos: false,
                  enableCaption: false,
                ),
              );
              setState(() {
                isActiveTime = false;
              });
            } else {
              setState(() {
                isActiveTime = true;
              });
            }
          },
          itemCount: dataQuiz!.detail!.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/image/img_splash_7.png',
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: isActiveTime
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icon/ic_timer.png',
                                  width: 16,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: TweenAnimationBuilder<Duration>(
                                      duration: Duration(
                                          seconds: dataQuiz
                                                  .detail![index].duration ??
                                              25),
                                      tween: Tween(
                                          begin: Duration(
                                              seconds: dataQuiz.detail![index]
                                                      .duration ??
                                                  25),
                                          end: Duration.zero),
                                      onEnd: () {
                                        if (!isAnswered) {
                                          checkAnswer(
                                              dataQuiz
                                                  .detail![index].quizDetailId,
                                              dataQuiz
                                                  .detail![index].questionId,
                                              answerOptions,
                                              dataQuiz.detail![index]
                                                      .duration ??
                                                  25,
                                              dataQuiz.detail![index]
                                                  .correctAnswerCode!,
                                              dataQuiz.detail![index].options!,
                                              _currentIndexOption,
                                              false,
                                              dataQuiz.detail![index].point!,
                                              dataQuiz.detail![index]
                                                  .pointIncorrect!,
                                              dataQuiz.detail![index]
                                                  .pointNotAnswer!);
                                        }
                                      },
                                      builder: (BuildContext context,
                                          Duration value, Widget? child) {
                                        minutes = value.inMinutes;
                                        seconds = value.inSeconds % 60;
                                        playTime = value.inSeconds;

                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(80),
                                          child: LinearProgressIndicator(
                                            backgroundColor:
                                                ColorPalette.bgLinear,
                                            minHeight: 16,
                                            value: value.inSeconds *
                                                100 /
                                                (dataQuiz.detail![index]
                                                        .duration ??
                                                    25) /
                                                100,
                                            valueColor: AlwaysStoppedAnimation<
                                                    Color>(
                                                calculateBackgroundColor(
                                                    value: value.inSeconds *
                                                        100 /
                                                        (dataQuiz.detail![index]
                                                                .duration ??
                                                            25) /
                                                        100)),
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            )
                          : Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: ColorPalette.background,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icon/ic_help.png',
                                  width: 20,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  '${index + 1} dari ${dataQuiz.detail!.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: ColorPalette.background,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icon/ic_star_36.png',
                                  width: 20,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  '$score star',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Flexible(
                      child: Container(
                        height: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        child: StackOfCards(
                          num: _stackedCard(dataQuiz.detail!.length),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  dataQuiz.detail![index].questionTypeId == 0 &&
                                          dataQuiz.detail![index].text == null
                                      ? Container()
                                      : Container(
                                          width: double.infinity,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.27,
                                          decoration: BoxDecoration(
                                              color:
                                                  ColorPalette.colorListRanks,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: dataQuiz.detail![index]
                                                      .questionTypeId ==
                                                  0
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: Center(
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        dataQuiz.detail![index]
                                                                    .text ==
                                                                null
                                                            ? "Jawablah pertanyaan dibawah ini"
                                                            : dataQuiz
                                                                .detail![index]
                                                                .text!,
                                                        style: const TextStyle(
                                                          fontSize: 42,
                                                          color: ColorPalette
                                                              .neutral_90,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : dataQuiz.detail![index]
                                                          .questionTypeId ==
                                                      1
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: CachedNetworkImage(
                                                        imageUrl: dataQuiz
                                                                .detail![index]
                                                                .image ??
                                                            '',
                                                        fit: BoxFit.cover,
                                                        placeholder: (context,
                                                                url) =>
                                                            Center(
                                                                child: Shimmer
                                                                    .fromColors(
                                                          baseColor:
                                                              Colors.grey[300]!,
                                                          highlightColor:
                                                              Colors.grey[100]!,
                                                          child: Container(
                                                            color: Colors.white,
                                                          ),
                                                        )),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                          "assets/image/default_image.png",
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child:
                                                          YoutubeValueBuilder(
                                                              controller:
                                                                  _youtubeController!,
                                                              builder: (context,
                                                                  value) {
                                                                if (value
                                                                        .playerState ==
                                                                    PlayerState
                                                                        .ended) {
                                                                  setState(() {
                                                                    isActiveTime =
                                                                        true;
                                                                  });
                                                                }
                                                                return YoutubePlayer(
                                                                  controller:
                                                                      _youtubeController!,
                                                                  aspectRatio:
                                                                      MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .aspectRatio,
                                                                  backgroundColor: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .background,
                                                                  // showVideoProgressIndicator: true,
                                                                  // progressIndicatorColor: Colors.blueAccent,
                                                                  // onEnded: (data) {
                                                                  //   setState(() {
                                                                  //     isActiveTime = true;
                                                                  //   });
                                                                  // },
                                                                );
                                                              }),
                                                    )),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    dataQuiz.detail![index].question!.trim(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: ColorPalette.neutral_90,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  ...dataQuiz.detail![index].options!
                                      .asMap()
                                      .map((i, data) => MapEntry(
                                            i,
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: InkWell(
                                                onTap: () {
                                                  if (!isAnswered) {
                                                    setState(() {
                                                      answerOptions = data.code;
                                                      _currentIndexOption = i;
                                                    });
                                                  }
                                                },
                                                child: optionJawaban(
                                                    dataQuiz.detail![index]
                                                        .correctAnswerCode,
                                                    dataQuiz.detail![index]
                                                        .options!,
                                                    i,
                                                    data.answer),
                                              ),
                                            ),
                                          ))
                                      .values
                                      .toList(),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  isLoadingAnswered
                                      ? Container()
                                      : GestureDetector(
                                          onTap: () {
                                            if (_currentIndexOption != -1 &&
                                                !isAnswered) {
                                              checkAnswer(
                                                  dataQuiz.detail![index]
                                                      .quizDetailId,
                                                  dataQuiz.detail![index]
                                                      .questionId,
                                                  answerOptions,
                                                  dataQuiz.detail![index]
                                                          .duration ??
                                                      25 - playTime!,
                                                  dataQuiz.detail![index]
                                                      .correctAnswerCode!,
                                                  dataQuiz
                                                      .detail![index].options!,
                                                  _currentIndexOption,
                                                  true,
                                                  dataQuiz
                                                      .detail![index].point!,
                                                  dataQuiz.detail![index]
                                                      .pointIncorrect!,
                                                  dataQuiz.detail![index]
                                                      .pointNotAnswer!);
                                            }
                                          },
                                          child: Container(
                                            height: 55,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: _currentIndexOption == -1
                                                  ? ColorPalette.btnDisableRanks
                                                  : ColorPalette.mainColor,
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Berikutnya',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: _currentIndexOption ==
                                                          -1
                                                      ? ColorPalette.neutral_90
                                                          .withOpacity(0.5)
                                                      : Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  isLoadingAnswered
                                      ? Container()
                                      : GestureDetector(
                                          onTap: () {
                                            if (!isAnswered) {
                                              checkAnswer(
                                                  dataQuiz.detail![index]
                                                      .quizDetailId,
                                                  dataQuiz.detail![index]
                                                      .questionId,
                                                  answerOptions,
                                                  dataQuiz.detail![index]
                                                          .duration ??
                                                      25,
                                                  dataQuiz.detail![index]
                                                      .correctAnswerCode!,
                                                  dataQuiz
                                                      .detail![index].options!,
                                                  _currentIndexOption,
                                                  false,
                                                  dataQuiz
                                                      .detail![index].point!,
                                                  dataQuiz.detail![index]
                                                      .pointIncorrect!,
                                                  dataQuiz.detail![index]
                                                      .pointNotAnswer!);
                                            }
                                          },
                                          child: Container(
                                            height: 55,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.transparent),
                                            child: const Center(
                                              child: Text(
                                                'Gak tau',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color:
                                                      ColorPalette.neutral_90,
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
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                isHeaderResult
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: MediaQuery.of(context).size.height * 0.17,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(headerResultAsset!),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              headerResultTitle!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ))
                    : Container(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget optionJawaban(String? correctAnswer, List<OptionQuiz> optionList,
      int index, String? optionText) {
    final correctIndex =
        optionList.indexWhere((element) => element.code == correctAnswer);

    if (isAnswered) {
      if (index == correctIndex) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorPalette.success,
            border: Border.all(color: ColorPalette.neutral_40, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  optionText ?? '-',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              const Icon(
                Icons.check_rounded,
                size: 16,
                color: Colors.white,
              ),
            ],
          ),
        );
      } else if (index == _currentIndexOption) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorPalette.danger,
            border: Border.all(color: ColorPalette.neutral_40, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  optionText ?? '-',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              const Icon(
                Icons.close_rounded,
                size: 16,
                color: Colors.white,
              ),
            ],
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white.withOpacity(0.3),
            border: Border.all(
                color: ColorPalette.neutral_40.withOpacity(0.3), width: 1),
          ),
          child: Text(
            optionText ?? '-',
            style: TextStyle(
              color: ColorPalette.neutral_90.withOpacity(0.3),
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        );
      }
    } else {
      if (index == _currentIndexOption) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorPalette.mainColor,
            border: Border.all(color: ColorPalette.neutral_40, width: 1),
          ),
          child: Text(
            optionText ?? '-',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        );
      }
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: ColorPalette.neutral_40, width: 1),
      ),
      child: Text(
        optionText ?? '-',
        style: const TextStyle(
          color: ColorPalette.neutral_90,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }

  Color calculateBackgroundColor({required double value}) {
    if (value < 0.30) {
      return ColorPalette.danger;
    } else if (value < 0.60) {
      return ColorPalette.colorTextYellow;
    } else {
      return ColorPalette.success;
    }
  }

  int _stackedCard(int totalQuestion) {
    if (pages == totalQuestion - 1) {
      return 1;
    } else if (pages == totalQuestion - 2) {
      return 2;
    } else if (pages == totalQuestion - 3) {
      return 3;
    } else {
      return 4;
    }
  }
}

/// build video controller
class VideoPositionIndicator extends StatelessWidget {
  const VideoPositionIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.ytController;

    return StreamBuilder<YoutubeVideoState>(
      stream: controller.videoStateStream,
      initialData: const YoutubeVideoState(),
      builder: (context, snapshot) {
        final position = snapshot.data?.position.inMilliseconds ?? 0;
        final duration = controller.metadata.duration.inMilliseconds;

        return LinearProgressIndicator(
          value: duration == 0 ? 0 : position / duration,
          minHeight: 1,
        );
      },
    );
  }
}
