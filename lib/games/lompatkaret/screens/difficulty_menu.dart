import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/model/list_game.dart';
import 'package:just_audio/just_audio.dart';
import './game_play.dart';

class DifficultyMenu extends StatelessWidget {
  final List<LevelGame>? levelGame;
  const DifficultyMenu({Key? key, @required this.levelGame}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> difficultyAsset = [
      'assets/game/UI/mudah.png',
      'assets/game/UI/lumayan.png',
      'assets/game/UI/susah.png'
    ];
    final player = AudioPlayer();
    return Stack(
      children: [
        Image.asset(
          'assets/images/rumahgadang.png',
          width: 1000,
          height: 900,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 160),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
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
                          'assets/game/UI/levelkesulitan.png',
                          width: MediaQuery.of(context).size.width * (2.7 / 4),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ...levelGame!
                            .asMap()
                            .map((i, level) => MapEntry(
                                i,
                                Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        (1.2 / 3),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          child:
                                              Image.asset(difficultyAsset[i]),
                                          onTap: () {
                                            if (level.level == 1) {
                                              player
                                                  .setAsset(
                                                      'assets/audio/hayo_jangan_tegang.wav')
                                                  .then((value) {
                                                player.play();
                                              });
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      GamePlay(level.level!,
                                                          level, levelGame),
                                                ),
                                              );
                                            }
                                            if (level.level == 2) {
                                              player
                                                  .setAsset(
                                                      'assets/audio/hayo_jangan_tegang.wav')
                                                  .then((value) {
                                                player.play();
                                              });
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      GamePlay(level.level!,
                                                          level, levelGame),
                                                ),
                                              );
                                            }
                                            if (level.level == 3) {
                                              player
                                                  .setAsset(
                                                      'assets/audio/hayo_jangan_tegang.wav')
                                                  .then((value) {
                                                player.play();
                                              });
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      GamePlay(level.level!,
                                                          level, levelGame),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                )))
                            .values
                            .toList()
                        // ...levelGame!.map((level) {
                        //   return Container(
                        //     width: MediaQuery.of(context).size.width / 3,
                        //     margin: const EdgeInsets.only(bottom: 8),
                        //     child: ElevatedButton(
                        //       style: ButtonStyle(
                        //           padding: MaterialStateProperty.all(
                        //               const EdgeInsets.only(
                        //                   left: 12,
                        //                   right: 12,
                        //                   bottom: 18,
                        //                   top: 12)),
                        //           backgroundColor: MaterialStateProperty.all(
                        //               ColorPalette.mainColor),
                        //           shape: MaterialStateProperty.all<
                        //                   RoundedRectangleBorder>(
                        //               RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(8.0),
                        //           ))),
                        //       child: Text(
                        //         level.label!,
                        //         style: const TextStyle(
                        //             fontSize: 14,
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.w700),
                        //       ),
                        //       onPressed: () {
                        //         if (level.level == 1) {
                        //           Navigator.of(context).pushReplacement(
                        //             MaterialPageRoute(
                        //               builder: (context) => GamePlay(
                        //                   level.level!, level, levelGame),
                        //             ),
                        //           );
                        //         }
                        //         if (level.level == 2) {
                        //           Navigator.of(context).pushReplacement(
                        //             MaterialPageRoute(
                        //               builder: (context) => GamePlay(
                        //                   level.level!, level, levelGame),
                        //             ),
                        //           );
                        //         }
                        //         if (level.level == 3) {
                        //           Navigator.of(context).pushReplacement(
                        //             MaterialPageRoute(
                        //               builder: (context) => GamePlay(
                        //                   level.level!, level, levelGame),
                        //             ),
                        //           );
                        //         }
                        //       },
                        //     ),
                        //   );
                        // }).toList()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
