import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/games/engklek/screens/game_play.dart';
import 'package:isilahtitiktitik/model/list_game.dart';

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
    return Stack(
      children: [
        Image.asset(
          'assets/images/background.png',
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
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      GamePlay(level.level,
                                                          level, levelGame),
                                                ),
                                              );
                                            }
                                            if (level.level == 2) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      GamePlay(level.level,
                                                          level, levelGame),
                                                ),
                                              );
                                            }
                                            if (level.level == 3) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      GamePlay(level.level,
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
