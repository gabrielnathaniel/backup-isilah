import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/model/post_register_by_google.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-auth/page-login/page_login_by_email.dart';
import 'package:isilahtitiktitik/view/page-auth/page-register/page_register_by_google.dart';
import 'package:isilahtitiktitik/view/widgets/flushbar_widget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int _current = 0;
  PageController? pageController;
  bool isLoading = true;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  PostRegisterByGoogle? postRegisterByGoogle;

  /// Fungsi ini untuk meng handle [Login with Google] dengan mengirim parameter
  /// `email` dan enkripsi `id google` ke Repository [Auth].
  /// Apabila result [status == 1] akan pindah ke Page [Root]
  /// dan jika result [status != 1] akan pindah ke [RegisterByGooglePage] dengan
  /// menbawa beberapa parameter.
  Future<void> _handleSignIn() async {
    BaseAuth auth = Provider.of<Auth>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final user = await _googleSignIn.signIn();

      if (user != null) {
        setState(() {
          isLoading = false;
        });
        auth
            .loginWithGoogle(user.email, user.id,
                generateMd5("GIS;${user.email};${user.id}"))
            .then((value) {
          if (value!.status == 1) {
            setState(() {
              isLoading = true;
              prefs.setBool("withGoogle", true);
            });

            return Navigator.pushNamedAndRemoveUntil(
                context, '/', (route) => false);
          } else {
            setState(() {
              isLoading = true;
              postRegisterByGoogle = PostRegisterByGoogle(
                  kodeReferral: "",
                  birthdate: "",
                  address: "",
                  city: "",
                  professionId: 0,
                  postalCode: '',
                  phone: "",
                  photo: null,
                  email: user.email,
                  fullName: user.displayName,
                  gender: "",
                  googleId: user.id,
                  token: generateMd5("GIS;${user.email};${user.id}"));
            });
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return RegisterByGooglePage(
                  postRegisterByGoogle: postRegisterByGoogle);
            }));
          }
        }).catchError((onError) {
          setState(() {
            isLoading = true;
          });
          return flushbarError(onError['message']['title']).show(context);
        });
      }
    } catch (error) {
      Logger().e("user : $error");
      return;
    }
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  final List<Map<String, Object>> _list = [
    {
      "title": 'Jawab Quiz dengan Cepat\ndan Tepat',
      "desc":
          'Jam 8 masuk kelas, jam 12 istirahat\njam 5 itu jam pulang, nah itulah jam-jam quiznya,\njangan ampe ketinggalan.',
      "image": 'assets/image/img_intro1.png',
    },
    {
      "title": Platform.isIOS
          ? 'Banyak hal\nyang menarik'
          : 'Dapatkan Hadiah\nyang Menarik',
      "desc": Platform.isIOS
          ? 'Banyak hal yang menarik bisa di lakukan\ndidalam isilah ada quiz, baca funfacts,\ndan banyak hal lainnya.'
          : 'Banyak hal yang menarik bisa di lakukan\ndalam permainan isilah ada quiz\nmini games dan baca funfacts.',
      "image": 'assets/image/img_intro2.png',
    },
    {
      "title": "Ajak Temanmu biar\nMakin Seru",
      "desc":
          "Dengan mengajak teman mu kamu akan\nmendapatkan extra point jika memiliki teman\nyang aktif sama seperti kamu.",
      "image": "assets/image/img_intro3.png",
    },
  ];

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  void nextPage() {
    pageController!.animateToPage(pageController!.page!.toInt() + 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.6,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() => _current = index);
                    },
                  ),
                  items: _list.map((data) {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Center(
                            child: Image.asset(
                              data['image'].toString(),
                              height: 250,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    data['title'].toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        height: 1.5,
                                        color: ColorPalette.neutral_90,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Center(
                                  child: Text(
                                    data['desc'].toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        height: 1.5,
                                        color: ColorPalette.neutral_70),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _list.map((page) {
                    int index = _list.indexOf(page);
                    return Container(
                      width: _current == index ? 24.0 : 10.0,
                      height: 10.0,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _current == index
                              ? ColorPalette.mainColor
                              : ColorPalette.bgDots),
                    );
                  }).toList(),
                ),
              ],
            ),

            Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LoginByEmailPage()));
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: ColorPalette.darkBlue,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Center(
                              child: Text(
                                'Masuk',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: ColorPalette.mainColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Center(
                              child: Text(
                                'Daftar',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'atau',
                  style: TextStyle(
                      fontSize: 12,
                      color: ColorPalette.neutral_80,
                      fontWeight: FontWeight.w400),
                ),
                Platform.isIOS
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          _handleSignIn();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: ColorPalette.neutral_60),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/logo/ic_google.png',
                                width: 24,
                              ),
                              const SizedBox(
                                width: 17,
                              ),
                              const Text(
                                'Login dengan Google',
                                style: TextStyle(
                                  color: ColorPalette.neutral_80,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),

            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Row(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.only(left: 24),
            //         child: GestureDetector(
            //           onTap: () {
            //             Navigator.pushNamed(context, '/login');
            //           },
            //           child: const Text(
            //             'Lewati',
            //             textAlign: TextAlign.center,
            //             style: TextStyle(fontSize: 14),
            //           ),
            //         ),
            //       ),

            //       GestureDetector(
            //         onTap: () {
            //           if (_current < 2) {
            //             setState(() {
            //               _current++;
            //             });
            //             nextPage();
            //           } else {
            //             Navigator.push(context,
            //                 MaterialPageRoute(builder: (context) {
            //               return Platform.isIOS
            //                   ? const LoginByEmailPage()
            //                   : const LoginPage();
            //             }));
            //           }
            //         },
            //         child: Container(
            //           padding: const EdgeInsets.all(8),
            //           width: _current == 2
            //               ? MediaQuery.of(context).size.width * 0.2
            //               : MediaQuery.of(context).size.width * 0.15,
            //           height: 50,
            //           decoration: const BoxDecoration(
            //               color: ColorPalette.mainColor,
            //               borderRadius: BorderRadius.only(
            //                   bottomLeft: Radius.circular(5),
            //                   topLeft: Radius.circular(5))),
            //           child: _current == 2
            //               ? Column(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: const [
            //                     Text(
            //                       'Mulai',
            //                       textAlign: TextAlign.center,
            //                       style: TextStyle(
            //                           fontSize: 14,
            //                           fontWeight: FontWeight.w700,
            //                           color: Colors.white),
            //                     ),
            //                   ],
            //                 )
            //               : const Icon(
            //                   Icons.arrow_forward,
            //                   color: Colors.white,
            //                 ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
