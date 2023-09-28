import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:isilahtitiktitik/games/tariktambang/game/game.dart';
import 'package:isilahtitiktitik/model/list_game.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';
import 'package:isilahtitiktitik/view/widgets/button_loading_widget.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../../resource/game_api.dart';
import '../../../../utils/api_helper.dart';

class GameOverMenu extends StatefulWidget {
  static const String id = 'GameOverMenu';
  final TarikTambangGame gameRef;
  final LevelGame? levelGame;

  final int idGame;
  final int level;
  final int result;
  final String start;
  final String end;

  const GameOverMenu(this.idGame, this.level, this.result, this.start, this.end,
      {Key? key, required this.gameRef, required this.levelGame})
      : super(key: key);

  @override
  State<GameOverMenu> createState() => _GameOverMenuState();
}

class _GameOverMenuState extends State<GameOverMenu> {
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  bool _isButtonLoading = true;

  List<String> kalahVoices = [
    'assets/audio/et_et_et.wav',
    'assets/audio/eh_hati_hati.wav',
    'assets/audio/yah_kalah.wav',
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
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 170),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.transparent,
        elevation: 0,
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/game/UI/Background Kayu.png',
                width: MediaQuery.of(context).size.width * (3.5 / 4),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/game/UI/kalah.png',
                    width: MediaQuery.of(context).size.width * (2.5 / 4),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Image.asset(
                    'assets/game/UI/0.png',
                    width: MediaQuery.of(context).size.width * (1.2 / 4),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Image.asset(
                    'assets/game/UI/wordingkalah.png',
                    width: MediaQuery.of(context).size.width * (2.5 / 4),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Image.asset(
                          'assets/game/UI/ulang.png',
                          width: MediaQuery.of(context).size.width / 3,
                        ),
                        onTap: () {
                          widget.gameRef.overlays.remove(GameOverMenu.id);
                          widget.gameRef.reset();
                          widget.gameRef.resumeEngine();
                        },
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      _isButtonLoading
                          ? GestureDetector(
                              child: Image.asset(
                                'assets/game/UI/keluar.png',
                                width: MediaQuery.of(context).size.width / 3,
                              ),
                              onTap: () {
                                setState(() {
                                  _isButtonLoading = false;
                                });

                                gameApi
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
                                      .remove(GameOverMenu.id);
                                  widget.gameRef.reset();
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const HomeWidget(
                                      showBanner: false,
                                    );
                                  }), (route) => false);
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
                          : const ButtonLoadingWidget(color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
