import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-auth/page-forgot-password/page_finishing_password.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

/// Page ini bertujuan untuk memvalidasi `otp` yang dikirimkan ke
/// `email` yang sebelumnya di isi oleh User. Otp ini hanya valid sampai `1 Menit`,
/// apabila otp sudah kadaluarsa user harus mengirim ulang.
class VerifyOTPPasswordPage extends StatefulWidget {
  final String? email;
  const VerifyOTPPasswordPage({Key? key, @required this.email})
      : super(key: key);

  @override
  State<VerifyOTPPasswordPage> createState() => _VerifyOTPPasswordPageState();
}

class _VerifyOTPPasswordPageState extends State<VerifyOTPPasswordPage> {
  final _pinPutController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isLoading = true;

  Timer? _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CHttp chttp = Provider.of(context, listen: false);
    Auth authForgot = chttp.auth!;
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: ColorPalette.neutral_90),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/image/img_otp.png',
                  width: 200,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Pinput(
                onChanged: (value) async {
                  if (value.length >= 4) {
                    setState(() {
                      _isLoading = false;
                    });

                    /// Fungsi untuk memvalidasi `otp` yang di input dengan `otp`
                    /// yang dikirim ke `email` user.
                    authForgot
                        .forgotPasswordVerifyOTP(
                            widget.email!, _pinPutController.text)
                        .then((value) {
                      if (value['status'] == 1) {
                        setState(() {
                          _isLoading = true;
                        });
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return FinishingPasswordPage(
                              email: widget.email, otp: _pinPutController.text);
                        }));
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
                      flushbarError(onError is String
                              ? onError
                              : onError['message']['title'])
                          .show(context);
                    });
                  }
                },
                autofocus: true,
                focusNode: _focusNode,
                controller: _pinPutController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                closeKeyboardWhenCompleted: true,
                focusedPinTheme: const PinTheme(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                              width: 2, color: ColorPalette.neutral_100))),
                  width: 70,
                  height: 70,
                  textStyle: TextStyle(
                      fontSize: 20.0,
                      color: ColorPalette.neutral_100,
                      fontWeight: FontWeight.w700),
                ),
                submittedPinTheme: const PinTheme(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                              width: 2, color: ColorPalette.neutral_100))),
                  width: 70,
                  height: 70,
                  textStyle: TextStyle(
                      fontSize: 20.0,
                      color: ColorPalette.neutral_100,
                      fontWeight: FontWeight.w700),
                ),
                followingPinTheme: const PinTheme(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                              width: 2, color: ColorPalette.neutral_40))),
                  textStyle: TextStyle(
                      fontSize: 20.0,
                      color: ColorPalette.neutral_100,
                      fontWeight: FontWeight.w700),
                  width: 70,
                  height: 70,
                ),
                defaultPinTheme: const PinTheme(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                              width: 2, color: ColorPalette.neutral_40))),
                  width: 70,
                  height: 70,
                  textStyle: TextStyle(
                      fontSize: 20.0,
                      color: ColorPalette.neutral_100,
                      fontWeight: FontWeight.w700),
                ),
                pinAnimationType: PinAnimationType.scale,
                onTap: () {
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 32,
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  style: const TextStyle(
                      fontSize: 14, fontFamily: 'PlusJakartaSans'),
                  children: <TextSpan>[
                    const TextSpan(
                      text:
                          'Masukkan 4 digit angka yang telah kami kirimkan ke email ',
                      style: TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.5),
                    ),
                    TextSpan(
                      text: '${widget.email}',
                      style: const TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Tidak menerima kode ?',
                style: TextStyle(
                  color: ColorPalette.neutral_70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              !_isLoading
                  ? const LoadingWidget()
                  : _start == 0
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              _isLoading = false;
                            });

                            /// Fungsi ini bertujuan untuk mengirim ulang
                            /// `otp` yang sudah kadaluarsa dengan yang baru.
                            authForgot
                                .forgotPasswordResendOTP(widget.email!)
                                .then((value) {
                              if (value['status'] == 1) {
                                setState(() {
                                  _start = 60;
                                  startTimer();
                                  _isLoading = true;
                                });
                              } else {
                                setState(() {
                                  _isLoading = true;
                                });
                                flushbarError(value['message']['title'])
                                    .show(context);
                              }
                            }).catchError((onError) {
                              setState(() {
                                _isLoading = true;
                              });
                              flushbarError(onError is String
                                      ? onError
                                      : onError['message']['title'])
                                  .show(context);
                            });
                          },
                          child: const Text(
                            'Kirim Ulang',
                            style: TextStyle(
                                color: ColorPalette.mainColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      : Text(
                          _start == 60 ? '1 Menit' : '$_start Detik',
                          style: const TextStyle(
                            color: ColorPalette.neutral_90,
                            fontSize: 14,
                          ),
                        ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Atau cek folder spam',
                style: TextStyle(
                  color: ColorPalette.neutral_70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ));
  }
}
