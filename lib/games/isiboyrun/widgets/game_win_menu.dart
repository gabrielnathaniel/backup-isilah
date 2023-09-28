import 'dart:convert';
import 'dart:ui';

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
class GameWinMenu extends StatefulWidget {
  // An unique identified for this overlay.
  static const id = 'GameWinMenu';

  // Reference to parent game.
  final RunningGame gameRef;
  final List<LevelGame>? levelGame;

  const GameWinMenu(this.gameRef, {Key? key, required this.levelGame})
      : super(key: key);

  @override
  State<GameWinMenu> createState() => _GameWinMenuState();
}

class _GameWinMenuState extends State<GameWinMenu> {
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  bool _isButtonLoading = true;

  final _player = AudioPlayer();

  @override
  void initState() {
    _player.setAsset('assets/audio/gas_terus.wav').then((value) {
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
                      'assets/game/UI/menang.png',
                      width: MediaQuery.of(context).size.width * (1.1 / 4),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Image.asset(
                      'assets/game/UI/30.png',
                      width: MediaQuery.of(context).size.width * (1 / 8),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    _isButtonLoading
                        ? GestureDetector(
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
                                widget.gameRef.overlays.remove(GameWinMenu.id);
                                widget.gameRef.reset();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const HomeWidget(
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
                        : const ButtonLoadingWidget(color: Colors.white),
                    // _isButtonLoading
                    //     ? ElevatedButton(
                    //         style: ButtonStyle(
                    //             padding: MaterialStateProperty.all(
                    //                 const EdgeInsets.all(8)),
                    //             backgroundColor: MaterialStateProperty.all(
                    //                 ColorPalette.mainColor),
                    //             shape: MaterialStateProperty.all<
                    //                     RoundedRectangleBorder>(
                    //                 RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(8.0),
                    //             ))),
                    //         child: const Text(
                    //           'Keluar',
                    //           style: TextStyle(
                    //               fontSize: 30,
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.w700),
                    //         ),
                    //         onPressed: () async {
                    //           // Flame.device.setPortrait();
                    //           setState(() {
                    //             _isButtonLoading = false;
                    //           });

                    //           await gameApi
                    //               .postGameResult(
                    //                   generateMd5(
                    //                       "GIS:Isilah&game:${basket['idGame'].toString()}&level:${basket['level'].toString()}&results:${basket['result'].toString()}"),
                    //                   basket['idGame'],
                    //                   basket['level'],
                    //                   basket['result'],
                    //                   basket['start'],
                    //                   basket['end'])
                    //               .then((value) {
                    //             widget.gameRef.overlays.remove(GameWinMenu.id);
                    //             widget.gameRef.reset();
                    //             Navigator.of(context).pushAndRemoveUntil(
                    //                 MaterialPageRoute(
                    //                   builder: (context) => const HomeWidget(
                    //                     showBanner: false,
                    //                   ),
                    //                 ),
                    //                 (route) => false);
                    //             setState(() {
                    //               _isButtonLoading = true;
                    //             });
                    //           }).onError((error, stackTrace) {
                    //             Logger().d(error.toString());
                    //             setState(() {
                    //               _isButtonLoading = true;
                    //             });
                    //           });
                    //         },
                    //       )
                    //     : const ButtonLoadingWidget(color: Colors.white),
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
