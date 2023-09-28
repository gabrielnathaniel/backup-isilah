import 'dart:developer';

import 'package:isilahtitiktitik/games/engklek/widgets/game_over_menu.dart';
import 'package:isilahtitiktitik/games/engklek/widgets/game_win_menu.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/model/list_game.dart';
import 'package:provider/provider.dart';
import '../game/game.dart';

class GamePlay extends StatefulWidget {
  final int? difficulty;
  final List<LevelGame>? levelGame;
  final LevelGame? levelGameObject;

  const GamePlay(
    this.difficulty,
    this.levelGameObject,
    this.levelGame, {
    Key? key,
  }) : super(key: key);

  @override
  State<GamePlay> createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay> {
  EngklekGame? _engklekGame;

  @override
  void initState() {
    _engklekGame = EngklekGame(context, widget.difficulty!);
    addGameResult();
    super.initState();
  }

  void addGameResult() {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    basket.addAll({
      'idGame': _engklekGame?.idGame,
      'level': _engklekGame?.level,
      'result': _engklekGame?.result,
      'start': _engklekGame?.start,
      'end': _engklekGame?.end,
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    log(basket['idGame'].toString());
    log(basket['level'].toString());
    log(basket['result'].toString());
    log(basket['start']);
    log(basket['end']);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: GameWidget(
          game: _engklekGame!,
          initialActiveOverlays: const [],
          overlayBuilderMap: {
            GameOverMenu.id: (BuildContext context, EngklekGame gameref) =>
                GameOverMenu(
                  basket['idGame'],
                  basket['level'],
                  basket['result'],
                  basket['start'],
                  basket['end'],
                  gameRef: gameref,
                  levelGameObject: widget.levelGameObject,
                  levelGame: widget.levelGame,
                ),
            GameWinMenu.id: (BuildContext context, EngklekGame gameref) =>
                GameWinMenu(
                  basket['idGame'],
                  basket['level'],
                  basket['result'],
                  basket['start'],
                  basket['end'],
                  gameRef: gameref,
                  levelGameObject: widget.levelGameObject,
                  levelGame: widget.levelGame,
                ),
          },
        ),
      ),
    );
  }
}
