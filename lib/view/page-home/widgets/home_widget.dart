import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/resource/promo_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-auth/page-login/page_login_by_email.dart';
import 'package:isilahtitiktitik/view/page-home/page_home.dart';
import 'package:isilahtitiktitik/view/page-home/page_promo.dart';
import 'package:isilahtitiktitik/view/page-intro/page_onboarding.dart';
import 'package:isilahtitiktitik/view/page-prize-pool/page_prize_pool.dart';
import 'package:isilahtitiktitik/view/page-profile/page_profile.dart';
import 'package:isilahtitiktitik/view/page-ranks/page_ranks.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeWidget extends StatefulWidget {
  final int? initialIndex;
  final bool? showBanner;
  const HomeWidget({Key? key, this.initialIndex, this.showBanner})
      : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int? _currentIndex = 0;
  int _currentPromo = 0;

  final List<Widget> _children = [
    const HomePage(),
    const RanksPage(),
    const PrizePoolPage(),
    const ProfilePage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _getPromo() {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    PromoApi promoApi = PromoApi(http: chttp);
    if (widget.showBanner == null || widget.showBanner!) {
      promoApi.fetchPromo().then((value) {
        if (value.data!.data!.isNotEmpty) {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (ctx) {
                return StatefulBuilder(
                  builder: (BuildContext ctx, StateSetter setState) {
                    return AlertDialog(
                      elevation: 0,
                      contentPadding: const EdgeInsets.all(0),
                      insetPadding: const EdgeInsets.all(0),
                      backgroundColor: Colors.transparent,
                      content: Wrap(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      'Tutup',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                CarouselSlider(
                                  options: CarouselOptions(
                                    height: MediaQuery.of(context).size.height *
                                        0.65,
                                    autoPlay: false,
                                    aspectRatio: 16 / 9,
                                    viewportFraction: 1,
                                    onPageChanged: (index, reason) {
                                      setState(() => _currentPromo = index);
                                    },
                                  ),
                                  items: value.data!.data!.map((data) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (data.externalLink!.isNotEmpty) {
                                            Navigator.pop(ctx);
                                            _launchInBrowser(
                                                Uri.parse(data.externalLink!));
                                          } else {
                                            Navigator.pop(ctx);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PromoPage(
                                                          dataPromo: data,
                                                        )));
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            child: CachedNetworkImage(
                                              imageUrl: '${data.thumbnail}',
                                              fit: BoxFit.contain,
                                              width: double.infinity,
                                              placeholder: (context, url) =>
                                                  Container(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Center(
                                                          child: Image.asset(
                                                "assets/image/default_image.png",
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                value.data!.data!.length == 1
                                    ? Container()
                                    : Column(
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: value.data!.data!
                                                  .map((url) {
                                                    int index = value
                                                        .data!.data!
                                                        .toList()
                                                        .indexOf(url);
                                                    return Container(
                                                      width: 10.0,
                                                      height: 10.0,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color:
                                                              _currentPromo ==
                                                                      index
                                                                  ? ColorPalette
                                                                      .mainColor
                                                                  : ColorPalette
                                                                      .colorHeaderModalBottomSheet),
                                                    );
                                                  })
                                                  .take(
                                                      value.data!.data!.length)
                                                  .toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              });
        }
      }).catchError((onError) {});
    }
  }

  @override
  void initState() {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    if (auth.currentUser!.data!.user!.id != 11) {
      _getPromo();
    }
    if (widget.initialIndex != null) {
      setState(() {
        _currentIndex = widget.initialIndex;
      });
    }
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.initState();
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      bottomNavigationBar: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: ColorPalette.neutral_90.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 16,
              offset: const Offset(0, -4), // changes position of shadow
            ),
          ],
        ),
        child: BottomNavigationBar(
          onTap: onTabTapped,
          backgroundColor: Colors.white,
          currentIndex: _currentIndex!,
          selectedItemColor: ColorPalette.mainColor,
          selectedIconTheme: const IconThemeData(color: ColorPalette.mainColor),
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
              height: 1.8,
              fontSize: 12,
              color: ColorPalette.mainColor,
              fontWeight: FontWeight.w500),
          unselectedLabelStyle: const TextStyle(
              height: 1.8,
              fontSize: 12,
              color: ColorPalette.neutral_50,
              fontWeight: FontWeight.w500),
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icon/ic_home.png',
                height: 24,
              ),
              activeIcon: Image.asset(
                'assets/icon/ic_home_active.png',
                height: 24,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icon/ic_ranking.png',
                height: 24,
              ),
              activeIcon: Image.asset(
                'assets/icon/ic_ranking_active.png',
                height: 24,
              ),
              label: 'Ranking',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icon/ic_prize_pool.png',
                height: 24,
              ),
              activeIcon: Image.asset(
                'assets/icon/ic_prize_pool_active.png',
                height: 24,
              ),
              label: 'Undian',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icon/ic_profile.png',
                height: 24,
              ),
              activeIcon: Image.asset(
                'assets/icon/ic_profile_active.png',
                height: 24,
              ),
              label: 'Profil',
            ),
          ],
        ),
      ),
      body: _children[_currentIndex!],
    );
  }
}
