import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-profile/page-referral/page_referral_step.dart';
import 'package:isilahtitiktitik/view/page-profile/page-referral/page_referral_user.dart';
import 'package:isilahtitiktitik/view/widgets/button_loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({Key? key}) : super(key: key);

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  final GlobalKey _globalKey = GlobalKey();
  bool _isLoading = true;
  final textEditingReferralCode = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      setState(() {});
      return pngBytes;
    } on DioError catch (err) {
      return err.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    Auth auth = chttp.auth!;
    BaseAuth auth0 = Provider.of<Auth>(context, listen: false);
    var heightStatusbar = MediaQuery.of(context).viewPadding.top;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            RepaintBoundary(
              key: _globalKey,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage('assets/image/img_bg_referral.png'))),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          'assets/logo/logo_isilah.png',
                          width: 50,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/image/img_share_referral.png',
                            width: MediaQuery.of(context).size.width * 0.25,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Jawab soal dan\nSeru seruan.',
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Ayo join sama kita, makin rame makin banyak star',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 41,
                      ),
                      const Text(
                        'Jangan lupa masukin kode dibawah',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${auth0.currentUser!.data!.user!.refferalCode}',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 37,
                      ),
                      const Text(
                        'Yuk Main dan Download di',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/logo/logo_isilah_ios.png',
                              width: 35,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            'Isilah Titik - Titik',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Image.asset(
                        'assets/image/img_google_play.png',
                        height: 40,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 490,
                      child: Stack(
                        children: [
                          Image.asset(
                            Platform.isIOS
                                ? 'assets/image/img_referral_bg_ios.png'
                                : 'assets/image/img_bg_referral.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 490,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: heightStatusbar,
                              ),
                              Container(
                                height: kToolbarHeight,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: GestureDetector(
                                        onTap: () =>
                                            Navigator.pop(context, true),
                                        child: Center(
                                          child: Platform.isIOS
                                              ? Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 8),
                                                  child: const Icon(
                                                      Icons.arrow_back_ios,
                                                      color: Colors.white),
                                                )
                                              : const Icon(Icons.arrow_back,
                                                  color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                      child: Text(
                                        'Referral',
                                        style: TextStyle(
                                            fontSize: titleSmall,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final RenderBox? box = context
                                            .findRenderObject() as RenderBox?;
                                        final directory = Platform.isIOS
                                            ? (await getApplicationDocumentsDirectory())
                                                .path
                                            : (await getExternalStorageDirectory())!
                                                .path;
                                        File imgFile = File(
                                            '$directory/referral_code.png');
                                        _capturePng().then((value) async {
                                          await imgFile.writeAsBytes(value);

                                          Share.shareXFiles(
                                              [XFile(imgFile.path)],
                                              subject:
                                                  "Ayo bergabung dan main bersama isilah",
                                              text: auth0.currentUser!.data!
                                                          .user!.id ==
                                                      11
                                                  ? "Ayo bergabung dan main bersama isilah"
                                                  : "Ayo bergabung dan main bersama https://isilah.com/ dan masukan kode referal ini ${auth0.currentUser!.data!.user!.refferalCode} dan dapatkan star nya",
                                              sharePositionOrigin: box!
                                                      .localToGlobal(
                                                          Offset.zero) &
                                                  box.size);
                                        });
                                      },
                                      child: const Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 16,
                                          ),
                                          child: Icon(
                                            Icons.share,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, bottom: 16, top: 25),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Dapatkan Hingga\n17.000 Star",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      Image.asset(
                                        'assets/image/img_referral.png',
                                        width: 150,
                                      ),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      const Text(
                                        'Ajak teman sebanyak banyaknya\nmakin banyak juga dapat starnya',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
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
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.5, color: ColorPalette.neutral_30),
                          borderRadius: BorderRadius.circular(8)),
                      child: ExpandablePanel(
                        theme: const ExpandableThemeData(
                            iconPadding: EdgeInsets.all(16),
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center),
                        header: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Lupa pakai kode referal temanmu?',
                            style: TextStyle(
                                fontSize: 14,
                                color: ColorPalette.neutral_90,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        collapsed: const SizedBox(height: 0),
                        expanded: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Yuk, masukin kode referalnya dibawah ini',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: ColorPalette.neutral_90,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                    cursorColor: ColorPalette.mainColor,
                                    controller: textEditingReferralCode,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    style: const TextStyle(
                                      color: ColorPalette.neutral_90,
                                      fontWeight: FontWeight.w500,
                                      fontSize: bodyMedium,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Nomor Referral',
                                      hintStyle: const TextStyle(
                                        color: ColorPalette.neutral_60,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                      errorStyle: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w400,
                                        fontSize: bodySmall,
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          if (textEditingReferralCode
                                              .text.isEmpty) {
                                            flushbarError(
                                                    'Kode tidak boleh kosong')
                                                .show(context);
                                          } else {
                                            String convertHp = "";
                                            if (textEditingReferralCode
                                                .text.isNotEmpty) {
                                              if (textEditingReferralCode.text
                                                  .startsWith("62")) {
                                                convertHp =
                                                    textEditingReferralCode.text
                                                        .replaceRange(0, 2, '');
                                              } else if (textEditingReferralCode
                                                  .text
                                                  .startsWith("0")) {
                                                convertHp =
                                                    textEditingReferralCode.text
                                                        .replaceRange(0, 1, '');
                                              } else {
                                                convertHp =
                                                    textEditingReferralCode
                                                        .text;
                                              }
                                            }
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            auth
                                                .postReferralUpdate(convertHp)
                                                .then((value) {
                                              if (value!.status == 1) {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                Navigator.pop(context);
                                                Flushbar(
                                                  message: value.message!.title,
                                                  margin:
                                                      const EdgeInsets.all(16),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  duration: const Duration(
                                                      seconds: 2),
                                                  messageSize: 12,
                                                  backgroundColor:
                                                      ColorPalette.greenColor,
                                                ).show(context);
                                              } else {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                flushbarError(
                                                        value.message!.title!)
                                                    .show(context);
                                              }
                                            }).catchError((onError) {
                                              setState(() {
                                                _isLoading = true;
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          margin: const EdgeInsets.only(
                                              top: 5, bottom: 5, right: 5),
                                          decoration: BoxDecoration(
                                              color: textEditingReferralCode
                                                      .text.isEmpty
                                                  ? ColorPalette.neutral_50
                                                  : ColorPalette.mainColor,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                _isLoading
                                                    ? const Text(
                                                        'Konfirmasi',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 12,
                                                        ),
                                                      )
                                                    : const ButtonLoadingWidget(
                                                        color: Colors.white),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          bottom: 8,
                                          top: 8,
                                          right: 12,
                                          left: 12),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: ColorPalette.neutral_50),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: const BorderSide(
                                              color: Colors.red)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: const BorderSide(
                                              color: Colors.red)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: const BorderSide(
                                              color: ColorPalette.mainColor)),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    keyboardType: TextInputType.text),
                              ],
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Nomor Referal kamu',
                        style: TextStyle(
                            color: ColorPalette.neutral_90,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 10),
                      decoration: ShapeDecoration(
                        color: ColorPalette.neutral_20,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 0.50, color: ColorPalette.neutral_40),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              auth0.currentUser!.data!.user!.refferalCode ?? '',
                              style: const TextStyle(
                                color: ColorPalette.neutral_90,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.07,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(
                                      text: auth0.currentUser!.data!.user!
                                          .refferalCode!))
                                  .then((value) {
                                Flushbar(
                                  message:
                                      'Kode referral telah disalin di papan klip',
                                  margin: const EdgeInsets.all(16),
                                  borderRadius: BorderRadius.circular(8),
                                  duration: const Duration(seconds: 2),
                                  messageSize: 12,
                                  backgroundColor: ColorPalette.greenColor,
                                ).show(context);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                  color: ColorPalette.mainColor,
                                  borderRadius: BorderRadius.circular(6)),
                              child: const Center(
                                  child: Text('Salin',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700))),
                            ),
                          )
                        ],
                      ),
                    ),
                    const ReferralStepPage(),
                    const ReferralUserPage(),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: ColorPalette.neutral_90.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 16,
                      offset: const Offset(0, -4), // changes position of shadow
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () async {
                    final RenderBox? box =
                        context.findRenderObject() as RenderBox?;
                    final directory = Platform.isIOS
                        ? (await getApplicationDocumentsDirectory()).path
                        : (await getExternalStorageDirectory())!.path;
                    File imgFile = File('$directory/referral_code.png');
                    _capturePng().then((value) async {
                      await imgFile.writeAsBytes(value);

                      Share.shareXFiles([XFile(imgFile.path)],
                          subject: "Ayo bergabung dan main bersama isilah",
                          text: auth0.currentUser!.data!.user!.id == 11
                              ? "Ayo bergabung dan main bersama isilah"
                              : "Ayo bergabung dan main bersama https://isilah.com/ dan masukan kode referal ini ${auth0.currentUser!.data!.user!.refferalCode} dan dapatkan star nya",
                          sharePositionOrigin:
                              box!.localToGlobal(Offset.zero) & box.size);
                    });
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: const Color(0xFFEF5696),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                        child: Text(
                      'Ajak Temanmu',
                      style: TextStyle(
                          fontSize: bodySmall,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    )),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
