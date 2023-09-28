import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/post_register.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/utils/content_view.dart';
import 'package:isilahtitiktitik/view/page-auth/page-register/page_verify_otp_register.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/success_state_widget.dart';
import 'package:provider/provider.dart';

class RegisterFotoPage extends StatefulWidget {
  final PostRegister? postRegister;
  const RegisterFotoPage({Key? key, @required this.postRegister})
      : super(key: key);

  @override
  State<RegisterFotoPage> createState() => _RegisterFotoPageState();
}

class _RegisterFotoPageState extends State<RegisterFotoPage> {
  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? foto;

  PostRegister? postRegister;

  bool _isLoading = true;

  bool validates() {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  /// Mengambil image dari `Camera` atau `Gallery` lalu menyimpannya di variable `foto`.
  /// Fungsi ini menggunakan plugin [ImagePicker].
  void _pickImages() async {
    final imageSource = await showModalBottomSheet<ImageSource>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                    Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: ColorPalette.neutral_30),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Pilih Sumber Gambar',
                          style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: bodyLarge,
                              color: ColorPalette.neutral_90,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context, ImageSource.camera),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1, color: ColorPalette.neutral_30)),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icon/ic_camera_pick.png',
                              width: 24,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            const Expanded(
                              child: Text(
                                'Kamera',
                                style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 14,
                                    color: ColorPalette.neutral_90,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context, ImageSource.gallery),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1, color: ColorPalette.neutral_30)),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icon/ic_gallery.png',
                              width: 24,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            const Expanded(
                              child: Text(
                                'Galeri',
                                style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 14,
                                    color: ColorPalette.neutral_90,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ])));
        });

    if (imageSource != null) {
      final file = await _picker.pickImage(source: imageSource, maxHeight: 720);
      if (file != null) {
        setState(() {
          foto = file;
        });
      }
    }
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                            color: ColorPalette.mainColor,
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Foto Profil',
                  style: TextStyle(
                      fontSize: 24,
                      color: ColorPalette.neutral_90,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'Pastikan Maksimal gambar yang di upload tidak lebih dari 2 MB',
                  style:
                      TextStyle(fontSize: 14, color: ColorPalette.neutral_70),
                ),
                const SizedBox(
                  height: 24,
                ),
                Expanded(
                  child: foto == null
                      ? GestureDetector(
                          onTap: () {
                            _pickImages();
                          },
                          child: Center(
                            child: Container(
                              width: 200,
                              height: 200,
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
                            _pickImages();
                          },
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(200),
                              child: FadeInImage(
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: 200,
                                  image: FileImage(File(foto!.path)),
                                  placeholder: const AssetImage(
                                    "assets/image/default_image.png",
                                  )),
                            ),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 24,
                ),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 14, fontFamily: 'PlusJakartaSans'),
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Dengan mendaftar anda setuju dengan ',
                        style: TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MyWebview(
                                url: Platform.isIOS
                                    ? 'https://isilah.com/myprivacy-policy'
                                    : 'https://isilah.com/myterms-conditions',
                              );
                            }));
                          },
                        text: 'syarat &\nketentuan ',
                        style: const TextStyle(
                          color: ColorPalette.mainColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const TextSpan(
                        text: ' yang berlaku.',
                        style: TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                GestureDetector(
                  onTap: () async {
                    if (foto == null) {
                      flushbarError('Anda Belum Memilih Foto').show(context);
                    } else {
                      setState(() {
                        _isLoading = false;
                      });

                      /// Fungsi ini bertujuan untuk mengirim data inputan
                      /// yang sudah diisi oleh user ke API repository [Auth].
                      /// Apabila response berhasil akan pindah ke page
                      /// [VerifyOTPRegisterPage] untuk proses validasi akun.
                      await auth
                          .postRegisterTwo(
                              widget.postRegister!.username!,
                              widget.postRegister!.phone!,
                              widget.postRegister!.email!,
                              widget.postRegister!.password!,
                              widget.postRegister!.confirmPassword!,
                              File(foto!.path))
                          .then((valueRegisterTwo) async {
                        if (valueRegisterTwo['status'] == 1) {
                          setState(() {
                            postRegister = PostRegister(
                                kodeReferral: widget.postRegister!.kodeReferral,
                                fullName: widget.postRegister!.fullName,
                                gender: widget.postRegister!.gender,
                                birthdate: widget.postRegister!.birthdate,
                                address: widget.postRegister!.address,
                                provinceId: widget.postRegister!.provinceId,
                                regencyId: widget.postRegister!.regencyId,
                                subdistrictId:
                                    widget.postRegister!.subdistrictId,
                                urbanVillageId:
                                    widget.postRegister!.urbanVillageId,
                                postalCode: widget.postRegister!.postalCode,
                                city: widget.postRegister!.city,
                                professionId: widget.postRegister!.professionId,
                                facebook: widget.postRegister!.facebook,
                                instagram: widget.postRegister!.instagram,
                                twitter: widget.postRegister!.twitter,
                                username: widget.postRegister!.username,
                                email: widget.postRegister!.email,
                                phone: widget.postRegister!.phone,
                                password: widget.postRegister!.password,
                                confirmPassword:
                                    widget.postRegister!.confirmPassword,
                                photo: File(foto!.path));
                          });

                          if (widget.postRegister!.email!.isNotEmpty) {
                            await auth
                                .postRegisterResendOTP(
                                    widget.postRegister!.email!)
                                .then((valueResendOTP) {
                              if (valueResendOTP['status'] == 1) {
                                setState(() {
                                  _isLoading = true;
                                });
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return VerifyOTPRegisterPage(
                                      postRegister: postRegister);
                                }));
                              } else {
                                setState(() {
                                  _isLoading = true;
                                });
                                flushbarError(
                                        valueResendOTP['message']['title'])
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
                          } else {
                            await auth
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
                                    File(foto!.path),
                                    "")
                                .then((valueFinshing) {
                              if (valueFinshing!.status == 1) {
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
                                      assets:
                                          'assets/image/img_verify_success.png',
                                      title: 'Verifikasi Berhasil',
                                      content:
                                          'Selamat akun kamu sudah berhasil di buat.');
                                }));
                              } else {
                                setState(() {
                                  _isLoading = true;
                                });
                                flushbarError(valueFinshing.message!.title!)
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
                        } else {
                          setState(() {
                            _isLoading = true;
                          });
                          flushbarError(valueRegisterTwo['message']['title'])
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
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: foto == null
                            ? ColorPalette.neutral_50
                            : ColorPalette.mainColor),
                    child: const Center(
                      child: Text(
                        'Daftar',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ])
            : const Center(
                child: LoadingWidget(),
              ),
      ),
    );
  }
}
