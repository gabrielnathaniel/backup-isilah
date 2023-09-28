import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/bloc/treasure-chest-bloc/treasure_chest_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/model/result_quiz.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-auth/page-login/page_login_by_email.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';
import 'package:isilahtitiktitik/view/page-intro/page_onboarding.dart';
import 'package:isilahtitiktitik/view/page-quiz/page_detail_answer.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/success_state_widget.dart';
import 'package:provider/provider.dart';

class ResultQuestionTreasureChestPage extends StatefulWidget {
  final int? eventId;
  const ResultQuestionTreasureChestPage({Key? key, @required this.eventId})
      : super(key: key);

  @override
  State<ResultQuestionTreasureChestPage> createState() =>
      _ResultQuestionTreasureChestPageState();
}

class _ResultQuestionTreasureChestPageState
    extends State<ResultQuestionTreasureChestPage> {
  TreasureChestBloc treasureChestBloc = TreasureChestBloc();

  @override
  void initState() {
    super.initState();
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    treasureChestBloc
        .add(GetResultTreasureChest(http: chttp, idQuiz: widget.eventId));
  }

  @override
  void dispose() {
    treasureChestBloc.close();
    super.dispose();
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
      child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocProvider<TreasureChestBloc>(
            create: (context) => treasureChestBloc,
            child: BlocListener<TreasureChestBloc, TreasureChestState>(
              listener: (context, state) {
                if (state is ResultTreasureChestNoAuth) {
                  BaseAuth auth = Provider.of<Auth>(context, listen: false);
                  auth.isLoggedIn().then((value) {
                    if (!value!) {
                      auth.logout();
                      if (Platform.isIOS) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginByEmailPage(),
                            ),
                            (route) => false);
                      } else {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const OnBoardingPage(),
                            ),
                            (route) => false);
                      }
                    }
                  });
                }
              },
              child: BlocBuilder<TreasureChestBloc, TreasureChestState>(
                builder: (context, state) {
                  if (state is TreasureChestInitial) {
                    return const LoadingWidget();
                  } else if (state is ResultTreasureChestLoading) {
                    return const LoadingWidget();
                  } else if (state is ResultTreasureChestLoaded) {
                    return _buildBody(context, state.resultQuizModel);
                  } else if (state is ResultTreasureChestError) {
                    return const SuccessStateWidget(
                      title: "",
                      content: "Terjadi kesalahan saat terhubung dengan server",
                      assets: 'assets/image/img_empty_state.png',
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          )),
    );
  }

  Widget _buildBody(BuildContext context, ResultQuizModel? resultQuizModel) {
    final int correct = resultQuizModel!.data!.header!.correct!;
    final int totalQuestion = resultQuizModel.data!.header!.correct! +
        resultQuizModel.data!.header!.wrong!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.14,
            child: Stack(
              children: [
                Image.asset(
                  'assets/image/img_bg_result_quiz.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Treasure Chest',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
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
                      text: '$correct',
                      style: const TextStyle(
                        color: ColorPalette.neutral_90,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: ' dari $totalQuestion ',
                      style: const TextStyle(
                        color: ColorPalette.neutral_90,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text: 'pertanyaan!',
                      style: TextStyle(
                        color: ColorPalette.neutral_90,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ]),
            ),
          ),
          ...resultQuizModel.data!.detail!
              .asMap()
              .map(
                (index, data) => MapEntry(
                  index,
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                data.answerStatus == 1 ? 'Benar' : 'Salah',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailAnswerPage(
                                          detailResultQuiz: data)));
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
    );
  }
}
