import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/user.dart';
import 'package:isilahtitiktitik/resource/friend_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DetailFriendPage extends StatefulWidget {
  final int? userId;
  const DetailFriendPage({Key? key, this.userId}) : super(key: key);

  @override
  State<DetailFriendPage> createState() => _DetailFriendPageState();
}

class _DetailFriendPageState extends State<DetailFriendPage> {
  bool darkMode = false;
  bool useSides = false;
  bool _isLoading = true;
  User? user;
  List<String> feature = [];
  List<String> descFeature = [];
  List<num> data = [];
  List<num> data1 = [];
  List<List<num>> data2 = [];

  @override
  void initState() {
    _getOverview();
    super.initState();
  }

  void _getOverview() async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    FriendApi friendApi = FriendApi(http: chttp);

    friendApi.fetchFriend(widget.userId!).then((value) {
      if (value.data!.user != null) {
        setState(() {
          user = value;
          _isLoading = false;
        });
        if (value.data!.user!.power != null) {
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
                  .add(value.data!.user!.power!.average![i].description!);
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
        }
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
      // flushbarError(onError['message']['title']).show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var heightStatusbar = MediaQuery.of(context).viewPadding.top;
    var paddingTop = (kToolbarHeight + heightStatusbar + defaultPadding);
    const ticks = [20, 40, 60, 80, 100];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading
            ? const LoadingWidget()
            : CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    elevation: 0,
                    backgroundColor: ColorPalette.darkBlue,
                    iconTheme: const IconThemeData(
                      color: Colors.white,
                    ),
                    leading: GestureDetector(
                      onTap: () => Navigator.pop(context, true),
                      child: Center(
                        child: Platform.isIOS
                            ? Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: const Icon(Icons.arrow_back_ios,
                                    color: Colors.white),
                              )
                            : const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    pinned: true,
                    expandedHeight: MediaQuery.of(context).size.height * 0.42,
                    // floating: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/image/img_background_home.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: paddingTop,
                                left: 24,
                                right: 24,
                                bottom: 24,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 95,
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: CachedNetworkImage(
                                                imageUrl: imageUrl +
                                                    user!.data!.user!.photo!,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                            Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Container(
                                                    color: Colors.white,
                                                    width: 80,
                                                    height: 80,
                                                  ),
                                                )),
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child: Image.asset(
                                                          "assets/image/default_profile.png",
                                                          fit: BoxFit.cover,
                                                          width: 80,
                                                          height: 80,
                                                        )),
                                              ),
                                            ),
                                            user!.data!.user!.rankExperience ==
                                                    1
                                                ? Positioned(
                                                    left: 22,
                                                    top: 65,
                                                    child: Image.asset(
                                                      'assets/icon/ic_page_friend_rank1.png',
                                                      width: 36,
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 24,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user!.data!.user!.username!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: bodyLarge,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                'ID ${user!.data!.user!.id!}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: bodyMedium,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Expanded(
                                    child: SizedBox(
                                      height: 24,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF252C6F),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration:
                                                        const BoxDecoration(
                                                            color:
                                                                ColorPalette
                                                                    .mainColor,
                                                            shape: BoxShape
                                                                .circle),
                                                    child: Image.asset(
                                                      'assets/icon/ic_star_single.png',
                                                      width: 10,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  const Text(
                                                    'Star',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: bodySmall,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                IsilahHelper
                                                    .formatCurrencyWithoutSymbol(
                                                        user!.data!.user!
                                                                    .point ==
                                                                null
                                                            ? 0
                                                            : user!.data!.user!
                                                                .point!
                                                                .toDouble()),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF252C6F),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration:
                                                        const BoxDecoration(
                                                            color:
                                                                ColorPalette
                                                                    .mainColor,
                                                            shape: BoxShape
                                                                .circle),
                                                    child: Center(
                                                      child: Image.asset(
                                                        'assets/icon/ic_piala.png',
                                                        width: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  const Text(
                                                    'Rank',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: bodySmall,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                '#${IsilahHelper.formatCurrencyWithoutSymbol(user!.data!.user!.rankExperience == null ? 0 : user!.data!.user!.rankExperience!.toDouble())}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate(
                    <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Statistik",
                                        style: TextStyle(
                                            fontSize: bodyLarge,
                                            color: ColorPalette.neutral_90,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            user!.data!.user!.power == null
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(24.0),
                                      child: Text(
                                        'Belum ada datanya',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: bodyMedium,
                                            color: ColorPalette.neutral_90),
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
                                            featuresTextStyle: const TextStyle(
                                                fontSize: bodyMedium,
                                                color: ColorPalette.neutral_90),
                                            ticksTextStyle: const TextStyle(
                                                fontSize: bodySmall,
                                                color: Colors.transparent),
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
                                              padding: const EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFF5F5F5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
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
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'PlusJakartaSans',
                                                          fontSize: bodySmall,
                                                          color: Colors
                                                              .grey.shade500,
                                                        ),
                                                      ),
                                                      Text(
                                                        IsilahHelper
                                                            .formatCurrencyWithoutSymbol(user!
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
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'PlusJakartaSans',
                                                            fontSize:
                                                                bodyMedium,
                                                            color: ColorPalette
                                                                .neutral_90,
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
                                              padding: const EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFF5F5F5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/icon/ic_stats_speed.png',
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
                                                        'Kecepatan',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'PlusJakartaSans',
                                                          fontSize: bodySmall,
                                                          color: Colors
                                                              .grey.shade500,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${user!.data!.user!.power!.header!.averagePlayingTime ?? 0} detik',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'PlusJakartaSans',
                                                            fontSize:
                                                                bodyMedium,
                                                            color: ColorPalette
                                                                .neutral_90,
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
                                        ],
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ],
                  )),
                ],
              ),
      ),
    );
  }
}
