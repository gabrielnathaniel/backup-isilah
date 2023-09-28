import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:isilahtitiktitik/bloc/leaderboard-treasure-chest-bloc/leaderboard_treasure_chest_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/event_detail.dart';
import 'package:isilahtitiktitik/model/leaderboard_treasure_chest.dart';
import 'package:isilahtitiktitik/resource/treasure_chest_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';
import 'package:isilahtitiktitik/view/page-profile/page-friend/page_detail_friend.dart';
import 'package:isilahtitiktitik/view/page-treasure-chest/page_all_leaderboard_treasure_chest.dart';
import 'package:isilahtitiktitik/view/page-treasure-chest/page_result_question_treasure_chest.dart';
import 'package:isilahtitiktitik/view/widgets/background_splash_widget.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

/// Page ini menampilkan list pemenang dari `treasure chest` yang mana hanya
/// menampilkan pemain yang menjawab `benar` semua dan yang tercepat saja.
class LeaderboardTreasureChestPage extends StatefulWidget {
  final int? eventId;
  final bool? navigate;
  const LeaderboardTreasureChestPage(
      {Key? key, @required this.eventId, @required this.navigate})
      : super(key: key);

  @override
  State<LeaderboardTreasureChestPage> createState() =>
      _LeaderboardTreasureChestPageState();
}

