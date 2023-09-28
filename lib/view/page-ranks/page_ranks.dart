import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';
import 'package:isilahtitiktitik/view/page-ranks/widgets/rank_all_time_widget.dart';
import 'package:isilahtitiktitik/view/page-ranks/widgets/rank_monthly_widget.dart';
import 'package:isilahtitiktitik/view/page-ranks/widgets/rank_today_widget.dart';
import 'package:isilahtitiktitik/view/page-ranks/widgets/rank_weekly_widget.dart';
import 'package:isilahtitiktitik/view/widgets/no_internet_connection_widget.dart';

class RanksPage extends StatefulWidget {
  const RanksPage({Key? key}) : super(key: key);

  @override
  State<RanksPage> createState() => _RanksPageState();
}

class _RanksPageState extends State<RanksPage> {
  bool isConnectedNetwork = true;

  @override
  void initState() {
    checkInternetConnection();
    super.initState();
  }

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
  Widget build(BuildContext context) {
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
        appBar: AppBar(
          flexibleSpace: const Image(
            image: AssetImage('assets/image/img_background_appbar.png'),
            fit: BoxFit.cover,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          title: const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Ranking',
              style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: titleMedium,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        body: !isConnectedNetwork
            ? NoInternetConnectionWidget(function: () {
                checkInternetConnection();
              })
            : DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                      ),
                      child: const TabBar(
                        isScrollable: true,
                        indicatorColor: ColorPalette.mainColor,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 3,
                        labelPadding: EdgeInsets.symmetric(horizontal: 20),
                        labelColor: Color(0xFFEF5696),
                        labelStyle: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: bodyMedium,
                            color: Color(0xFFEF5696),
                            fontWeight: FontWeight.w500),
                        unselectedLabelColor: ColorPalette.colorTextTabDisable,
                        unselectedLabelStyle: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: bodyMedium,
                            fontWeight: FontWeight.w500),
                        tabs: [
                          Tab(
                            text: 'Hari Ini',
                          ),
                          Tab(
                            text: 'Minggu Ini',
                          ),
                          Tab(
                            text: 'Bulan Ini',
                          ),
                          Tab(
                            text: 'Sepanjang Waktu',
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: TabBarView(
                        children: [
                          RankTodayWidget(),
                          RankWeeklyWidget(),
                          RankMonthlyWidget(),
                          RankAllTimeWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
