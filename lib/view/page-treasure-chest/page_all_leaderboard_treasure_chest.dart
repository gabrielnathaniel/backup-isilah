import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:isilahtitiktitik/bloc/leaderboard-treasure-chest-bloc/leaderboard_treasure_chest_bloc.dart';
import 'package:isilahtitiktitik/bloc/my-ranking-treasure-chest-bloc/my_ranking_treasure_chest_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/event_detail.dart';
import 'package:isilahtitiktitik/model/leaderboard_treasure_chest.dart';
import 'package:isilahtitiktitik/resource/treasure_chest_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/page-profile/page-friend/page_detail_friend.dart';
import 'package:isilahtitiktitik/view/page-treasure-chest/widgets/my_rangking_widget.dart';
import 'package:isilahtitiktitik/view/widgets/empty_state.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AllLeaderboardTreasureChestPage extends StatefulWidget {
  final int? eventId;
  const AllLeaderboardTreasureChestPage({Key? key, @required this.eventId})
      : super(key: key);

  @override
  State<AllLeaderboardTreasureChestPage> createState() =>
      _AllLeaderboardTreasureChestPageState();
}

class _AllLeaderboardTreasureChestPageState
    extends State<AllLeaderboardTreasureChestPage> {
  bool isLoading = true;
  bool isRefresh = false;

  EventDetailBody? eventDetailBody;

  LeaderboardTreasureChestBloc leaderboardTreasureChestBloc =
      LeaderboardTreasureChestBloc();
  MyRankingTreasureChestBloc myRankingTreasureChestBloc =
      MyRankingTreasureChestBloc();
  int pageNumber = 1;
  int? _limit = 1;
  int? _currentLenght;
  List<LeaderboardTreasureChestList> _listLeaderboard = [];
  final ScrollController _scLeaderboard = ScrollController();

  int? hours;
  int? minutes;
  int? seconds;
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
    _loadMyRank();
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

  Future<void> _loadMyRank() async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    myRankingTreasureChestBloc
        .add(GetMyRankingTreasureChest(http: chttp, eventId: widget.eventId));
  }

  @override
  Widget build(BuildContext context) {
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
          'Rank Room',
          style: TextStyle(
              fontSize: titleSmall,
              color: Colors.white,
              fontWeight: FontWeight.w500),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
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
                        _loadMyRank();
                      });
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icon/ic_reload.png',
                          width: 16,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Refresh',
                          style: TextStyle(
                              fontSize: titleSmall,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
          )
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<LeaderboardTreasureChestBloc>(
              create: (_) => leaderboardTreasureChestBloc),
          BlocProvider<MyRankingTreasureChestBloc>(
              create: (_) => myRankingTreasureChestBloc),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          controller: _scLeaderboard,
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              !isLoading
                  ? Container()
                  : eventDetailBody == null
                      ? Container()
                      : Builder(builder: (context) {
                          Duration? diffTimeStart;
                          var endTimeNext =
                              "${eventDetailBody!.endDate} ${eventDetailBody!.startTo}";

                          diffTimeStart =
                              DateFormat("yyyy-MM-dd HH:mm:ss", 'id')
                                  .parse(endTimeNext)
                                  .difference(DateTime.now());

                          return diffTimeStart.inSeconds < 0
                              ? const Text(
                                  "Permainan Selesai",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: ColorPalette.neutral_90,
                                    fontWeight: FontWeight.w300,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Sisa Waktu Treasure Chest",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ColorPalette.neutral_90,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    TweenAnimationBuilder<Duration>(
                                        duration: Duration(
                                            seconds: diffTimeStart.inSeconds),
                                        tween: Tween(
                                            begin: Duration(
                                                seconds:
                                                    diffTimeStart.inSeconds),
                                            end: Duration.zero),
                                        onEnd: () {},
                                        builder: (BuildContext context,
                                            Duration value, Widget? child) {
                                          final days = value.inDays;
                                          final hours = value.inHours % 24;
                                          final minutes = value.inMinutes % 60;
                                          final seconds = value.inSeconds % 60;

                                          return Row(
                                            children: [
                                              Text(
                                                days > 0
                                                    ? '$days Hari ${hours.toString().padLeft(1, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'
                                                    : '${hours.toString().padLeft(1, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                                                textAlign: TextAlign.center,
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
                                );
                        }),
              const MyRankingTreasureChestWidget(),
              isRefresh ? const LoadingWidget() : _buildLeaderBoard()
            ],
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
          return _buildListLeaderboard(state);
        } else if (state is LeaderboardTreasureChestError) {
          return Container();
        }

        return Container();
      },
    );
  }

  Widget _buildListLeaderboard(LeaderboardTreasureChestState state) {
    if (_listLeaderboard.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: EmptyStateWidget(
              sizeWidth: 200,
              title: 'Belum Ada Yang Masuk Rank',
              subTitle: "Ayo jadi yang pertama masuk rank!",
            ),
          ),
        ),
      );
    }
    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _checkPos2()),
            Expanded(child: _checkPos1()),
            Expanded(child: _checkPos3()),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        ..._listLeaderboard
            .where((element) =>
                element.seq != 1 && element.seq != 2 && element.seq != 3)
            .map((data) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: ColorPalette.neutral_30)),
            margin: const EdgeInsets.only(bottom: 8, top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  width: 4,
                ),
                SizedBox(
                  width: 25,
                  child: Text(
                    data.seq.toString(),
                    style: const TextStyle(
                      color: ColorPalette.neutral_90,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                data.photo == null
                    ? Image.asset(
                        'assets/image/default_profile.png',
                        width: 32,
                      )
                    : CachedNetworkImage(
                        width: 32,
                        height: 32,
                        imageUrl: data.photo!,
                        imageBuilder: (context, imageProvider) => Container(
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
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        )),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/image/default_profile.png',
                          width: 32,
                        ),
                      ),
                const SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Text(
                    data.username!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ColorPalette.neutral_90,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Text(
                  "${data.answerCorrect} Benar",
                  style: const TextStyle(
                    color: ColorPalette.success,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        (state is LeaderboardTreasureChestMoreLoading)
            ? const Center(
                child: SpinKitThreeBounce(
                color: ColorPalette.mainColor,
                size: 30.0,
              ))
            : const SizedBox(),
        const SizedBox(
          height: 40,
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
                          color: ColorPalette.neutral_90,
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
                          fontSize: 12,
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
                                      fit: BoxFit.cover,
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
                          color: ColorPalette.neutral_90,
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
                          fontSize: 12,
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
                          color: ColorPalette.neutral_90,
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
                          fontSize: 12,
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
