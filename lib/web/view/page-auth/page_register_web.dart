import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/city.dart';
import 'package:isilahtitiktitik/model/post_register.dart';
import 'package:isilahtitiktitik/model/profesi.dart';
import 'package:isilahtitiktitik/model/province.dart';
import 'package:isilahtitiktitik/model/subdistrict.dart';
import 'package:isilahtitiktitik/model/urban_village.dart';
import 'package:isilahtitiktitik/resource/helper_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/widgets/button_loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/input_decoration_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_web_widget.dart';
import 'package:isilahtitiktitik/web/view/page-auth/page_register_last_web.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterWebPage extends StatefulWidget {
  const RegisterWebPage({Key? key}) : super(key: key);

  @override
  State<RegisterWebPage> createState() => _RegisterWebPageState();
}

class _RegisterWebPageState extends State<RegisterWebPage> {
  final textEditingKodeReferral = TextEditingController();
  final textEditingNamaLengkap = TextEditingController();
  final textEditingTglLahir = TextEditingController();
  final textEditingAlamat = TextEditingController();
  final textEditingKota = TextEditingController();
  final textEditingProfesi = TextEditingController();
  final textEditingProvince = TextEditingController();
  final textEditingCity = TextEditingController();
  final textEditingSubdistrict = TextEditingController();
  final textEditingUrbanVillage = TextEditingController();
  final textEditingInstagram = TextEditingController();
  final textEditingFacebook = TextEditingController();
  final textEditingTwitter = TextEditingController();

  PostRegister? postRegister;

  final formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  int _gender = -1;

