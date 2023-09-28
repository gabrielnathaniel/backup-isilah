import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/bloc/quiz-bloc/quiz_bloc.dart';
import 'package:isilahtitiktitik/bloc/treasure-chest-bloc/treasure_chest_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/play_quiz.dart';
import 'package:isilahtitiktitik/model/treasure_chest.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-auth/page-login/page_login_by_email.dart';
import 'package:isilahtitiktitik/view/page-intro/page_onboarding.dart';
import 'package:isilahtitiktitik/view/page-quiz/page_quiz.dart';
import 'package:isilahtitiktitik/view/page-treasure-chest/page_quiz_treasure_chest.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/success_state_widget.dart';
import 'package:isilahtitiktitik/view/widgets/update_app_widget.dart';
import 'package:provider/provider.dart';

class CountdownPage extends StatefulWidget {
  final int? idQuiz;
  final String? flagQuiz;
  final String? eventName;
  const CountdownPage({Key? key, this.idQuiz, this.flagQuiz, this.eventName})
      : super(key: key);

  @override
  State<CountdownPage> createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage>
    with TickerProviderStateMixin {
  QuizBloc quizBloc = QuizBloc();
  TreasureChestBloc treasureChestBloc = TreasureChestBloc();

  PlayQuizModel? _playQuizModel;
  TreasureChestModel? _treasureChestModel;

  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);

    /// Validasi untuk mengambil [source pertanyaan].
    if (widget.flagQuiz == "treasure_chest") {
      treasureChestBloc
          .add(GetPlayTreasureChest(http: chttp, idQuiz: widget.idQuiz));
    } else {
      quizBloc.add(GetPlayQuiz(http: chttp, idQuiz: widget.idQuiz));
    }

    super.initState();
  }

  @override
  void dispose() {
    quizBloc.close();
    treasureChestBloc.close();
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: ColorPalette.darkBlue,
        body: MultiBlocProvider(
          providers: [
            BlocProvider<QuizBloc>(
              create: (context) => quizBloc,
            ),
            BlocProvider<TreasureChestBloc>(
              create: (context) => treasureChestBloc,
            ),
          ],
          child: _buildBlocBuilder(),
        ),
      ),
    );
  }

  Widget _buildBlocBuilder() {
    return widget.flagQuiz == "treasure_chest"
        ? BlocListener<TreasureChestBloc, TreasureChestState>(
            listener: (context, state) {
              if (state is PlayTreasureChestNoAuth) {
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
              if (state is PlayTreasureChestUpdateApp) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => UpdateAppWidget(
                        link: Platform.isAndroid ? androidUrl : iOSUrl,
                      ),
                    ),
                    (route) => false);
              }
            },
            child: BlocBuilder<TreasureChestBloc, TreasureChestState>(
              builder: (context, state) {
                if (state is TreasureChestInitial) {
                  return const LoadingWidget();
                } else if (state is PlayTreasureChestLoading) {
                  return const LoadingWidget();
                } else if (state is PlayTreasureChestLoaded) {
                  _treasureChestModel = state.treasureChestModel;
                  _controller = AnimationController(
                    duration: const Duration(milliseconds: 1000),
                    vsync: this,
                  )..repeat(reverse: true);
                  _animation = CurvedAnimation(
                      parent: _controller!, curve: Curves.easeIn);
                  return _buildBody(context);
                } else if (state is PlayTreasureChestError) {
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
          )
        : BlocListener<QuizBloc, QuizState>(
            listener: (context, state) {
              if (state is PlayQuizNoAuth) {
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
              if (state is PlayQuizUpdateApp) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => UpdateAppWidget(
                        link: Platform.isAndroid ? androidUrl : iOSUrl,
                      ),
                    ),
                    (route) => false);
              }
            },
            child: BlocBuilder<QuizBloc, QuizState>(
              builder: (context, state) {
                if (state is QuizInitial) {
                  return const LoadingWidget();
                } else if (state is PlayQuizLoading) {
                  return const LoadingWidget();
                } else if (state is PlayQuizLoaded) {
                  _playQuizModel = state.playQuizModel;
                  _controller = AnimationController(
                    duration: const Duration(milliseconds: 1000),
                    vsync: this,
                  )..repeat(reverse: true);
                  _animation = CurvedAnimation(
                      parent: _controller!, curve: Curves.easeIn);
                  return _buildBody(context);
                } else if (state is PlayQuizError) {
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
          );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        TweenAnimationBuilder<Duration>(
            duration: const Duration(seconds: 6),
            tween: Tween(
                begin: const Duration(seconds: 0),
                end: const Duration(seconds: 6)),
            onEnd: () {
              if (widget.flagQuiz == "treasure_chest") {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuizTreasureChestPage(
                            eventId: widget.idQuiz,
                            dataQuiz: _treasureChestModel!.data!.quiz!)));
              } else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuizPage(
                              dataQuiz: _playQuizModel!.data!.quiz!,
                              eventName: widget.eventName,
                            )));
              }
            },
            builder: (BuildContext context, Duration value, Widget? child) {
              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.25),
                    child: Column(
                      children: [
                        FadeTransition(
                          opacity: _animation!,
                          child: Center(
                            child: Text(
                              value.inSeconds == 0 || value.inSeconds == 1
                                  ? "Siap - Siap!"
                                  : value.inSeconds == 2 || value.inSeconds == 3
                                      ? "Atur Posisi!"
                                      : value.inSeconds == 4 ||
                                              value.inSeconds == 5
                                          ? "Mulai!"
                                          : "Mulai!",
                              style: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/image/img_contour.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FadeTransition(
                        opacity: _animation!,
                        child: Center(
                          child: Image.asset(
                            value.inSeconds == 0 || value.inSeconds == 1
                                ? 'assets/image/img_ready.png'
                                : value.inSeconds == 2 || value.inSeconds == 3
                                    ? 'assets/image/img_set_position.png'
                                    : 'assets/image/img_start.png',
                            width: value.inSeconds > 3 ? 220 : 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: value.inSeconds > 3 ? 120 : 32,
                      )
                    ],
                  ),
                ],
              );
            }),
      ],
    );
  }
}
