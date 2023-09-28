import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:isilahtitiktitik/bloc/ranks-bloc/rank-monthly-bloc/rank_monthly_bloc.dart';
import 'package:isilahtitiktitik/bloc/single-user-rank-bloc/single_user_rank_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/ranks.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/page-auth/page-login/page_login_by_email.dart';
import 'package:isilahtitiktitik/view/page-intro/page_onboarding.dart';
import 'package:isilahtitiktitik/view/page-profile/page-friend/page_detail_friend.dart';
import 'package:isilahtitiktitik/view/widgets/loading_rank_widget.dart';
import 'package:isilahtitiktitik/view/page-ranks/widgets/single_user_rank_by_type_widget.dart';
import 'package:isilahtitiktitik/view/widgets/empty_state.dart';
import 'package:isilahtitiktitik/view/widgets/update_app_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class RankMonthlyWidget extends StatefulWidget {
  const RankMonthlyWidget({Key? key}) : super(key: key);

  @override
  State<RankMonthlyWidget> createState() => _RankMonthlyWidgetState();
}

class _RankMonthlyWidgetState extends State<RankMonthlyWidget> {
  bool status = false;

  int pageNumber = 1;
  int? _limit = 1;
  int? _currentLenght;
  List<DataRanks> _listDataRanks = [];
  final ScrollController _scRanks = ScrollController();
  RankMonthlyBloc rankMonthlyBloc = RankMonthlyBloc();
  SingleUserRankBloc singleUserRankBloc = SingleUserRankBloc();

  @override
  void initState() {
    _loadUserRank();
    _loadMoreDataRanks(true, false);
    _scRanks.addListener(() {
      if (_scRanks.position.pixels == _scRanks.position.maxScrollExtent) {
        if (_currentLenght != null) {
          if (_currentLenght! < _limit!) {
            pageNumber = pageNumber + 1;
            _loadMoreDataRanks(false, false);
          }
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scRanks.dispose();
  }

  Future<void> _loadMoreDataRanks(bool statusLoad, bool isRefresh) async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    rankMonthlyBloc.add(GetRankMonthly(
        http: chttp,
        statusLoad: statusLoad,
        page: pageNumber,
        isRefresh: isRefresh));
  }

  Future<void> _loadUserRank() async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    singleUserRankBloc.add(GetSingleUserRank(http: chttp, type: 'monthly'));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SingleUserRankBloc>(create: (_) => singleUserRankBloc),
        BlocProvider<RankMonthlyBloc>(create: (_) => rankMonthlyBloc),
      ],
      child: BlocListener<RankMonthlyBloc, RankMonthlyState>(
        listener: (context, state) {
          if (state is RankMonthlyNoAuth) {
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
          if (state is RankMonthlyUpdateApp) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => UpdateAppWidget(
                    link: Platform.isAndroid ? androidUrl : iOSUrl,
                  ),
                ),
                (route) => false);
          }
        },
        child: BlocBuilder<RankMonthlyBloc, RankMonthlyState>(
          builder: (context, state) {
            if (state is RankMonthlyInitial) {
              return LoadingRankWidget();
            } else if (state is RankMonthlyLoading) {
              return LoadingRankWidget();
            } else if (state is RankMonthlyLoaded ||
                state is RankMonthlyMoreLoading) {
              if (state is RankMonthlyLoaded) {
                _listDataRanks = state.list;
                _currentLenght = state.count;
                _limit = state.limit;
              }
              return _buildList(state);
            } else if (state is RankMonthlyError) {
              return _buildEmptyList();
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildList(RankMonthlyState state) {
    if (_listDataRanks.isEmpty) {
      return _buildEmptyList();
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          pageNumber = 1;
          _limit = 1;
          _currentLenght = 0;
        });

        _loadUserRank();
        _loadMoreDataRanks(true, true);
      },
      child: SingleChildScrollView(
        controller: _scRanks,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SingleUserRankByTypeWidget(
              type: 'monthly',
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
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
            const SizedBox(
              height: 32,
            ),
            ..._listDataRanks
                .where((element) => element.rank != 1)
                .where((element) => element.rank != 2)
                .where((element) => element.rank != 3)
                .map(
                  (data) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailFriendPage(
                                    userId: data.userId,
                                  )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // data.rankStatus! > 0
                          //     ? Image.asset(
                          //         'assets/icon/ic_up.png',
                          //         width: 12,
                          //       )
                          //     : data.rankStatus! < 0
                          //         ? Image.asset(
                          //             'assets/icon/ic_down.png',
                          //             width: 12,
                          //           )
                          //         : Container(
                          //             width: 11,
                          //           ),
                          Text(
                            data.rank!.toString(),
                            style: const TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 12,
                                color: ColorPalette.neutral_90,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(
                            width: 8,
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
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
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
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 12,
                                  color: ColorPalette.neutral_90,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            "${IsilahHelper.formatCurrencyWithoutSymbol(data.experience == null ? 0 : data.experience!.toDouble())} Exp",
                            style: const TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 12,
                                color: Color(0xFFEF5696),
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
            (state is RankMonthlyMoreLoading)
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
        ),
      ),
    );
  }

  Widget _checkPos2() {
    if (_listDataRanks.where((element) => element.rank == 2).isEmpty) {
      return const SizedBox(
        width: 73,
        height: 73,
      );
    }
    return Column(
      children: [
        ..._listDataRanks
            .where((element) => element.rank == 2)
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
                                    "${data.rank}",
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
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 12,
                            color: ColorPalette.neutral_90,
                            fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "${IsilahHelper.formatCurrencyWithoutSymbol(data.experience == null ? 0 : data.experience!.toDouble())} Exp",
                        style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 12,
                            color: Color(0xFFEF5696),
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _checkPos1() {
    if (_listDataRanks.where((element) => element.rank == 1).isEmpty) {
      return const SizedBox(
        width: 110,
        height: 110,
      );
    }
    return Column(
      children: [
        ..._listDataRanks
            .where((element) => element.rank == 1)
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
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 12,
                            color: ColorPalette.neutral_90,
                            fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "${IsilahHelper.formatCurrencyWithoutSymbol(data.experience == null ? 0 : data.experience!.toDouble())} Exp",
                        style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 12,
                            color: Color(0xFFEF5696),
                            fontWeight: FontWeight.w700),
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
    if (_listDataRanks.where((element) => element.rank == 3).isEmpty) {
      return const SizedBox(
        width: 73,
        height: 73,
      );
    }
    return Column(
      children: [
        ..._listDataRanks
            .where((element) => element.rank == 3)
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
                                    "${data.rank}",
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
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 12,
                            color: ColorPalette.neutral_90,
                            fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "${IsilahHelper.formatCurrencyWithoutSymbol(data.experience == null ? 0 : data.experience!.toDouble())} Exp",
                        style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 12,
                            color: Color(0xFFEF5696),
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _buildEmptyList() {
    return const Center(
      child: EmptyStateWidget(
        sizeWidth: 200,
        title: 'Belum Ada Yang Masuk Rank',
        subTitle: 'Ayo jadi yang pertama masuk rank!',
      ),
    );
  }
}