class _LeaderboardTreasureChestPageState
    extends State<LeaderboardTreasureChestPage> {
  bool isLoading = true;
  bool isRefresh = false;

  EventDetailBody? eventDetailBody;

  LeaderboardTreasureChestBloc leaderboardTreasureChestBloc =
      LeaderboardTreasureChestBloc();
  int pageNumber = 1;
  int? _limit = 1;
  int? _currentLenght;
  List<LeaderboardTreasureChestList> _listLeaderboard = [];
  final ScrollController _scLeaderboard = ScrollController();

  final GlobalKey _globalKey = GlobalKey();

  int? hours;
  int? minutes;
  int? seconds;

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

  void getDetailEvent() async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    TreasureChestApi treasureChestApi = TreasureChestApi(http: chttp);

    setState(() {
      isLoading = false;
    });

    await treasureChestApi
        .fetchTreasureChestDetail(widget.eventId!)
        .then((value) {
      if (value.status == 1) {
        setState(() {
          isLoading = true;
          eventDetailBody = value.data;
        });
      } else {
        setState(() {
          isLoading = true;
        });
        flushbarError(value.message!.title!).show(context);
      }
    }).catchError((onError) {
      setState(() {
        isLoading = true;
      });
      flushbarError(onError is String ? onError : onError['message']['title'])
          .show(context);
    });
  }

  @override
  void initState() {
    getDetailEvent();
    _loadMoreLeaderboard(true, false);
    _scLeaderboard.addListener(() {
      if (_scLeaderboard.position.pixels ==
          _scLeaderboard.position.maxScrollExtent) {
        if (_currentLenght != null) {
          if (_currentLenght! < _limit!) {
            pageNumber = pageNumber + 1;
            _loadMoreLeaderboard(false, false);
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scLeaderboard.dispose();
    leaderboardTreasureChestBloc.close();
    super.dispose();
  }

  Future<void> _loadMoreLeaderboard(bool statusLoad, bool isRefresh) async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    leaderboardTreasureChestBloc.add(GetLeaderboardTreasureChest(
        http: chttp,
        eventId: widget.eventId,
        statusLoad: statusLoad,
        page: pageNumber,
        isRefresh: isRefresh));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => leaderboardTreasureChestBloc,
      child: WillPopScope(
        onWillPop: () async {
          if (widget.navigate!) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
              return const HomeWidget(
                showBanner: false,
              );
            }), (Route<dynamic> route) => false);
          } else {
            Navigator.pop(context);
          }

          return true;
        },
        child: Scaffold(
          backgroundColor: ColorPalette.darkBlue,
          appBar: AppBar(
            backgroundColor: ColorPalette.darkBlue,
            elevation: 0,
            centerTitle: false,
            titleSpacing: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'Rank Room',
              style: TextStyle(
                  fontSize: titleSmall,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            leading: GestureDetector(
              onTap: () {
                if (widget.navigate!) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const HomeWidget(
                      showBanner: false,
                    );
                  }));
                } else {
                  Navigator.pop(context);
                }
              },
              child: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: isRefresh
                    ? const SpinKitThreeBounce(
                        color: Colors.white,
                        size: 20.0,
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            isRefresh = true;
                          });
                          Future.delayed(const Duration(milliseconds: 1500))
                              .then((value) async {
                            setState(() {
                              isRefresh = false;
                              pageNumber = 1;
                            });
                            if (_scLeaderboard.hasClients) {
                              _scLeaderboard.jumpTo(0);
                            }
                            _loadMoreLeaderboard(true, true);
                          });
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icon/ic_reload.png',
                              width: 12,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text(
                              'Refresh',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
              )
            ],
          ),
          body: RepaintBoundary(
            key: _globalKey,
            child: Stack(
              children: [
                Container(
                  color: ColorPalette.darkBlue,
                  child: Stack(
                    children: [
                      const BackgroundSplashWidget(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Image.asset(
                            'assets/image/img_star_leaderboard.png',
                            width: 80,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          !isLoading
                              ? Container()
                              : eventDetailBody == null
                                  ? Container()
                                  : Builder(builder: (context) {
                                      Duration? diffTimeStart;
                                      var endTimeNext =
                                          "${eventDetailBody!.endDate} ${eventDetailBody!.startTo}";

                                      diffTimeStart = DateFormat(
                                              "yyyy-MM-dd HH:mm:ss", 'id')
                                          .parse(endTimeNext)
                                          .difference(DateTime.now());

                                      return diffTimeStart.inSeconds < 0
                                          ? const Text(
                                              "Permainan Selesai",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 24, right: 24),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    "Sisa Waktu Treasure Chest",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                  TweenAnimationBuilder<
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
                                                      onEnd: () {},
                                                      builder:
                                                          (BuildContext context,
                                                              Duration value,
                                                              Widget? child) {
                                                        final days =
                                                            value.inDays;
                                                        final hours =
                                                            value.inHours % 24;
                                                        final minutes =
                                                            value.inMinutes %
                                                                60;
                                                        final seconds =
                                                            value.inSeconds %
                                                                60;

                                                        return Row(
                                                          children: [
                                                            Text(
                                                              days > 0
                                                                  ? '$days Hari ${hours.toString().padLeft(1, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'
                                                                  : '${hours.toString().padLeft(1, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white,
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
                                            );
                                    }),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Expanded(
                              child: isRefresh
                                  ? const LoadingWidget()
                                  : _buildLeaderBoard()),
                          const SizedBox(
                            height: 12,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return AllLeaderboardTreasureChestPage(
                                    eventId: widget.eventId);
                              }));
                            },
                            child: const Text(
                              "Lihat Semua Rank",
                              style: TextStyle(
                                color: ColorPalette.mainColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              "Rank disini merupakan siapa yang tercepat dan\ntepat menjawab Quiz",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          GestureDetector(
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
                              margin:
                                  const EdgeInsets.only(left: 24, right: 24),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.white),
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Center(
                                child: Text(
                                  'Lihat Jawaban',
                                  style: TextStyle(
                                    fontSize: 14,
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
                          GestureDetector(
                            onTap: () async {
                              final RenderBox? box =
                                  context.findRenderObject() as RenderBox?;
                              setState(() {});
                              await Future.delayed(
                                  const Duration(milliseconds: 300));

                              final directory = Platform.isIOS
                                  ? (await getApplicationDocumentsDirectory())
                                      .path
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
                                    .then((value) {
                                  setState(() {});
                                });
                              });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 24, right: 24),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              decoration: BoxDecoration(
                                  color: ColorPalette.mainColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Center(
                                child: Text(
                                  'Bagikan ke Temanmu',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderBoard() {
    return BlocBuilder<LeaderboardTreasureChestBloc,
        LeaderboardTreasureChestState>(
      builder: (context, state) {
        if (state is LeaderboardTreasureChestInitial) {
          return const LoadingWidget();
        } else if (state is LeaderboardTreasureChestLoading) {
          return const LoadingWidget();
        } else if (state is LeaderboardTreasureChestLoaded ||
            state is LeaderboardTreasureChestMoreLoading) {
          if (state is LeaderboardTreasureChestLoaded) {
            _listLeaderboard = state.list;
            _currentLenght = state.count;
            _limit = state.limit;
          }
          return _buildListLeaderboard();
        } else if (state is LeaderboardTreasureChestError) {
          return Container();
        }

        return Container();
      },
    );
  }

  Widget _buildListLeaderboard() {
    if (_listLeaderboard.isEmpty) {
      return const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Belum Ada Yang Masuk Rank",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "Ayo jadi yang pertama masuk rank!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _checkPos2()),
              Expanded(child: _checkPos1()),
              Expanded(child: _checkPos3()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _checkPos2() {
    if (_listLeaderboard.where((element) => element.seq == 2).isEmpty) {
      return const SizedBox(
        width: 73,
        height: 73,
      );
    }
    return Column(
      children: [
        ..._listLeaderboard
            .where((element) => element.seq == 2)
            .map((data) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailFriendPage(
                                  userId: data.userId,
                                )));
                  },
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        height: 90,
                        child: Stack(
                          children: [
                            data.photo == null
                                ? Center(
                                    child: Image.asset(
                                      'assets/image/default_profile.png',
                                      width: 73,
                                    ),
                                  )
                                : Center(
                                    child: CachedNetworkImage(
                                      width: 73,
                                      height: 73,
                                      imageUrl: data.photo!,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => Center(
                                          child: Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 73,
                                          height: 73,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/image/default_profile.png',
                                        width: 73,
                                      ),
                                    ),
                                  ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: const BoxDecoration(
                                    color: ColorPalette.background,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Text(
                                    "${data.seq!}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        data.username!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "${IsilahHelper.formatCurrencyWithoutSymbol(data.answerCorrect == null ? 0 : data.answerCorrect!.toDouble())} Benar",
                        style: const TextStyle(
                          color: ColorPalette.success,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _checkPos1() {
    if (_listLeaderboard.where((element) => element.seq == 1).isEmpty) {
      return const SizedBox(
        width: 110,
        height: 110,
      );
    }
    return Column(
      children: [
        ..._listLeaderboard
            .where((element) => element.seq == 1)
            .map((data) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailFriendPage(
                                  userId: data.userId,
                                )));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 120,
                        child: Stack(
                          children: [
                            data.photo == null
                                ? Center(
                                    child: Image.asset(
                                      'assets/image/default_profile.png',
                                      width: 110,
                                    ),
                                  )
                                : Center(
                                    child: CachedNetworkImage(
                                      width: 110,
                                      height: 110,
                                      imageUrl: data.photo!,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => Center(
                                          child: Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 110,
                                          height: 110,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/image/default_profile.png',
                                        width: 110,
                                      ),
                                    ),
                                  ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Image.asset(
                                'assets/icon/ic_rank_1.png',
                                width: 45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        data.username!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "${IsilahHelper.formatCurrencyWithoutSymbol(data.answerCorrect == null ? 0 : data.answerCorrect!.toDouble())} Benar",
                        style: const TextStyle(
                          color: ColorPalette.success,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _checkPos3() {
    if (_listLeaderboard.where((element) => element.seq == 3).isEmpty) {
      return const SizedBox(
        width: 73,
        height: 73,
      );
    }
    return Column(
      children: [
        ..._listLeaderboard
            .where((element) => element.seq == 3)
            .map((data) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailFriendPage(
                                  userId: data.userId,
                                )));
                  },
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        height: 90,
                        child: Stack(
                          children: [
                            data.photo == null
                                ? Center(
                                    child: Image.asset(
                                      'assets/image/default_profile.png',
                                      width: 73,
                                    ),
                                  )
                                : Center(
                                    child: CachedNetworkImage(
                                      width: 73,
                                      height: 73,
                                      imageUrl: data.photo!,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => Center(
                                          child: Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 73,
                                          height: 73,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/image/default_profile.png',
                                        width: 73,
                                      ),
                                    ),
                                  ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: const BoxDecoration(
                                    color: ColorPalette.background,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Text(
                                    "${data.seq}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        data.username!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "${IsilahHelper.formatCurrencyWithoutSymbol(data.answerCorrect == null ? 0 : data.answerCorrect!.toDouble())} Benar",
                        style: const TextStyle(
                          color: ColorPalette.success,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }
}
