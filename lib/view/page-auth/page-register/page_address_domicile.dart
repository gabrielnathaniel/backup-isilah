import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/city.dart';
import 'package:isilahtitiktitik/model/province.dart';
import 'package:isilahtitiktitik/model/subdistrict.dart';
import 'package:isilahtitiktitik/model/urban_village.dart';
import 'package:isilahtitiktitik/resource/helper_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/widgets/alert_dialog_update_widget.dart';
import 'package:isilahtitiktitik/view/widgets/button_loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/empty_state.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/input_decoration_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class AddressDomicilePage extends StatefulWidget {
  const AddressDomicilePage({Key? key}) : super(key: key);

  @override
  State<AddressDomicilePage> createState() => _AddressDomicilePageState();
}

class _AddressDomicilePageState extends State<AddressDomicilePage> {
  TextEditingController textEditingProvince = TextEditingController();
  TextEditingController textEditingCity = TextEditingController();
  TextEditingController textEditingSubdistrict = TextEditingController();
  TextEditingController textEditingUrbanVillage = TextEditingController();
  TextEditingController textEditingPostalCode = TextEditingController();
  TextEditingController textEditingAddress = TextEditingController();
  LocationPermission? permission;

  bool isLoadingGps = true;

  int? selectedProvince;
  String? selectedNameProvince;
  int? selectedCity;
  String? selectedNameCity;
  int? selectedSubdistrict;
  String? selectedNameSubdistrict;
  int? selectedUrbanVillage;
  String? selectedNameUrbanVillage;
  String? postalCode;

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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Future.delayed(const Duration(seconds: 0)).then((value) {
        flushbarError("Layanan lokasi dinonaktifkan.").show(context);
      });
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Future.delayed(const Duration(seconds: 0)).then((value) {
          flushbarError("Izin lokasi ditolak").show(context);
        });
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Future.delayed(const Duration(seconds: 0)).then((value) {
        flushbarError(
                "Izin lokasi ditolak secara permanen, kami tidak dapat meminta izin")
            .show(context);
      });
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getPostalCode(String postalCode) async {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    HelperApi helperApi = HelperApi(http: chttp);
    await helperApi.fetchRegionByPostalCode(postalCode).then((region) {
      if (region.status == 0) {
        setState(() {
          isLoadingGps = true;
        });
        flushbarError(region.message!.title!).show(context);
      } else {
        setState(() {
          textEditingProvince =
              TextEditingController(text: region.data!.province);
          textEditingCity = TextEditingController(text: region.data!.regency);
          textEditingSubdistrict =
              TextEditingController(text: region.data!.subdistrict);
          textEditingUrbanVillage =
              TextEditingController(text: region.data!.urbanVillage);
          textEditingPostalCode =
              TextEditingController(text: region.data!.postalCode);

          basket.addAll({
            "postalCode": region.data!.postalCode,
            "idProvince": region.data!.provinceId,
            "idCity": region.data!.regencyId,
            "idSubdistrict": region.data!.subdistrictId,
            "idUrbanVillage": region.data!.urbanVillageId,
            "nameProvince": region.data!.province,
            "nameCity": region.data!.regency,
            "nameSubdistrict": region.data!.subdistrict,
            "nameUrbanVillage": region.data!.urbanVillage,
          });

          selectedProvince = region.data!.provinceId;
          selectedCity = region.data!.regencyId;
          selectedSubdistrict = region.data!.subdistrictId;
          selectedUrbanVillage = region.data!.urbanVillageId;

          if (basket['address'] == region.data!.address) {
            basket.addAll({
              "address": region.data!.address,
            });
            textEditingAddress =
                TextEditingController(text: region.data!.address);
          } else {
            textEditingAddress = TextEditingController(text: basket['address']);
          }
          isLoadingGps = true;
        });
      }
    }).catchError((onError) {
      setState(() {
        isLoadingGps = true;
      });
      flushbarError(onError is String ? onError : onError['message']['title'])
          .show(context);
    });
  }

  @override
  void initState() {
    checkAvailable();
    super.initState();
  }

