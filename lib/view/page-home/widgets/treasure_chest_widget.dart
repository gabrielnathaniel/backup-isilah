import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isilahtitiktitik/bloc/treasure_chest_list/treasure_chest_list_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/model/treasure_chest_list.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/daily_event_widget.dart';
import 'package:isilahtitiktitik/view/page-treasure-chest/cara_bermain_page.dart';
import 'package:isilahtitiktitik/view/page-treasure-chest/page_leaderboard_treasure_chest.dart';
import 'package:isilahtitiktitik/view/widgets/loading_event_daily.dart';
import 'package:provider/provider.dart';

class TreasureChestWidget extends StatefulWidget {
  const TreasureChestWidget({Key? key}) : super(key: key);

  @override
  State<TreasureChestWidget> createState() => _TreasureChestWidgetState();
}

class _TreasureChestWidgetState extends State<TreasureChestWidget> {
  TreasureChestListBloc treasureChestListBloc = TreasureChestListBloc();
  int indexTreasure = 0;

  void _refreshTreasureChest() {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    treasureChestListBloc.add(GetTreasureChestList(http: chttp));
  }

  @override
  void initState() {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    treasureChestListBloc.add(GetTreasureChestList(http: chttp));
    super.initState();
  }

  @override
  void dispose() {
    treasureChestListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TreasureChestListBloc>(
      create: (context) => treasureChestListBloc,
      child: _buildTreasureChest(),
    );
  }

