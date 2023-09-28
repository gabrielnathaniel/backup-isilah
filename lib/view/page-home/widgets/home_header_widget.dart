import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/bloc/single-user-bloc/single_user_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/user.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/page-auth/page-login/page_login_by_email.dart';
import 'package:isilahtitiktitik/view/page-home/page_notification_main.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/treasure_chest_widget.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/user_referral_widget.dart';
import 'package:isilahtitiktitik/view/page-intro/page_onboarding.dart';
import 'package:isilahtitiktitik/view/page-prize-pool/page_histories_claim.dart';
import 'package:isilahtitiktitik/view/widgets/loading_header_widget.dart';
import 'package:isilahtitiktitik/view/widgets/update_app_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:badges/badges.dart' as badges;

class HomeHeaderWidget extends StatefulWidget {
  const HomeHeaderWidget({Key? key}) : super(key: key);

  @override
  State<HomeHeaderWidget> createState() => _HomeHeaderWidgetState();
}

class _HomeHeaderWidgetState extends State<HomeHeaderWidget> {
  SingleUserBloc singleUserBloc = SingleUserBloc();

  @override
  void initState() {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    singleUserBloc.add(GetSingleUser(http: chttp, baseAuth: auth));
    super.initState();
  }

  @override
  void dispose() {
    singleUserBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SingleUserBloc>(
      create: (context) => singleUserBloc,
      child: _buildSingleUser(),
    );
  }

  Widget _buildSingleUser() {
    return BlocListener<SingleUserBloc, SingleUserState>(
      listener: (context, state) {
        if (state is SingleUserNotAuth) {
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
        if (state is SingleUserUpdateApp) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => UpdateAppWidget(
                  link: Platform.isAndroid ? androidUrl : iOSUrl,
                ),
              ),
              (route) => false);
        }
      },
      child: BlocBuilder<SingleUserBloc, SingleUserState>(
        builder: (context, state) {
          if (state is SingleUserInitial) {
            return loadingHeaderWidget(context);
          } else if (state is SingleUserLoading) {
            return loadingHeaderWidget(context);
          } else if (state is SingleUserLoaded) {
            return _buildView(context, state.user);
          } else if (state is SingleUserError) {
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildView(BuildContext context, User singleUserModel) {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const HomeWidget(
                      initialIndex: 3,
                      showBanner: false,
                    );
                  }));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl + auth.currentUser!.data!.user!.photo!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                        child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.white,
                        width: 40,
                        height: 40,
                      ),
                    )),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          "assets/image/default_profile.png",
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        )),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return const HomeWidget(
                            initialIndex: 3,
                            showBanner: false,
                          );
                        }));
                      },
                      child: Text(
                        singleUserModel.data!.user!.username == null
                            ? ""
                            : singleUserModel.data!.user!.username!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              auth.currentUser!.data!.user!.notificationUnread == 0
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const NotificationMainPage();
                        })).then((val) => val! == true
                            ? singleUserBloc
                                .add(GetSingleUser(http: chttp, baseAuth: auth))
                            : null);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: ColorPalette.background,
                            shape: BoxShape.circle),
                        child: Center(
                          child: Image.asset(
                            'assets/icon/ic_notif_v2.png',
                            width: 18,
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const NotificationMainPage();
                        })).then((val) => val! == true
                            ? singleUserBloc
                                .add(GetSingleUser(http: chttp, baseAuth: auth))
                            : null);
                      },
                      child: Center(
                        child: badges.Badge(
                          badgeStyle: badges.BadgeStyle(
                            badgeColor: ColorPalette.colorRed,
                            elevation: 2,
                            padding: EdgeInsets.all(auth.currentUser!.data!
                                        .user!.notificationUnread! >
                                    9
                                ? 3
                                : 4),
                          ),
                          position: badges.BadgePosition.custom(
                            end: 0.1,
                            bottom: 12,
                          ),
                          badgeContent: Text(
                            auth.currentUser!.data!.user!.notificationUnread! >
                                    9
                                ? "+9"
                                : "${auth.currentUser!.data!.user!.notificationUnread}",
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                color: ColorPalette.background,
                                shape: BoxShape.circle),
                            child: Center(
                              child: Image.asset(
                                'assets/icon/ic_notif_v2.png',
                                width: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/statistics');
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.12,
                  margin: const EdgeInsets.only(right: 8, left: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF252C6F),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                        imageUrl:
                            imageUrl + singleUserModel.data!.user!.levelLogo!,
                        placeholder: (context, url) => Center(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 50,
                              height: 50,
                              padding: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40)),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            'assets/image/default_image.png',
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              singleUserModel.data!.user!.levelCode!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: LinearProgressIndicator(
                                  value: (singleUserModel
                                          .data!.user!.experiencePercentage! /
                                      100),
                                  backgroundColor: const Color(0xFFEDEDED),
                                  minHeight: 5,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Color(0xFFEF5696)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Tambah ${IsilahHelper.formatCurrencyWithoutSymbol(singleUserModel.data!.user!.experienceTo!.toDouble() - singleUserModel.data!.user!.experience!.toDouble())} Exp lagi buat naik level!",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return const HomeWidget(
                      initialIndex: 1,
                      showBanner: false,
                    );
                  }), (Route<dynamic> route) => false);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.12,
                  margin: const EdgeInsets.only(right: 8, left: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF252C6F),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: ColorPalette.mainColor,
                            shape: BoxShape.circle),
                        child: Center(
                          child: Image.asset(
                            'assets/icon/ic_piala.png',
                            width: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rank',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: IsilahHelper
                                        .formatCurrencyWithoutSymbol(
                                            singleUserModel
                                                .data!.user!.experience!
                                                .toDouble()),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: ColorPalette.neutral_30,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: " EXP",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: ColorPalette.neutral_30,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "#${IsilahHelper.formatCurrencyWithoutSymbol(singleUserModel.data!.user!.rankExperience == null ? 0 : singleUserModel.data!.user!.rankExperience!.toDouble())}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return const HomeWidget(
                      initialIndex: 2,
                      showBanner: false,
                    );
                  }), (Route<dynamic> route) => false);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.12,
                  margin: const EdgeInsets.only(right: 8, left: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF252C6F),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: ColorPalette.mainColor,
                            shape: BoxShape.circle),
                        child: Image.asset(
                          'assets/icon/ic_star_single.png',
                          width: 10,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Expanded(
                        child: Text(
                          'Star',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        singleUserModel.data!.user!.point! < 100000
                            ? IsilahHelper.formatCurrencyWithoutSymbol(
                                singleUserModel.data!.user!.point!.toDouble())
                            : "${IsilahHelper.formatCurrencyWithoutSymbol((singleUserModel.data!.user!.point! / 1000).floor().toDouble())} K",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ),
              const UserReferralWidget(),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const HistoriesClaimPage();
                  }));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.12,
                  margin: const EdgeInsets.only(right: 8, left: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF252C6F),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: ColorPalette.mainColor,
                            shape: BoxShape.circle),
                        child: Center(
                          child: Image.asset(
                            'assets/icon/ic_home_prize.png',
                            width: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Expanded(
                        child: Text(
                          'Riwayat Hadiah',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        "${singleUserModel.data!.user!.prizeWinTotal!}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        const TreasureChestWidget(),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }
}
