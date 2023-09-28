import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/bloc/notification-main-bloc/notification_main_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/notification_main.dart';
import 'package:isilahtitiktitik/resource/notification_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/view/page-fun-fact/page_detail_fun_fact.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/no_internet_connection_widget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class NotificationMainPage extends StatefulWidget {
  const NotificationMainPage({Key? key}) : super(key: key);

  @override
  State<NotificationMainPage> createState() => _NotificationMainPageState();
}

class _NotificationMainPageState extends State<NotificationMainPage> {
  NotificationMainBloc notificationMainBloc = NotificationMainBloc();

  void _getNotification(bool isRefresh) {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    notificationMainBloc
        .add(GetNotificationMain(http: chttp, isRefresh: isRefresh));
  }

  @override
  void initState() {
    _getNotification(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: BlocProvider<NotificationMainBloc>(
        create: (context) => notificationMainBloc,
        child: Scaffold(
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
                'Notifikasi',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
            body: _buildNotificationMain()),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          'assets/image/img_empty_state.png',
          width: 200,
        ),
        const SizedBox(
          height: 32,
        ),
        const Text(
          'Cie kesepian, emang lagi ga ada\nnotifikasi sih hehe',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorPalette.neutral_90,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ]),
    );
  }

  Widget _buildNotificationMain() {
    return BlocBuilder<NotificationMainBloc, NotificationMainState>(
        builder: (context, state) {
      if (state is NotificationMainInitial) {
        return const LoadingWidget();
      } else if (state is NotificationMainLoading) {
        return const LoadingWidget();
      } else if (state is NotificationMainLoaded) {
        return _buildNotificationMainList(context, state.notificationModel);
      } else if (state is NotificationMainError) {
        Logger().e("message error ${state.message}");
        return state.message == 'Not connected'
            ? NoInternetConnectionWidget(function: () {
                _getNotification(true);
              })
            : _buildEmpty();
      }
      return Container();
    });
  }

  Widget _buildNotificationMainList(
      BuildContext context, NotificationModel notificationModel) {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    NotificationApi notificationApi = NotificationApi(http: chttp);
    return notificationModel.data!.data == null
        ? _buildEmpty()
        : notificationModel.data!.data!.latest!.data!.isEmpty &&
                notificationModel.data!.data!.oldest!.data!.isEmpty
            ? _buildEmpty()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...notificationModel.data!.data!.latest!.data!
                          .asMap()
                          .map((index, notif) => MapEntry(
                              index,
                              GestureDetector(
                                onTap: () {
                                  notificationApi
                                      .postReadNotification(notif.id!)
                                      .then((value) {
                                    if (notif.refference == "article") {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return DetailFunFactPage(
                                          idFunFact:
                                              int.parse(notif.refferenceId!),
                                        );
                                      })).then((val) => val! == true
                                          ? _getNotification(true)
                                          : null);
                                    } else if (notif.refference == "profile") {
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const HomeWidget(
                                          initialIndex: 3,
                                          showBanner: false,
                                        );
                                      }));
                                    } else {
                                      _getNotification(true);
                                    }
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  margin:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  padding: const EdgeInsets.all(defaultPadding),
                                  decoration: BoxDecoration(
                                      color: notif.status == 1
                                          ? ColorPalette.greyNotif
                                          : Colors.white.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          width: 1,
                                          color: ColorPalette.neutral_30)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          notif.content == null
                                              ? ""
                                              : notif.content!,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: notif.status == 1
                                                  ? ColorPalette.neutral_70
                                                  : ColorPalette.neutral_90),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      notif.status == 1
                                          ? Container()
                                          : Container(
                                              width: 8,
                                              height: 8,
                                              decoration: const BoxDecoration(
                                                  color: ColorPalette.mainColor,
                                                  shape: BoxShape.circle),
                                            )
                                    ],
                                  ),
                                ),
                              )))
                          .values
                          .toList(),
                      ...notificationModel.data!.data!.oldest!.data!
                          .asMap()
                          .map((index, notif) => MapEntry(
                              index,
                              GestureDetector(
                                onTap: () {
                                  notificationApi
                                      .postReadNotification(notif.id!)
                                      .then((value) {
                                    if (notif.refference == "article") {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return DetailFunFactPage(
                                          idFunFact:
                                              int.parse(notif.refferenceId!),
                                        );
                                      })).then((val) => val! == true
                                          ? _getNotification(true)
                                          : null);
                                    } else if (notif.refference == "profile") {
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const HomeWidget(
                                          initialIndex: 3,
                                          showBanner: false,
                                        );
                                      }));
                                    } else {
                                      _getNotification(true);
                                    }
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  margin:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  padding: const EdgeInsets.all(defaultPadding),
                                  decoration: BoxDecoration(
                                      color: notif.status == 1
                                          ? ColorPalette.greyNotif
                                          : Colors.white.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          width: 1,
                                          color: ColorPalette.neutral_30)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          notif.content == null
                                              ? ""
                                              : notif.content!,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: notif.status == 1
                                                  ? ColorPalette.neutral_70
                                                  : ColorPalette.neutral_90),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      notif.status == 1
                                          ? Container()
                                          : Container(
                                              width: 8,
                                              height: 8,
                                              decoration: const BoxDecoration(
                                                  color: ColorPalette.mainColor,
                                                  shape: BoxShape.circle),
                                            )
                                    ],
                                  ),
                                ),
                              )))
                          .values
                          .toList(),
                    ]));
  }
}
