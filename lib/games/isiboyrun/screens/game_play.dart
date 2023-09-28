import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/games/isiboyrun/widgets/first_win_menu.dart';
import 'package:isilahtitiktitik/games/isiboyrun/widgets/second_win_menu.dart';
import 'package:isilahtitiktitik/model/list_game.dart';

import '../widgets/first_checkpoint.dart';
import '../widgets/second_checkpoint.dart';
import '../widgets/hud.dart';
import '../game/game.dart';
import '../widgets/main_menu.dart';

import '../widgets/pause_menu.dart';
import '../widgets/settings_menu.dart';
import '../widgets/game_over_menu.dart';
import '../widgets/game_win_menu.dart';

// The main widget for this game.
class GamePlay extends StatefulWidget {
  final List<LevelGame>? levelGame;
  const GamePlay({Key? key, @required this.levelGame}) : super(key: key);

  @override
  State<GamePlay> createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay> {
  /// This is the single instance of [DinoRun] which
  /// will be reused throughout the lifecycle of the game.
  RunningGame? _runningGame;
  @override
  void initState() {
    _runningGame = RunningGame(context);
    // Makes the game full screen and landscape only.
    Flame.device.fullScreen();
    Flame.device.setLandscape();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily: 'Audiowide',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Settings up some default theme for elevated buttons.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            fixedSize: const Size(200, 60),
          ),
        ),
      ),
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () async => false,
          child: GameWidget(
            // This will dislpay a loading bar until [DinoRun] completes
            // its onLoad method.
            loadingBuilder: (context) => const Center(
              child: SizedBox(
                width: 200,
                child: LinearProgressIndicator(),
              ),
            ),
            // Register all the overlays that will be used by this game.
            overlayBuilderMap: {
              MainMenu.id: (BuildContext context, RunningGame gameRef) =>
                  MainMenu(gameRef),
              PauseMenu.id: (BuildContext context, RunningGame gameRef) =>
                  PauseMenu(gameRef),
              Hud.id: (BuildContext context, RunningGame gameRef) =>
                  Hud(gameRef),
              SettingsMenu.id: (BuildContext context, RunningGame gameRef) =>
                  SettingsMenu(gameRef),
              FirstCheckpoint.id: (BuildContext context, RunningGame gameRef) =>
                  FirstCheckpoint(
                    gameRef,
                    levelGame: widget.levelGame,
                  ),
              SecondCheckpoint.id:
                  (BuildContext context, RunningGame gameRef) =>
                      SecondCheckpoint(
                        gameRef,
                        levelGame: widget.levelGame,
                      ),
              GameOverMenu.id: (BuildContext context, RunningGame gameRef) =>
                  GameOverMenu(
                    gameRef,
                    levelGame: widget.levelGame,
                  ),
              GameWinMenu.id: (BuildContext context, RunningGame gameRef) =>
                  GameWinMenu(
                    gameRef,
                    levelGame: widget.levelGame,
                  ),
              FirstWinMenu.id: (BuildContext context, RunningGame gameRef) =>
                  FirstWinMenu(
                    gameRef,
                    levelGame: widget.levelGame,
                  ),
              SecondWinMenu.id: (BuildContext context, RunningGame gameRef) =>
                  SecondWinMenu(
                    gameRef,
                    levelGame: widget.levelGame,
                  ),
            },
            // By default MainMenu overlay will be active.
            initialActiveOverlays: const [MainMenu.id],
            game: _runningGame!,
          ),
        ),
      ),
    );
  }
}
