import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-auth/page-login/page_login_by_email.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';
import 'package:isilahtitiktitik/view/page-intro/page_onboarding.dart';
import 'package:isilahtitiktitik/view/page-prize-pool/widgets/header.dart';
import 'package:isilahtitiktitik/view/page-prize-pool/widgets/prize_next_level.dart';
import 'package:isilahtitiktitik/view/page-prize-pool/widgets/prize_widget.dart';
import 'package:isilahtitiktitik/view/page-prize-pool/widgets/undian_widget.dart';
import 'package:isilahtitiktitik/view/widgets/no_internet_connection_widget.dart';
import 'package:provider/provider.dart';

class PrizePoolPage extends StatefulWidget {
  const PrizePoolPage({Key? key}) : super(key: key);

  @override
  State<PrizePoolPage> createState() => _PrizePoolPageState();
}

class _PrizePoolPageState extends State<PrizePoolPage> {
  bool isConnectedNetwork = true;
  void checkInternetConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isConnectedNetwork = false;
      });
    } else {
      setState(() {
        isConnectedNetwork = true;
      });
    }
  }

  @override
  void initState() {
    checkInternetConnection();
    super.initState();
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const HomeWidget(
            showBanner: false,
          );
        }));
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: !isConnectedNetwork
            ? NoInternetConnectionWidget(function: () {
                checkInternetConnection();
              })
            : const SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderPrizePoolWidget(),
                    SizedBox(
                      height: 23,
                    ),
                    PrizeWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: UndianWidget(
                        title: 'Pemenang Undian',
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        "Hadiah Level Berikutnya",
                        style: TextStyle(
                          fontSize: bodyMedium,
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: PrizeNextLevelWidget(),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
