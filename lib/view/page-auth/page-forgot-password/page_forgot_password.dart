import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-auth/page-forgot-password/page_verify_otp_password.dart';
import 'package:isilahtitiktitik/view/widgets/button_loading_widget.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:isilahtitiktitik/view/widgets/input_decoration_widget.dart';
import 'package:provider/provider.dart';

/// Apabila user lupa password, user dapat me reset password nya di page ini.
/// Dimana user dapat mengisi `email` yang nantinya akan di kirim melalui [API].
/// Jika response status berhasil, akan pindah ke page [VerifyOtpPasswordPage].
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final textEditingEmail = TextEditingController();
  final regExp = RegExp(
      "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$");

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: ColorPalette.neutral_90),
      ),
      body: _buildSendEmail(),
    );
  }

  Widget _buildSendEmail() {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    Auth auth = chttp.auth!;
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Center(
                  child: Image.asset(
                    'assets/image/img_forgot_password.png',
                    width: 180,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                const Center(
                  child: Text(
                    'Lupa Password',
                    style: TextStyle(
                        fontSize: 24,
                        color: ColorPalette.neutral_90,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Center(
                  child: Text(
                    'Masukkan email yang terhubung dengan akun\nkamu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: ColorPalette.neutral_70,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorPalette.neutral_70,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: textEditingEmail,
                  cursorColor: ColorPalette.mainColor,
                  onChanged: (value) {
                    setState(() {});
                  },
                  style: const TextStyle(
                    color: ColorPalette.neutral_90,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                  decoration: inputDecoration('Masukan Email'),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Email tidak boleh kosong";
                    } else if (!regExp.hasMatch(val)) {
                      return "Format email salah";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: () {
                    if (validates()) {
                      setState(() {
                        _isLoading = false;
                      });

                      /// Fungsi ini untuk memvalidasi apakah `email` yang di isi user
                      /// tersedia di dalam database atau tidak. Jika tersedia, akan
                      /// pindah ke page [VerifyOtpPasswordPage].
                      auth.forgotPassword(textEditingEmail.text).then((value) {
                        if (value['status'] == 1) {
                          setState(() {
                            _isLoading = true;
                          });
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return VerifyOTPPasswordPage(
                                email: textEditingEmail.text);
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
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: textEditingEmail.text.isEmpty
                            ? ColorPalette.neutral_50
                            : ColorPalette.mainColor),
                    child: Center(
                      child: _isLoading
                          ? const Text(
                              'Kirim',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : const ButtonLoadingWidget(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                          fontSize: 14, fontFamily: 'PlusJakartaSans'),
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Kamu inget passwordnya ? ',
                          style: TextStyle(
                            color: ColorPalette.neutral_90,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                          text: 'Masuk Sekarang',
                          style: const TextStyle(
                            color: ColorPalette.mainColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