  bool validates() {
    final form = formKey.currentState!;
    if (form.validate()) {
      if (_gender != -1) {
        form.save();
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    Auth auth = chttp.auth!;
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          basket['address'] = null;
          basket['postalCode'] = null;
          basket['idProfesi'] = null;
          basket['idProvince'] = null;
          basket['idCity'] = null;
          basket['idSubdistrict'] = null;
          basket['idUrbanVillage'] = null;
        });
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
                  'Buat Akun',
                  style: TextStyle(
                      fontSize: headingSmall,
                      color: ColorPalette.neutral_90,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'Dengan membuat akun kamu dapat mendapatkan hadiah menarik',
                  style: TextStyle(
                      fontSize: bodyLarge, color: ColorPalette.neutral_90),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                    controller: textEditingKodeReferral,
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
                      hintText: 'Masukan Kode',
                      hintStyle: const TextStyle(
                        color: ColorPalette.colorHintText,
                        fontWeight: FontWeight.w400,
                        fontSize: bodyMedium,
                      ),
                      errorStyle: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w400,
                        fontSize: bodySmall,
                      ),
                      prefixIcon: Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: const BoxDecoration(
                            color: ColorPalette.mainColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5))),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Kode Referral',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      contentPadding:
                          const EdgeInsets.only(bottom: 8, top: 8, right: 12),
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
                    keyboardType: TextInputType.text),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Silahkan masukkan kode referal jika ada',
                  style: TextStyle(
                      fontSize: bodySmall, color: ColorPalette.neutral_90),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Nama Lengkap',
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
                    controller: textEditingNamaLengkap,
                    cursorColor: ColorPalette.mainColor,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: const TextStyle(
                      color: ColorPalette.blackPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: bodyMedium,
                    ),
                    decoration: inputDecoration('Masukan Nama Lengkap'),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Nama lengkap tidak boleh kosong";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.sentences),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Jenis Kelamin',
                  style: TextStyle(
                    color: ColorPalette.neutral_90,
                    fontWeight: FontWeight.w700,
                    fontSize: bodyLarge,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    customRadioButtonGender(1),
                    const Padding(
                      padding: EdgeInsets.only(left: 13, right: 23),
                      child: Text(
                        'Laki-laki',
                        style: TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    customRadioButtonGender(2),
                    const Padding(
                      padding: EdgeInsets.only(left: 13),
                      child: Text(
                        'Perempuan',
                        style: TextStyle(
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  'Tanggal Lahir',
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
                    controller: textEditingTglLahir,
                    cursorColor: ColorPalette.mainColor,
                    readOnly: true,
                    onChanged: (value) {
                      setState(() {});
                    },
                    onTap: () {
                      final now = DateTime.now();
                      FocusScope.of(context).requestFocus(FocusNode());
                      showDatePicker(
                        context: context,
                        confirmText: "OKE",
                        cancelText: "BATAL",
                        initialDate:
                            DateTime(now.year - 16, now.month, now.day),
                        firstDate: DateTime(now.year - 90, now.month, now.day),
                        lastDate: DateTime(now.year - 16, now.month, now.day),
                        locale: const Locale("id", "ID"),
                        builder: (context, child) {
                          return Theme(
                              data: ThemeData(
                                  primaryColor: const MaterialColor(
                                      0xFFEF5696, ColorPalette.colorList),
                                  colorScheme: ColorScheme.fromSwatch(
                                          primarySwatch: const MaterialColor(
                                              0xFFEF5696,
                                              ColorPalette.colorList))
                                      .copyWith(
                                          secondary: const MaterialColor(
                                              0xFFEF5696,
                                              ColorPalette.colorList))),
                              child: child!);
                        },
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            textEditingTglLahir.text =
                                DateFormat("y-MM-dd").format(value);
                          });
                        }
                      });
                    },
                    style: const TextStyle(
                      color: ColorPalette.blackPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: bodyMedium,
                    ),
                    decoration: inputDecoration('Masukan Tanggal Lahir'),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Tanggal lahir tidak boleh kosong";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.datetime),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Alamat Tempat Tinggal',
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
                    controller: textEditingAlamat,
                    cursorColor: ColorPalette.mainColor,
                    onChanged: (value) {
                      setState(() {});
                    },
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: ColorPalette.blackPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: bodyMedium,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ColorPalette.colorFilledTextField,
                      hintText: 'Masukan Alamat',
                      hintStyle: const TextStyle(
                        color: ColorPalette.colorHintText,
                        fontWeight: FontWeight.w400,
                        fontSize: bodyMedium,
                      ),
                      errorStyle: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w400,
                        fontSize: bodySmall,
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 30, top: 30),
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
                        return "Alamat tidak boleh kosong";
                      } else {
                        return null;
                      }
                    },
                    maxLines: null,
                    maxLength: null,
                    keyboardType: TextInputType.multiline),
                const SizedBox(
                  height: 16,
                ),
                // Text(
                //   'Kota/Kabupaten',
                //   style: TextStyle(
                //     color: ColorPalette.neutral_90,
                //     fontWeight: FontWeight.w700,
                //     fontSize: bodyLarge,
                //   ),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // TextFormField(
                //     autovalidateMode: AutovalidateMode.onUserInteraction,
                //     controller: textEditingKota,
                //     cursorColor: ColorPalette.mainColor,
                //     onChanged: (value) {
                //       setState(() {});
                //     },
                //     readOnly: true,
                //     onTap: () {
                //       Navigator.push(context,
                //           MaterialPageRoute(builder: (context) {
                //         return const RegionPage();
                //       })).then((val) => val != null ? _getTextKota() : null);
                //     },
                //     style: TextStyle(
                //       color: ColorPalette.blackPrimary,
                //       fontWeight: FontWeight.w500,
                //       fontSize: bodyMedium,
                //     ),
                //     decoration: inputDecoration('Masukan Kota/Kabupaten'),
                //     validator: Platform.isIOS
                //         ? null
                //         : (val) {
                //             if (val!.isEmpty) {
                //               return "Kota/Kabupaten tidak boleh kosong";
                //             } else {
                //               return null;
                //             }
                //           },
                //     keyboardType: TextInputType.text),
                const Text(
                  'Provinsi',
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
                    controller: textEditingProvince,
                    cursorColor: ColorPalette.mainColor,
                    onChanged: (value) {
                      setState(() {});
                    },
                    readOnly: true,
                    onTap: () {},
                    style: const TextStyle(
                      color: ColorPalette.blackPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: bodyMedium,
                    ),
                    decoration: inputDecoration('Masukan Provinsi'),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Provinsi tidak boleh kosong";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Kota/Kabupaten',
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
                    controller: textEditingCity,
                    cursorColor: ColorPalette.mainColor,
                    onChanged: (value) {
                      setState(() {});
                    },
                    readOnly: true,
                    onTap: () {
                      if (basket['idProvince'] == null) {
                        flushbarError('Anda belum memilih Provinsi')
                            .show(context);
                      } else {}
                    },
                    style: const TextStyle(
                      color: ColorPalette.blackPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: bodyMedium,
                    ),
                    decoration: inputDecoration('Masukan Kota/Kabupaten'),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Kota/Kabupaten tidak boleh kosong";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Kecamatan',
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
                    controller: textEditingSubdistrict,
                    cursorColor: ColorPalette.mainColor,
                    onChanged: (value) {
                      setState(() {});
                    },
                    readOnly: true,
                    onTap: () {
                      if (basket['idCity'] == null) {
                        flushbarError('Anda belum memilih Kota/Kabupaten')
                            .show(context);
                      } else {}
                    },
                    style: const TextStyle(
                      color: ColorPalette.blackPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: bodyMedium,
                    ),
                    decoration: inputDecoration('Masukan Kecamatan'),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Kecamatan tidak boleh kosong";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Kelurahan',
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
                    controller: textEditingUrbanVillage,
                    cursorColor: ColorPalette.mainColor,
                    onChanged: (value) {
                      setState(() {});
                    },
                    readOnly: true,
                    onTap: () {
                      if (basket['idSubdistrict'] == null) {
                        flushbarError('Anda belum memilih Kelurahan')
                            .show(context);
                      } else {}
                    },
                    style: const TextStyle(
                      color: ColorPalette.blackPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: bodyMedium,
                    ),
                    decoration: inputDecoration('Masukan Kelurahan'),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Kelurahan tidak boleh kosong";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Profesi',
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
                    controller: textEditingProfesi,
                    cursorColor: ColorPalette.mainColor,
                    onChanged: (value) {
                      setState(() {});
                    },
                    readOnly: true,
                    onTap: () {},
                    style: const TextStyle(
                      color: ColorPalette.blackPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: bodyMedium,
                    ),
                    decoration: inputDecoration('Masukan Profesi'),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Profesi tidak boleh kosong";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Instagram',
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
                    controller: textEditingInstagram,
                    cursorColor: ColorPalette.mainColor,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: const TextStyle(
                      color: ColorPalette.blackPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: bodyMedium,
                    ),
                    decoration:
                        inputDecoration('Username Instagram (Optional)'),
                    keyboardType: TextInputType.text),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Facebook',
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
                    controller: textEditingFacebook,
                    cursorColor: ColorPalette.mainColor,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: const TextStyle(
                      color: ColorPalette.blackPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: bodyMedium,
                    ),
                    decoration: inputDecoration('Username Facebook (Optional)'),
                    keyboardType: TextInputType.text),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Twitter',
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
                    controller: textEditingTwitter,
                    cursorColor: ColorPalette.mainColor,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: const TextStyle(
                      color: ColorPalette.blackPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: bodyMedium,
                    ),
                    decoration: inputDecoration('Username Twitter (Optional)'),
                    keyboardType: TextInputType.text),
                Column(
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Social media kamu di gunakan buat\n',
                              style: TextStyle(
                                color: ColorPalette.neutral_90,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _launchInBrowser(
                                      Uri.parse('https://isilah.com'));
                                },
                              text: 'Klaim hadiah loh',
                              style: const TextStyle(
                                color: ColorPalette.mainColor,
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
                GestureDetector(
                  onTap: () {
                    if (validates()) {
                      String convertHp = "";
                      if (textEditingKodeReferral.text.isNotEmpty) {
                        if (textEditingKodeReferral.text.startsWith("62")) {
                          convertHp = textEditingKodeReferral.text
                              .replaceRange(0, 2, '');
                        } else if (textEditingKodeReferral.text
                            .startsWith("0")) {
                          convertHp = textEditingKodeReferral.text
                              .replaceRange(0, 1, '');
                        } else {
                          convertHp = textEditingKodeReferral.text;
                        }
                      }

                      setState(() {
                        _isLoading = false;
                      });
                      auth
                          .postRegisterOne(
                              convertHp,
                              textEditingNamaLengkap.text,
                              _gender == 1 ? "m" : "f",
                              textEditingTglLahir.text,
                              textEditingAlamat.text,
                              basket['idProvince'],
                              basket['idCity'],
                              basket['idSubdistrict'],
                              basket['idUrbanVillage'],
                              basket['postalCode'].toString(),
                              int.parse(basket['idProfesi'].toString()),
                              textEditingFacebook.text,
                              textEditingInstagram.text,
                              textEditingTwitter.text)
                          .then((value) {
                        if (value['status'] == 1) {
                          setState(() {
                            _isLoading = true;
                          });
                          setState(() {
                            postRegister = PostRegister(
                                kodeReferral: convertHp,
                                fullName: textEditingNamaLengkap.text,
                                gender: _gender == 1 ? "m" : "f",
                                birthdate: textEditingTglLahir.text,
                                address: textEditingAlamat.text,
                                provinceId: basket['idProvince'],
                                regencyId: basket['idCity'],
                                subdistrictId: basket['idSubdistrict'],
                                urbanVillageId: basket['idUrbanVillage'],
                                city: textEditingKota.text,
                                professionId:
                                    int.parse(basket['idProfesi'].toString()),
                                facebook: textEditingFacebook.text,
                                instagram: textEditingInstagram.text,
                                twitter: textEditingTwitter.text,
                                postalCode: basket['postalCode'].toString(),
                                email: "",
                                phone: "",
                                password: "",
                                confirmPassword: "",
                                photo: null);
                          });
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return RegisterLastWebPage(
                              postRegister: postRegister!,
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
                        flushbarError(onError['message']['title'])
                            .show(context);
                      });
                    }
                  },
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: textEditingNamaLengkap.text.isEmpty ||
                                textEditingTglLahir.text.isEmpty ||
                                textEditingAlamat.text.isEmpty ||
                                textEditingProvince.text.isEmpty ||
                                textEditingCity.text.isEmpty ||
                                textEditingSubdistrict.text.isEmpty ||
                                textEditingUrbanVillage.text.isEmpty ||
                                textEditingProfesi.text.isEmpty ||
                                _gender == -1
                            ? ColorPalette.neutral_50
                            : ColorPalette.mainColor),
                    child: Center(
                      child: _isLoading
                          ? const Text(
                              'Berikutnya',
                              style: TextStyle(
                                fontSize: bodyLarge,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : const ButtonLoadingWidget(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Widget modalProfesi(BuildContext context) {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    HelperApi helperApi = HelperApi(http: chttp);
    return SafeArea(
      bottom: false,
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: defaultPadding,
                    right: defaultPadding,
                    top: defaultPadding),
                child: const Text("Pilih Profesi",
                    style: TextStyle(
                        fontSize: bodyLarge,
                        color: ColorPalette.neutral_90,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              const Divider(
                thickness: 1,
                color: ColorPalette.neutral_50,
              ),
              Expanded(
                flex: 40,
                child: FutureBuilder<ProfesiModel>(
                    future: helperApi.fetchProfesi(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        final ProfesiModel profesiModel = snapshot.data!;
                        return ListView.separated(
                          padding: const EdgeInsets.all(defaultPadding),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: profesiModel.data!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  basket.addAll({
                                    'idProfesi': profesiModel.data![index].id,
                                  });
                                  textEditingProfesi.text =
                                      profesiModel.data![index].profession!;
                                });
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    basket['idProfesi'] ==
                                            profesiModel.data![index].id
                                        ? Text(
                                            profesiModel
                                                .data![index].profession!,
                                            style: const TextStyle(
                                                fontSize: bodyMedium,
                                                color: ColorPalette.neutral_90,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            profesiModel
                                                .data![index].profession!,
                                            style: const TextStyle(
                                                fontSize: bodyMedium,
                                                color: ColorPalette.neutral_90),
                                          ),
                                    basket['idProfesi'] ==
                                            profesiModel.data![index].id
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: ColorPalette.greenColor,
                                          )
                                        : const Icon(
                                            Icons.lens_outlined,
                                            color: ColorPalette.neutral_90,
                                          )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(
                              thickness: 1,
                              color: ColorPalette.neutral_50,
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Container();
                      }
                      return const LoadingWebWidget();
                    })),
              )
            ],
          )),
    );
  }

  Widget modalRegion(BuildContext context, String typeRegion) {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    HelperApi helperApi = HelperApi(http: chttp);
    return SafeArea(
      bottom: false,
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: defaultPadding,
                    right: defaultPadding,
                    top: defaultPadding),
                child: Text(
                    typeRegion == "province"
                        ? "Pilih Provinsi"
                        : typeRegion == "city"
                            ? "Pilih Kota/Kabupaten"
                            : typeRegion == "subdistrict"
                                ? "Pilih Kecamatan"
                                : typeRegion == "urban-village"
                                    ? "Pilih Kelurahan"
                                    : "",
                    style: const TextStyle(
                        fontSize: bodyLarge,
                        color: ColorPalette.neutral_90,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              const Divider(
                thickness: 1,
                color: ColorPalette.neutral_50,
              ),
              Expanded(
                flex: 40,
                child: typeRegion == "province"
                    ? FutureBuilder<ProvinceModel>(
                        future: helperApi.fetchProvince(),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            final ProvinceModel provinceModel = snapshot.data!;
                            return ListView.separated(
                              padding: const EdgeInsets.all(defaultPadding),
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: provinceModel.data!.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      basket.addAll({
                                        'idProvince':
                                            provinceModel.data![index].id,
                                      });
                                      basket['idCity'] = null;
                                      basket['idSubdistrict'] = null;
                                      basket['idUrbanVillage'] = null;
                                      textEditingCity.text = '';
                                      textEditingSubdistrict.text = '';
                                      textEditingUrbanVillage.text = '';
                                      textEditingProvince.text =
                                          provinceModel.data![index].province!;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        basket['idProvince'] ==
                                                provinceModel.data![index].id
                                            ? Text(
                                                provinceModel
                                                    .data![index].province!,
                                                style: const TextStyle(
                                                    fontSize: bodyMedium,
                                                    color:
                                                        ColorPalette.neutral_90,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text(
                                                provinceModel
                                                    .data![index].province!,
                                                style: const TextStyle(
                                                    fontSize: bodyMedium,
                                                    color: ColorPalette
                                                        .neutral_90),
                                              ),
                                        basket['idProvince'] ==
                                                provinceModel.data![index].id
                                            ? const Icon(
                                                Icons.check_circle,
                                                color: ColorPalette.greenColor,
                                              )
                                            : const Icon(
                                                Icons.lens_outlined,
                                                color: ColorPalette.neutral_90,
                                              )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  thickness: 1,
                                  color: ColorPalette.neutral_50,
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Container();
                          }
                          return const LoadingWebWidget();
                        }))
                    : typeRegion == "city"
                        ? FutureBuilder<CityModel>(
                            future: helperApi.fetchCity(basket['idProvince']),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                final CityModel cityModel = snapshot.data!;
                                return ListView.separated(
                                  padding: const EdgeInsets.all(defaultPadding),
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: cityModel.data!.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          basket.addAll({
                                            'idCity': cityModel.data![index].id,
                                          });
                                          basket['idSubdistrict'] = null;
                                          basket['idUrbanVillage'] = null;
                                          textEditingSubdistrict.text = '';
                                          textEditingUrbanVillage.text = '';
                                          textEditingCity.text =
                                              cityModel.data![index].regency!;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            basket['idCity'] ==
                                                    cityModel.data![index].id
                                                ? Text(
                                                    cityModel
                                                        .data![index].regency!,
                                                    style: const TextStyle(
                                                        fontSize: bodyMedium,
                                                        color: ColorPalette
                                                            .neutral_90,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Text(
                                                    cityModel
                                                        .data![index].regency!,
                                                    style: const TextStyle(
                                                        fontSize: bodyMedium,
                                                        color: ColorPalette
                                                            .neutral_90),
                                                  ),
                                            basket['idCity'] ==
                                                    cityModel.data![index].id
                                                ? const Icon(
                                                    Icons.check_circle,
                                                    color:
                                                        ColorPalette.greenColor,
                                                  )
                                                : const Icon(
                                                    Icons.lens_outlined,
                                                    color:
                                                        ColorPalette.neutral_90,
                                                  )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      thickness: 1,
                                      color: ColorPalette.neutral_50,
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Container();
                              }
                              return const LoadingWebWidget();
                            }))
                        : typeRegion == "subdistrict"
                            ? FutureBuilder<SubdistrictModel>(
                                future: helperApi
                                    .fetchSubdistrict(basket['idCity']),
                                builder: ((context, snapshot) {
                                  if (snapshot.hasData) {
                                    final SubdistrictModel subdistrictModel =
                                        snapshot.data!;
                                    return ListView.separated(
                                      padding:
                                          const EdgeInsets.all(defaultPadding),
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: subdistrictModel.data!.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              basket.addAll({
                                                'idSubdistrict':
                                                    subdistrictModel
                                                        .data![index].id,
                                              });
                                              basket['idUrbanVillage'] = null;
                                              textEditingUrbanVillage.text = '';
                                              textEditingSubdistrict.text =
                                                  subdistrictModel.data![index]
                                                      .subdistrict!;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8, bottom: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                basket['idSubdistrict'] ==
                                                        subdistrictModel
                                                            .data![index].id
                                                    ? Text(
                                                        subdistrictModel
                                                            .data![index]
                                                            .subdistrict!,
                                                        style: const TextStyle(
                                                            fontSize:
                                                                bodyMedium,
                                                            color: ColorPalette
                                                                .neutral_90,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : Text(
                                                        subdistrictModel
                                                            .data![index]
                                                            .subdistrict!,
                                                        style: const TextStyle(
                                                            fontSize:
                                                                bodyMedium,
                                                            color: ColorPalette
                                                                .neutral_90),
                                                      ),
                                                basket['idSubdistrict'] ==
                                                        subdistrictModel
                                                            .data![index].id
                                                    ? const Icon(
                                                        Icons.check_circle,
                                                        color: ColorPalette
                                                            .greenColor,
                                                      )
                                                    : const Icon(
                                                        Icons.lens_outlined,
                                                        color: ColorPalette
                                                            .neutral_90,
                                                      )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const Divider(
                                          thickness: 1,
                                          color: ColorPalette.neutral_50,
                                        );
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return Container();
                                  }
                                  return const LoadingWebWidget();
                                }))
                            : FutureBuilder<UrbanVillageModel>(
                                future: helperApi
                                    .fetchUrbanVillage(basket['idSubdistrict']),
                                builder: ((context, snapshot) {
                                  if (snapshot.hasData) {
                                    final UrbanVillageModel urbanVillageModel =
                                        snapshot.data!;
                                    return ListView.separated(
                                      padding:
                                          const EdgeInsets.all(defaultPadding),
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: urbanVillageModel.data!.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              basket.addAll({
                                                'idUrbanVillage':
                                                    urbanVillageModel
                                                        .data![index].id,
                                              });
                                              textEditingUrbanVillage.text =
                                                  urbanVillageModel.data![index]
                                                      .urbanVillage!;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8, bottom: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                basket['idUrbanVillage'] ==
                                                        urbanVillageModel
                                                            .data![index].id
                                                    ? Text(
                                                        urbanVillageModel
                                                            .data![index]
                                                            .urbanVillage!,
                                                        style: const TextStyle(
                                                            fontSize:
                                                                bodyMedium,
                                                            color: ColorPalette
                                                                .neutral_90,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : Text(
                                                        urbanVillageModel
                                                            .data![index]
                                                            .urbanVillage!,
                                                        style: const TextStyle(
                                                            fontSize:
                                                                bodyMedium,
                                                            color: ColorPalette
                                                                .neutral_90),
                                                      ),
                                                basket['idUrbanVillage'] ==
                                                        urbanVillageModel
                                                            .data![index].id
                                                    ? const Icon(
                                                        Icons.check_circle,
                                                        color: ColorPalette
                                                            .greenColor,
                                                      )
                                                    : const Icon(
                                                        Icons.lens_outlined,
                                                        color: ColorPalette
                                                            .neutral_90,
                                                      )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const Divider(
                                          thickness: 1,
                                          color: ColorPalette.neutral_50,
                                        );
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return Container();
                                  }
                                  return const LoadingWebWidget();
                                })),
              )
            ],
          )),
    );
  }

  Widget customRadioButtonGender(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _gender = index;
        });
      },
      child: Container(
        width: 24,
        height: 21,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: ColorPalette.neutral_50,
          ),
          borderRadius: BorderRadius.circular(8),
          color: _gender == index
              ? ColorPalette.mainColor
              : ColorPalette.colorFilledTextField,
        ),
      ),
    );
  }
}
