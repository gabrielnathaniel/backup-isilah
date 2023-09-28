import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/bloc/fun-fact-pantun-bloc/fun_facts_pantun_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/model/fun_fact_pantun.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/view/widgets/background_splash_widget.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  FunFactsPantunBloc funFactsPantunBloc = FunFactsPantunBloc();
  String myPantun = "";
  AnimationController? controller;
  Animation<double>? animation;
  startTime() async {
    Duration duration = const Duration(seconds: 0);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/MyApp');
  }

  @override
  void initState() {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    funFactsPantunBloc.add(GetFunFactsPantun(http: chttp));
    final random = Random();
    myPantun = pantunList[random.nextInt(pantunList.length)];
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller!)
      ..addListener(() {
        setState(() {});
      });
    controller!.forward();
  }

  List<String> pantunList = [
    "Seekor Iguana bisa menghentikan detak jantungnya selama 45 menit",
    "Bunga Udumbara, bunga langka yang konon hanya mekar sekali dalam 3000 tahun.",
    "Buah Matoa merupakan buah yang berasal dari Papua",
    "Seekor semut bisa mengangkat beban sebesar 20 kali lipat dari berat tubuhnya.",
    "Dalam setahun bunga Tulip hanya hanya mekar dalam kurun waktu 1-2 minggu",
    "Gigi termahal di dunia adalah milih Isaac Newton, terjual dengan harga USD 3,633 dan bernilai 10 kali lipat pada masa kini",
    "Manfaat keju baik untuk kesehatan tulang",
    "Laksa Betawi merupakan makanan khas Betawi yang merupakan hasil dari perpaduan dua budaya, yaitu Melayu dan Tiongkok.",
    "Email ditemukan lebih awal dibanding World Wide Web (WWW)!",
    "Car Free Day bukan Hari Gratis Mobil",
  ];

  @override
  void dispose() {
    funFactsPantunBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => funFactsPantunBloc,
      child: Scaffold(
        backgroundColor: ColorPalette.darkBlue,
        body: Stack(
          children: [
            const BackgroundSplashWidget(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/logo/logo_isilah.png',
                    width: 240,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                ),
                _buildFunFactsPantun()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFunFactsPantun() {
    return BlocBuilder<FunFactsPantunBloc, FunFactsPantunState>(
      builder: (context, state) {
        if (state is FunFactsPantunInitial) {
          return Container();
        } else if (state is FunFactsPantunLoading) {
          return Container();
        } else if (state is FunFactsPantunLoaded) {
          if (controller!.value == 1.0) {
            startTime();
          }
          return _buildView(context, state.funFactPantunModel!);
        } else if (state is FunFactsPantunError) {
          if (controller!.value == 1.0) {
            startTime();
          }
          return _buildError();
        } else {
          if (controller!.value == 1.0) {
            startTime();
          }
          return _buildError();
        }
      },
    );
  }

  Widget _buildError() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Center(
            child: Text(
              myPantun,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'PlusJakartaSans',
                  color: Colors.white,
                  height: 1.5,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: ColorPalette.bgLinear,
                borderRadius: BorderRadius.circular(15)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: LinearProgressIndicator(
                value: animation!.value,
                backgroundColor: ColorPalette.bgLinear,
                minHeight: 12,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(ColorPalette.mainColor),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildView(
      BuildContext context, FunFactPantunModel funFactPantunModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Center(
            child: Text(
              funFactPantunModel.data == null
                  ? myPantun
                  : funFactPantunModel.data!.word == null
                      ? myPantun
                      : funFactPantunModel.data!.word!
                          .replaceAll('<p>', "")
                          .replaceAll("</p>", ""),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'PlusJakartaSans',
                  color: Colors.white,
                  height: 1.5,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: ColorPalette.bgLinear,
                borderRadius: BorderRadius.circular(15)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: LinearProgressIndicator(
                value: animation!.value,
                backgroundColor: ColorPalette.bgLinear,
                minHeight: 12,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(ColorPalette.mainColor),
              ),
            ),
          ),
        )
      ],
    );
  }
}