  void checkAvailable() {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    BaseAuth auth = Provider.of<Auth>(context, listen: false);

    setState(() {
      basket.addAll({
        "postalCode": basket['postalCode'] != null
            ? basket['postalCode']!
            : auth.currentUser == null
                ? null
                : auth.currentUser!.data == null
                    ? null
                    : auth.currentUser!.data!.user!.postalCode,
        "idProvince": basket['idProvince'] != null
            ? basket['idProvince']!
            : auth.currentUser == null
                ? null
                : auth.currentUser!.data == null
                    ? null
                    : auth.currentUser!.data!.user!.provinceId,
        "idCity": basket['idCity'] != null
            ? basket['idCity']!
            : auth.currentUser == null
                ? null
                : auth.currentUser!.data == null
                    ? null
                    : auth.currentUser!.data!.user!.regencyId,
        "idSubdistrict": basket['idSubdistrict'] != null
            ? basket['idSubdistrict']!
            : auth.currentUser == null
                ? null
                : auth.currentUser!.data == null
                    ? null
                    : auth.currentUser!.data!.user!.subdistrictId,
        "idUrbanVillage": basket['idUrbanVillage'] != null
            ? basket['idUrbanVillage']!
            : auth.currentUser == null
                ? null
                : auth.currentUser!.data == null
                    ? null
                    : auth.currentUser!.data!.user!.urbanVillageId,
      });

      selectedProvince = basket['idProvince'] != null
          ? basket['idProvince']!
          : auth.currentUser == null
              ? null
              : auth.currentUser!.data == null
                  ? null
                  : auth.currentUser!.data!.user!.provinceId;
      selectedCity = basket['idCity'] != null
          ? basket['idCity']!
          : auth.currentUser == null
              ? null
              : auth.currentUser!.data == null
                  ? null
                  : auth.currentUser!.data!.user!.regencyId;
      selectedSubdistrict = basket['idSubdistrict'] != null
          ? basket['idSubdistrict']!
          : auth.currentUser == null
              ? null
              : auth.currentUser!.data == null
                  ? null
                  : auth.currentUser!.data!.user!.subdistrictId;
      selectedUrbanVillage = basket['idUrbanVillage'] != null
          ? basket['idUrbanVillage']!
          : auth.currentUser == null
              ? null
              : auth.currentUser!.data == null
                  ? null
                  : auth.currentUser!.data!.user!.urbanVillageId;

      textEditingProvince = TextEditingController(
          text: basket['nameProvince'] != null
              ? basket['nameProvince']!
              : auth.currentUser == null
                  ? ""
                  : auth.currentUser!.data == null
                      ? ""
                      : auth.currentUser!.data!.user!.province);

      textEditingCity = TextEditingController(
          text: basket['nameCity'] != null
              ? basket['nameCity']!
              : auth.currentUser == null
                  ? ""
                  : auth.currentUser!.data == null
                      ? ""
                      : auth.currentUser!.data!.user!.regency);

      textEditingSubdistrict = TextEditingController(
          text: basket['nameSubdistrict'] != null
              ? basket['nameSubdistrict']!
              : auth.currentUser == null
                  ? ""
                  : auth.currentUser!.data == null
                      ? ""
                      : auth.currentUser!.data!.user!.subdistrict);

      textEditingUrbanVillage = TextEditingController(
          text: basket['nameUrbanVillage'] != null
              ? basket['nameUrbanVillage']!
              : auth.currentUser == null
                  ? ""
                  : auth.currentUser!.data == null
                      ? ""
                      : auth.currentUser!.data!.user!.urbanVillage);

      textEditingPostalCode = TextEditingController(
          text: basket['postalCode'] != null
              ? basket['postalCode']!
              : auth.currentUser == null
                  ? ""
                  : auth.currentUser!.data == null
                      ? ""
                      : auth.currentUser!.data!.user!.postalCode);

      textEditingAddress = TextEditingController(
          text: basket['address'] != null
              ? basket['address']!
              : auth.currentUser == null
                  ? ""
                  : auth.currentUser!.data == null
                      ? ""
                      : auth.currentUser!.data!.user!.address);
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
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
          basket['nameProfesi'] = null;
          basket['nameProvince'] = null;
          basket['nameCity'] = null;
          basket['nameSubdistrict'] = null;
          basket['nameUrbanVillage'] = null;
        });
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: const IconThemeData(
            color: ColorPalette.neutral_90,
          ),
          title: const Text(
            'Alamat Domisili',
            style: TextStyle(
                fontSize: 14,
                color: ColorPalette.neutral_90,
                fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isLoadingGps = false;
                    });
                    _determinePosition().then((location) async {
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                              location.latitude, location.longitude);

                      await getPostalCode(placemarks[0].postalCode!);
                    }).catchError((onError) {
                      setState(() {
                        isLoadingGps = true;
                      });
                    });
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(
                            width: 1, color: ColorPalette.mainColor)),
                    child: isLoadingGps
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icon/ic_gps.png',
                                width: 20,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Text(
                                'Gunakan Lokasi Saat Ini',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ColorPalette.mainColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : const ButtonLoadingWidget(
                            color: ColorPalette.mainColor),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                RichText(
                  text: const TextSpan(
                    style:
                        TextStyle(fontSize: 14, fontFamily: 'PlusJakartaSans'),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Provinsi',
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
                    controller: textEditingProvince,
                    cursorColor: ColorPalette.mainColor,
                    onChanged: (value) {
                      setState(() {});
                    },
                    readOnly: true,
                    onTap: () {
                      /// Menampilan [ModalBottomSheet] yang berisi list `Provinsi`.
                      /// User dapat memilih salah satu agar bisa melanjutkan pengisian data.
                      modalRegion(context, 'province');
                    },
                    style: const TextStyle(
                      color: ColorPalette.neutral_90,
                      fontWeight: FontWeight.w400,
                      fontSize: bodyMedium,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Pilih Provinsi',
                      contentPadding: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 8, top: 8),
                      hintStyle: const TextStyle(
                          color: ColorPalette.neutral_50, fontSize: 14),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down,
                            size: 24, color: ColorPalette.neutral_90),
                        onPressed: () {
                          /// Menampilan [ModalBottomSheet] yang berisi list `Provinsi`.
                          /// User dapat memilih salah satu agar bisa melanjutkan pengisian data.
                          modalRegion(context, 'province');
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
                    validator: Platform.isIOS
                        ? null
                        : (val) {
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
                RichText(
                  text: const TextSpan(
                    style:
                        TextStyle(fontSize: 14, fontFamily: 'PlusJakartaSans'),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Kota/Kabupaten',
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
                    controller: textEditingCity,
                    cursorColor: ColorPalette.mainColor,
                    onChanged: (value) {
                      setState(() {});
                    },
                    readOnly: true,
                    onTap: () {
                      /// Menampilan [ModalBottomSheet] yang berisi list `Kota/Kabupaten`.
                      /// User dapat memilih salah satu agar bisa melanjutkan pengisian data.
                      /// User harus memilih `Provinsi` terlebih dahulu.
                      if (basket['idProvince'] == null) {
                        flushbarError('Anda belum memilih Provinsi')
                            .show(context);
                      } else {
                        modalRegion(context, 'city');
                      }
                    },
                    style: const TextStyle(
                      color: ColorPalette.neutral_90,
                      fontWeight: FontWeight.w400,
                      fontSize: bodyMedium,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Pilih Kota / Kabupaten',
                      contentPadding: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 8, top: 8),
                      hintStyle: const TextStyle(
                          color: ColorPalette.neutral_50, fontSize: 14),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down,
                            size: 24, color: ColorPalette.neutral_90),
                        onPressed: () {
                          /// Menampilan [ModalBottomSheet] yang berisi list `Kota/Kabupaten`.
                          /// User dapat memilih salah satu agar bisa melanjutkan pengisian data.
                          /// User harus memilih `Provinsi` terlebih dahulu.
                          if (basket['idProvince'] == null) {
                            flushbarError('Anda belum memilih Provinsi')
                                .show(context);
                          } else {
                            modalRegion(context, 'city');
                          }
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
                    validator: Platform.isIOS
                        ? null
                        : (val) {
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
                RichText(
                  text: const TextSpan(
                    style:
                        TextStyle(fontSize: 14, fontFamily: 'PlusJakartaSans'),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Kecamatan',
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
                    controller: textEditingSubdistrict,
                    cursorColor: ColorPalette.mainColor,
                    onChanged: (value) {
                      setState(() {});
                    },
                    readOnly: true,
                    onTap: () {
                      /// Menampilan [ModalBottomSheet] yang berisi list `Kecamatan`.
                      /// User dapat memilih salah satu agar bisa melanjutkan pengisian data.
                      /// User harus memilih `Kota/Kabupaten` terlebih dahulu.
                      if (basket['idCity'] == null) {
                        flushbarError('Anda belum memilih Kota/Kabupaten')
                            .show(context);
                      } else {
                        modalRegion(context, 'subdistrict');
                      }
                    },
                    style: const TextStyle(
                      color: ColorPalette.neutral_90,
                      fontWeight: FontWeight.w400,
                      fontSize: bodyMedium,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Pilih Kecamatan',
                      contentPadding: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 8, top: 8),
                      hintStyle: const TextStyle(
                          color: ColorPalette.neutral_50, fontSize: 14),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down,
                            size: 24, color: ColorPalette.neutral_90),
                        onPressed: () {
                          /// Menampilan [ModalBottomSheet] yang berisi list `Kecamatan`.
                          /// User dapat memilih salah satu agar bisa melanjutkan pengisian data.
                          /// User harus memilih `Kota/Kabupaten` terlebih dahulu.
                          if (basket['idCity'] == null) {
                            flushbarError('Anda belum memilih Kota/Kabupaten')
                                .show(context);
                          } else {
                            modalRegion(context, 'subdistrict');
                          }
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
                    validator: Platform.isIOS
                        ? null
                        : (val) {
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
                RichText(
                  text: const TextSpan(
                    style:
                        TextStyle(fontSize: 14, fontFamily: 'PlusJakartaSans'),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Kelurahan',
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
                    controller: textEditingUrbanVillage,
                    cursorColor: ColorPalette.mainColor,
                    onChanged: (value) {
                      setState(() {});
                    },
                    readOnly: true,
                    onTap: () {
                      /// Menampilan [ModalBottomSheet] yang berisi list `Kelurahan`.
                      /// User dapat memilih salah satu agar bisa melanjutkan pengisian data.
                      /// User harus memilih `Kecamatan` terlebih dahulu.
                      if (basket['idSubdistrict'] == null) {
                        flushbarError('Anda belum memilih Kelurahan')
                            .show(context);
                      } else {
                        modalRegion(context, 'urban-village');
                      }
                    },
                    style: const TextStyle(
                      color: ColorPalette.neutral_90,
                      fontWeight: FontWeight.w400,
                      fontSize: bodyMedium,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Pilih Kelurahan',
                      contentPadding: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 8, top: 8),
                      hintStyle: const TextStyle(
                          color: ColorPalette.neutral_50, fontSize: 14),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down,
                            size: 24, color: ColorPalette.neutral_90),
                        onPressed: () {
                          //// Menampilan [ModalBottomSheet] yang berisi list `Kelurahan`.
                          /// User dapat memilih salah satu agar bisa melanjutkan pengisian data.
                          /// User harus memilih `Kecamatan` terlebih dahulu.
                          if (basket['idSubdistrict'] == null) {
                            flushbarError('Anda belum memilih Kelurahan')
                                .show(context);
                          } else {
                            modalRegion(context, 'urban-village');
                          }
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
                    validator: Platform.isIOS
                        ? null
                        : (val) {
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
                RichText(
                  text: const TextSpan(
                    style:
                        TextStyle(fontSize: 14, fontFamily: 'PlusJakartaSans'),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Kode Pos',
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
                  controller: textEditingPostalCode,
                  cursorColor: ColorPalette.mainColor,
                  onChanged: (value) {
                    setState(() {});
                  },
                  readOnly: true,
                  style: const TextStyle(
                    color: ColorPalette.neutral_90,
                    fontWeight: FontWeight.w400,
                    fontSize: bodyMedium,
                  ),
                  decoration: inputDecoration('Masukan Kode Pos'),
                  keyboardType: TextInputType.number,
                  validator: Platform.isIOS
                      ? null
                      : (val) {
                          if (val!.isEmpty) {
                            return "Kode Pos tidak boleh kosong";
                          } else {
                            return null;
                          }
                        },
                ),
                const SizedBox(
                  height: 16,
                ),
                RichText(
                  text: const TextSpan(
                    style:
                        TextStyle(fontSize: 14, fontFamily: 'PlusJakartaSans'),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Detail Alamat',
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
                  height: 10,
                ),
                TextFormField(
                    controller: textEditingAddress,
                    cursorColor: ColorPalette.mainColor,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: const TextStyle(
                      color: ColorPalette.neutral_90,
                      fontWeight: FontWeight.w400,
                      fontSize: bodyMedium,
                    ),
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Masukkan Nama Jalan, Gedung, No. Rumah',
                      contentPadding: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 18, top: 18),
                      hintStyle: const TextStyle(
                          color: ColorPalette.neutral_50, fontSize: 14),
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
                    maxLines: 3,
                    minLines: null,
                    keyboardType: TextInputType.multiline),
                const SizedBox(
                  height: 32,
                ),
                GestureDetector(
                  onTap: () {
                    if (validates()) {
                      setState(() {
                        basket.addAll({
                          "address": textEditingAddress.text.isEmpty
                              ? "${textEditingProvince.text}, ${textEditingCity.text}, ${textEditingSubdistrict.text}, ${textEditingUrbanVillage.text}, ${textEditingPostalCode.text}"
                              : textEditingAddress.text
                        });
                      });

                      Navigator.pop(context, true);
                    }
                  },
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: textEditingProvince.text.isEmpty ||
                                textEditingCity.text.isEmpty ||
                                textEditingSubdistrict.text.isEmpty ||
                                textEditingUrbanVillage.text.isEmpty ||
                                textEditingPostalCode.text.isEmpty
                            ? ColorPalette.neutral_50
                            : ColorPalette.mainColor),
                    child: const Center(
                      child: Text(
                        'Simpan Alamat',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget ini berfungsi untuk menampilkan list `provinsi`, `kota/kabupaten`,
  /// `kecamatan`, dan `kelurahan` yang didapat dari API.
  void modalRegion(BuildContext context, String typeRegion) {
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
                Padding(
                  padding: const EdgeInsets.all(16),
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
                          fontSize: 16,
                          color: ColorPalette.neutral_90,
                          fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  flex: 40,
                  child: typeRegion == "province"
                      ? FutureBuilder<ProvinceModel>(
                          future: helperApi.fetchProvince(),
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              final ProvinceModel provinceModel =
                                  snapshot.data!;
                              if (provinceModel.data!.isEmpty) {
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
                                          ...provinceModel.data!
                                              .map((dataProvince) {
                                            return RadioListTile<int>(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 0),
                                              value: dataProvince.id!,
                                              groupValue: selectedProvince,
                                              activeColor:
                                                  ColorPalette.darkBlue,
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              title: Text(
                                                dataProvince.province!,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        ColorPalette.neutral_90,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedProvince = value;
                                                  selectedNameProvince =
                                                      dataProvince.province;
                                                });
                                              },
                                            );
                                          }).toList()
                                        ],
                                      ),
                                    ),
                                  ),
                                  _buildButtonSave(typeRegion)
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
                          }))
                      : typeRegion == "city"
                          ? FutureBuilder<CityModel>(
                              future: helperApi.fetchCity(basket['idProvince']),
                              builder: ((context, snapshot) {
                                if (snapshot.hasData) {
                                  final CityModel cityModel = snapshot.data!;
                                  if (cityModel.data!.isEmpty) {
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
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Column(
                                            children: [
                                              ...cityModel.data!
                                                  .map((dataCity) {
                                                return RadioListTile<int>(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 0),
                                                  value: dataCity.id!,
                                                  groupValue: selectedCity,
                                                  activeColor:
                                                      ColorPalette.darkBlue,
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .leading,
                                                  title: Text(
                                                    dataCity.regency!,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: ColorPalette
                                                            .neutral_90,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedCity = value;
                                                      selectedNameCity =
                                                          dataCity.regency;
                                                    });
                                                  },
                                                );
                                              }).toList()
                                            ],
                                          ),
                                        ),
                                      ),
                                      _buildButtonSave(typeRegion)
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
                              }))
                          : typeRegion == "subdistrict"
                              ? FutureBuilder<SubdistrictModel>(
                                  future: helperApi
                                      .fetchSubdistrict(basket['idCity']),
                                  builder: ((context, snapshot) {
                                    if (snapshot.hasData) {
                                      final SubdistrictModel subdistrictModel =
                                          snapshot.data!;
                                      if (subdistrictModel.data!.isEmpty) {
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
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              child: Column(
                                                children: [
                                                  ...subdistrictModel.data!
                                                      .map((dataSubdistrict) {
                                                    return RadioListTile<int>(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 8,
                                                              vertical: 0),
                                                      value:
                                                          dataSubdistrict.id!,
                                                      groupValue:
                                                          selectedSubdistrict,
                                                      activeColor:
                                                          ColorPalette.darkBlue,
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading,
                                                      title: Text(
                                                        dataSubdistrict
                                                            .subdistrict!,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: ColorPalette
                                                                .neutral_90,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedSubdistrict =
                                                              value;
                                                          selectedNameSubdistrict =
                                                              dataSubdistrict
                                                                  .subdistrict;
                                                        });
                                                      },
                                                    );
                                                  }).toList()
                                                ],
                                              ),
                                            ),
                                          ),
                                          _buildButtonSave(typeRegion)
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
                                  }))
                              : FutureBuilder<UrbanVillageModel>(
                                  future: helperApi.fetchUrbanVillage(
                                      basket['idSubdistrict']),
                                  builder: ((context, snapshot) {
                                    if (snapshot.hasData) {
                                      final UrbanVillageModel
                                          urbanVillageModel = snapshot.data!;
                                      if (urbanVillageModel.data!.isEmpty) {
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
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              child: Column(
                                                children: [
                                                  ...urbanVillageModel.data!
                                                      .map((dataUrbanVillage) {
                                                    return RadioListTile<int>(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 8,
                                                              vertical: 0),
                                                      value:
                                                          dataUrbanVillage.id!,
                                                      groupValue:
                                                          selectedUrbanVillage,
                                                      activeColor:
                                                          ColorPalette.darkBlue,
                                                      controlAffinity:
                                                          ListTileControlAffinity
                                                              .leading,
                                                      title: Text(
                                                        dataUrbanVillage
                                                            .urbanVillage!,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: ColorPalette
                                                                .neutral_90,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedUrbanVillage =
                                                              value;
                                                          selectedNameUrbanVillage =
                                                              dataUrbanVillage
                                                                  .urbanVillage;
                                                          postalCode =
                                                              dataUrbanVillage
                                                                  .postalCode;
                                                        });
                                                      },
                                                    );
                                                  }).toList()
                                                ],
                                              ),
                                            ),
                                          ),
                                          _buildButtonSave(typeRegion)
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
              ],
            ),
          );
        });
      },
    ).whenComplete(() {
      setState(() {});
    });
  }

  Widget _buildButtonSave(String typeRegion) {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    return GestureDetector(
      onTap: () {
        if (typeRegion == 'province') {
          if (selectedProvince != null) {
            setState(() {
              basket.addAll({
                'idProvince': selectedProvince,
                'nameProvince': selectedNameProvince,
              });
              textEditingProvince.text = selectedNameProvince ?? "";
              basket['idCity'] = null;
              basket['idSubdistrict'] = null;
              basket['idUrbanVillage'] = null;
              basket['nameCity'] = null;
              basket['nameSubdistrict'] = null;
              basket['nameUrbanVillage'] = null;
              textEditingCity.text = '';
              textEditingSubdistrict.text = '';
              textEditingUrbanVillage.text = '';
            });
          }
        }
        if (typeRegion == 'city') {
          if (selectedCity != null) {
            setState(() {
              basket.addAll({
                'idCity': selectedCity,
                'nameCity': selectedNameCity,
              });
              basket['idSubdistrict'] = null;
              basket['idUrbanVillage'] = null;
              basket['nameSubdistrict'] = null;
              basket['nameUrbanVillage'] = null;
              textEditingSubdistrict.text = '';
              textEditingUrbanVillage.text = '';
              textEditingCity.text = selectedNameCity!;
            });
          }
        }
        if (typeRegion == 'subdistrict') {
          if (selectedSubdistrict != null) {
            setState(() {
              basket.addAll({
                'idSubdistrict': selectedSubdistrict,
                'nameSubdistrict': selectedNameSubdistrict,
              });
              basket['idUrbanVillage'] = null;
              basket['nameUrbanVillage'] = null;
              basket['postalCode'] = null;
              textEditingUrbanVillage.text = '';
              textEditingPostalCode.text = '';
              textEditingSubdistrict.text = selectedNameSubdistrict ?? "";
            });
          }
        }
        if (typeRegion == 'urban-village') {
          if (selectedUrbanVillage != null) {
            setState(() {
              basket.addAll({
                'idUrbanVillage': selectedUrbanVillage,
                'nameUrbanVillage': selectedNameUrbanVillage,
                'postalCode': postalCode,
              });
              textEditingUrbanVillage.text = selectedNameUrbanVillage ?? "";
              textEditingPostalCode.text = postalCode ?? "";
            });
          }
        }
        Navigator.pop(context);
      },
      child: Container(
        height: 70,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        decoration: const BoxDecoration(color: Colors.white),
        child: Container(
          decoration: BoxDecoration(
              color: ColorPalette.mainColor,
              borderRadius: BorderRadius.circular(8)),
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
    );
  }
}
