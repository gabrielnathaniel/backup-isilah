import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/model/result_quiz.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';
import 'package:isilahtitiktitik/view/page-quiz/page_detail_answer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class DetailResultQuizPage extends StatefulWidget {
  final List<DetailResultQuiz>? detailResultQuiz;
  final HeaderResultQuiz? headerResultQuiz;
  final String? eventName;
  const DetailResultQuizPage(
      {Key? key, this.detailResultQuiz, this.headerResultQuiz, this.eventName})
      : super(key: key);

  @override
  State<DetailResultQuizPage> createState() => _DetailResultQuizPageState();
}

class _DetailResultQuizPageState extends State<DetailResultQuizPage> {
  @override
  Widget build(BuildContext context) {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
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
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/image/img_bg_result_quiz.png',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                            widget.eventName!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          const Text(
                            'Yeay! Kamu berhasil Dapetin',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icon/ic_star_36.png',
                                width: 32,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                '${widget.headerResultQuiz!.point} star',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    CircularPercentIndicator(
                        startAngle: 180.0,
                        backgroundColor: ColorPalette.neutral_30,
                        radius: 50,
                        lineWidth: 14.0,
                        percent: widget.headerResultQuiz!.correct! /
                            widget.detailResultQuiz!.length,
                        center: RichText(
                          text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 14, fontFamily: 'PlusJakartaSans'),
                              children: [
                                TextSpan(
                                  text: '${widget.headerResultQuiz!.correct}',
                                  style: const TextStyle(
                                    color: ColorPalette.mainColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: '/${widget.detailResultQuiz!.length}',
                                  style: const TextStyle(
                                    color: ColorPalette.mainColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ]),
                        ),
                        linearGradient: const LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: <Color>[
                              ColorPalette.mainColor,
                              ColorPalette.mainColor
                            ]),
                        rotateLinearGradient: true,
                        circularStrokeCap: CircularStrokeCap.round),
                    const SizedBox(
                      width: 16,
                    ),
                    Flexible(
                      child: RichText(
                          text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 14, fontFamily: 'PlusJakartaSans'),
                              children: [
                            const TextSpan(
                              text: 'Kamu menjawab benar ',
                              style: TextStyle(
                                color: ColorPalette.neutral_90,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${widget.headerResultQuiz!.correct} dari ${widget.detailResultQuiz!.length}',
                              style: const TextStyle(
                                color: ColorPalette.neutral_90,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const TextSpan(
                              text: ' Pertanyaan!',
                              style: TextStyle(
                                color: ColorPalette.neutral_90,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ])),
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 4),
                child: Text(
                  'Jawaban Kamu',
                  style: TextStyle(
                    color: ColorPalette.neutral_90,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ...widget.detailResultQuiz!
                  .asMap()
                  .map(
                    (index, data) => MapEntry(
                      index,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 4),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: data.answerStatus == 1
                                ? ColorPalette.success
                                : ColorPalette.danger,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Soal ${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    '${data.point!} Star',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                '${data.question}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              data.answerStatus == 0
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Jawaban Benar :',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          '${data.correctAnswer}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                      ],
                                    )
                                  : Container(),
                              const Text(
                                'Jawaban Kamu :',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                data.answer ?? 'Tidak Menjawab',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (auth.currentUser!.data!.user!.id != 11) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailAnswerPage(
                                                    detailResultQuiz: data)));
                                  }
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Lihat Selengkapnya',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .values
                  .toList(),
              const SizedBox(
                height: 32,
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
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorPalette.mainColor,
                  ),
                  child: const Center(
                    child: Text(
                      'Kembali ke Beranda',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
