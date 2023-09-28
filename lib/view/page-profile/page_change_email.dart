import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/resource/single_user_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-profile/page_otp_change_email.dart';
import 'package:isilahtitiktitik/view/widgets/button_loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:provider/provider.dart';

class ChangeEmailPage extends StatefulWidget {
  final String? email;
  const ChangeEmailPage({Key? key, @required this.email}) : super(key: key);

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    CHttp chttp = Provider.of(context, listen: false);
    SingleUserApi singleUserApi = SingleUserApi(http: chttp);
    return Scaffold(
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
        title: Text(
          auth.currentUser!.data!.user!.email == null ||
                  auth.currentUser!.data!.user!.email!.isEmpty
              ? 'Tambah Email'
              : 'Ganti Email',
          style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: bodyMedium,
              color: Colors.white,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            Expanded(
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/image/img_otp.png',
                      width: 250,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                          fontSize: 14, fontFamily: 'PlusJakartaSans'),
                      children: <TextSpan>[
                        TextSpan(
                          text: auth.currentUser!.data!.user!.email == null ||
                                  auth.currentUser!.data!.user!.email!.isEmpty
                              ? 'Untuk melanjutkan tambah email, kami akan\nmengirimkan OTP ke email\n'
                              : 'Untuk melanjutkan ganti email, kami akan\nmengirimkan OTP ke email\n',
                          style: const TextStyle(
                              color: ColorPalette.neutral_70,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 1.5),
                        ),
                        TextSpan(
                          text: ' ${widget.email} ',
                          style: const TextStyle(
                              color: ColorPalette.neutral_90,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.5),
                        ),
                      ],
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
                setState(() {
                  isLoading = false;
                });
                singleUserApi.postUpdateEmailOne(widget.email!).then((value) {
                  setState(() {
                    isLoading = true;
                  });
                  if (value['status'] == 0) {
                    flushbarError(value['message']['title']).show(context);
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return OTPChangeEmailPage(email: widget.email);
                    }));
                  }
                }).catchError((onError) {
                  setState(() {
                    isLoading = true;
                  });
                  flushbarError(onError is String
                          ? onError
                          : onError['message']['title'])
                      .show(context);
                });
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorPalette.mainColor),
                child: Center(
                  child: isLoading
                      ? const Text(
                          'Kirim OTP',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : const ButtonLoadingWidget(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
