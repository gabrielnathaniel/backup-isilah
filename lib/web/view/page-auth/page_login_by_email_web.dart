import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/model/post_register_by_google.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-auth/page-register/page_register_by_google.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/input_decoration_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:isilahtitiktitik/web/view/page-auth/page_register_web.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginByEmailWebPage extends StatefulWidget {
  const LoginByEmailWebPage({Key? key}) : super(key: key);

  @override
  State<LoginByEmailWebPage> createState() => _LoginByEmailWebPageState();
}

class _LoginByEmailWebPageState extends State<LoginByEmailWebPage> {
  bool _isHidePassword = true;
  bool isLoading = true;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  PostRegisterByGoogle? postRegisterByGoogle;

  final textEditingEmail = TextEditingController();
  final textEditingKataSandi = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final regExp = RegExp(
      "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$");

  bool validates() {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future<void> _handleSignIn() async {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final user = await _googleSignIn.signIn();

      if (user != null) {
        setState(() {
          isLoading = false;
        });
        auth
            .loginWithGoogle(user.email, user.id,
                generateMd5("GIS;${user.email};${user.id}"))
            .then((value) {
          if (value!.status == 1) {
            setState(() {
              isLoading = true;
              prefs.setBool("withGoogle", true);
            });
            return Navigator.pushReplacementNamed(context, "/");
          } else {
            setState(() {
              isLoading = true;
              postRegisterByGoogle = PostRegisterByGoogle(
                  kodeReferral: "",
                  birthdate: "",
                  address: "",
                  city: "",
                  professionId: 0,
                  postalCode: '',
                  phone: "",
                  photo: null,
                  email: user.email,
                  fullName: user.displayName,
                  gender: "",
                  googleId: user.id,
                  token: generateMd5("GIS;${user.email};${user.id}"));
            });
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return RegisterByGooglePage(
                  postRegisterByGoogle: postRegisterByGoogle);
            }));
          }
        }).catchError((onError) {
          setState(() {
            isLoading = true;
          });
          return flushbarError(onError['message']['title']).show(context);
        });
      }
    } catch (error) {
      Logger().d("user : $error");
      return;
    }
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  void togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

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
          return Navigator.pushReplacementNamed(context, "/");
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
        return flushbarError(onError['message']['title']).show(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Center(
                        child: Image.asset(
                          'assets/logo/logo_isilah.png',
                          width: 171,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Center(
                        child: Text(
                          '... more than a game\n... your knowledge is always matter',
                          style: TextStyle(
                            color: ColorPalette.neutral_90,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        'Email',
                        style: TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
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
                          color: ColorPalette.blackPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        decoration: inputDecoration('Masukan Email'),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Email tidak boleh kosong";
                          } else if (!regExp.hasMatch(val)) {
                            return "Format email salah";
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
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
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
                          color: ColorPalette.blackPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorPalette.colorFilledTextField,
                          hintText: 'Masukan Password',
                          contentPadding: const EdgeInsets.only(
                              left: 12, right: 12, bottom: 8, top: 8),
                          hintStyle: const TextStyle(
                              color: ColorPalette.colorHintText, fontSize: 14),
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
                                color: ColorPalette.neutral_50),
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
                            'Lupa Password',
                            style: TextStyle(
                              color: ColorPalette.colorTextSecond,
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
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
                              'Login',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          GestureDetector(
                            onTap: () {
                              _handleSignIn();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border:
                                    Border.all(color: ColorPalette.neutral_90),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/logo/ic_google.png',
                                    width: 24,
                                  ),
                                  const SizedBox(
                                    width: 17,
                                  ),
                                  const Text(
                                    'Login melalui Google',
                                    style: TextStyle(
                                      color: ColorPalette.neutral_90,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 62,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterWebPage()));
                                  },
                                text: 'Daftar',
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
