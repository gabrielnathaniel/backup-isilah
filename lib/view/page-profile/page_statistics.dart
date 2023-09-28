import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/model/level.dart';
import 'package:isilahtitiktitik/model/user.dart';
import 'package:isilahtitiktitik/resource/level_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../constant/constant.dart';

class StatisticsPage extends StatefulWidget {
  final int? initialPage;
  const StatisticsPage({Key? key, this.initialPage}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool darkMode = false;
  bool useSides = false;
  bool _isLoading = true;
  bool _isLoadingLevel = true;
  bool lastStatus = true;
  User? user;
  // int _currentIndex = 0;
  int _currentIndexCarousel = 0;
  List<String> feature = [];
  List<String> descFeature = [];
  List<num> data = [];
  List<num> data1 = [];
  List<List<num>> data2 = [];
  LevelModel? levelModel;
  CarouselController? carouselController;
  int initialPageCarousel = 0;

  bool _isLoadingUser = false;
  User? singleUserModel;

  @override
  void initState() {
    carouselController = CarouselController();
    if (widget.initialPage != null) {
      _currentIndexCarousel = widget.initialPage!;
    }
    _getOverview();
    _getLevel();
    _getSingleUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getSingleUser() async {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);

    await auth.loadSingleUser().then((value) {
      setState(() {
        singleUserModel = value;
        _isLoadingUser = true;
      });
    }).catchError((onError) {
      if (mounted) {
        setState(() {
          _isLoadingUser = true;
        });
      }
    });
  }

  void _getLevel() async {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);

    CHttp chttp = Provider.of(context, listen: false);
    LevelApi levelApi = LevelApi(http: chttp);
    levelApi.fetchListLevel().then((value) {
      setState(() {
        levelModel = value;
        initialPageCarousel = value.data!.indexWhere(
            (element) => element.level == auth.currentUser!.data!.user!.level);
        _currentIndexCarousel = value.data!.indexWhere(
            (element) => element.level == auth.currentUser!.data!.user!.level);
        _isLoadingLevel = false;
      });
    }).catchError((onError) {
      setState(() {
        _isLoadingLevel = false;
      });
    });
  }

