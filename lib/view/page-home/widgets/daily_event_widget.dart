import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isilahtitiktitik/bloc/quiz-bloc/quiz_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/model/daily_event.dart';
import 'package:isilahtitiktitik/model/treasure_chest_list.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/view/page-quiz/page_countdown.dart';
import 'package:isilahtitiktitik/view/widgets/loading_event_daily.dart';
import 'package:provider/provider.dart';

class DailyEventWidget extends StatefulWidget {
  final List<DataTreasureChestList>? dataTraesureChest;
  const DailyEventWidget({Key? key, @required this.dataTraesureChest})
      : super(key: key);

  @override
  State<DailyEventWidget> createState() => _DailyEventWidgetState();
}

class _DailyEventWidgetState extends State<DailyEventWidget> {
  QuizBloc quizBloc = QuizBloc();

  void _refreshQuiz() {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    quizBloc.add(GetDailyEvent(
        http: chttp,
        timezone: DateTime.now().timeZoneName.toLowerCase(),
        gmt: DateTime.now().timeZoneOffset.inHours));
  }

  @override
  void initState() {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    quizBloc.add(GetDailyEvent(
        http: chttp,
        timezone: DateTime.now().timeZoneName.toLowerCase(),
        gmt: DateTime.now().timeZoneOffset.inHours));
    super.initState();
  }

  @override
  void dispose() {
    quizBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuizBloc>(
      create: (context) => quizBloc,
      child: _buildDailyEvent(),
    );
  }

  Widget _buildDailyEvent() {
    return BlocBuilder<QuizBloc, QuizState>(builder: (context, state) {
      if (state is QuizInitial) {
        return SizedBox(
            height: MediaQuery.of(context).size.height * 0.22,
            width: MediaQuery.of(context).size.width,
            child: loadingEventDaily(context));
      } else if (state is DailyEventLoading) {
        return SizedBox(
            height: MediaQuery.of(context).size.height * 0.22,
            width: MediaQuery.of(context).size.width,
            child: loadingEventDaily(context));
      } else if (state is DailyEventLoaded) {
        return _buildDaily(context, state.dailyEventModel);
      } else if (state is DailyEventError) {
        // return _buildEmptyCart();
        // Logger().d("message error ${state.message}");
        return Container();
      }
      return Container();
    });
  }

