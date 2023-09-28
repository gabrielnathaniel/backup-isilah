import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:isilahtitiktitik/games/lompatkaret/widgets/game_over_menu.dart';
import 'package:isilahtitiktitik/games/lompatkaret/widgets/game_win_menu.dart';
import 'package:isilahtitiktitik/model/list_game.dart';
import 'package:provider/provider.dart';
import '../game/game.dart';
import '../widgets/progress_bar.dart';

class GamePlay extends StatefulWidget {
  final int difficulty;
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
  LompatKaretGame? _lompatKaretGame;

  double _currentValue = 0;
  late double _finalValue = 0;

  late Timer _timer;

  bool zero = true;

  double margin = 0;

  setEndPressed(double value) {
    setState(() {
      _currentValue = value;
    });
  }

  setStart() {
    const oneSec = Duration(milliseconds: 5);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (zero == true) {
        setState(() {
          _currentValue++;
          if (_currentValue == 100) {
            zero = false;
          }
        });
      } else if (zero == false) {
        setState(() {
          _currentValue--;
          if (_currentValue == 0) {
            zero = true;
          }
        });
      }

      if (widget.difficulty == 1) {
        margin = 125;
      } else if (widget.difficulty == 2) {
        margin = 150;
      } else if (widget.difficulty == 3) {
        margin = 175;
      }
    });
  }

  setStop() {
    _timer.cancel();
    _finalValue = _currentValue;
    setState(() {
      _lompatKaretGame =
          LompatKaretGame(context, widget.difficulty, _finalValue);
    });
  }

  @override
  void initState() {
    _lompatKaretGame = LompatKaretGame(context, widget.difficulty, 0);

    setStart();
    addGameResult();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildFloatingButton(String text, VoidCallback callback) {
    TextStyle roundTextStyle =
        const TextStyle(fontSize: 16.0, color: Colors.white);
    return FloatingActionButton(
      heroTag: Text(text),
      onPressed: callback,
      child: Text(text, style: roundTextStyle),
    );
  }

  void addGameResult() {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    basket.addAll({
      'idGame': _lompatKaretGame?.idGame,
      'level': _lompatKaretGame?.level,
      'result': _lompatKaretGame?.result,
      'start': _lompatKaretGame?.start,
      'end': _lompatKaretGame?.end,
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> basket = Provider.of(context, listen: false);
    // log(basket['idGame'].toString());
    // log(basket['level'].toString());
    // log(basket['result'].toString());
    // log(basket['start']);
    // log(basket['end']);
    return Stack(
      children: [
        Image.asset(
          "assets/images/rumahgadang.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: WillPopScope(
            onWillPop: () async => false,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        height: 450,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Row(
                            children: <Widget>[
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                      'assets/game/UI/barloncattali.png'),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: FAProgressBar(
                                      size: 40,
                                      progressColor: Colors.yellowAccent,
                                      backgroundColor: Colors.white,
                                      currentValue: _currentValue,
                                      animatedDuration:
                                          const Duration(milliseconds: 0),
                                      direction: Axis.vertical,
                                      verticalDirection: VerticalDirection.up,
                                    ),
                                  ),
                                  Container(
                                    width: 55,
                                    margin: EdgeInsets.symmetric(
                                        vertical: widget.difficulty == 1
                                            ? 125
                                            : widget.difficulty == 2
                                                ? 150
                                                : 175),
                                    // padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.redAccent, width: 8)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GameWidget(
                  game: _lompatKaretGame!,
                  initialActiveOverlays: const [],
                  overlayBuilderMap: {
                    ProgressBar.id:
                        (BuildContext context, LompatKaretGame gameRef) =>
                            const ProgressBar(),
                    GameOverMenu.id:
                        (BuildContext context, LompatKaretGame gameRef) =>
                            GameOverMenu(
                              basket['idGame'],
                              basket['level'],
                              basket['result'],
                              basket['start'],
                              basket['end'],
                              gameRef: gameRef,
                              levelGameObject: widget.levelGameObject,
                              levelGame: widget.levelGame,
                            ),
                    GameWinMenu.id:
                        (BuildContext context, LompatKaretGame gameRef) =>
                            GameWinMenu(
                              basket['idGame'],
                              basket['level'],
                              basket['result'],
                              basket['start'],
                              basket['end'],
                              gameRef: gameRef,
                              levelGameObject: widget.levelGameObject,
                              levelGame: widget.levelGame,
                            ),
                  },
                ),
                Positioned(
                  bottom: 30,
                  right: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      // buildFloatingButton("start", () => setStart()),
                      // buildFloatingButton("stop", () => setStop()),
                      GestureDetector(
                        child: Image.asset(
                          'assets/game/UI/buttonloncat.png',
                          width: MediaQuery.of(context).size.width / 5,
                        ),
                        onTap: () {
                          setStop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
