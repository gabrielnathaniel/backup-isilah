import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/model/list_game.dart';
import './difficulty_menu.dart';

class MainMenu extends StatelessWidget {
  final List<LevelGame>? levelGame;
  const MainMenu({Key? key, @required this.levelGame}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/monas.png',
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
                          'assets/game/UI/tariktambang.png',
                          width: MediaQuery.of(context).size.width * (2.5 / 4),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * (1.4 / 3),
                          child: GestureDetector(
                            child: Image.asset(
                              'assets/game/UI/tarik.png',
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DifficultyMenu(levelGame: levelGame),
                                ),
                              );
                            },
                          ),
                        ),
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