  Widget _buildDaily(BuildContext context, DailyEventModel dailyEventModel) {
    Duration? diffTime;
    if (dailyEventModel.data!.current!.event != null) {
      var endTimeCurrent =
          "${dailyEventModel.data!.current!.eventDate} ${dailyEventModel.data!.current!.startTo}";

      diffTime = DateFormat("yyyy-MM-dd HH:mm:ss", 'id')
          .parse(endTimeCurrent)
          .difference(DateTime.now());
    } else {
      var startTimeCurrent =
          "${dailyEventModel.data!.next!.eventDate} ${dailyEventModel.data!.next!.startFrom}";

      diffTime = DateFormat("yyyy-MM-dd HH:mm:ss", 'id')
          .parse(startTimeCurrent)
          .difference(DateTime.now());
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: const Color(0xFF252C6F),
        margin: const EdgeInsets.only(left: 16, right: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF252C6F),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(16),
          child: dailyEventModel.data!.current!.event != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${dailyEventModel.data!.current!.event}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                    color: dailyEventModel
                                                    .data!.current!.eventId! ==
                                                1 ||
                                            dailyEventModel
                                                    .data!.current!.eventId! ==
                                                2 ||
                                            dailyEventModel
                                                    .data!.current!.eventId! ==
                                                3
                                        ? ColorPalette.mainColor
                                        : ColorPalette.neutral_50,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Image.asset(
                                    'assets/icon/ic_pagi.png',
                                    width: 15,
                                  ),
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 2,
                                color:
                                    dailyEventModel.data!.current!.eventId! ==
                                                2 ||
                                            dailyEventModel
                                                    .data!.current!.eventId! ==
                                                3
                                        ? ColorPalette.mainColor
                                        : ColorPalette.neutral_50,
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                    color: dailyEventModel
                                                    .data!.current!.eventId! ==
                                                2 ||
                                            dailyEventModel
                                                    .data!.current!.eventId! ==
                                                3
                                        ? ColorPalette.mainColor
                                        : ColorPalette.neutral_50,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Image.asset(
                                    'assets/icon/ic_siang.png',
                                    width: 15,
                                  ),
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 2,
                                color:
                                    dailyEventModel.data!.current!.eventId! == 3
                                        ? ColorPalette.mainColor
                                        : ColorPalette.neutral_50,
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                    color: dailyEventModel
                                                .data!.current!.eventId! ==
                                            3
                                        ? ColorPalette.mainColor
                                        : ColorPalette.neutral_50,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Image.asset(
                                    'assets/icon/ic_sore.png',
                                    width: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Sisa waktu ${dailyEventModel.data!.current!.event}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        TweenAnimationBuilder<Duration>(
                            duration: Duration(seconds: diffTime.inSeconds),
                            tween: Tween(
                                begin: Duration(seconds: diffTime.inSeconds),
                                end: Duration.zero),
                            onEnd: () {
                              Future.delayed(const Duration(milliseconds: 1000))
                                  .then((value) {
                                _refreshQuiz();
                              });
                            },
                            builder: (BuildContext context, Duration value,
                                Widget? child) {
                              final hours = value.inHours % 24;
                              final minutes = value.inMinutes % 60;
                              final seconds = value.inSeconds % 60;

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${hours.toString().padLeft(1, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CountdownPage(
                                      idQuiz: dailyEventModel
                                          .data!.current!.eventId,
                                      eventName:
                                          dailyEventModel.data!.current!.event,
                                    )));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: ColorPalette.mainColor,
                        ),
                        child: const Center(
                          child: Text(
                            'Mulai',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (widget.dataTraesureChest!.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...widget.dataTraesureChest!.map((treasure) {
                            return Row(
                              children: [
                                Container(
                                  width: 6.0,
                                  height: 4.0,
                                  margin: const EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white),
                                ),
                              ],
                            );
                          }).toList(),
                          Container(
                            width: 12.0,
                            height: 4.0,
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorPalette.mainColor,
                            ),
                          ),
                        ],
                      ),
                  ],
                )
              : dailyEventModel.data!.next!.event == null
                  ? const Text(
                      'Coming Soon',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${dailyEventModel.data!.next!.event}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            TweenAnimationBuilder<Duration>(
                                duration: Duration(seconds: diffTime.inSeconds),
                                tween: Tween(
                                    begin:
                                        Duration(seconds: diffTime.inSeconds),
                                    end: Duration.zero),
                                onEnd: () {
                                  Future.delayed(
                                          const Duration(milliseconds: 1000))
                                      .then((value) {
                                    _refreshQuiz();
                                  });
                                },
                                builder: (BuildContext context, Duration value,
                                    Widget? child) {
                                  final hours = value.inHours % 24;
                                  final minutes = value.inMinutes % 60;

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        hours > 0
                                            ? '${hours.toString().padLeft(1, '0')} Jam Lagi'
                                            : minutes > 10
                                                ? '${minutes.toString().padLeft(2, '0')} Menit Lagi'
                                                : '${minutes.toString().padLeft(1, '0')} Menit Lagi',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: ColorPalette.mainColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              dailyEventModel.data!.next!.randomWord == null
                                  ? ""
                                  : dailyEventModel.data!.next!.randomWord!
                                      .replaceAll('<p>', "")
                                      .replaceAll("</p>", ""),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                height: 1.5,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        if (widget.dataTraesureChest!.isNotEmpty)
                          Column(
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ...widget.dataTraesureChest!.map((treasure) {
                                    return Row(
                                      children: [
                                        Container(
                                          width: 6.0,
                                          height: 4.0,
                                          margin:
                                              const EdgeInsets.only(right: 4),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                  Container(
                                    width: 12.0,
                                    height: 4.0,
                                    margin: const EdgeInsets.only(right: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorPalette.mainColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
        ),
      ),
    );
  }
}
