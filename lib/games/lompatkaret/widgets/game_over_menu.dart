import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:isilahtitiktitik/games/lompatkaret/screens/difficulty_menu.dart';
import 'package:isilahtitiktitik/model/list_game.dart';
import 'package:logger/logger.dart';
import 'package:just_audio/just_audio.dart';

import 'package:provider/provider.dart';

import '../../../view/page-home/widgets/home_widget.dart';
import '../../../view/widgets/button_loading_widget.dart';
import '../game/game.dart';

import '../../../../resource/game_api.dart';
import '../../../../utils/api_helper.dart';

// This represents the game over overlay,
// displayed with dino runs out of lives.
class GameOverMenu extends StatefulWidget {
  // An unique identified for this overlay.
  static const id = 'GameOverMenu';
  final LompatKaretGame gameRef;
  final List<LevelGame>? levelGame;
  final LevelGame? levelGameObject;

  final int idGame;
  final int level;
  final int result;
  final String start;
  final String end;

  const GameOverMenu(this.idGame, this.level, this.result, this.start, this.end,
      {Key? key,
      required this.gameRef,
      required this.levelGameObject,
      required this.levelGame})
      : super(key: key);

  @override
  State<GameOverMenu> createState() => _GameOverMenuState();
}

class _GameOverMenuState extends State<GameOverMenu> {
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  List<String> gelindingVoices = [
    'assets/audio/aw_aw.wav',
    'assets/audio/keseleo_deh.wav',
    'assets/audio/yah_gelinding.wav',
    'assets/audio/kalah.wav',
  ];

  List<String> nabrakVoices = [
    'assets/audio/aw_aw.wav',
    'assets/audio/aw_aw.wav',
    'assets/audio/keseleo_deh.wav',
    'assets/audio/kalah.wav',
  ];

  List<String> ufoVoices = [
    'assets/audio/mo_kemana_bang.wav',
    'assets/audio/mo_kemana_bang.wav',
    'assets/audio/mo_kemana_bang.wav',
    'assets/audio/kalah.wav',
  ];

  List<String> terbangVoices = [
    'assets/audio/mo_kemana_bang.wav',
    'assets/audio/mo_kemana_bang.wav',
    'assets/audio/mo_kemana_bang.wav',
    'assets/audio/kalah.wav',
  ];
  final _random = math.Random();

  final _player = AudioPlayer();

  bool _isButtonLoading = true;

  @override
  void initState() {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    int randomIndex = _random.nextInt(gelindingVoices.length);
    String gelindingVoice = gelindingVoices[randomIndex];
    String nabrakVoice = nabrakVoices[randomIndex];
    String ufoVoice = ufoVoices[randomIndex];
    String terbangVoice = terbangVoices[randomIndex];
    if (basket['lose'] == 1) {
      _player.setAsset(gelindingVoice).then((value) {
        _player.play();
      });
    }
    if (basket['lose'] == 2) {
      _player.setAsset(nabrakVoice).then((value) {
        _player.play();
      });
    }
    if (basket['lose'] == 3) {
      _player.setAsset(ufoVoice).then((value) {
        _player.play();
      });
    }
    if (basket['lose'] == 4) {
      _player.setAsset(terbangVoice).then((value) {
        _player.play();
      });
    }
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
    log(basket['idGame'].toString());
    log(basket['level'].toString());
    log(basket['result'].toString());
    log(basket['start']);
    log(basket['end']);
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
                            widget.gameRef.resumeEngine();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    DifficultyMenu(levelGame: widget.levelGame),
                              ),
                            );
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
      ),
    );
  }
}
