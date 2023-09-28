import 'package:flutter/material.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-auth/page-login/page_login_by_email.dart';
import 'package:isilahtitiktitik/view/widgets/button_loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/success_state_widget.dart';
import 'package:provider/provider.dart';

/// Page ini untuk membuat `password` baru. User dapat mengisi `password` baru
/// sesuai ketentuan dan harus mengkonfirmasi `password` tersebut. Selanjutnya
/// `password` tersebut dikirim dan disimpan ke dalam `Database` melalui [API].
class FinishingPasswordPage extends StatefulWidget {
  final String? email;
  final String? otp;
  const FinishingPasswordPage(
      {Key? key, @required this.email, @required this.otp})
      : super(key: key);

  @override
  State<FinishingPasswordPage> createState() => _FinishingPasswordPageState();
}

class _FinishingPasswordPageState extends State<FinishingPasswordPage> {
  final regExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  final formKey = GlobalKey<FormState>();

  final textEditingNewPassword = TextEditingController();
  final textEditingConfirmPassword = TextEditingController();

  bool _isLoading = true;
  bool _isHideNewPassword = true;
  bool _isHideConfirmPassword = true;

  bool validates() {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void toggleNewPasswordVisibility() {
    setState(() {
      _isHideNewPassword = !_isHideNewPassword;
    });
  }

  void toggleConfirmPasswordVisibility() {
    setState(() {
      _isHideConfirmPassword = !_isHideConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    Auth auth = chttp.auth!;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const LoginByEmailPage();
        }));
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: ColorPalette.neutral_90),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reset Password',
                      style: TextStyle(
                          fontSize: 24,
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Jangan lupa ya sama password baru kamu',
                      style: TextStyle(
                        color: ColorPalette.neutral_70,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    const Text(
                      'Password Baru',
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: textEditingNewPassword,
                      cursorColor: ColorPalette.mainColor,
                      onChanged: (value) {
                        setState(() {});
                      },
                      style: const TextStyle(
                        color: ColorPalette.neutral_90,
                        fontWeight: FontWeight.w400,
                        fontSize: bodyMedium,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Masukan Password Anda',
                        contentPadding: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 8, top: 8),
                        hintStyle: const TextStyle(
                            color: ColorPalette.neutral_50, fontSize: 14),
                        suffixIcon: _isHideNewPassword
                            ? IconButton(
                                icon: Image.asset(
                                  'assets/icon/ic_eyeof.png',
                                  width: 24.0,
                                  height: 24.0,
                                ),
                                onPressed: () {
                                  toggleNewPasswordVisibility();
                                },
                              )
                            : IconButton(
                                icon: Image.asset(
                                  'assets/icon/ic_eyeon.png',
                                  width: 24.0,
                                  height: 24.0,
                                ),
                                onPressed: () {
                                  toggleNewPasswordVisibility();
                                },
                              ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: ColorPalette.neutral_40),
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
                          return "Password baru tidak boleh kosong";
                        } else if (val.length < 8) {
                          return "Password kurang dari 8 karakter";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      obscureText: _isHideNewPassword,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    FlutterPasswordStrength(
                      password: textEditingNewPassword.text,
                      backgroundColor: ColorPalette.colorFilledTextField,
                      height: 12,
                      radius: 5,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Konfirmasi Password',
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: textEditingConfirmPassword,
                      cursorColor: ColorPalette.mainColor,
                      onChanged: (value) {
                        setState(() {});
                      },
                      style: const TextStyle(
                        color: ColorPalette.neutral_90,
                        fontWeight: FontWeight.w400,
                        fontSize: bodyMedium,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Masukan Konfirmasi Password Anda',
                        contentPadding: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 8, top: 8),
                        hintStyle: const TextStyle(
                            color: ColorPalette.neutral_50, fontSize: 14),
                        suffixIcon: _isHideConfirmPassword
                            ? IconButton(
                                icon: Image.asset(
                                  'assets/icon/ic_eyeof.png',
                                  width: 24.0,
                                  height: 24.0,
                                ),
                                onPressed: () {
                                  toggleConfirmPasswordVisibility();
                                },
                              )
                            : IconButton(
                                icon: Image.asset(
                                  'assets/icon/ic_eyeon.png',
                                  width: 24.0,
                                  height: 24.0,
                                ),
                                onPressed: () {
                                  toggleConfirmPasswordVisibility();
                                },
                              ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: ColorPalette.neutral_40),
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
                          return "Konfirmasi password tidak boleh kosong";
                        } else if (val != textEditingNewPassword.text) {
                          return "Konfirmasi password tidak sesuai.";
                        } else if (val.length < 8) {
                          return "Konfirmasi Password kurang dari 8 karakter";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      obscureText: _isHideConfirmPassword,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (validates()) {
                    setState(() {
                      _isLoading = false;
                    });

                    /// Fungsi ini untuk mengirim dan menyimpan `password` baru
                    /// ke dalam `Database` melalui [API].
                    auth
                        .forgotPasswordFinishing(
                            widget.email!,
                            widget.otp!,
                            textEditingNewPassword.text,
                            textEditingConfirmPassword.text)
                        .then((value) {
                      if (value!.status == 1) {
                        setState(() {
                          _isLoading = true;
                        });
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SuccessStateWidget(
                              assets: 'assets/image/img_verify_success.png',
                              title: 'Password diubah',
                              content: 'Password telah berhasil di reset');
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
                  }
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: textEditingNewPassword.text.isEmpty ||
                              textEditingConfirmPassword.text.isEmpty
                          ? ColorPalette.neutral_50
                          : ColorPalette.mainColor),
                  child: Center(
                    child: _isLoading
                        ? const Text(
                            'Simpan',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : const ButtonLoadingWidget(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
