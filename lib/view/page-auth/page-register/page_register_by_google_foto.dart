import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/post_register_by_google.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/utils/content_view.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/success_state_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterByGoogleFotoPage extends StatefulWidget {
  final PostRegisterByGoogle? postRegisterByGoogle;
  const RegisterByGoogleFotoPage(
      {Key? key, @required this.postRegisterByGoogle})
      : super(key: key);

  @override
  State<RegisterByGoogleFotoPage> createState() =>
      _RegisterByGoogleFotoPageState();
}

class _RegisterByGoogleFotoPageState extends State<RegisterByGoogleFotoPage> {
  bool _isLoading = true;
  final ImagePicker _picker = ImagePicker();
  XFile? foto;

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
      body: _isLoading
          ? Padding(
              padding: const EdgeInsets.all(16.0),
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
                      style: TextStyle(
                          fontSize: 14, color: ColorPalette.neutral_70),
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
                        onTap: () {
                          SharedPreferences.getInstance().then((prefs) {
                            if (foto == null) {
                              flushbarError('Anda belum memilih foto')
                                  .show(context);
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                              authGoogle
                                  .postRegisterGoogleFinishing(
                                      widget
                                          .postRegisterByGoogle!.kodeReferral!,
                                      widget.postRegisterByGoogle!.fullName!,
                                      widget.postRegisterByGoogle!.username!,
                                      widget.postRegisterByGoogle!.gender!,
                                      widget.postRegisterByGoogle!.birthdate!,
                                      widget.postRegisterByGoogle!.address!,
                                      widget.postRegisterByGoogle!.provinceId!,
                                      widget.postRegisterByGoogle!.regencyId!,
                                      widget
                                          .postRegisterByGoogle!.subdistrictId!,
                                      widget.postRegisterByGoogle!
                                          .urbanVillageId!,
                                      "",
                                      widget
                                          .postRegisterByGoogle!.professionId!,
                                      widget.postRegisterByGoogle!.phone!,
                                      widget.postRegisterByGoogle!.email!,
                                      widget.postRegisterByGoogle!.password!,
                                      widget.postRegisterByGoogle!
                                          .confirmPassword!,
                                      widget.postRegisterByGoogle!.googleId!,
                                      widget.postRegisterByGoogle!.token!,
                                      File(foto!.path))
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
                                    prefs.setBool("withGoogle", true);
                                  });
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const SuccessStateWidget(
                                        assets:
                                            'assets/image/img_verify_success.png',
                                        title: 'Verifikasi Berhasil',
                                        content:
                                            'Selamat kamu berhasil buat akun, Mari kita main');
                                  }));
                                } else {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  flushbarError(value.message!.title!);
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
                          });
                        },
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: ColorPalette.mainColor),
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
                        )),
                    SizedBox(
                      height: Platform.isIOS ? 8 : 0,
                    ),
                  ]),
            )
          : const LoadingWidget(),
    );
  }
}
