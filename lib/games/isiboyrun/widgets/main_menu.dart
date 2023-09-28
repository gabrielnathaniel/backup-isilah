import 'dart:ui';

import 'package:flutter/material.dart';

import '../widgets/hud.dart';
import '../game/game.dart';

// This represents the main menu overlay.
class MainMenu extends StatelessWidget {
  // An unique identified for this overlay.
  static const id = 'MainMenu';

  // Reference to parent game.
  final RunningGame gameRef;

  const MainMenu(this.gameRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      'assets/game/UI/slametrun.png',
                      width: MediaQuery.of(context).size.width * (1.2 / 5),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * (1.1 / 6),
                      child: GestureDetector(
                        child: Image.asset(
                          'assets/game/UI/main.png',
                        ),
                        onTap: () {
                          gameRef.startGamePlay();
                          gameRef.resumeEngine();
                          gameRef.overlays.remove(MainMenu.id);
                          gameRef.overlays.add(Hud.id);
                        },
                      ),
                    ),
                    // ElevatedButton(
                    //   style: ButtonStyle(
                    //       padding: MaterialStateProperty.all(
                    //           const EdgeInsets.all(12)),
                    //       backgroundColor:
                    //           MaterialStateProperty.all(ColorPalette.mainColor),
                    //       shape:
                    //           MaterialStateProperty.all<RoundedRectangleBorder>(
                    //               RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(8.0),
                    //       ))),
                    //   onPressed: () {
                    //     gameRef.startGamePlay();
                    //     gameRef.resumeEngine();
                    //     gameRef.overlays.remove(MainMenu.id);
                    //     gameRef.overlays.add(Hud.id);
                    //   },
                    //   child: const Text(
                    //     'Play',
                    //     style: TextStyle(
                    //         fontSize: 30,
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.w700),
                    //   ),
                    // ),
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
