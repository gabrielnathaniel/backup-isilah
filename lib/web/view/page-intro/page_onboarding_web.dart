// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/web/view/page-auth/page_login_web.dart';

class OnBoardingWebPage extends StatefulWidget {
  const OnBoardingWebPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingWebPage> createState() => _OnBoardingWebPageState();
}

class _OnBoardingWebPageState extends State<OnBoardingWebPage> {
  int _current = 0;
  PageController? pageController;
  List<Widget> pageList = [
    Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/image/img_intro1.png',
              width: 200,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Jawab Quiz dengan\nCepat dan Tepat',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: Text(
                    'Jam 8 masuk kelas, jam 12 istirahat\njam 5 itu jam pulang, nah itulah jam-jam\nquiznya, jangan ampe ketinggalan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
    Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/image/img_intro2.png',
              width: 200,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Dapatkan Hadiah\nyang menarik',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: Text(
                    'Dengan mengajak teman mu kamu akan\nmendapatkan extra star jika memiliki teman\nyang aktif sama seperti kamu.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
    Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/image/img_intro3.png',
              width: 200,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Ajak teman mu biar\nmakin seru',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: Text(
                    'Dengan mengajak teman mu kamu akan\nmendapatkan extra star jika memiliki teman\nyang aktif sama seperti kamu.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
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
        child: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  _current = value;
                });
              },
              itemCount: pageList.length,
              itemBuilder: (context, i) {
                return Stack(
                  children: [
                    pageList[i],
                  ],
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Lewati',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: pageList.map((page) {
                      int index = pageList.indexOf(page);
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
                  )),
                  GestureDetector(
                    onTap: () {
                      if (_current < 2) {
                        setState(() {
                          _current++;
                        });
                        nextPage();
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const LoginWebPage();
                        }));
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: _current == 2
                          ? MediaQuery.of(context).size.width * 0.2
                          : MediaQuery.of(context).size.width * 0.15,
                      height: 50,
                      decoration: const BoxDecoration(
                          color: ColorPalette.mainColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              topLeft: Radius.circular(5))),
                      child: _current == 2
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Mulai',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ],
                            )
                          : const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
