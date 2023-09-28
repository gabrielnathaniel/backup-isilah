import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-intro/page_onboarding.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAccountStateWidget extends StatefulWidget {
  final bool? navigasi;
  const DeleteAccountStateWidget({Key? key, @required this.navigasi})
      : super(key: key);

  @override
  State<DeleteAccountStateWidget> createState() =>
      _DeleteAccountStateWidgetState();
}

class _DeleteAccountStateWidgetState extends State<DeleteAccountStateWidget> {
  bool _isLoading = true;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleSignOut() async {
    try {
      final user = await _googleSignIn.signOut();
      Logger().d(user);
    } catch (error) {
      return;
    }
  }

  void _whenLogout() async {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    Auth authLogout = chttp.auth!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('withGoogle') == true) {
      _handleSignOut();
    }
    authLogout.fetchLogout().then((value) {
      if (value['status'] == 1) {
        setState(() {
          _isLoading = true;
        });
        Future.delayed(const Duration(milliseconds: 50), () {
          auth.logout();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const OnBoardingPage(),
              ),
              (route) => false);
        });
      } else {
        setState(() {
          _isLoading = true;
        });
        flushbarError(value['message']['title']).show(context);
      }
    }).catchError((onError) {
      setState(() {
        _isLoading = true;
      });
      flushbarError(onError is String ? onError : onError['message']['title'])
          .show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    CHttp chttp = Provider.of(context, listen: false);
    Auth authLink = chttp.auth!;
    return WillPopScope(
      onWillPop: () async {
        // if (widget.navigasi!) {
        //   Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        // } else {
        SystemNavigator.pop();
        // }

        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   centerTitle: false,
        //   titleSpacing: 0,
        //   iconTheme: const IconThemeData(color: ColorPalette.neutral_90),
        //   title: Text(
        //     'Kembali',
        //     style: TextStyle(
        //         fontSize: titleSmall,
        //         color: ColorPalette.neutral_90,
        //         fontWeight: FontWeight.w600),
        //   ),
        // ),
        body: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          Image.asset(
                            'assets/image/img_delete_account.png',
                            width: 200,
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          const Text(
                            'Akun Akan Dihapus',
                            style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: titleLarge,
                                color: ColorPalette.neutral_90,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Akun kamu akan terhapus dari sistem dalam\nwaktu 30 hari, jika kamu ingin membatalkan\npenghapusan akun, klik tombol “Batalkan\nPenghapusan Akun” dibawah ini',
                            style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: bodyMedium,
                                height: 1.5,
                                color: ColorPalette.neutral_70,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          GestureDetector(
                            onTap: () {
                              _whenLogout();
                            },
                            child: const Text(
                              'Keluar dari sini',
                              style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: bodyMedium,
                                  height: 1.5,
                                  color: ColorPalette.mainColor,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          _isLoading = false;
                        });
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        authLink.cancelDeleteAccount().then((cancelDelete) {
                          if (cancelDelete['status'] == 1) {
                            prefs.setString(
                                'deleteRequestAt',
                                cancelDelete['data']['delete_request_at'] ??
                                    "");
                            prefs.setString('deletedAt',
                                cancelDelete['data']['deleted_at'] ?? "");
                            prefs.setInt(
                                'status',
                                cancelDelete['data']['user']['user']
                                        ['status'] ??
                                    "");
                            // setState(() {
                            //   _isLoading = true;
                            // });
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (route) => false);
                            Flushbar(
                              message: cancelDelete['message']['title'],
                              margin: const EdgeInsets.all(16),
                              borderRadius: BorderRadius.circular(8),
                              duration: const Duration(seconds: 2),
                              messageSize: 12,
                              backgroundColor: ColorPalette.greenColor,
                            ).show(context);
                          } else {
                            flushbarError(cancelDelete['message']['title'])
                                .show(context);
                          }
                        }).catchError((onError) {
                          if (onError == 'Unauthorized') {
                            _whenLogout();
                          } else {
                            setState(() {
                              _isLoading = true;
                            });
                            flushbarError(onError['message']['title'])
                                .show(context);
                          }
                        });
                      },
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF5696),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Batalkan Penghapusan Akun',
                            style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : const LoadingWidget(),
      ),
    );
  }
}
