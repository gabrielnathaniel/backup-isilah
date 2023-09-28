import 'package:flutter/material.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/widgets/button_loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/success_state_widget.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final formKey = GlobalKey<FormState>();

  final textEditingNewPassword = TextEditingController();
  final textEditingOldPassword = TextEditingController();
  final textEditingConfirmPassword = TextEditingController();

  bool _isLoading = true;
  bool _isHideOldPassword = true;
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

  void toggleOldPasswordVisibility() {
    setState(() {
      _isHideOldPassword = !_isHideOldPassword;
    });
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
    CHttp chttp = Provider.of(context, listen: false);
    Auth authChange = chttp.auth!;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
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
          'Ganti Password',
          style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: bodyMedium,
              color: Colors.white,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          fontSize: 14, fontFamily: 'PlusJakartaSans'),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Password Lama',
                          style: TextStyle(
                            color: ColorPalette.neutral_90,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: ColorPalette.mainColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: textEditingOldPassword,
                    cursorColor: ColorPalette.mainColor,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: bodyMedium,
                        color: ColorPalette.neutral_90,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Masukan Password Lama',
                      contentPadding: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 8, top: 8),
                      hintStyle: const TextStyle(
                          color: ColorPalette.neutral_50, fontSize: 14),
                      suffixIcon: _isHideOldPassword
                          ? IconButton(
                              icon: Image.asset(
                                'assets/icon/ic_eyeof.png',
                                width: 24.0,
                                height: 24.0,
                              ),
                              onPressed: () {
                                toggleOldPasswordVisibility();
                              },
                            )
                          : IconButton(
                              icon: Image.asset(
                                'assets/icon/ic_eyeon.png',
                                width: 24.0,
                                height: 24.0,
                              ),
                              onPressed: () {
                                toggleOldPasswordVisibility();
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
                          borderSide:
                              const BorderSide(color: ColorPalette.mainColor)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Password lama tidak boleh kosong";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    obscureText: _isHideOldPassword,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          fontSize: 14, fontFamily: 'PlusJakartaSans'),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Password Baru',
                          style: TextStyle(
                            color: ColorPalette.neutral_90,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: ColorPalette.mainColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
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
                        fontFamily: 'PlusJakartaSans',
                        fontSize: bodyMedium,
                        color: ColorPalette.neutral_90,
                        fontWeight: FontWeight.w500),
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
                          borderSide:
                              const BorderSide(color: ColorPalette.mainColor)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Password baru tidak boleh kosong";
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
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          fontSize: 14, fontFamily: 'PlusJakartaSans'),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Konfirmasi Password',
                          style: TextStyle(
                            color: ColorPalette.neutral_90,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: ColorPalette.mainColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
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
                        fontFamily: 'PlusJakartaSans',
                        fontSize: bodyMedium,
                        color: ColorPalette.neutral_90,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Masukan Password Anda',
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
                          borderSide:
                              const BorderSide(color: ColorPalette.mainColor)),
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
                  authChange
                      .changePassword(
                    textEditingOldPassword.text,
                    textEditingNewPassword.text,
                    textEditingConfirmPassword.text,
                  )
                      .then((value) {
                    if (value.status == 1) {
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
                            textEditingOldPassword.text.isEmpty ||
                            textEditingConfirmPassword.text.isEmpty
                        ? ColorPalette.neutral_50
                        : ColorPalette.mainColor),
                child: Center(
                  child: _isLoading
                      ? const Text(
                          'Simpan',
                          style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        )
                      : const ButtonLoadingWidget(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
