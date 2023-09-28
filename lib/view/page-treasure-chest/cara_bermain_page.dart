import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/event_detail.dart';
import 'package:isilahtitiktitik/resource/treasure_chest_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/page-auth/page-login/page_login_by_email.dart';
import 'package:isilahtitiktitik/view/page-intro/page_onboarding.dart';
import 'package:isilahtitiktitik/view/page-quiz/page_countdown.dart';
import 'package:isilahtitiktitik/view/widgets/button_loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/update_app_widget.dart';
import 'package:provider/provider.dart';

class CaraBermainPage extends StatefulWidget {
  final int? eventId;
  const CaraBermainPage({Key? key, this.eventId}) : super(key: key);

  @override
  State<CaraBermainPage> createState() => _CaraBermainPageState();
}

class _CaraBermainPageState extends State<CaraBermainPage> {
  bool isLoading = true;
  bool isLoadingButton = true;

  EventDetailBody? eventDetailBody;

  @override
  void initState() {
    super.initState();
    getDetailEvent();
  }

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

      if (onError == 'Unauthorized') {
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
      } else if (onError == 'Update Required') {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => UpdateAppWidget(
                link: Platform.isAndroid ? androidUrl : iOSUrl,
              ),
            ),
            (route) => false);
      } else {
        flushbarError(onError is String ? onError : onError['message']['title'])
            .show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    TreasureChestApi treasureChestApi = TreasureChestApi(http: chttp);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
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
            'Cara Bermain',
            style: TextStyle(
                fontSize: titleSmall,
                color: Colors.white,
                fontWeight: FontWeight.w600),
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
        ),
        body: isLoading
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Html(
                      data: eventDetailBody!.description ?? '',
                      style: {
                        "body": Style(
                          fontSize: FontSize.large,
                          color: ColorPalette.neutral_80,
                          fontWeight: FontWeight.w400,
                        ),
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        CHttp chttp =
                            Provider.of<CHttp>(context, listen: false);
                        Auth auth = chttp.auth!;
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return Container(
                                height: MediaQuery.of(context).size.height *
                                    ((auth.currentUser!.data!.user!.point! -
                                                    eventDetailBody!
                                                        .requiredPoint!)
                                                .toDouble() <
                                            eventDetailBody!.requiredPoint!
                                                .toDouble()
                                        ? 0.55
                                        : 0.45),
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12))),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Center(
                                            child: Container(
                                              width: 50,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                  color:
                                                      ColorPalette.neutral_30,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Image.asset(
                                            'assets/icon/ic_ticket_star.png',
                                            width: 56,
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          const Text(
                                            'Beli Tiket Main Treasure Chest',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: ColorPalette.neutral_90,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          const Text(
                                            'Star kamu saat ini',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: ColorPalette.neutral_90,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/icon/ic_star_36.png',
                                                width: 32,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                IsilahHelper
                                                    .formatCurrencyWithoutSymbol((auth
                                                                .currentUser!
                                                                .data!
                                                                .user!
                                                                .point! -
                                                            eventDetailBody!
                                                                .requiredPoint!)
                                                        .toDouble()),
                                                style: const TextStyle(
                                                    fontSize: 24,
                                                    color:
                                                        ColorPalette.neutral_90,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    (auth.currentUser!.data!.user!.point! -
                                                    eventDetailBody!
                                                        .requiredPoint!)
                                                .toDouble() <
                                            eventDetailBody!.requiredPoint!
                                                .toDouble()
                                        ? Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                    color: ColorPalette.surface,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      'assets/icon/ic_danger.png',
                                                      width: 24,
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    const Expanded(
                                                      child: Text(
                                                        'Yah, Star kamu belum cukup nih buat main treasure chest. Kumpulin star dulu gih!',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: ColorPalette
                                                              .mainColor,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 24,
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    GestureDetector(
                                      onTap: () async {
                                        if ((auth.currentUser!.data!.user!
                                                        .point! -
                                                    eventDetailBody!
                                                        .requiredPoint!)
                                                .toDouble() <
                                            eventDetailBody!.requiredPoint!
                                                .toDouble()) {
                                          flushbarError(
                                                  'Yah, Star kamu belum cukup')
                                              .show(context);
                                        } else {
                                          setState(() {
                                            isLoadingButton = false;
                                          });

                                          await treasureChestApi
                                              .fetchJoinTreasureChest(
                                                  widget.eventId!)
                                              .then((value) {
                                            if (value['status'] == 1) {
                                              setState(() {
                                                isLoadingButton = true;
                                              });
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CountdownPage(
                                                                flagQuiz:
                                                                    "treasure_chest",
                                                                idQuiz: widget
                                                                    .eventId,
                                                              )));
                                            } else {
                                              setState(() {
                                                isLoadingButton = true;
                                              });
                                              flushbarError(
                                                      value['message']['title'])
                                                  .show(context);
                                            }
                                          }).catchError((onError) {
                                            setState(() {
                                              isLoadingButton = true;
                                            });
                                            flushbarError(onError is String
                                                    ? onError
                                                    : onError['message']
                                                        ['title'])
                                                .show(context);
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 55,
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: (auth.currentUser!.data!.user!
                                                              .point! -
                                                          eventDetailBody!
                                                              .requiredPoint!)
                                                      .toDouble() <
                                                  eventDetailBody!
                                                      .requiredPoint!
                                                      .toDouble()
                                              ? ColorPalette.neutral_50
                                              : ColorPalette.mainColor,
                                        ),
                                        child: isLoadingButton
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        'assets/icon/ic_star_single.png',
                                                        width: 18,
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        IsilahHelper
                                                            .formatCurrencyWithoutSymbol(
                                                                eventDetailBody!
                                                                    .requiredPoint!
                                                                    .toDouble()),
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Text(
                                                    'Main Sekarang',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const ButtonLoadingWidget(
                                                color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                          },
                        );
                      },
                      child: Container(
                        height: 55,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: ColorPalette.mainColor,
                        ),
                        child: const Center(
                          child: Text(
                            'Main',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const LoadingWidget(),
      ),
    );
  }
}
