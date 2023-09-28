import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/post_register_by_google.dart';
import 'package:isilahtitiktitik/resource/helper_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/web/utils/auth_web.dart';
import 'package:isilahtitiktitik/web/view/page-auth/page_login_by_email_web.dart';
import 'package:isilahtitiktitik/view/page-auth/page-register/page_register_by_google.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:isilahtitiktitik/web/view/page-auth/page_register_web.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginWebPage extends StatefulWidget {
  const LoginWebPage({Key? key}) : super(key: key);

  @override
  State<LoginWebPage> createState() => _LoginWebPageState();
}

class _LoginWebPageState extends State<LoginWebPage> {
  bool isLoading = true;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  PostRegisterByGoogle? postRegisterByGoogle;

  Future<void> _initPackageInfo() async {
    PackageInfo.fromPlatform().then((info) {
      _checkUpdateVersion(info.version);
    });
  }

  Future<void> _handleSignIn() async {
    BaseAuthWeb auth = Provider.of<AuthWeb>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final user = await _googleSignIn.signIn();

      if (user != null) {
        setState(() {
          isLoading = false;
        });
        auth
            .loginWithGoogle(
                user.email, generateMd5("GIS;${user.email};${user.id}"))
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

  void _checkUpdateVersion(String versi) async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    HelperApi helperApi = HelperApi(http: chttp);
    helperApi.fetchVersion(versi, "2").then((checkUpdate) {
      if (checkUpdate.status == 1) {
        if (checkUpdate.data!.status == -2) {
          _alertCheckUpdate(checkUpdate.message!.title!,
              checkUpdate.data!.status!, checkUpdate.data!.link!);
        }
        if (checkUpdate.data!.status == -1) {
          _alertCheckUpdate(checkUpdate.message!.title!,
              checkUpdate.data!.status!, checkUpdate.data!.link!);
        }
        if (checkUpdate.data!.status == 0) {
          _alertCheckUpdate(checkUpdate.message!.title!,
              checkUpdate.data!.status!, checkUpdate.data!.link!);
        }
      } else {}
    }).catchError((onError) {});
  }

  void _alertCheckUpdate(String title, int status, String link) {
    showDialog(
        context: context,
        barrierDismissible: status < 0 ? false : true,
        builder: (cn) {
          return WillPopScope(
            onWillPop: () async {
              if (status < 0) {
                Navigator.pop(cn);
                SystemNavigator.pop();
              } else {
                Navigator.pop(cn);
              }

              return true;
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Perhatian",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: titleLarge,
                        color: ColorPalette.neutral_90,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: bodyMedium,
                        color: ColorPalette.neutral_90,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  status < 0
                      ? GestureDetector(
                          onTap: () {
                            if (status == -1) {
                              _launchInBrowser(Uri.parse(link));
                            } else {
                              Navigator.pop(cn);
                              SystemNavigator.pop();
                            }
                          },
                          child: Center(
                            child: Text(
                              status == -1 ? 'Update' : 'Tutup',
                              style: const TextStyle(
                                  fontSize: bodyMedium,
                                  color: ColorPalette.mainColor,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(cn);
                                },
                                child: const Center(
                                  child: Text(
                                    'Lain Kali',
                                    style: TextStyle(
                                        fontSize: bodyMedium,
                                        color: ColorPalette.colorTextThree,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _launchInBrowser(Uri.parse(link));
                                  Navigator.pop(cn);
                                },
                                child: const Center(
                                  child: Text(
                                    'Update',
                                    style: TextStyle(
                                        fontSize: bodyMedium,
                                        color: ColorPalette.mainColor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    _initPackageInfo();
    super.initState();
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
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Flexible(
                      child: SizedBox(
                        height: 105,
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        'assets/logo/logo_isilah.png',
                        width: 171,
                      ),
                    ),
                    const SizedBox(
                      height: 23,
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
                      height: 88,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterWebPage()));
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: ColorPalette.greenColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ColorPalette.mainColor,
                              width: 2,
                            ),
                          ),
                          child: const Text(
                            'Daftar',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )),
                    Column(
                      children: [
                        const SizedBox(
                          height: 23,
                        ),
                        const Text(
                          'Atau',
                          style: TextStyle(
                            color: ColorPalette.neutral_90,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                      height: 24,
                    ),
                    Flexible(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Sudah punya akun? ',
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
                                                const LoginByEmailWebPage()));
                                  },
                                text: 'Masuk',
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
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              )
            : const LoadingWidget(),
      ),
    );
  }
}
