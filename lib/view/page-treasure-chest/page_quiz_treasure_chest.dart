import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/model/answer.dart';
import 'package:isilahtitiktitik/model/treasure_chest.dart';
import 'package:isilahtitiktitik/resource/treasure_chest_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-auth/page-login/page_login_by_email.dart';
import 'package:isilahtitiktitik/view/page-treasure-chest/page_result_treasure_chest.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/stacked_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// Page ini bertujuan untuk menjalankan quiz dari [Treasure Chest]
/// Yang dimana data quiz nya diambil dari page [CountdownPage]
/// Ada beberapa tipe pertanyaan yaitu :
/// Tipe Pertanyaan dengan Text [questionTypeId == 0]
/// Tipe Pertanyaan dengan Image [questionTypeId == 1]
/// Tipe Pertanyaan dengan Video [questionTypeId == 2]
/// Setiap user yang menjawab atau memilih [Option Jawaban] dan mengklik button [Berikutnya]
/// akan langsung memanggil [API] untuk pengecekan jawaban dan mendapatkan Response
/// Apabila Response dari API == `Benar` akan muncul Pertanyaan selanjutnya sampai
/// pertanyaan ke 25 atau terakhir.
/// Dan apabila Response dari API == `Salah` akan langsung pergi ke Page [ResultTreasureChestPage]
/// dengan mengirimkan data atau value [Kalah]
class QuizTreasureChestPage extends StatefulWidget {
  final int? eventId;
  final TreasureChestQuiz? dataQuiz;
  const QuizTreasureChestPage({Key? key, this.dataQuiz, this.eventId})
      : super(key: key);

  @override
  State<QuizTreasureChestPage> createState() => _QuizTreasureChestPageState();
}

class _QuizTreasureChestPageState extends State<QuizTreasureChestPage>
    with SingleTickerProviderStateMixin {
  PageController? _controller;
  YoutubePlayerController? _youtubeController;

  bool answered = false;
  bool isAnswered = false;
  bool isActiveTime = true;
  bool isLoading = true;

  String? answerOptions;

  int pages = 0;
  int questionPos = 0;
  int score = 0;
  int _currentIndexOption = -1;
  int? playTime;
  int? minutes;
  int? seconds;

  List<AnswerModel> listAnswer = [];

  @override
  void initState() {
    _controller = PageController(initialPage: 0);

    /// Validasi apakah tipe pertanyaan adalah Pertanyaan Video atau bukan
    /// Karna untuk [YoutubePlayerController] dibutuhkan inisialisasi di awal.
    /// dan mengubah variable [isActiveTime] menjadi [false] supapa tidak tampil
    /// sampai video tersebut selesai dijalankan.
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

  /// Fungsi ini bertujuan untuk mengecek jawaban user
  void checkAnswer(
      int? quizDetailId,
      int? questionId,
      String? answerOptions,
      int time,
      String correctAnswer,
      List<OptionTreasureChestQuiz> optionList,
      int index,
      bool answered) async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    TreasureChestApi treasureChestApi = TreasureChestApi(http: chttp);

    setState(() {
      isAnswered = true;
      isLoading = false;
    });

    await treasureChestApi
        .postAnswer(
            widget.eventId, quizDetailId, answered ? answerOptions : null, time)
        .then((value) {
      /// validasi,
      /// jika status `finish` == `0` maka lanjut ke pertanyaan selanjutnya.
      /// jika status `finish` == `1` maka quiz selesai dan user `menang`.
      /// jika status `finish` == `-1` maka quiz selesai dan user `kalah`.
      if (value.data!.finish == 0) {
        _controller!.nextPage(
            duration: const Duration(milliseconds: 1),
            curve: Curves.easeInExpo);
      } else if (value.data!.finish == 1) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ResultTreasureChestPage(
                  eventId: widget.eventId,
                  resultFlag: 'win',
                  indexSoal: pages,
                )));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ResultTreasureChestPage(
                  eventId: widget.eventId,
                  resultFlag: 'lose',
                  indexSoal: pages,
                )));
      }
      setState(() {
        isLoading = true;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = true;
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
              playTime = 0;
              minutes = 0;
              seconds = 0;
              pages = page;
            });

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
                                              false);
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
                                                        fit: BoxFit.fill,
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
                                                  setState(() {
                                                    answerOptions = data.code;
                                                    _currentIndexOption = i;
                                                  });
                                                },
                                                child: optionJawaban(
                                                    dataQuiz.detail![index]
                                                        .correctAnswerCode,
                                                    dataQuiz
                                                        .detail![index].options,
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
                                  isAnswered
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
                                                  true);
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
              ],
            );
          },
        ),
      ),
    );
  }

  Widget optionJawaban(
      String? correctAnswer,
      List<OptionTreasureChestQuiz>? optionList,
      int index,
      String? optionText) {
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
