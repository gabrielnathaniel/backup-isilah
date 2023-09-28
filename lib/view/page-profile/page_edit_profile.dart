import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/model/profesi.dart';
import 'package:isilahtitiktitik/resource/helper_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-auth/page-register/page_address_domicile.dart';
import 'package:isilahtitiktitik/view/widgets/alert_dialog_update_widget.dart';
import 'package:isilahtitiktitik/view/widgets/empty_state.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/success_state_widget.dart';
import 'package:isilahtitiktitik/view/widgets/button_loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/input_decoration_widget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

enum Gender { male, female }

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController textEditingNamaLengkap = TextEditingController();
  TextEditingController textEditingTglLahir = TextEditingController();
  TextEditingController textEditingAlamat = TextEditingController();
  TextEditingController textEditingProfesi = TextEditingController();
  TextEditingController textEditingInstagram = TextEditingController();
  TextEditingController textEditingFacebook = TextEditingController();
  TextEditingController textEditingTwitter = TextEditingController();
  TextEditingController textEditingNoHp = TextEditingController();

  Gender? _gender;

  final ImagePicker _picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  XFile? foto;
  bool _isLoading = true;

  int? selectedProfesi;
  String? selectedNameProfesi;

  bool validates() {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void setAddressDetail() {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    setState(() {
      textEditingAlamat = TextEditingController(
          text: basket['address'] ?? auth.currentUser!.data!.user!.address);
    });
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  void _initData() async {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    setState(() {
      textEditingNamaLengkap =
          TextEditingController(text: auth.currentUser!.data!.user!.fullName);
      if (auth.currentUser!.data!.user!.gender == "m") {
        _gender = Gender.male;
      } else {
        _gender = Gender.female;
      }
      textEditingTglLahir =
          TextEditingController(text: auth.currentUser!.data!.user!.birthdate);
      textEditingNoHp =
          TextEditingController(text: auth.currentUser!.data!.user!.phone);
      textEditingAlamat =
          TextEditingController(text: auth.currentUser!.data!.user!.address);
      textEditingProfesi =
          TextEditingController(text: auth.currentUser!.data!.user!.profession);
      textEditingInstagram =
          TextEditingController(text: auth.currentUser!.data!.user!.socmedIg);
      textEditingFacebook =
          TextEditingController(text: auth.currentUser!.data!.user!.socmedFb);
      textEditingTwitter =
          TextEditingController(text: auth.currentUser!.data!.user!.socmedTw);

      basket['idProvince'] = auth.currentUser!.data!.user!.provinceId;
      basket['idCity'] = auth.currentUser!.data!.user!.regencyId;
      basket['idSubdistrict'] = auth.currentUser!.data!.user!.subdistrictId;
      basket['idUrbanVillage'] = auth.currentUser!.data!.user!.urbanVillageId;
      basket['idProfesi'] = auth.currentUser!.data!.user!.professionId;
      selectedProfesi = auth.currentUser!.data!.user!.professionId;
      basket['postalCode'] = auth.currentUser!.data!.user!.postalCode;
      basket['address'] = auth.currentUser!.data!.user!.address;
    });
  }

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
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    CHttp chttp = Provider.of(context, listen: false);
    Auth authPut = chttp.auth!;
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
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
            'Ubah Profil',
            style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: bodyMedium,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(defaultPadding),
            physics: const BouncingScrollPhysics(),
            child: auth.currentUser == null
                ? Container()
                : Form(
                    key: formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          foto == null
                              ? GestureDetector(
                                  onTap: () {
                                    _pickImages();
                                  },
                                  child: Center(
                                    child: SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: CachedNetworkImage(
                                                imageUrl: imageUrl +
                                                    auth.currentUser!.data!
                                                        .user!.photo!,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                            Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Container(
                                                    color: Colors.white,
                                                    width: 120,
                                                    height: 120,
                                                  ),
                                                )),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child: Image.asset(
                                                          "assets/image/default_profile.png",
                                                          fit: BoxFit.cover,
                                                          width: 120,
                                                          height: 120,
                                                        )),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              width: 120,
                                              height: 120,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.black38),
                                            ),
                                          ),
                                          Center(
                                            child: Image.asset(
                                              'assets/icon/ic_folder.png',
                                              width: 30,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    _pickImages();
                                  },
                                  child: Center(
                                    child: SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: FadeInImage(
                                                  fit: BoxFit.cover,
                                                  height: 120,
                                                  width: 120,
                                                  image: FileImage(
                                                      File(foto!.path)),
                                                  placeholder: const AssetImage(
                                                    "assets/image/default_profile.png",
                                                  )),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              width: 120,
                                              height: 120,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.black38),
                                            ),
                                          ),
                                          Center(
                                            child: Image.asset(
                                              'assets/icon/ic_folder.png',
                                              width: 30,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 24,
                          ),
                          const Text(
                            'Nama Lengkap',
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: textEditingNamaLengkap,
                              cursorColor: ColorPalette.mainColor,
                              onChanged: (value) {
                                setState(() {});
                              },
                              style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: bodyMedium,
                                  color: ColorPalette.neutral_90,
                                  fontWeight: FontWeight.w500),
                              decoration:
                                  inputDecoration('Masukan Nama Lengkap'),
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
                                fontFamily: 'PlusJakartaSans',
                                fontSize: bodyMedium,
                                color: ColorPalette.neutral_90,
                                fontWeight: FontWeight.w500),
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
                            height: 25,
                          ),
                          const Text(
                            'Tanggal Lahir',
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
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                showDatePicker(
                                  context: context,
                                  confirmText: "OKE",
                                  cancelText: "BATAL",
                                  initialDate:
                                      DateTime(now.year, now.month, now.day),
                                  firstDate: DateTime(
                                      now.year - 90, now.month, now.day),
                                  lastDate:
                                      DateTime(now.year, now.month, now.day),
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
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: bodyMedium,
                                  color: ColorPalette.neutral_90,
                                  fontWeight: FontWeight.w500),
                              decoration:
                                  inputDecoration('Masukan Tanggal Lahir'),
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
                            'Nomor HP',
                            style: TextStyle(
                                fontSize: bodyMedium,
                                color: ColorPalette.neutral_90,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            readOnly: true,
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
                                borderSide: const BorderSide(
                                    color: ColorPalette.neutral_40),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            keyboardType: TextInputType.number,
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
                                    color: ColorPalette.neutral_50,
                                    fontSize: 14),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios,
                                      size: 15, color: ColorPalette.neutral_90),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const AddressDomicilePage();
                                    })).then((val) =>
                                        val ? setAddressDetail() : null);
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
                          const Text(
                            'Profesi',
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: textEditingProfesi,
                              cursorColor: ColorPalette.mainColor,
                              onChanged: (value) {
                                setState(() {});
                              },
                              readOnly: true,
                              onTap: () {
                                modalProfesi(context);
                              },
                              style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: bodyMedium,
                                  color: ColorPalette.neutral_90,
                                  fontWeight: FontWeight.w400),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Pilih Profesi',
                                contentPadding: const EdgeInsets.only(
                                    left: 12, right: 12, bottom: 8, top: 8),
                                hintStyle: const TextStyle(
                                    color: ColorPalette.neutral_50,
                                    fontSize: 14),
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
                                fontFamily: 'PlusJakartaSans',
                                fontSize: bodyMedium,
                                color: ColorPalette.neutral_90,
                                fontWeight: FontWeight.w500),
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
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: bodyMedium,
                                  color: ColorPalette.neutral_90,
                                  fontWeight: FontWeight.w500),
                              decoration: inputDecoration('Optional'),
                              keyboardType: TextInputType.text),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'Facebook',
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
                              controller: textEditingFacebook,
                              cursorColor: ColorPalette.mainColor,
                              onChanged: (value) {
                                setState(() {});
                              },
                              style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: bodyMedium,
                                  color: ColorPalette.neutral_90,
                                  fontWeight: FontWeight.w500),
                              decoration: inputDecoration('Optional'),
                              keyboardType: TextInputType.text),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'Twitter',
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
                              controller: textEditingTwitter,
                              cursorColor: ColorPalette.mainColor,
                              onChanged: (value) {
                                setState(() {});
                              },
                              style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: bodyMedium,
                                  color: ColorPalette.neutral_90,
                                  fontWeight: FontWeight.w500),
                              decoration: inputDecoration('Optional'),
                              keyboardType: TextInputType.text),
                          const SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (validates()) {
                                setState(() {
                                  _isLoading = false;
                                });
                                authPut
                                    .putProfile(
                                        textEditingNamaLengkap.text,
                                        _gender == Gender.male ? "m" : "f",
                                        textEditingTglLahir.text,
                                        textEditingAlamat.text,
                                        basket['idProvince'],
                                        basket['idCity'],
                                        basket['idSubdistrict'],
                                        basket['idUrbanVillage'],
                                        "",
                                        basket['idProfesi'] ??
                                            auth.currentUser!.data!.user!
                                                .professionId,
                                        foto,
                                        textEditingFacebook.text,
                                        textEditingInstagram.text,
                                        textEditingTwitter.text)
                                    .then((value) {
                                  if (value!.status == 1) {
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
                                      _isLoading = true;
                                    });
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const SuccessStateWidget(
                                          assets:
                                              'assets/image/img_verify_success.png',
                                          title: 'Profile diubah',
                                          content:
                                              'Selamat profile kamu berhasil di rubah');
                                    }));
                                  } else {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    flushbarError(value.message!.title!)
                                        .show(context);
                                  }
                                }).catchError((onError) {
                                  Logger().d(onError);
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
                                  borderRadius: BorderRadius.circular(10),
                                  color: textEditingNamaLengkap.text.isEmpty ||
                                          textEditingTglLahir.text.isEmpty ||
                                          textEditingAlamat.text.isEmpty ||
                                          textEditingProfesi.text.isEmpty
                                      ? ColorPalette.neutral_50
                                      : ColorPalette.mainColor),
                              child: Center(
                                child: _isLoading
                                    ? const Text(
                                        'Simpan',
                                        style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: bodyMedium,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      )
                                    : const ButtonLoadingWidget(
                                        color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ]))),
      ),
    );
  }

  /// Widget ini berfungsi untuk menampilkan data list `profesi` yang di ambil dari
  /// API.
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

//   Widget customRadioButtonGender(int index) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _gender = index;
//         });
//       },
//       child: Container(
//         width: 18,
//         height: 18,
//         decoration: BoxDecoration(
//           border: Border.all(
//             width: 1,
//             color: _gender == index
//                 ? ColorPalette.mainColor
//                 : ColorPalette.neutral_50,
//           ),
//           borderRadius: BorderRadius.circular(18),
//           color: _gender == index ? ColorPalette.mainColor : Colors.white,
//         ),
//       ),
//     );
//   }
}
