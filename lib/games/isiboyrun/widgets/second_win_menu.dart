import 'dart:convert';
import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:isilahtitiktitik/model/list_game.dart';
import 'package:isilahtitiktitik/resource/game_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';
import 'package:isilahtitiktitik/view/widgets/button_loading_widget.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../game/game.dart';

// This represents the game over overlay,
// displayed with dino runs out of lives.
class SecondWinMenu extends StatefulWidget {
  // An unique identified for this overlay.
  static const id = 'SecondWinMenu';

  // Reference to parent game.
  final RunningGame gameRef;
  final List<LevelGame>? levelGame;

  const SecondWinMenu(this.gameRef, {Key? key, required this.levelGame})
      : super(key: key);

  @override
  State<SecondWinMenu> createState() => _SecondWinMenuState();
}

class _SecondWinMenuState extends State<SecondWinMenu> {
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  bool _isButtonLoading = true;

  List<String> kalahVoices = [
    'assets/audio/eh_nabrak.wav',
    'assets/audio/jaga_jarak_tuh.wav',
    'assets/audio/pelan_pelan_pak_supir.wav',
  ];
  final _random = math.Random();

  final _player = AudioPlayer();

  @override
  void initState() {
    int randomIndex = _random.nextInt(kalahVoices.length);
    String kalahVoice = kalahVoices[randomIndex];
    _player.setAsset(kalahVoice).then((value) {
      _player.play();
    });
    super.initState();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    GameApi gameApi = GameApi(http: chttp);
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.transparent,
          elevation: 0,
          child: Stack(
            children: [
              Center(
                child: Image.asset(
                  'assets/game/UI/Background Kayu - Slamet RUN.png',
                  width: MediaQuery.of(context).size.width * (3 / 4),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/game/UI/kalah.png',
                      width: MediaQuery.of(context).size.width * (1.1 / 4),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Image.asset(
                      'assets/game/UI/20.png',
                      width: MediaQuery.of(context).size.width * (1 / 8),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Image.asset(
                      'assets/game/UI/wordingkalahslametrun.png',
                      width: MediaQuery.of(context).size.width * (2.2 / 4),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    _isButtonLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: Image.asset(
                                  'assets/game/UI/ulang.png',
                                  width: MediaQuery.of(context).size.width / 6,
                                ),
                                onTap: () {
                                  widget.gameRef.overlays
                                      .remove(SecondWinMenu.id);
                                  widget.gameRef.resumeEngine();
                                  widget.gameRef.reset();
                                  widget.gameRef.startGamePlay();
                                },
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              GestureDetector(
                                child: Image.asset(
                                  'assets/game/UI/keluar.png',
                                  width: MediaQuery.of(context).size.width / 6,
                                ),
                                onTap: () async {
                                  setState(() {
                                    _isButtonLoading = false;
                                  });
                                  await gameApi
                                      .postGameResult(
                                          generateMd5(
                                              "GIS:Isilah&game:${basket['idGame'].toString()}&level:${basket['level'].toString()}&results:${basket['result'].toString()}"),
                                          basket['idGame'],
                                          basket['level'],
                                          basket['result'],
                                          basket['start'],
                                          basket['end'])
                                      .then((value) {
                                    widget.gameRef.overlays
                                        .remove(SecondWinMenu.id);
                                    widget.gameRef.reset();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeWidget(
                                            showBanner: false,
                                          ),
                                        ),
                                        (route) => false);
                                    setState(() {
                                      _isButtonLoading = true;
                                    });
                                  }).onError((error, stackTrace) {
                                    Logger().d(error.toString());
                                    setState(() {
                                      _isButtonLoading = true;
                                    });
                                  });
                                },
                              )
                            ],
                          )
                        : const ButtonLoadingWidget(color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