  Widget _buildTreasureChest() {
    return BlocBuilder<TreasureChestListBloc, TreasureChestListState>(
        builder: (context, state) {
      if (state is TreasureChestListInitial) {
        return SizedBox(
            height: MediaQuery.of(context).size.height * 0.22,
            width: MediaQuery.of(context).size.width,
            child: loadingEventDaily(context));
      } else if (state is TreasureChestListLoading) {
        return SizedBox(
            height: MediaQuery.of(context).size.height * 0.22,
            width: MediaQuery.of(context).size.width,
            child: loadingEventDaily(context));
      } else if (state is TreasureChestListLoaded) {
        return _buildTreasureChestList(context, state.treasureChestListModel);
      } else if (state is TreasureChestListError) {
        return CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.22,
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() => indexTreasure = index);
            },
          ),
          items: const [
            DailyEventWidget(dataTraesureChest: []),
          ],
        );
      }
      return CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.22,
          aspectRatio: 16 / 9,
          viewportFraction: 1,
          onPageChanged: (index, reason) {
            setState(() => indexTreasure = index);
          },
        ),
        items: const [
          DailyEventWidget(dataTraesureChest: []),
        ],
      );
    });
  }

  Widget _buildTreasureChestList(
      BuildContext context, TreasureChestListModel treasureChestListModel) {
    return CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.22,
          aspectRatio: 16 / 9,
          viewportFraction: 1,
          initialPage: indexTreasure,
          enableInfiniteScroll:
              treasureChestListModel.data!.isEmpty ? false : true,
          onPageChanged: (index, reason) {
            _refreshTreasureChest();
            setState(() => indexTreasure = index);
          },
        ),
        items: [
          ...treasureChestListModel.data!.map((dataTreasure) {
            return Builder(builder: (context) {
              Duration? diffTimeStart;
              var startTimeNext =
                  "${dataTreasure.startDate} ${dataTreasure.startFrom}";
              var endTimeNext =
                  "${dataTreasure.endDate} ${dataTreasure.startTo}";

              if (dataTreasure.statusTimer == -1) {
                diffTimeStart = DateFormat("yyyy-MM-dd HH:mm:ss", 'id')
                    .parse(startTimeNext)
                    .difference(DateTime.now());
              } else {
                diffTimeStart = DateFormat("yyyy-MM-dd HH:mm:ss", 'id')
                    .parse(endTimeNext)
                    .difference(DateTime.now());
              }

              return Card(
                color: const Color(0xFF252C6F),
                margin: const EdgeInsets.only(left: 16, right: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.92,
                  height: MediaQuery.of(context).size.height * 0.22,
                  decoration: BoxDecoration(
                      color: const Color(0xFF252C6F),
                      borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          'assets/image/img_semi_circle_3.png',
                          width: 60,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10)),
                          child: Image.asset(
                            'assets/image/img_rectangle_yellow.png',
                            width: 25,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10)),
                          child: Image.asset(
                            'assets/image/img_line_three.png',
                            width: 50,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10)),
                          child: Image.asset(
                            'assets/image/img_line_one.png',
                            width: 32,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/icon/ic_treasure.png',
                                  width: 18,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    dataTreasure.event!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                dataTreasure.statusTimer == 1
                                    ? const Text(
                                        'Selesai',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      )
                                    : dataTreasure.statusTimer == -1 &&
                                            diffTimeStart.inSeconds < 0
                                        ? Container()
                                        : dataTreasure.statusTimer == -1
                                            ? TweenAnimationBuilder<Duration>(
                                                duration: Duration(
                                                    seconds: diffTimeStart
                                                        .inSeconds),
                                                tween: Tween(
                                                    begin: Duration(
                                                        seconds: diffTimeStart
                                                            .inSeconds),
                                                    end: Duration.zero),
                                                onEnd: () {
                                                  Future.delayed(const Duration(
                                                          milliseconds: 1000))
                                                      .then((value) {
                                                    _refreshTreasureChest();
                                                  });
                                                },
                                                builder: (BuildContext context,
                                                    Duration value,
                                                    Widget? child) {
                                                  return const Text(
                                                    'Belum dimulai ⏳',
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  );
                                                })
                                            : dataTreasure.statusTimer == 0 &&
                                                    diffTimeStart.inSeconds < 0
                                                ? Container()
                                                : TweenAnimationBuilder<
                                                        Duration>(
                                                    duration: Duration(
                                                        seconds: diffTimeStart
                                                            .inSeconds),
                                                    tween: Tween(
                                                        begin: Duration(
                                                            seconds:
                                                                diffTimeStart
                                                                    .inSeconds),
                                                        end: Duration.zero),
                                                    onEnd: () {
                                                      Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      1000))
                                                          .then((value) {
                                                        _refreshTreasureChest();
                                                      });
                                                    },
                                                    builder:
                                                        (BuildContext context,
                                                            Duration value,
                                                            Widget? child) {
                                                      final days = value.inDays;
                                                      final hours =
                                                          value.inHours % 24;
                                                      final minutes =
                                                          value.inMinutes % 60;
                                                      final seconds =
                                                          value.inSeconds % 60;

                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            days > 0
                                                                ? '$days Hari ${hours.toString().padLeft(1, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'
                                                                : '${hours.toString().padLeft(1, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }),
                              ],
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Prize Pool',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: ColorPalette.neutral_40,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        dataTreasure.prize!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (dataTreasure.statusJoin == 0) {
                                      if (dataTreasure.statusTimer == 0) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CaraBermainPage(
                                                      eventId: dataTreasure.id,
                                                    )));
                                      } else if (dataTreasure.statusTimer ==
                                          1) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LeaderboardTreasureChestPage(
                                                      eventId: dataTreasure.id,
                                                      navigate: false,
                                                    )));
                                      }
                                    } else {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LeaderboardTreasureChestPage(
                                                    eventId: dataTreasure.id,
                                                    navigate: false,
                                                  )));
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        bottom: 12,
                                        top: 12),
                                    decoration: BoxDecoration(
                                        color: dataTreasure.statusTimer == -1
                                            ? ColorPalette.neutral_50
                                            : ColorPalette.mainColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: dataTreasure.statusTimer == 1
                                        ? const Text(
                                            'Lihat Rank',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          )
                                        : dataTreasure.statusJoin == 0
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: Image.asset(
                                                      'assets/icon/ic_star_single.png',
                                                      width: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    IsilahHelper
                                                        .formatCurrencyWithoutSymbol(
                                                            dataTreasure
                                                                .requiredPoint!
                                                                .toDouble()),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  )
                                                ],
                                              )
                                            : const Text(
                                                'Lihat Rank',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...treasureChestListModel.data!.map((i) {
                                  int index = treasureChestListModel.data!
                                      .toList()
                                      .indexOf(i);
                                  return Container(
                                    width: indexTreasure == index ? 12.0 : 6.0,
                                    height: 4.0,
                                    margin: const EdgeInsets.only(right: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: indexTreasure == index
                                          ? ColorPalette.mainColor
                                          : Colors.white,
                                    ),
                                  );
                                }).toList(),
                                Container(
                                  width: 6.0,
                                  height: 4.0,
                                  margin: const EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          }).toList(),
          DailyEventWidget(dataTraesureChest: treasureChestListModel.data),
        ]);
  }
}
