import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isilahtitiktitik/bloc/username-check-bloc/username_check_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/user.dart';
import 'package:isilahtitiktitik/model/username_check.dart';
import 'package:isilahtitiktitik/resource/single_user_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/utils/content_view.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:isilahtitiktitik/view/page-auth/page-login/page_login_by_email.dart';
import 'package:isilahtitiktitik/view/page-intro/page_onboarding.dart';
import 'package:isilahtitiktitik/view/page-profile/page_change_email.dart';
import 'package:isilahtitiktitik/view/widgets/button_loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/delete_account_state_widget.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/input_decoration_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/success_state_widget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({Key? key}) : super(key: key);

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  UsernameCheckBloc usernameCheckBloc = UsernameCheckBloc();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = true;
  bool isConnect = false;
  bool _isLoadingChangeUsername = true;

  TextEditingController textEditingUsername = TextEditingController();
  TextEditingController textEditingEmail = TextEditingController();

  @override
  void initState() {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    refreshCheck(context);
    textEditingUsername =
        TextEditingController(text: auth.currentUser!.data!.user!.username);
    textEditingEmail =
        TextEditingController(text: auth.currentUser!.data!.user!.email ?? "");
    _checkLinkConnect();
    super.initState();
  }

  void refreshCheck(BuildContext context) {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    usernameCheckBloc.add(GetUsernameCheck(http: chttp));
  }

  void _checkLinkConnect() {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    if (auth.currentUser!.data!.user!.googleLink == 0) {
      setState(() {
        isConnect = false;
      });
    } else {
      setState(() {
        isConnect = true;
      });
    }
  }

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
    setState(() {
      _isLoading = false;
    });
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

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  @override
  void dispose() {
    usernameCheckBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    CHttp chttp = Provider.of(context, listen: false);

    Auth authLink = chttp.auth!;
    auth.isLoggedIn().then((value) {
      if (!value!) {
        auth.logout();
        if (Platform.isIOS) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const OnBoardingPage(),
              ),
              (route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const LoginByEmailPage(),
              ),
              (route) => false);
        }
      }
    });
    return BlocProvider<UsernameCheckBloc>(
      create: (context) => usernameCheckBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
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
            'Pengaturan',
            style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: bodyMedium,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
        ),
        body: auth.currentUser == null
            ? Container()
            : SingleChildScrollView(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Platform.isIOS
                        ? Container()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                'Terhubung dengan',
                                style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: bodyMedium,
                                    color: ColorPalette.neutral_90,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 8, top: 8, bottom: 8),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade200),
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/logo/ic_google.png',
                                      width: 24,
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    const Expanded(
                                      child: Text(
                                        'Google',
                                        style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: bodyMedium,
                                            color: ColorPalette.neutral_90,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Switch(
                                      value: isConnect,
                                      onChanged: (value) async {
                                        if (value) {
                                          final user =
                                              await _googleSignIn.signIn();

                                          if (user != null) {
                                            authLink
                                                .linkWithGoogle(
                                                    user.email,
                                                    user.id,
                                                    generateMd5(
                                                        "GIS;${user.email};${user.id}"))
                                                .then((value) {
                                              if (value!.status == 1) {
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
                                                setState(() {
                                                  isConnect = true;
                                                });
                                                _writeUserData(value);
                                              } else {
                                                flushbarError(
                                                        value.message!.title!)
                                                    .show(context);
                                                setState(() {
                                                  isConnect = false;
                                                });
                                              }
                                            }).catchError((onError) {
                                              flushbarError(onError is String
                                                      ? onError
                                                      : onError['message']
                                                          ['title'])
                                                  .show(context);
                                              setState(() {
                                                isConnect = false;
                                              });
                                            });
                                          }
                                        } else {
                                          authLink.unlinkGoogle().then((value) {
                                            setState(() {
                                              isConnect = false;
                                            });
                                            Flushbar(
                                              message: value!.message!.title,
                                              margin: const EdgeInsets.all(16),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              duration:
                                                  const Duration(seconds: 2),
                                              messageSize: 12,
                                              backgroundColor:
                                                  ColorPalette.greenColor,
                                            ).show(context);
                                          }).catchError((onError) {
                                            setState(() {
                                              isConnect = true;
                                            });
                                            flushbarError(onError is String
                                                    ? onError
                                                    : onError['message']
                                                        ['title'])
                                                .show(context);
                                          });
                                        }
                                      },
                                      activeTrackColor: ColorPalette.lineSwitch
                                          .withOpacity(0.5),
                                      activeColor: ColorPalette.mainColor,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Akun & Keamanan',
                      style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: bodyMedium,
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'ID ${auth.currentUser!.data!.user!.id!}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, color: ColorPalette.neutral_70),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/edit-profile');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Ubah Profil',
                                style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: bodyMedium,
                                    color: ColorPalette.neutral_90,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: ColorPalette.neutral_90,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/change-password');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Ganti Password',
                                style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: bodyMedium,
                                    color: ColorPalette.neutral_90,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: ColorPalette.neutral_90,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        _changeUsername();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Ganti Username',
                                style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: bodyMedium,
                                    color: ColorPalette.neutral_90,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: ColorPalette.neutral_90,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return Container(
                                    padding: const EdgeInsets.all(16),
                                    height: MediaQuery.of(context).size.height *
                                        (MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom ==
                                                0.0
                                            ? 0.3
                                            : 0.65),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12))),
                                    child: Center(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                          Center(
                                            child: Container(
                                              height: 5,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  color:
                                                      ColorPalette.neutral_30),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            auth.currentUser!.data!.user!
                                                            .email ==
                                                        null ||
                                                    auth.currentUser!.data!
                                                        .user!.email!.isEmpty
                                                ? 'Tambah Email'
                                                : 'Ganti Email',
                                            style: const TextStyle(
                                                fontFamily: 'PlusJakartaSans',
                                                fontSize: bodyLarge,
                                                color: ColorPalette.neutral_90,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                controller: textEditingEmail,
                                                cursorColor:
                                                    ColorPalette.mainColor,
                                                onChanged: (value) {
                                                  setState(() {});
                                                },
                                                style: const TextStyle(
                                                  color:
                                                      ColorPalette.neutral_90,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: bodyMedium,
                                                ),
                                                decoration: inputDecoration(
                                                    'Masukan Email Baru'),
                                                keyboardType:
                                                    TextInputType.text),
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (textEditingEmail
                                                  .text.isNotEmpty) {
                                                Navigator.pop(context);
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return ChangeEmailPage(
                                                      email: textEditingEmail
                                                          .text);
                                                }));
                                              } else {
                                                flushbarError(
                                                        'Email tidak boleh kosong')
                                                    .show(context);
                                              }
                                            },
                                            child: Container(
                                              height: 55,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: textEditingEmail
                                                              .text ==
                                                          ''
                                                      ? ColorPalette.neutral_50
                                                      : ColorPalette.mainColor),
                                              child: const Center(
                                                child: Text(
                                                  'Selanjutnya',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                          )
                                        ])));
                              });
                            });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                auth.currentUser!.data!.user!.email == null ||
                                        auth.currentUser!.data!.user!.email!
                                            .isEmpty
                                    ? 'Tambah Email'
                                    : 'Ganti Email',
                                style: const TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: bodyMedium,
                                    color: ColorPalette.neutral_90,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: ColorPalette.neutral_90,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  height: 200,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12))),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 5,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              color: ColorPalette.neutral_30),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Hapus Akun',
                                              style: TextStyle(
                                                  fontFamily: 'PlusJakartaSans',
                                                  fontSize: bodyLarge,
                                                  color:
                                                      ColorPalette.neutral_90,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          'Yakin mau hapus akun?',
                                          style: TextStyle(
                                              fontFamily: 'PlusJakartaSans',
                                              fontSize: bodyMedium,
                                              color: ColorPalette.neutral_70,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          // mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.3,
                                                padding:
                                                    const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFFCDDEA),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: const Center(
                                                    child: Text('Batal',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'PlusJakartaSans',
                                                            fontSize: bodySmall,
                                                            color: Color(
                                                                0xFFEF5696),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600))),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();

                                                authLink
                                                    .deleteAccount()
                                                    .then((delete) {
                                                  if (delete['status'] == 1) {
                                                    prefs.setString(
                                                        'deleteRequestAt',
                                                        delete['data'][
                                                                'delete_request_at'] ??
                                                            "");
                                                    prefs.setString(
                                                        'deletedAt',
                                                        delete['data'][
                                                                'deleted_at'] ??
                                                            "");
                                                    prefs.setInt(
                                                        'status',
                                                        delete['data']['user']
                                                                    ['user']
                                                                ['status'] ??
                                                            "");
                                                    Navigator.pop(context);
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return const DeleteAccountStateWidget(
                                                        navigasi: true,
                                                      );
                                                    }));

                                                    Flushbar(
                                                      message: delete['message']
                                                          ['title'],
                                                      margin:
                                                          const EdgeInsets.all(
                                                              16),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      duration: const Duration(
                                                          seconds: 2),
                                                      messageSize: 12,
                                                      backgroundColor:
                                                          ColorPalette
                                                              .greenColor,
                                                    ).show(context);
                                                  } else {
                                                    flushbarError(
                                                            delete['message']
                                                                ['title'])
                                                        .show(context);
                                                  }
                                                }).catchError((onError) {
                                                  flushbarError(onError
                                                              is String
                                                          ? onError
                                                          : onError['message']
                                                              ['title'])
                                                      .show(context);
                                                });
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.3,
                                                padding:
                                                    const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFEF5696),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: const Center(
                                                    child: Text(
                                                  'Yakin',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'PlusJakartaSans',
                                                      fontSize: bodySmall,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade200),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Hapus Akun',
                                    style: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: bodyMedium,
                                        color: ColorPalette.neutral_90,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: ColorPalette.neutral_90,
                                  size: 16,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Tentang',
                      style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: bodyMedium,
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w600),
                    ),
                    auth.currentUser!.data!.user!.id == 11
                        ? Container()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return MyWebview(
                                      url: auth.currentUser!.data!.user!.id ==
                                              11
                                          ? 'https://isilah.com/myprivacy-policy'
                                          : 'https://isilah.com/myterms-conditions',
                                    );
                                  }));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade200),
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Syarat dan Ketentuan',
                                          style: TextStyle(
                                              fontFamily: 'PlusJakartaSans',
                                              fontSize: bodyMedium,
                                              color: ColorPalette.neutral_90,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: ColorPalette.neutral_90,
                                        size: 16,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MyWebview(
                            url: Platform.isIOS
                                ? 'https://isilah.com/myprivacy-policy'
                                : 'https://isilah.com/privacy-policy',
                          );
                        }));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Kebijakan Privasi',
                                style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: bodyMedium,
                                    color: ColorPalette.neutral_90,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: ColorPalette.neutral_90,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              height: 200,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12))),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 5,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          color: ColorPalette.neutral_30),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Keluar Dari Aplikasi',
                                          style: TextStyle(
                                              fontFamily: 'PlusJakartaSans',
                                              fontSize: bodyLarge,
                                              color: ColorPalette.neutral_90,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      'Yakin mau keluar dari aplikasi?',
                                      style: TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          fontSize: bodyMedium,
                                          color: ColorPalette.neutral_70,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.3,
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                                color: const Color(0xFFFCDDEA),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: const Center(
                                                child: Text('Batal',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'PlusJakartaSans',
                                                        fontSize: bodySmall,
                                                        color:
                                                            Color(0xFFEF5696),
                                                        fontWeight:
                                                            FontWeight.w600))),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _whenLogout();
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.3,
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                                color: const Color(0xFFEF5696),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: const Center(
                                                child: Text(
                                              'Yakin',
                                              style: TextStyle(
                                                  fontFamily: 'PlusJakartaSans',
                                                  fontSize: bodySmall,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        height: 55,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _isLoading
                              ? const Text(
                                  'Keluar Dari Aplikasi',
                                  style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: bodyMedium,
                                      color: ColorPalette.neutral_90,
                                      fontWeight: FontWeight.w400),
                                )
                              : const ButtonLoadingWidget(
                                  color: ColorPalette.neutral_90),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                )),
      ),
    );
  }

  Widget _buildUsernameCheck() {
    return BlocBuilder<UsernameCheckBloc, UsernameCheckState>(
      builder: (context, state) {
        if (state is UsernameCheckInitial) {
          return const LoadingWidget();
        } else if (state is UsernameCheckLoading) {
          return const LoadingWidget();
        } else if (state is UsernameCheckLoaded) {
          return _buildView(context, state.usernameCheckModel!);
        } else if (state is UsernameCheckError) {
          return _buildError(state.message);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Ups!',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 16,
                color: ColorPalette.neutral_90,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                color: ColorPalette.neutral_70,
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 24,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 120,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: ColorPalette.mainColor,
                  borderRadius: BorderRadius.circular(8)),
              child: const Text(
                'Kembali',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildView(
      BuildContext context, UsernameCheckModel usernameCheckModel) {
    CHttp chttp = Provider.of(context, listen: false);
    SingleUserApi singleUserApi = SingleUserApi(http: chttp);
    return StatefulBuilder(builder: (_, setState) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: ColorPalette.neutral_30),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Ganti Username',
                  style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: bodyLarge,
                      color: ColorPalette.neutral_90,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: textEditingUsername,
                    cursorColor: ColorPalette.mainColor,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: const TextStyle(
                      color: ColorPalette.neutral_90,
                      fontWeight: FontWeight.w400,
                      fontSize: bodyMedium,
                    ),
                    decoration: inputDecoration('Masukan Username'),
                    keyboardType: TextInputType.text),
                usernameCheckModel.data!.statusAvailableAt != 0
                    ? Container()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 14, fontFamily: 'PlusJakartaSans'),
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Username kamu dapat diganti dalam',
                                  style: TextStyle(
                                    color: ColorPalette.neutral_70,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      ' ${usernameCheckModel.data!.changeUsernameDuration!} hari lagi',
                                  style: const TextStyle(
                                    color: ColorPalette.neutral_90,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Kamu hanya dapat mengganti username kamu tanpa biaya selama 1 kali, setelahnya kamu dikenakan biaya ${IsilahHelper.formatCurrencyWithoutSymbol(double.parse(usernameCheckModel.data!.changeUsernameCost!.toString()))} star untuk mengganti username kamu',
                  style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: bodyMedium,
                      color: ColorPalette.neutral_70,
                      fontWeight: FontWeight.w400),
                ),
              ],
            )),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                if (textEditingUsername.text.isEmpty) {
                  flushbarError('Username tidak boleh kosong').show(context);
                } else {
                  if (usernameCheckModel.data!.statusAvailableAt != 0) {
                    setState(() {
                      _isLoadingChangeUsername = false;
                    });
                    singleUserApi
                        .postUpdateUsername(textEditingUsername.text)
                        .then((value) {
                      setState(() {
                        _isLoadingChangeUsername = true;
                      });
                      if (value['status'] == 0) {
                        flushbarError(value['message']['title'] ??
                                'Terjadi kesalahan silahkan coba lagi')
                            .show(context);
                      } else {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SuccessStateWidget(
                              assets: 'assets/image/img_verify_success.png',
                              title: 'Username diubah',
                              content:
                                  'Selamat username kamu berhasil di rubah');
                        }));
                      }
                    }).catchError((onError) {
                      setState(() {
                        _isLoadingChangeUsername = true;
                      });
                      flushbarError(onError is String
                              ? onError
                              : onError['message']['title'])
                          .show(context);
                    });
                  } else {
                    Navigator.pop(context);
                  }
                }
              },
              child: Container(
                height: 55,
                padding: const EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: textEditingUsername.text == '' ||
                            usernameCheckModel.data!.statusAvailableAt == 0
                        ? ColorPalette.neutral_50
                        : ColorPalette.mainColor),
                child: _isLoadingChangeUsername
                    ? Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icon/ic_star_single.png',
                                  width: 14,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  usernameCheckModel.data!.changeUsernameCost ==
                                          "0"
                                      ? 'Gratis'
                                      : IsilahHelper
                                          .formatCurrencyWithoutSymbol(
                                              double.parse(usernameCheckModel
                                                  .data!.changeUsernameCost!
                                                  .toString())),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          usernameCheckModel.data!.statusAvailableAt != 0
                              ? const Text(
                                  'Ganti',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              : Container(),
                        ],
                      )
                    : const ButtonLoadingWidget(color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
            )
          ]);
    });
  }

  void _changeUsername() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) {
          return BlocProvider<UsernameCheckBloc>(
            create: (context) => usernameCheckBloc,
            child: Container(
                padding: const EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height *
                    (MediaQuery.of(context).viewInsets.bottom == 0.0
                        ? 0.45
                        : 0.8),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12))),
                child: Center(child: _buildUsernameCheck())),
          );
        });
  }

  void _writeUserData(User currentUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("visited", false);
    if (currentUser.data != null) {
      prefs.setString("token", currentUser.data!.token!);
      prefs.setInt("id", currentUser.data!.user!.id!);
      prefs.setString("refferalCode", currentUser.data!.user!.refferalCode!);
      prefs.setString("username", currentUser.data!.user!.username!);
      prefs.setString("email", currentUser.data!.user!.email ?? "");
      prefs.setInt("point", currentUser.data!.user!.point!);
      prefs.setInt("rankPoint", currentUser.data!.user!.rankPoint!);
      prefs.setInt("rankPointStatus", currentUser.data!.user!.rankPointStatus!);
      prefs.setInt("experience", currentUser.data!.user!.experience!);
      prefs.setInt("rankExperience", currentUser.data!.user!.rankExperience!);
      prefs.setInt("rankExperienceStatus",
          currentUser.data!.user!.rankExperienceStatus!);
      prefs.setInt("experienceFrom", currentUser.data!.user!.experienceFrom!);
      prefs.setInt("experienceTo", currentUser.data!.user!.experienceTo!);
      prefs.setInt("experiencePercentage",
          currentUser.data!.user!.experiencePercentage!);
      prefs.setString("level", currentUser.data!.user!.level!);
      prefs.setString("levelLogo", currentUser.data!.user!.levelLogo!);
      prefs.setString(
          "photo",
          currentUser.data!.user!.photo == null
              ? ""
              : currentUser.data!.user!.photo!);
      prefs.setString("fullName", currentUser.data!.user!.fullName!);
      prefs.setString(
          "birthdate",
          currentUser.data!.user!.birthdate == null
              ? ""
              : currentUser.data!.user!.birthdate!);
      prefs.setString(
          "gender",
          currentUser.data!.user!.gender == null
              ? ""
              : currentUser.data!.user!.gender!);
      prefs.setString(
          "phone",
          currentUser.data!.user!.phone == null
              ? ""
              : currentUser.data!.user!.phone!);
      prefs.setString(
          "address",
          currentUser.data!.user!.address == null
              ? ""
              : currentUser.data!.user!.address!);
      prefs.setInt(
          "urbanVillageId",
          currentUser.data!.user!.urbanVillageId == null
              ? 0
              : currentUser.data!.user!.urbanVillageId!);
      prefs.setString(
          "urbanVillage",
          currentUser.data!.user!.urbanVillage == null
              ? ""
              : currentUser.data!.user!.urbanVillage!);
      prefs.setInt(
          "subdistrictId",
          currentUser.data!.user!.subdistrictId == null
              ? 0
              : currentUser.data!.user!.subdistrictId!);
      prefs.setString(
          "subdistrict",
          currentUser.data!.user!.subdistrict == null
              ? ""
              : currentUser.data!.user!.subdistrict!);
      prefs.setInt(
          "regencyId",
          currentUser.data!.user!.regencyId == null
              ? 0
              : currentUser.data!.user!.regencyId!);
      prefs.setString(
          "regency",
          currentUser.data!.user!.regency == null
              ? ""
              : currentUser.data!.user!.regency!);
      prefs.setInt(
          "provinceId",
          currentUser.data!.user!.provinceId == null
              ? 0
              : currentUser.data!.user!.provinceId!);
      prefs.setString(
          "province",
          currentUser.data!.user!.province == null
              ? ""
              : currentUser.data!.user!.province!);
      prefs.setString(
          "postalCode",
          currentUser.data!.user!.postalCode == null
              ? ""
              : currentUser.data!.user!.postalCode!);
      prefs.setInt("professionId", currentUser.data!.user!.professionId!);
      prefs.setString(
          "profession",
          currentUser.data!.user!.profession == null
              ? ""
              : currentUser.data!.user!.profession!);
      prefs.setString(
          "bio",
          currentUser.data!.user!.bio == null
              ? ""
              : currentUser.data!.user!.bio!);
      prefs.setString(
          "socmedFb",
          currentUser.data!.user!.socmedFb == null
              ? ""
              : currentUser.data!.user!.socmedFb!);
      prefs.setString(
          "socmedIg",
          currentUser.data!.user!.socmedIg == null
              ? ""
              : currentUser.data!.user!.socmedIg!);
      prefs.setString(
          "socmedTw",
          currentUser.data!.user!.socmedTw == null
              ? ""
              : currentUser.data!.user!.socmedTw!);
      prefs.setInt(
          "friendshipRequest",
          currentUser.data!.user!.friendshipRequest == null
              ? 0
              : currentUser.data!.user!.friendshipRequest!);
      prefs.setString(
          "deviceToken",
          currentUser.data!.user!.deviceToken == null
              ? ""
              : currentUser.data!.user!.deviceToken!);
      prefs.setInt(
          "googleLink",
          currentUser.data!.user!.googleLink == null
              ? 0
              : currentUser.data!.user!.googleLink!);
      prefs.setInt(
          "appleLink",
          currentUser.data!.user!.appleLink == null
              ? 0
              : currentUser.data!.user!.appleLink!);
      prefs.setInt(
          "shipmentDefaultId",
          currentUser.data!.user!.shipmentDefaultId == null
              ? 0
              : currentUser.data!.user!.shipmentDefaultId!);
      prefs.setInt(
          "notificationUnread",
          currentUser.data!.user!.notificationUnread == null
              ? 0
              : currentUser.data!.user!.notificationUnread!);
      prefs.setInt(
          "prizeWinTotal",
          currentUser.data!.user!.prizeWinTotal == null
              ? 0
              : currentUser.data!.user!.prizeWinTotal!);
      prefs.setString(
          "deleteRequestAt",
          currentUser.data!.user!.deleteRequestAt == null
              ? ""
              : currentUser.data!.user!.deleteRequestAt!);
      prefs.setString(
          "deletedAt",
          currentUser.data!.user!.deletedAt == null
              ? ""
              : currentUser.data!.user!.deletedAt!);
      prefs.setInt(
          "status",
          currentUser.data!.user!.status == null
              ? 0
              : currentUser.data!.user!.status!);
    }
  }
}
