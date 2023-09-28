import 'dart:io';

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
import 'package:isilahtitiktitik/view/page-intro/page_onboarding.dart';
import 'package:isilahtitiktitik/view/page-prize-pool/page_histories_claim.dart';
import 'package:isilahtitiktitik/view/widgets/shimmer_widget.dart';
import 'package:isilahtitiktitik/view/widgets/update_app_widget.dart';
import 'package:provider/provider.dart';

class HeaderPrizePoolWidget extends StatefulWidget {
  const HeaderPrizePoolWidget({Key? key}) : super(key: key);

  @override
  State<HeaderPrizePoolWidget> createState() => _HeaderPrizePoolWidgetState();
}

class _HeaderPrizePoolWidgetState extends State<HeaderPrizePoolWidget> {
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
      child: BlocListener<SingleUserBloc, SingleUserState>(
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
              return _loadingHeader();
            } else if (state is SingleUserLoading) {
              return _loadingHeader();
            } else if (state is SingleUserLoaded) {
              return _buildHeader(context, state.user);
            } else if (state is SingleUserError) {
              // return _buildEmptyCart();
              return Container();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _loadingHeader() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Stack(
        children: [
          Image.asset(
            'assets/image/img_bg_prize_pool.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(
                  height: 56,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Prize Pool',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(
                        width: 12,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HistoriesClaimPage()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                            color: ColorPalette.mainColor,
                            borderRadius: BorderRadius.circular(4)),
                        child: const Text(
                          "Riwayat Klaim",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const Expanded(
                  child: SizedBox(
                    height: 8,
                  ),
                ),
                Flexible(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Star kamu saat ini',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Flexible(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icon/ic_star_36.png',
                                    width: 18,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const ShimmerWidget(width: 70, height: 20),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Star dalam undian',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Flexible(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icon/ic_star_36.png',
                                    width: 18,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const ShimmerWidget(width: 70, height: 20),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 23,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, User? user) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Stack(
        children: [
          Image.asset(
            'assets/image/img_bg_prize_pool.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Expanded(
                  child: SizedBox(
                    height: 56,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Prize Pool',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(
                        width: 12,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HistoriesClaimPage()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                            color: ColorPalette.mainColor,
                            borderRadius: BorderRadius.circular(4)),
                        child: const Text(
                          "Riwayat Klaim",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const Expanded(
                  child: SizedBox(
                    height: 0,
                  ),
                ),
                Flexible(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Star kamu saat ini',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Flexible(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icon/ic_star_36.png',
                                    width: 18,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    IsilahHelper.formatCurrencyWithoutSymbol(
                                        user!.data!.user!.point == null
                                            ? 0
                                            : user.data!.user!.point!
                                                .toDouble()),
                                    style: const TextStyle(
                                      fontSize: bodyLarge,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Star dalam undian',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Flexible(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icon/ic_star_36.png',
                                    width: 18,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    IsilahHelper.formatCurrencyWithoutSymbol(
                                        user.data!.user!.pointPending == null
                                            ? 0
                                            : user.data!.user!.pointPending!
                                                .toDouble()),
                                    style: const TextStyle(
                                      fontSize: bodyLarge,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 23,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
