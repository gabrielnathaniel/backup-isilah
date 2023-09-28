import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/model/list_game.dart';
import 'package:provider/provider.dart';
import '../game/game.dart';
import '../widgets/overlays/game_over.dart';
import '../widgets/overlays/game_win.dart';

class GamePlay extends StatefulWidget {
  final double? movementSpeed;
  final int? level;
  final LevelGame? levelGame;

  const GamePlay(
    this.movementSpeed,
    this.level,
    this.levelGame, {
    Key? key,
  }) : super(key: key);

  @override
  State<GamePlay> createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay> {
  TarikTambangGame? _tarikTambangGame;
  @override
  void initState() {
    _tarikTambangGame =
        TarikTambangGame(context, widget.movementSpeed!, widget.level!);
    addGameResult();
    super.initState();
  }

  void addGameResult() {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    basket.addAll({
      'idGame': _tarikTambangGame?.idGame,
      'level': _tarikTambangGame?.level,
      'result': _tarikTambangGame?.result,
      'start': _tarikTambangGame?.start,
      'end': _tarikTambangGame?.end,
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: GameWidget(
          game: _tarikTambangGame!,
          initialActiveOverlays: const [],
          overlayBuilderMap: {
            GameOverMenu.id: (BuildContext context, TarikTambangGame gameRef) =>
                GameOverMenu(
                  basket['idGame'],
                  basket['level'],
                  basket['result'],
                  basket['start'],
                  basket['end'],
                  gameRef: gameRef,
                  levelGame: widget.levelGame,
                ),
            GameWinMenu.id: (BuildContext context, TarikTambangGame gameRef) =>
                GameWinMenu(
                  basket['idGame'],
                  basket['level'],
                  basket['result'],
                  basket['start'],
                  basket['end'],
                  gameRef: gameRef,
                  levelGame: widget.levelGame,
                ),
          },
        ),
      ),
    );
  }
}
