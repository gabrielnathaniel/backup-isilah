import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/post_register_by_google.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-auth/page-register/page_register_by_google_foto.dart';
import 'package:isilahtitiktitik/view/widgets/button_loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/input_decoration_widget.dart';
import 'package:provider/provider.dart';

class RegisterByGoogleLastPage extends StatefulWidget {
  final PostRegisterByGoogle? postRegisterByGoogle;
  const RegisterByGoogleLastPage(
      {Key? key, @required this.postRegisterByGoogle})
      : super(key: key);

  @override
  State<RegisterByGoogleLastPage> createState() =>
      _RegisterByGoogleLastPageState();
}

class _RegisterByGoogleLastPageState extends State<RegisterByGoogleLastPage> {
  bool _isLoading = true;

  bool _isHidePassword = true;
  bool _isHideConfirmPassword = true;
  PostRegisterByGoogle? postRegisterByGoogle;

  final textEditingUsername = TextEditingController();
  final textEditingNoHp = TextEditingController();
  final textEditingPassword = TextEditingController();
  final textEditingConfirmPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool validates() {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  void toggleConfirmPasswordVisibility() {
    setState(() {
      _isHideConfirmPassword = !_isHideConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    Auth authGoogle = chttp.auth!;
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
          child: Form(
              key: formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                                color: ColorPalette.mainColor,
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                                color: ColorPalette.mainColor,
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                                color: ColorPalette.neutral_30,
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Buat Akun',
                      style: TextStyle(
                          fontSize: 24,
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Dengan membuat akun kamu dapat mendapatkan hadiah menarik',
                      style: TextStyle(
                          fontSize: 14, color: ColorPalette.neutral_70),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                            fontSize: 14, fontFamily: 'PlusJakartaSans'),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Username',
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
                      decoration: inputDecoration('Masukan Username Kamu'),
                      validator: Platform.isIOS
                          ? null
                          : (val) {
                              if (val!.isEmpty) {
                                return "Username tidak boleh kosong";
                              } else {
                                return null;
                              }
                            },
                      keyboardType: TextInputType.text,
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
                            text: 'Nomor HP',
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
                      controller: textEditingNoHp,
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
                        hintText: '',
                        contentPadding: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 8, top: 8),
                        hintStyle: const TextStyle(
                            color: ColorPalette.neutral_50, fontSize: 14),
                        prefixIcon: const SizedBox(
                          width: 60,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 12, right: 12, bottom: 8, top: 8),
                            child: Row(
                              children: [
                                Text(
                                  '+62  |',
                                  style: TextStyle(
                                    color: ColorPalette.neutral_50,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                      validator: Platform.isIOS
                          ? null
                          : (val) {
                              if (val!.isEmpty) {
                                return "Nomor Hp tidak boleh kosong";
                              } else if (val.length > 15) {
                                return "Nomor ponsel lebih dari 15 angka";
                              } else {
                                return null;
                              }
                            },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
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
                            text: 'Password',
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
                      controller: textEditingPassword,
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
                      obscureText: _isHidePassword,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    FlutterPasswordStrength(
                      password: textEditingPassword.text,
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
                        } else if (val != textEditingPassword.text) {
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
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                        onTap: () async {
                          if (validates()) {
                            String convertHp = "";
                            if (textEditingNoHp.text.startsWith("62")) {
                              convertHp =
                                  textEditingNoHp.text.replaceRange(0, 2, '');
                            } else if (textEditingNoHp.text.startsWith("0")) {
                              convertHp =
                                  textEditingNoHp.text.replaceRange(0, 1, '');
                            } else {
                              convertHp = textEditingNoHp.text;
                            }
                            setState(() {
                              _isLoading = false;
                            });
                            authGoogle
                                .postRegisterGoogleTwo(
                                    convertHp,
                                    widget.postRegisterByGoogle!.email!,
                                    textEditingPassword.text,
                                    textEditingConfirmPassword.text,
                                    widget.postRegisterByGoogle!.googleId!,
                                    widget.postRegisterByGoogle!.token!)
                                .then((value) {
                              if (value['status'] == 1) {
                                setState(() {
                                  _isLoading = true;
                                  postRegisterByGoogle = PostRegisterByGoogle(
                                      kodeReferral: widget
                                          .postRegisterByGoogle!.kodeReferral,
                                      fullName:
                                          widget.postRegisterByGoogle!.fullName,
                                      username: textEditingUsername.text,
                                      gender:
                                          widget.postRegisterByGoogle!.gender,
                                      birthdate: widget
                                          .postRegisterByGoogle!.birthdate,
                                      address:
                                          widget.postRegisterByGoogle!.address,
                                      provinceId: basket['idProvince'],
                                      regencyId: basket['idCity'],
                                      subdistrictId: basket['idSubdistrict'],
                                      urbanVillageId: basket['idUrbanVillage'],
                                      city: widget.postRegisterByGoogle!.city,
                                      professionId: int.parse(
                                          basket['idProfesi'].toString()),
                                      postalCode:
                                          basket['postalCode'].toString(),
                                      email: widget.postRegisterByGoogle!.email,
                                      phone: convertHp,
                                      googleId:
                                          widget.postRegisterByGoogle!.googleId,
                                      token: widget.postRegisterByGoogle!.token,
                                      password: textEditingPassword.text,
                                      confirmPassword:
                                          textEditingConfirmPassword.text,
                                      photo: null);
                                });
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return RegisterByGoogleFotoPage(
                                    postRegisterByGoogle: postRegisterByGoogle!,
                                  );
                                }));
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
                          }
                        },
                        child: Platform.isIOS
                            ? Container(
                                height: 55,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: textEditingUsername.text.isEmpty ||
                                            textEditingPassword.text.isEmpty
                                        ? ColorPalette.neutral_50
                                        : ColorPalette.mainColor),
                                child: Center(
                                  child: _isLoading
                                      ? const Text(
                                          'Selanjutnya',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      : const ButtonLoadingWidget(
                                          color: Colors.white),
                                ),
                              )
                            : Container(
                                height: 55,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: textEditingUsername.text.isEmpty ||
                                            textEditingNoHp.text.isEmpty ||
                                            textEditingPassword.text.isEmpty
                                        ? ColorPalette.neutral_50
                                        : ColorPalette.mainColor),
                                child: Center(
                                  child: _isLoading
                                      ? const Text(
                                          'Selanjutnya',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      : const ButtonLoadingWidget(
                                          color: Colors.white),
                                ),
                              )),
                    SizedBox(
                      height: Platform.isIOS ? 8 : 0,
                    ),
                  ]))),
    );
  }
}
