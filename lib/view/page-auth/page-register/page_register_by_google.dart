import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/post_register_by_google.dart';
import 'package:isilahtitiktitik/model/profesi.dart';
import 'package:isilahtitiktitik/resource/helper_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-auth/page-register/page_address_domicile.dart';
import 'package:isilahtitiktitik/view/page-auth/page-register/page_register_by_google_last.dart';
import 'package:isilahtitiktitik/view/widgets/alert_dialog_update_widget.dart';
import 'package:isilahtitiktitik/view/widgets/button_loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/empty_state.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/input_decoration_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

enum Gender { male, female }

class RegisterByGooglePage extends StatefulWidget {
  final PostRegisterByGoogle? postRegisterByGoogle;
  const RegisterByGooglePage({Key? key, @required this.postRegisterByGoogle})
      : super(key: key);

  @override
  State<RegisterByGooglePage> createState() => _RegisterByGooglePageState();
}

class _RegisterByGooglePageState extends State<RegisterByGooglePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  TextEditingController textEditingKodeReferral = TextEditingController();
  TextEditingController textEditingTglLahir = TextEditingController();
  TextEditingController textEditingAlamat = TextEditingController();
  TextEditingController textEditingKota = TextEditingController();
  TextEditingController textEditingProvince = TextEditingController();
  TextEditingController textEditingCity = TextEditingController();
  TextEditingController textEditingSubdistrict = TextEditingController();
  TextEditingController textEditingUrbanVillage = TextEditingController();
  TextEditingController textEditingProfesi = TextEditingController();
  final formKey = GlobalKey<FormState>();

  PostRegisterByGoogle? postRegisterByGoogle;

  int? selectedProfesi;
  String? selectedNameProfesi;
  bool _isLoading = true;

  Gender? _gender;

  bool validates() {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
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

  void setAddressDetail() {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    setState(() {
      textEditingAlamat = TextEditingController(text: basket['address'] ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    Auth authGoogle = chttp.auth!;
    return WillPopScope(
      onWillPop: () async {
        _handleSignOut();
        setState(() {
          basket['address'] = null;
          basket['postalCode'] = null;
          basket['idProfesi'] = null;
          basket['idProvince'] = null;
          basket['idCity'] = null;
          basket['idSubdistrict'] = null;
          basket['idUrbanVillage'] = null;
          basket['nameProfesi'] = null;
          basket['nameProvince'] = null;
          basket['nameCity'] = null;
          basket['nameSubdistrict'] = null;
          basket['nameUrbanVillage'] = null;
        });
        Navigator.pop(context);
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
                                    color: ColorPalette.neutral_30,
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
                        const Text(
                          'Kode Referal',
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
                            controller: textEditingKodeReferral,
                            cursorColor: ColorPalette.mainColor,
                            onChanged: (value) {
                              setState(() {});
                            },
                            style: const TextStyle(
                              color: ColorPalette.neutral_90,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            decoration: inputDecoration('Masukan Kode'),
                            keyboardType: TextInputType.text),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          'Silahkan masukkan kode referal jika ada',
                          style: TextStyle(
                            fontSize: bodySmall,
                            color: ColorPalette.neutral_60,
                          ),
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
                                text: 'Jenis Kelamin',
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
                        Row(
                          children: [
                            Radio<Gender>(
                              value: Gender.male,
                              groupValue: _gender,
                              activeColor: ColorPalette.darkBlue,
                              onChanged: (value) {
                                setState(() {
                                  _gender = value;
                                });
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8, right: 23),
                              child: Text(
                                'Laki-laki',
                                style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: bodyMedium,
                                    color: ColorPalette.neutral_90,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Radio<Gender>(
                              value: Gender.female,
                              groupValue: _gender,
                              activeColor: ColorPalette.darkBlue,
                              onChanged: (value) {
                                setState(() {
                                  _gender = value;
                                });
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                'Perempuan',
                                style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: bodyMedium,
                                    color: ColorPalette.neutral_90,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
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
                                text: 'Tanggal Lahir',
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: textEditingTglLahir,
                            cursorColor: ColorPalette.mainColor,
                            readOnly: true,
                            onChanged: (value) {
                              setState(() {});
                            },
                            onTap: () {
                              final now = DateTime.now();
                              showDatePicker(
                                context: context,
                                confirmText: "OKE",
                                cancelText: "BATAL",
                                initialDate:
                                    DateTime(now.year - 16, now.month, now.day),
                                firstDate:
                                    DateTime(now.year - 90, now.month, now.day),
                                lastDate:
                                    DateTime(now.year - 16, now.month, now.day),
                                locale: const Locale("id", "ID"),
                                builder: (context, child) {
                                  return Theme(
                                      data: ThemeData(
                                          primaryColor: const MaterialColor(
                                              0xFFEF5696,
                                              ColorPalette.colorList),
                                          colorScheme: ColorScheme.fromSwatch(
                                                  primarySwatch:
                                                      const MaterialColor(
                                                          0xFFEF5696,
                                                          ColorPalette
                                                              .colorList))
                                              .copyWith(
                                                  secondary:
                                                      const MaterialColor(
                                                          0xFFEF5696,
                                                          ColorPalette
                                                              .colorList))),
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
                              color: ColorPalette.neutral_90,
                              fontWeight: FontWeight.w400,
                              fontSize: bodyMedium,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Pilih Tanggal Lahir',
                              contentPadding: const EdgeInsets.only(
                                  left: 12, right: 12, bottom: 8, top: 8),
                              hintStyle: const TextStyle(
                                  color: ColorPalette.neutral_50, fontSize: 14),
                              suffixIcon: IconButton(
                                icon: Image.asset(
                                  'assets/icon/ic_calendar.png',
                                  width: 24.0,
                                  height: 24.0,
                                ),
                                onPressed: () {
                                  final now = DateTime.now();
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  showDatePicker(
                                    context: context,
                                    confirmText: "OKE",
                                    cancelText: "BATAL",
                                    initialDate: DateTime(
                                        now.year - 16, now.month, now.day),
                                    firstDate: DateTime(
                                        now.year - 90, now.month, now.day),
                                    lastDate: DateTime(
                                        now.year - 16, now.month, now.day),
                                    locale: const Locale("id", "ID"),
                                    builder: (context, child) {
                                      return Theme(
                                          data: ThemeData(
                                              primaryColor: const MaterialColor(
                                                  0xFFEF5696,
                                                  ColorPalette.colorList),
                                              colorScheme: ColorScheme.fromSwatch(
                                                      primarySwatch:
                                                          const MaterialColor(
                                                              0xFFEF5696,
                                                              ColorPalette
                                                                  .colorList))
                                                  .copyWith(
                                                      secondary:
                                                          const MaterialColor(
                                                              0xFFEF5696,
                                                              ColorPalette
                                                                  .colorList))),
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
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: ColorPalette.neutral_40),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
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
                                      return "Tanggal lahir tidak boleh kosong";
                                    } else {
                                      return null;
                                    }
                                  },
                            keyboardType: TextInputType.datetime),
                        const SizedBox(
                          height: 16,
                        ),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                                fontSize: 14, fontFamily: 'PlusJakartaSans'),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Alamat Domisili',
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: textEditingAlamat,
                            cursorColor: ColorPalette.mainColor,
                            onChanged: (value) {
                              setState(() {});
                            },
                            readOnly: true,
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const AddressDomicilePage();
                              })).then(
                                  (val) => val ? setAddressDetail() : null);
                            },
                            style: const TextStyle(
                              color: ColorPalette.neutral_90,
                              fontWeight: FontWeight.w400,
                              fontSize: bodyMedium,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Masukan Alamat Domisili',
                              contentPadding: const EdgeInsets.only(
                                  left: 12, right: 12, bottom: 8, top: 8),
                              hintStyle: const TextStyle(
                                  color: ColorPalette.neutral_50, fontSize: 14),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.arrow_forward_ios,
                                    size: 15, color: ColorPalette.neutral_90),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const AddressDomicilePage();
                                  })).then(
                                      (val) => val ? setAddressDetail() : null);
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: ColorPalette.neutral_40),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
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
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                                fontSize: 14, fontFamily: 'PlusJakartaSans'),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Profesi',
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: textEditingProfesi,
                            cursorColor: ColorPalette.mainColor,
                            onChanged: (value) {
                              setState(() {});
                            },
                            readOnly: true,
                            onTap: () {
                              /// Menampilan [ModalBottomSheet] yang berisi list `profesi`.
                              /// User dapat memilih salah satu agar bisa melanjutkan pengisian data.
                              modalProfesi(context);
                            },
                            style: const TextStyle(
                              color: ColorPalette.neutral_90,
                              fontWeight: FontWeight.w400,
                              fontSize: bodyMedium,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Pilih Profesi',
                              contentPadding: const EdgeInsets.only(
                                  left: 12, right: 12, bottom: 8, top: 8),
                              hintStyle: const TextStyle(
                                  color: ColorPalette.neutral_50, fontSize: 14),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.keyboard_arrow_down,
                                    size: 24, color: ColorPalette.neutral_90),
                                onPressed: () {
                                  /// Menampilan [ModalBottomSheet] yang berisi list `profesi`.
                                  /// User dapat memilih salah satu agar bisa melanjutkan pengisian data.
                                  modalProfesi(context);
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: ColorPalette.neutral_40),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
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
                                      return "Profesi tidak boleh kosong";
                                    } else {
                                      return null;
                                    }
                                  },
                            keyboardType: TextInputType.text),
                        const SizedBox(
                          height: 24,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (validates()) {
                              if (_gender == null) {
                                flushbarError(
                                        'Jenis kelamin tidak boleh kosong')
                                    .show(context);
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                                authGoogle
                                    .postRegisterGoogleOne(
                                        textEditingKodeReferral.text,
                                        widget.postRegisterByGoogle!.fullName!,
                                        _gender == Gender.male ? "m" : "f",
                                        textEditingTglLahir.text,
                                        textEditingAlamat.text,
                                        basket['idProvince'],
                                        basket['idCity'],
                                        basket['idSubdistrict'],
                                        basket['idUrbanVillage'],
                                        basket['postalCode'].toString(),
                                        int.parse(
                                            basket['idProfesi'].toString()))
                                    .then((value) {
                                  if (value['status'] == 1) {
                                    setState(() {
                                      _isLoading = true;
                                      postRegisterByGoogle = PostRegisterByGoogle(
                                          kodeReferral:
                                              textEditingKodeReferral.text,
                                          fullName: widget
                                              .postRegisterByGoogle!.fullName,
                                          gender: _gender == Gender.male
                                              ? "m"
                                              : "f",
                                          birthdate: textEditingTglLahir.text,
                                          address: textEditingAlamat.text,
                                          provinceId: basket['idProvince'],
                                          regencyId: basket['idCity'],
                                          subdistrictId:
                                              basket['idSubdistrict'],
                                          urbanVillageId:
                                              basket['idUrbanVillage'],
                                          city: textEditingKota.text,
                                          professionId: int.parse(
                                              basket['idProfesi'].toString()),
                                          postalCode:
                                              basket['postalCode'].toString(),
                                          email: widget
                                              .postRegisterByGoogle!.email,
                                          googleId: widget
                                              .postRegisterByGoogle!.googleId,
                                          token: widget
                                              .postRegisterByGoogle!.token,
                                          username: "",
                                          phone: "",
                                          password: "",
                                          confirmPassword: "",
                                          photo: null);
                                    });
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return RegisterByGoogleLastPage(
                                        postRegisterByGoogle:
                                            postRegisterByGoogle!,
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
                            }
                          },
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: textEditingTglLahir.text.isEmpty ||
                                        textEditingAlamat.text.isEmpty ||
                                        textEditingProfesi.text.isEmpty ||
                                        _gender == null
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
                          ),
                        ),
                        SizedBox(
                          height: Platform.isIOS ? 8 : 0,
                        ),
                      ])))),
    );
  }

  void modalProfesi(BuildContext context) {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    HelperApi helperApi = HelperApi(http: chttp);
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: Container(
                          height: 5,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: ColorPalette.neutral_30),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("Pilih Profesi",
                            style: TextStyle(
                                fontSize: 16,
                                color: ColorPalette.neutral_90,
                                fontWeight: FontWeight.w600)),
                      ),
                      Expanded(
                        flex: 40,
                        child: FutureBuilder<ProfesiModel>(
                            future: helperApi.fetchProfesi(),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                final ProfesiModel profesiModel =
                                    snapshot.data!;
                                if (profesiModel.data!.isEmpty) {
                                  return const Center(
                                    child: EmptyStateWidget(
                                      sizeWidth: 200,
                                      title: 'Oops!',
                                      subTitle: 'Belum Ada Data',
                                    ),
                                  );
                                }
                                return Column(
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        child: Column(
                                          children: [
                                            ...profesiModel.data!
                                                .map((dataProfesi) {
                                              return RadioListTile<int>(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 0),
                                                value: dataProfesi.id!,
                                                groupValue: selectedProfesi,
                                                activeColor:
                                                    ColorPalette.darkBlue,
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                                title: Text(
                                                  dataProfesi.profession!,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: ColorPalette
                                                          .neutral_90,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedProfesi = value;
                                                    selectedNameProfesi =
                                                        dataProfesi.profession;
                                                  });
                                                },
                                              );
                                            }).toList()
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          basket.addAll({
                                            'idProfesi': selectedProfesi,
                                          });
                                          textEditingProfesi.text =
                                              selectedNameProfesi ?? "";
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 70,
                                        padding: const EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            top: 8,
                                            bottom: 8),
                                        decoration: const BoxDecoration(
                                            color: Colors.white),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: ColorPalette.mainColor,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: const Center(
                                            child: Text(
                                              'Pilih',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                if (snapshot.error == 'Update Required') {
                                  return showAlertUpdate(context);
                                } else {
                                  return Center(
                                    child: EmptyStateWidget(
                                      sizeWidth: 200,
                                      title: 'Oops!',
                                      subTitle: snapshot.error.toString(),
                                    ),
                                  );
                                }
                              }
                              return const LoadingWidget();
                            })),
                      ),
                    ]));
          });
        });
  }
}
