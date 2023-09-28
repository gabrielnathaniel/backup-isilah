import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/post_register.dart';
import 'package:isilahtitiktitik/view/widgets/button_loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/input_decoration_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterLastWebPage extends StatefulWidget {
  final PostRegister? postRegister;
  const RegisterLastWebPage({Key? key, @required this.postRegister})
      : super(key: key);

  @override
  State<RegisterLastWebPage> createState() => _RegisterLastWebPageState();
}

class _RegisterLastWebPageState extends State<RegisterLastWebPage> {
  final regExpPassword =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  bool _isHidePassword = true;
  bool _isHideConfirmPassword = true;
  bool isLoading = true;
  PostRegister? postRegister;
  PlatformFile? platformFile;

  final textEditingEmail = TextEditingController();
  final textEditingNoHp = TextEditingController();
  final textEditingPassword = TextEditingController();
  final textEditingConfirmPassword = TextEditingController();
  final regExp = RegExp(
      "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$");

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

  void _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowCompression: false,
        allowedExtensions: ['jpg', 'png'],
        allowMultiple: false);

    if (result != null) {
      setState(() {
        platformFile = result.files[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // CHttp _chttp = Provider.of<CHttp>(context, listen: false);
    // Auth auth = _chttp.auth!;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: ColorPalette.neutral_90),
          title: const Text(
            'Kembali',
            style: TextStyle(
                fontSize: titleSmall,
                color: ColorPalette.neutral_90,
                fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(defaultPadding),
            physics: const BouncingScrollPhysics(),
            child: Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upload Photo\nProfile',
                        style: TextStyle(
                            fontSize: headingSmall,
                            color: ColorPalette.neutral_90,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        'Upload Foto profile biar makin ciamik',
                        style: TextStyle(
                            fontSize: bodyLarge,
                            color: ColorPalette.neutral_90),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      platformFile == null
                          ? GestureDetector(
                              onTap: () {
                                _pickImage();
                              },
                              child: Center(
                                child: Container(
                                  width: 180,
                                  height: 180,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorPalette.bgDots),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/icon/ic_camera.png',
                                      width: 45,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                _pickImage();
                              },
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(180),
                                  child: Container(
                                    height: 180,
                                    width: 180,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle),
                                    child: Image.memory(
                                      platformFile!.bytes!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Center(
                        child: Text(
                          'Pastikan Maksimal gambar yang di upload\ntidak lebih dari 2 MB',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: bodySmall,
                              color: ColorPalette.neutral_90),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      const Text(
                        'Email',
                        style: TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w700,
                          fontSize: bodyLarge,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: textEditingEmail,
                          cursorColor: ColorPalette.mainColor,
                          onChanged: (value) {
                            setState(() {});
                          },
                          style: const TextStyle(
                            color: ColorPalette.blackPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: bodyMedium,
                          ),
                          decoration: inputDecoration('Masukan Nama Email'),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Email tidak boleh kosong";
                            } else if (!regExp.hasMatch(val)) {
                              return "Format email salah";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.emailAddress),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'Nomor HP',
                        style: TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w700,
                          fontSize: bodyLarge,
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
                          color: ColorPalette.blackPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: bodyMedium,
                        ),
                        decoration: inputDecoration('Masukan Nomor Hp'),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Nomor Hp tidak boleh kosong";
                          } else if (val.length > 15) {
                            return "Nomor ponsel lebih dari 15 angka";
                          } else if (!val.startsWith('08') &&
                              !val.startsWith('62')) {
                            return "Format nomor ponsel belum benar";
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
                      const Text(
                        'Password',
                        style: TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w700,
                          fontSize: bodyLarge,
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
                          color: ColorPalette.blackPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: bodyMedium,
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
                      const Text(
                        'Konfirmasi Password',
                        style: TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w700,
                          fontSize: bodyLarge,
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
                          color: ColorPalette.blackPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: bodyMedium,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorPalette.colorFilledTextField,
                          hintText: 'Masukan Konfirmasi Password',
                          contentPadding: const EdgeInsets.only(
                              left: 12, right: 12, bottom: 8, top: 8),
                          hintStyle: const TextStyle(
                              color: ColorPalette.colorHintText, fontSize: 14),
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
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                text:
                                    'Dengan mengklik Daftar anda menyetujui\n',
                                style: TextStyle(
                                  color: ColorPalette.neutral_90,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _launchInBrowser(Uri.parse(
                                        'https://isilah.com/myterms-conditions'));
                                  },
                                text: 'Syarat dan Ketentuan',
                                style: const TextStyle(
                                  color: ColorPalette.mainColor,
                                  fontSize: 14,
                                ),
                              ),
                              const TextSpan(
                                text: ' yang berlaku',
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
                      const SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                          onTap: () {
                            if (validates()) {
                              if (platformFile == null) {
                                Flushbar(
                                  message: 'Anda belum memilih foto',
                                  margin: const EdgeInsets.all(16),
                                  borderRadius: BorderRadius.circular(8),
                                  duration: const Duration(seconds: 2),
                                  messageSize: 12,
                                  backgroundColor: Colors.red,
                                ).show(context);
                              } else {
                                // String convertHp = "";
                                // if (textEditingNoHp.text.startsWith("62")) {
                                //   convertHp = textEditingNoHp.text
                                //       .replaceRange(0, 2, '');
                                // } else if (textEditingNoHp.text
                                //     .startsWith("0")) {
                                //   convertHp = textEditingNoHp.text
                                //       .replaceRange(0, 1, '');
                                // } else {
                                //   convertHp = textEditingNoHp.text;
                                // }
                                // setState(() {
                                //   _isLoading = false;
                                // });
                                // auth
                                //     .postRegisterTwo(
                                //         convertHp,
                                //         textEditingEmail.text,
                                //         textEditingPassword.text,
                                //         textEditingConfirmPassword.text,
                                //         File(''))
                                //     .then((value) {
                                //   if (value['status'] == 1) {
                                //     setState(() {
                                //       _isLoading = true;
                                //     });
                                //     setState(() {
                                //       postRegister = PostRegister(
                                //           kodeReferral:
                                //               widget.postRegister!.kodeReferral,
                                //           fullName:
                                //               widget.postRegister!.fullName,
                                //           gender: widget.postRegister!.gender,
                                //           birthdate:
                                //               widget.postRegister!.birthdate,
                                //           address: widget.postRegister!.address,
                                //           provinceId:
                                //               widget.postRegister!.provinceId,
                                //           regencyId:
                                //               widget.postRegister!.regencyId,
                                //           subdistrictId: widget
                                //               .postRegister!.subdistrictId,
                                //           urbanVillageId: widget
                                //               .postRegister!.urbanVillageId,
                                //           postalCode:
                                //               widget.postRegister!.postalCode,
                                //           city: widget.postRegister!.city,
                                //           professionId:
                                //               widget.postRegister!.professionId,
                                //           facebook:
                                //               widget.postRegister!.facebook,
                                //           instagram:
                                //               widget.postRegister!.instagram,
                                //           twitter: widget.postRegister!.twitter,
                                //           email: textEditingEmail.text,
                                //           phone: convertHp,
                                //           password: textEditingPassword.text,
                                //           confirmPassword:
                                //               textEditingConfirmPassword.text,
                                //           photo: File(''));
                                //     });
                                //     Navigator.push(context,
                                //         MaterialPageRoute(builder: (context) {
                                //       return VerifyOTPRegisterPage(
                                //           postRegister: postRegister);
                                //     }));
                                //   } else {
                                //     setState(() {
                                //       _isLoading = true;
                                //     });
                                //     flushbarError(value['message']['title'])
                                //         .show(context);
                                //   }
                                // }).catchError((onError) {
                                //   setState(() {
                                //     _isLoading = true;
                                //   });
                                //   flushbarError(onError['message']['title'])
                                //       .show(context);
                                // });
                              }
                            }
                          },
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: textEditingEmail.text.isEmpty ||
                                        textEditingNoHp.text.isEmpty ||
                                        textEditingPassword.text.isEmpty ||
                                        textEditingConfirmPassword.text.isEmpty
                                    ? ColorPalette.neutral_50
                                    : ColorPalette.mainColor),
                            child: Center(
                              child: isLoading
                                  ? const Text(
                                      'Daftar',
                                      style: TextStyle(
                                        fontSize: bodyLarge,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  : const ButtonLoadingWidget(
                                      color: Colors.white),
                            ),
                          )),
                      const SizedBox(
                        height: 0,
                      ),
                    ]))));
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
