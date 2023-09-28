import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/input_decoration_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// LoginByEmailPage bertujuan memverifikasi User agar bisa masuk ke dalam Aplikasi.
/// User dapat mengisi `email` dan `password` lalu akan dikirim melalui [API].
/// Dan user juga dapat masuk melalui [Login with Google].
class LoginByEmailPage extends StatefulWidget {
  const LoginByEmailPage({Key? key}) : super(key: key);

  @override
  State<LoginByEmailPage> createState() => _LoginByEmailPageState();
}

class _LoginByEmailPageState extends State<LoginByEmailPage> {
  bool _isHidePassword = true;
  bool isLoading = true;

  final textEditingEmail = TextEditingController();
  final textEditingKataSandi = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final regExp = RegExp(
      "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$");

  /// Fungsi ini untuk memvalidasi [Form].
  bool validates() {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  /// Fungsi ini bertujuan untuk menghandle `lihat password`.
  void togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  /// Fungsi ini untuk memvalidasi apakah `email` dan `password` yang sudah di isi
  /// oleh user tersedia di dalam `database`, yang mana jika tersedia akan ke page [Root].
  void validateAndSave() async {
    if (validates()) {
      setState(() {
        isLoading = false;
      });

      BaseAuth auth = Provider.of<Auth>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      auth
          .login(textEditingEmail.text.trim(), textEditingKataSandi.text)
          .then((value) async {
        if (value!.status == 1) {
          setState(() {
            isLoading = true;
            prefs.setBool("withGoogle", false);
          });
          return Navigator.pushNamedAndRemoveUntil(
              context, '/', (route) => false);
        } else {
          setState(() {
            isLoading = true;
          });
          return flushbarError(value.message!.title!).show(context);
        }
      }).catchError((onError) {
        setState(() {
          isLoading = true;
        });
        return flushbarError(
                onError is String ? onError : onError['message']['title'])
            .show(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: ColorPalette.neutral_90),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: ColorPalette.neutral_90,
              )),
        ),
        body: isLoading
            ? Form(
                key: formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        'Masuk',
                        style: TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        'Username / Email / Nomor HP',
                        style: TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: textEditingEmail,
                        cursorColor: ColorPalette.mainColor,
                        onChanged: (value) {
                          setState(() {});
                        },
                        style: const TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                        decoration:
                            inputDecoration('Username / Email / Nomor HP Anda'),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Username / Email / Nomor HP tidak boleh kosong";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Password',
                        style: TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: textEditingKataSandi,
                        cursorColor: ColorPalette.mainColor,
                        onChanged: (value) {
                          setState(() {});
                        },
                        style: const TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Masukan Password',
                          contentPadding: const EdgeInsets.only(
                              left: 12, right: 12, bottom: 8, top: 8),
                          hintStyle: const TextStyle(
                              color: ColorPalette.neutral_50, fontSize: 14),
                          suffixIcon: _isHidePassword
                              ? IconButton(
                                  icon: Image.asset(
                                    'assets/icon/ic_eyeof.png',
                                    width: 24.0,
                                    height: 24.0,
                                  ),
                                  onPressed: () {
                                    togglePasswordVisibility();
                                  },
                                )
                              : IconButton(
                                  icon: Image.asset(
                                    'assets/icon/ic_eyeon.png',
                                    width: 24.0,
                                    height: 24.0,
                                  ),
                                  onPressed: () {
                                    togglePasswordVisibility();
                                  },
                                ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: ColorPalette.neutral_40),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(color: Colors.red)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(color: Colors.red)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                  color: ColorPalette.mainColor)),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Password tidak boleh kosong";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.text,
                        obscureText: _isHidePassword,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: const Text(
                            'Lupa Password?',
                            style: TextStyle(
                              color: ColorPalette.mainColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          validateAndSave();
                        },
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: textEditingEmail.text == '' ||
                                      textEditingKataSandi.text == ''
                                  ? ColorPalette.neutral_50
                                  : ColorPalette.mainColor),
                          child: const Center(
                            child: Text(
                              'Masuk',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                                fontFamily: 'PlusJakartaSans', fontSize: 12),
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Belum punya akun? ',
                                style: TextStyle(
                                  color: ColorPalette.neutral_90,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, '/register');
                                  },
                                text: 'Daftar Sekarang',
                                style: const TextStyle(
                                  color: ColorPalette.mainColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              )
            : const LoadingWidget(),
      ),
    );
  }
}