  void _getOverview() async {
    CHttp chttp = Provider.of(context, listen: false);
    Auth authOverview = chttp.auth!;

    authOverview.fetchOverview().then((value) {
      if (value.data!.user!.power != null) {
        setState(() {
          user = value;
        });
        value.data!.user!.power!.average!.sort((a, b) => a.categoryId == null
            ? 1
            : b.categoryId == null
                ? -1
                : a.categoryId!.compareTo(b.categoryId!));

        value.data!.user!.power!.detail!.sort((a, b) => a.categoryId == null
            ? 1
            : b.categoryId == null
                ? -1
                : a.categoryId!.compareTo(b.categoryId!));
        for (int i = 0; i < value.data!.user!.power!.average!.length; i++) {
          setState(() {
            feature.add(value.data!.user!.power!.average![i].category!);
            descFeature
                .add(value.data!.user!.power!.average![i].description ?? "-");
          });
        }
        for (var element in value.data!.user!.power!.detail!) {
          setState(() {
            if (element.power != null) {
              data.add(
                double.parse(element.power!),
              );
            } else {
              data.add(
                0.0,
              );
            }
          });
        }

        for (var element in value.data!.user!.power!.average!) {
          setState(() {
            if (element.power != null) {
              data1.add(element.power!.toDouble());
            } else {
              data1.add(
                0.0,
              );
            }
          });
        }

        data2.addAll([data, data1]);
        feature = feature.sublist(
            0, value.data!.user!.power!.average!.length.floor());
        data2 = data2
            .map((graph) => graph.sublist(
                0, value.data!.user!.power!.average!.length.floor()))
            .toList();
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        if (value.message!.title != null) {
          flushbarError(value.message!.title!).show(context);
        }
      }
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
      flushbarError(onError['message']['title']).show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    const ticks = [40, 60, 80, 100];

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          flexibleSpace: const Image(
            image: AssetImage('assets/image/img_background_appbar.png'),
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Statistik',
            style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: bodyMedium,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
        ),
        body: _isLoadingUser
            ? singleUserModel == null
                ? const LoadingWidget()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Statistik Personal",
                                          style: TextStyle(
                                              fontFamily: 'PlusJakartaSans',
                                              fontSize: bodyMedium,
                                              color: ColorPalette.neutral_90,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'Statistic quiz kamu selama ini',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: 'PlusJakartaSans',
                                              fontSize: bodySmall,
                                              color: Colors.grey.shade600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     if (descFeature.isNotEmpty) {
                                  //       showDialog(
                                  //           context: context,
                                  //           builder: (ctx) {
                                  //             return AlertDialog(
                                  //               shape: RoundedRectangleBorder(
                                  //                   borderRadius: BorderRadius.circular(16)),
                                  //               backgroundColor: Colors.white,
                                  //               content: SingleChildScrollView(
                                  //                 child: Column(
                                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                                  //                   children: [
                                  //                     Text(
                                  //                       "Detail Stat",
                                  //                       style: TextStyle(
                                  //                           fontSize: 18,
                                  //                           color: ColorPalette.neutral_90,
                                  //                           fontWeight: FontWeight.w700),
                                  //                     ),
                                  //                     const SizedBox(
                                  //                       height: 16,
                                  //                     ),
                                  //                     ...feature
                                  //                         .asMap()
                                  //                         .map((i, fitur) => MapEntry(
                                  //                             i,
                                  //                             Column(
                                  //                               crossAxisAlignment:
                                  //                                   CrossAxisAlignment.start,
                                  //                               children: [
                                  //                                 Row(
                                  //                                   children: [
                                  //                                     const Icon(
                                  //                                       Icons.circle,
                                  //                                       size: 5,
                                  //                                       color: ColorPalette.neutral_90,
                                  //                                     ),
                                  //                                     const SizedBox(
                                  //                                       width: 8,
                                  //                                     ),
                                  //                                     Expanded(
                                  //                                       child: Text(
                                  //                                         fitur,
                                  //                                         style:
                                  //                                             TextStyle(
                                  //                                                 fontSize:
                                  //                                                     bodyMedium,
                                  //                                                 fontWeight:
                                  //                                                     FontWeight
                                  //                                                         .w700,
                                  //                                                 color: Colors
                                  //                                                     .black),
                                  //                                       ),
                                  //                                     ),
                                  //                                   ],
                                  //                                 ),
                                  //                                 const SizedBox(
                                  //                                   height: 4,
                                  //                                 ),
                                  //                                 Row(
                                  //                                   children: [
                                  //                                     const Icon(
                                  //                                       Icons.circle,
                                  //                                       size: 5,
                                  //                                       color: Colors.white,
                                  //                                     ),
                                  //                                     const SizedBox(
                                  //                                       width: 8,
                                  //                                     ),
                                  //                                     Expanded(
                                  //                                       child: Text(
                                  //                                         descFeature[i],
                                  //                                         style:
                                  //                                             TextStyle(
                                  //                                                 fontSize:
                                  //                                                     bodyMedium,
                                  //                                                 color: Colors
                                  //                                                     .black),
                                  //                                       ),
                                  //                                     ),
                                  //                                   ],
                                  //                                 ),
                                  //                                 const SizedBox(
                                  //                                   height: 8,
                                  //                                 ),
                                  //                               ],
                                  //                             )))
                                  //                         .values
                                  //                         .toList(),
                                  //                     const SizedBox(
                                  //                       height: 8,
                                  //                     ),
                                  //                     GestureDetector(
                                  //                       onTap: () {
                                  //                         Navigator.pop(ctx);
                                  //                       },
                                  //                       child: Center(
                                  //                         child: Text(
                                  //                           'Tutup',
                                  //                           textAlign: TextAlign.center,
                                  //                           style: TextStyle(
                                  //                             fontSize: 16,
                                  //                             color: ColorPalette.mainColor,
                                  //                             fontWeight: FontWeight.w700,
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //               ),
                                  //             );
                                  //           });
                                  //     }
                                  //   },
                                  //   child: Text(
                                  //     "Detail Stat",
                                  //     style: TextStyle(
                                  //         fontSize: 14,
                                  //         color: ColorPalette.mainColor,
                                  //         fontWeight: FontWeight.w700),
                                  //   ),
                                  // ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              _isLoading
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      child: const LoadingWidget())
                                  : user == null
                                      ? const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(24.0),
                                            child: Text(
                                              'Belum ada datanya',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: bodyMedium,
                                                  color:
                                                      ColorPalette.neutral_90),
                                            ),
                                          ),
                                        )
                                      : Column(
                                          children: [
                                            Center(
                                              child: SizedBox(
                                                width: 280,
                                                height: 280,
                                                child: RadarChart.light(
                                                  ticks: ticks,
                                                  features: feature,
                                                  data: data2,
                                                  reverseAxis: false,
                                                  useSides: true,
                                                  outlineColor:
                                                      ColorPalette.outlineColor,
                                                  axisColor:
                                                      ColorPalette.outlineColor,
                                                  featuresTextStyle:
                                                      const TextStyle(
                                                          fontSize: bodyMedium,
                                                          color: ColorPalette
                                                              .neutral_90),
                                                  ticksTextStyle:
                                                      const TextStyle(
                                                          fontSize: bodySmall,
                                                          color: Colors
                                                              .transparent),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFFF5F5F5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          'assets/icon/ic_stats_play.png',
                                                          width: 35,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Bermain',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'PlusJakartaSans',
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                              ),
                                                            ),
                                                            Text(
                                                              IsilahHelper.formatCurrencyWithoutSymbol(user!
                                                                          .data!
                                                                          .user!
                                                                          .power!
                                                                          .header!
                                                                          .playing ==
                                                                      null
                                                                  ? 0
                                                                  : user!
                                                                      .data!
                                                                      .user!
                                                                      .power!
                                                                      .header!
                                                                      .playing!
                                                                      .toDouble()),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      bodyMedium,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFFF5F5F5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          'assets/icon/ic_stats_speed.png',
                                                          width: 35,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Flexible(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Kecepatan',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade500,
                                                                ),
                                                              ),
                                                              Text(
                                                                '${user!.data!.user!.power!.header!.averagePlayingTime ?? 0} detik',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        bodyMedium,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Level Kamu",
                                style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: bodyMedium,
                                    color: ColorPalette.neutral_90,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Urutan level yang bisa kamu capai',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: bodySmall,
                                    color: Colors.grey.shade600),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              _isLoadingLevel
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      child: const LoadingWidget())
                                  : levelModel == null
                                      ? SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                        )
                                      : Column(
                                          children: [
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                _currentIndexCarousel == 0
                                                    ? Container(
                                                        width: 16,
                                                      )
                                                    : GestureDetector(
                                                        onTap: () {
                                                          carouselController!
                                                              .previousPage();
                                                        },
                                                        child: Image.asset(
                                                          'assets/icon/ic_arrow_back.png',
                                                          width: 25,
                                                        ),
                                                      ),
                                                const SizedBox(
                                                  width: 22,
                                                ),
                                                Expanded(
                                                  child: CarouselSlider(
                                                    carouselController:
                                                        carouselController,
                                                    options: CarouselOptions(
                                                      autoPlay: false,
                                                      enableInfiniteScroll:
                                                          false,
                                                      viewportFraction: 1,
                                                      aspectRatio: 1,
                                                      initialPage:
                                                          initialPageCarousel,
                                                      onPageChanged:
                                                          (index, reason) {
                                                        setState(() =>
                                                            _currentIndexCarousel =
                                                                index);
                                                      },
                                                    ),
                                                    items: [
                                                      ...levelModel!.data!
                                                          .map(
                                                              (dataLevel) =>
                                                                  Container(
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        left: 8,
                                                                        right:
                                                                            8),
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            16,
                                                                        vertical:
                                                                            8),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .transparent,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        fit: BoxFit
                                                                            .contain,
                                                                        imageUrl:
                                                                            imageUrl +
                                                                                dataLevel.logo!,
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                Center(
                                                                          child:
                                                                              Shimmer.fromColors(
                                                                            baseColor:
                                                                                Colors.grey[300]!,
                                                                            highlightColor:
                                                                                Colors.grey[100]!,
                                                                            child:
                                                                                Container(
                                                                              width: 120,
                                                                              height: 120,
                                                                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(120)),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(120),
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/image/default_image.png',
                                                                            fit:
                                                                                BoxFit.contain,
                                                                            width:
                                                                                120,
                                                                            height:
                                                                                120,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ))
                                                          .toList()
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 22,
                                                ),
                                                _currentIndexCarousel ==
                                                        (levelModel!
                                                                .data!.length -
                                                            1)
                                                    ? Container(
                                                        width: 16,
                                                      )
                                                    : GestureDetector(
                                                        onTap: () {
                                                          carouselController!
                                                              .nextPage();
                                                        },
                                                        child: Image.asset(
                                                          'assets/icon/ic_arrow_forward.png',
                                                          width: 25,
                                                        ),
                                                      ),
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              levelModel!
                                                  .data![_currentIndexCarousel]
                                                  .level!,
                                              style: const TextStyle(
                                                  fontFamily: 'PlusJakartaSans',
                                                  fontSize: titleMedium,
                                                  color:
                                                      ColorPalette.neutral_90,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "${IsilahHelper.formatCurrencyWithoutSymbol(levelModel!.data![_currentIndexCarousel].experienceFrom!.toDouble())} - ${IsilahHelper.formatCurrencyWithoutSymbol(levelModel!.data![_currentIndexCarousel].experienceTo!.toDouble())}",
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color:
                                                      ColorPalette.neutral_90,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              levelModel!
                                                          .data![
                                                              _currentIndexCarousel]
                                                          .description ==
                                                      null
                                                  ? '-'
                                                  : levelModel!
                                                      .data![
                                                          _currentIndexCarousel]
                                                      .description!,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color:
                                                      ColorPalette.neutral_90,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children:
                                                  levelModel!.data!.map((url) {
                                                int index = levelModel!.data!
                                                    .toList()
                                                    .indexOf(url);
                                                return Container(
                                                  width:
                                                      _currentIndexCarousel ==
                                                              index
                                                          ? 20
                                                          : 10.0,
                                                  height: 10.0,
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: _currentIndexCarousel ==
                                                              index
                                                          ? ColorPalette
                                                              .mainColor
                                                          : ColorPalette
                                                              .colorHeaderModalBottomSheet),
                                                );
                                              }).toList(),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "Tambah ${IsilahHelper.formatCurrencyWithoutSymbol(singleUserModel!.data!.user!.experienceTo!.toDouble() - singleUserModel!.data!.user!.experience!.toDouble())} Exp lagi buat naik level!",
                                  style: const TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: bodyMedium,
                                      color: ColorPalette.neutral_90,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: LinearProgressIndicator(
                                  value: (singleUserModel!
                                          .data!.user!.experiencePercentage! /
                                      100),
                                  backgroundColor: const Color(0xFFEDEDED),
                                  minHeight: 8,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Color(0xFFEF5696)),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "EXP ",
                                        style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: bodySmall,
                                            color: ColorPalette.neutral_90,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      TextSpan(
                                        text: IsilahHelper
                                            .formatCurrencyWithoutSymbol(
                                                singleUserModel!
                                                    .data!.user!.experience!
                                                    .toDouble()),
                                        style: const TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: bodySmall,
                                            color: Color(0xFF757575),
                                            fontWeight: FontWeight.w400),
                                      ),
                                      TextSpan(
                                          text:
                                              "/${IsilahHelper.formatCurrencyWithoutSymbol(singleUserModel!.data!.user!.experienceTo!.toDouble())}",
                                          style: const TextStyle(
                                              fontFamily: 'PlusJakartaSans',
                                              fontSize: bodySmall,
                                              color: Color(0xFF757575),
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                width: MediaQuery.of(context).size.width / 2.5,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFFCDDEA),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                    child: Text('Main Mini Games',
                                        style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: bodySmall,
                                            color: Color(0xFFEF5696),
                                            fontWeight: FontWeight.w600))),
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
                                width: MediaQuery.of(context).size.width / 2.5,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFEF5696),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                    child: Text(
                                  'Ikut Daily Quiz',
                                  style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: bodySmall,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                )),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  )
            : const LoadingWidget());
  }
}
