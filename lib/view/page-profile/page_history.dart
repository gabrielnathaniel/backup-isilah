import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/bloc/history-bloc/history_bloc.dart';
import 'package:isilahtitiktitik/model/history.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-auth/page-login/page_login_by_email.dart';
import 'package:isilahtitiktitik/view/page-intro/page_onboarding.dart';
import 'package:isilahtitiktitik/view/widgets/empty_state.dart';
import 'package:isilahtitiktitik/view/widgets/loading_history_star_widget.dart';
import 'package:isilahtitiktitik/view/widgets/update_app_widget.dart';
import 'package:provider/provider.dart';
import '../../constant/constant.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

enum TimeSpan { hariini, mingguini, bulanini }

class _HistoryPageState extends State<HistoryPage> {
  final HistoryBloc historyBloc = HistoryBloc();
  int pageNumber = 1;
  int? _limit = 1;
  int? _currentLenght;
  List<Data> _listDataHistory = [];
  final ScrollController _scHistory = ScrollController();

  TimeSpan? timespan = TimeSpan.mingguini;

  String startDate = DateTime.now()
      .subtract(Duration(days: DateTime.now().weekday))
      .toString();
  // String startDate = DateTime.now().subtract(Duration(days: 365)).toString();
  String endDate = DateTime.now()
      .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday - 1))
      .toString();

  String timeSpanText = 'Minggu Ini';

  @override
  void initState() {
    _loadMoreHistory(true, false);
    _scHistory.addListener(() {
      if (_scHistory.position.pixels == _scHistory.position.maxScrollExtent) {
        if (_currentLenght != null) {
          if (_currentLenght! < _limit!) {
            pageNumber = pageNumber + 1;
            _loadMoreHistory(false, false);
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scHistory.dispose();
    historyBloc.close();
  }

  Future<void> _loadMoreHistory(bool statusLoad, bool statusRefresh) async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    historyBloc.add(GetHistory(
        http: chttp,
        statusLoad: statusLoad,
        statusRefresh: statusRefresh,
        startDate: startDate,
        endDate: endDate,
        page: pageNumber));
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
          'Riwayat Star',
          style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: bodyMedium,
              color: Colors.white,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocProvider(
        create: (context) => historyBloc,
        child: BlocListener<HistoryBloc, HistoryState>(
          listener: (context, state) {
            if (state is HistoryNoAuth) {
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
            if (state is HistoryUpdateApp) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => UpdateAppWidget(
                      link: Platform.isAndroid ? androidUrl : iOSUrl,
                    ),
                  ),
                  (route) => false);
            }
          },
          child: BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              if (state is HistoryInitial) {
                return LoadingHistoryStarWidget();
              } else if (state is HistoryLoading) {
                return LoadingHistoryStarWidget();
              } else if (state is HistoryLoaded ||
                  state is HistoryMoreLoading) {
                if (state is HistoryLoaded) {
                  _listDataHistory = state.list;
                  _currentLenght = state.count;
                  _limit = state.limit;
                }
                return _buildData(state);
              } else if (state is HistoryError) {
                return Center(
                  child: EmptyStateWidget(
                    sizeWidth: 200,
                    title: 'Oops!',
                    subTitle: state.message,
                  ),
                );
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildData(HistoryState state) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          pageNumber = 1;
          _limit = 1;
          _currentLenght = 0;
        });

        _loadMoreHistory(true, true);
      },
      child: SingleChildScrollView(
        controller: _scHistory,
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Riwayat star kamu',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: bodyMedium,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      backgroundColor: Colors.white,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    height: 6,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: ColorPalette
                                            .colorHeaderModalBottomSheet),
                                  ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Pilih Rentang Waktu',
                                      style: TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          fontSize: bodyLarge,
                                          color: ColorPalette.neutral_90,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    RadioListTile<TimeSpan>(
                                      contentPadding: const EdgeInsets.all(0),
                                      title: const Text(
                                        'Hari Ini',
                                        style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: bodyLarge,
                                            color: ColorPalette.neutral_90,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      activeColor: const Color(0xFF2D3F6F),
                                      value: TimeSpan.hariini,
                                      groupValue: timespan,
                                      onChanged: (TimeSpan? value) {
                                        setState(() {
                                          timespan = value;
                                          timeSpanText = 'Hari Ini';
                                          startDate = DateTime.now().toString();
                                          endDate = DateTime.now().toString();
                                        });
                                      },
                                    ),
                                    RadioListTile<TimeSpan>(
                                      contentPadding: const EdgeInsets.all(0),
                                      title: const Text(
                                        'Minggu Ini',
                                        style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: bodyLarge,
                                            color: ColorPalette.neutral_90,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      activeColor: const Color(0xFF2D3F6F),
                                      value: TimeSpan.mingguini,
                                      groupValue: timespan,
                                      onChanged: (TimeSpan? value) {
                                        setState(() {
                                          timespan = value;
                                          timeSpanText = 'Minggu Ini';
                                          startDate = DateTime.now()
                                              .subtract(Duration(
                                                  days: DateTime.now().weekday))
                                              .toString();
                                          endDate = DateTime.now()
                                              .add(Duration(
                                                  days: DateTime.daysPerWeek -
                                                      DateTime.now().weekday -
                                                      1))
                                              .toString();
                                        });
                                      },
                                    ),
                                    RadioListTile<TimeSpan>(
                                      contentPadding: const EdgeInsets.all(0),
                                      title: const Text(
                                        'Bulan Ini',
                                        style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: bodyLarge,
                                            color: ColorPalette.neutral_90,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      activeColor: const Color(0xFF2D3F6F),
                                      value: TimeSpan.bulanini,
                                      groupValue: timespan,
                                      onChanged: (TimeSpan? value) {
                                        setState(() {
                                          timespan = value;
                                          timeSpanText = 'Bulan Ini';
                                          startDate = DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  1)
                                              .toString();
                                          endDate = DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month + 1,
                                                  0)
                                              .toString();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      pageNumber = 1;
                                    });
                                    _loadMoreHistory(true, true);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFEF5696),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: const Center(
                                        child: Text('Terapkan',
                                            style: TextStyle(
                                                fontFamily: 'PlusJakartaSans',
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600))),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          timeSpanText,
                          style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: bodyMedium,
                              color: ColorPalette.neutral_90,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          'assets/icon/ic_arrow_down.png',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            _buildList(state),
          ],
        ),
      ),
    );
  }

  Widget _buildList(HistoryState state) {
    if (_listDataHistory.isEmpty) {
      return const Center(
        child: EmptyStateWidget(
          sizeWidth: 200,
          title: 'Riwayat star kamu tidak ada',
          subTitle: 'Yuk main dan kumpulin star buat klaim hadiah kamu',
        ),
      );
    }

    return Column(
      children: [
        ..._listDataHistory
            .map(
              (data) => Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          iconHistory(data.source!),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: Text(
                              data.notes!.toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: bodyMedium,
                                  color: ColorPalette.neutral_90,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${data.amount!} ${data.code!}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: bodyMedium,
                                color: data.amount! >= 0
                                    ? const Color(0xFF5CB489)
                                    : const Color(0xFFCB3A31),
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        (state is HistoryMoreLoading)
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

  Widget iconHistory(String source) {
    if (source == "quiz") {
      return Image.asset(
        'assets/icon/ic_star_single.png',
        width: 22,
      );
    }
    if (source == "game") {
      return Image.asset(
        'assets/icon/ic_game_history.png',
        width: 22,
      );
    }
    return Image.asset(
      'assets/icon/ic_prize_history.png',
      width: 22,
    );
  }
}
