import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/post_register.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/success_state_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

/// Page ini bertujuan untuk memvalidasi registrasi akun, yang mana user wajib menginput Kode OTP
/// yang dikirim melalui `email` yang di registrasi di page sebelumnya.
/// Apabila user mengisi kode OTP dengan benar dan response status success maka semua
/// data yang diisi akan disimpan ke dalam `database` melalui API dan user sudah bisa
/// menggunakan Aplikasi.
///
/// Kode OTP memiliki batas waktu hingga `60 Detik`, jika sudah melewati batas waktu yang ditentukan
/// kode OTP akan kadaluarsa dan user wajib mengirim kembali kode OTP baru.
class VerifyOTPRegisterPage extends StatefulWidget {
  /// Data inputan user dari page [RegisterLastPage].
  final PostRegister? postRegister;
  const VerifyOTPRegisterPage({Key? key, @required this.postRegister})
      : super(key: key);

  @override
  State<VerifyOTPRegisterPage> createState() => _VerifyOTPRegisterPageState();
}

class _VerifyOTPRegisterPageState extends State<VerifyOTPRegisterPage> {
  final _pinPutController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isLoading = true;

  Timer? _timer;

  /// batas waktu untuk kode OTP selama `60 detik`
  int _start = 60;

  /// Fungsi ini untuk menginisialisasi `timer` dimana variable `_start` akan berkurang
  /// nilainya setiap `1 detik` hingga ke detik `0`
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
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    Auth auth = chttp.auth!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: ColorPalette.neutral_90),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                  auth
                      .postRegisterVerifyOTP(
                          widget.postRegister!.email!, _pinPutController.text)
                      .then((value) {
                    if (value['status'] == 1) {
                      /// Proses pengiriman semua data yang di input user ke API
                      /// yang nantinya akan disimpan ke dalam `database`.
                      auth
                          .postRegisterFinishing(
                              widget.postRegister!.kodeReferral!,
                              widget.postRegister!.username!,
                              widget.postRegister!.fullName!,
                              widget.postRegister!.gender!,
                              widget.postRegister!.birthdate!,
                              widget.postRegister!.address!,
                              widget.postRegister!.provinceId!,
                              widget.postRegister!.regencyId!,
                              widget.postRegister!.subdistrictId!,
                              widget.postRegister!.urbanVillageId!,
                              "",
                              widget.postRegister!.professionId!,
                              widget.postRegister!.facebook!,
                              widget.postRegister!.instagram!,
                              widget.postRegister!.twitter!,
                              widget.postRegister!.phone!,
                              widget.postRegister!.email!,
                              widget.postRegister!.password!,
                              widget.postRegister!.confirmPassword!,
                              widget.postRegister!.photo!,
                              _pinPutController.text)
                          .then((value) {
                        if (value!.status == 1) {
                          setState(() {
                            _isLoading = true;
                            basket['address'] = null;
                            basket['postalCode'] = null;
                            basket['idProfesi'] = null;
                            basket['idProvince'] = null;
                            basket['idCity'] = null;
                            basket['idSubdistrict'] = null;
                            basket['idUrbanVillage'] = null;
                          });
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const SuccessStateWidget(
                                assets: 'assets/image/img_verify_success.png',
                                title: 'Verifikasi Berhasil',
                                content:
                                    'Selamat akun kamu sudah berhasil di buat.');
                          }));
                        } else {
                          setState(() {
                            _isLoading = true;
                          });
                          flushbarError(value.message!.title!).show(context);
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
                    text: '${widget.postRegister!.email}',
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

                          /// Proses untuk mengirim ulang kode OTP.
                          auth
                              .postRegisterResendOTP(
                                  widget.postRegister!.email!)
                              .then((value) {
                            if (value['status'] == 1) {
                              setState(() {
                                _pinPutController.text = '';
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
            SizedBox(
              height: Platform.isIOS ? 8 : 0,
            ),
          ],
        ),
      ),
    );
  }
}
