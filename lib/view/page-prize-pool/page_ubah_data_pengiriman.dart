import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-auth/page-register/page_address_domicile.dart';
import 'package:isilahtitiktitik/view/widgets/input_decoration_widget.dart';
import 'package:provider/provider.dart';

class UbahDataPengirimanPage extends StatefulWidget {
  const UbahDataPengirimanPage({super.key});

  @override
  State<UbahDataPengirimanPage> createState() => _UbahDataPengirimanPageState();
}

class _UbahDataPengirimanPageState extends State<UbahDataPengirimanPage> {
  TextEditingController textEditingNamaLengkap = TextEditingController();
  TextEditingController textEditingPhone = TextEditingController();
  TextEditingController textEditingAlamat = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    textEditingNamaLengkap = TextEditingController(
        text: basket['receiverName'] ?? auth.currentUser!.data!.user!.fullName);
    textEditingPhone = TextEditingController(
        text: basket['phone'] ?? auth.currentUser!.data!.user!.phone);
    textEditingAlamat = TextEditingController(
        text: basket['address'] ?? auth.currentUser!.data!.user!.address);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setAddressDetail() {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    setState(() {
      var addressDetail =
          basket['address'] ?? auth.currentUser!.data!.user!.address;
      var postalCode =
          basket['postalCode'] ?? auth.currentUser!.data!.user!.postalCode;
      var province =
          basket['nameProvince'] ?? auth.currentUser!.data!.user!.province;
      var city = basket['nameCity'] ?? auth.currentUser!.data!.user!.regency;
      var subdistrict = basket['nameSubdistrict'] ??
          auth.currentUser!.data!.user!.subdistrict;
      var urbanVillage = basket['nameUrbanVillage'] ??
          auth.currentUser!.data!.user!.urbanVillage;
      textEditingAlamat = TextEditingController(
          text: addressDetail ==
                  "$province, $city, $subdistrict, $urbanVillage, $postalCode"
              ? "$addressDetail"
              : '$addressDetail,\n$province, $city, $subdistrict, $urbanVillage $postalCode');
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          basket['receiverName'] = null;
          basket['phone'] = null;
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
          flexibleSpace: const Image(
            image: AssetImage('assets/image/img_background_appbar.png'),
            fit: BoxFit.fitWidth,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Ubah Data Pengiriman',
            style: TextStyle(
                fontSize: titleSmall,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    'Nama Lengkap',
                    style: TextStyle(
                      color: ColorPalette.neutral_90,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
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
                        color: ColorPalette.neutral_90,
                        fontWeight: FontWeight.w400,
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
                    'Nomor HP',
                    style: TextStyle(
                      color: ColorPalette.neutral_90,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: textEditingPhone,
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
                      fillColor: ColorPalette.neutral_20,
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
                              return "Nomor Hp lebih dari 15 angka";
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
                    'Alamat Domisili',
                    style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: bodyMedium,
                        color: ColorPalette.neutral_90,
                        fontWeight: FontWeight.w500),
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
                      readOnly: true,
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const AddressDomicilePage();
                        })).then((val) => val ? setAddressDetail() : null);
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
                            })).then((val) => val ? setAddressDetail() : null);
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
                    height: 32,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (validates()) {
                        setState(() {
                          basket.addAll({
                            'receiverName': textEditingNamaLengkap.text,
                            'phone': textEditingPhone.text
                          });
                        });

                        Navigator.pop(context, true);
                      }
                    },
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: textEditingNamaLengkap.text.isEmpty ||
                                  textEditingAlamat.text.isEmpty
                              ? ColorPalette.neutral_50
                              : ColorPalette.mainColor),
                      child: const Center(
                        child: Text(
                          'Simpan',
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
      ),
    );
  }
}
