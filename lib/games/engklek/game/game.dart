import 'dart:developer';

import 'package:isilahtitiktitik/games/engklek/game/background.dart';
import 'package:isilahtitiktitik/games/engklek/game/button1.dart';
import 'package:isilahtitiktitik/games/engklek/game/button2.dart';
import 'package:isilahtitiktitik/games/engklek/game/button3.dart';
import 'package:isilahtitiktitik/games/engklek/game/button_text1.dart';
import 'package:isilahtitiktitik/games/engklek/game/button_text2.dart';
import 'package:isilahtitiktitik/games/engklek/game/button_text3.dart';
import 'package:isilahtitiktitik/games/engklek/game/clicked_button1.dart';
import 'package:isilahtitiktitik/games/engklek/game/clicked_button2.dart';
import 'package:isilahtitiktitik/games/engklek/game/clicked_button3.dart';
import 'package:isilahtitiktitik/games/engklek/game/clicked_text1.dart';
import 'package:isilahtitiktitik/games/engklek/game/clicked_text2.dart';
import 'package:isilahtitiktitik/games/engklek/game/clicked_text3.dart';
import 'package:isilahtitiktitik/games/engklek/game/slamet1.dart';
import 'package:isilahtitiktitik/games/engklek/game/slamet2.dart';
import 'package:isilahtitiktitik/games/engklek/game/slamet3.dart';
import 'package:isilahtitiktitik/games/engklek/game/slamet4.dart';
import 'package:isilahtitiktitik/games/engklek/game/slamet5.dart';
import 'package:isilahtitiktitik/games/engklek/game/slamet6.dart';
import 'package:isilahtitiktitik/games/engklek/game/slamet_happy.dart';
import 'package:isilahtitiktitik/games/engklek/game/slamet_sad.dart';
import 'package:isilahtitiktitik/games/engklek/game/text1.dart';
import 'package:isilahtitiktitik/games/engklek/game/text2.dart';
import 'package:isilahtitiktitik/games/engklek/game/text3.dart';
import 'package:isilahtitiktitik/games/engklek/game/timer_button.dart';
import 'package:isilahtitiktitik/games/engklek/game/timer_text.dart';
import 'package:isilahtitiktitik/games/engklek/game/word1.dart';
import 'package:isilahtitiktitik/games/engklek/game/word2.dart';
import 'package:isilahtitiktitik/games/engklek/game/word3.dart';
import 'package:isilahtitiktitik/games/engklek/widgets/game_over_menu.dart';
import 'package:isilahtitiktitik/games/engklek/widgets/game_win_menu.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class EngklekGame extends FlameGame {
  late Slamet1 slamet1;
  late Slamet2 slamet2;
  late Slamet3 slamet3;
  late Slamet4 slamet4;
  late Slamet5 slamet5;
  late Slamet6 slamet6;
  late SlametHappy slametHappy;
  late SlametSad slametSad;
  late Background background;
  late Button1 button1;
  late Button2 button2;
  late Button3 button3;
  late ClickedButton1 clickedButton1;
  late ClickedButton2 clickedButton2;
  late ClickedButton3 clickedButton3;
  late Word1 word1;
  late Word2 word2;
  late Word3 word3;
  late Text1 text1;
  late Text2 text2;
  late Text3 text3;
  late ButtonText1 buttonText1;
  late ButtonText2 buttonText2;
  late ButtonText3 buttonText3;
  late ClickedText1 clickedText1;
  late ClickedText2 clickedText2;
  late ClickedText3 clickedText3;
  late TimerText timerText;
  late TimerButton timerButton;

  late Timer countDown;
  late int remainingTime = 10;

  int stage = 1;
  int correct = 0;
  int turn = 1;
  int wrong = 0;

  bool slamet1Active = false;
  bool slamet2Active = false;
  bool slamet3Active = false;
  bool slamet4Active = false;
  bool slamet5Active = false;
  bool slamet6Active = false;

  late String start = DateTime.now().toString();
  late String end = DateTime.now().toString();
  late int result = 0;

  late int idGame = 4;

  BuildContext? context;
  int level;

  List<String> charList = ['A', 'B', 'C'];

  EngklekGame(this.context, this.level);

  final _player = AudioPlayer();

  @override
  Future<void>? onLoad() async {
    await images.load('background1.png');
    await images.load('background2.png');
    await images.load('background3.png');
    await images.load('background4.png');
    await images.load('background5.png');
    await images.load('background6.png');
    await images.load('background7.png');
    await images.load('button.png');
    await images.load('word.png');
    await images.load('isiboy_engklek_belakang1.png');
    await images.load('isiboy_engklek_belakang2.png');
    await images.load('isiboy_engklek_depan1.png');
    await images.load('isiboy_engklek_depan2.png');
    await images.load('isiboy_engklek_happy.png');
    await images.load('isiboy_engklek_sad.png');

    background = Background(
      sprite: await loadSprite('background1.png'),
      size: Vector2(size.x, size.y),
    );

    slamet1 = Slamet1();
    slamet1.position = Vector2(size.x / 2, size.y * (4.5 / 7));
    slamet1.anchor = Anchor.center;

    slamet2 = Slamet2();
    slamet2.anchor = Anchor.center;

    slamet4 = Slamet4();
    slamet4.anchor = Anchor.center;

    slamet5 = Slamet5();
    slamet5.anchor = Anchor.center;

    slametHappy = SlametHappy();
    slametHappy.anchor = Anchor.center;

    slametSad = SlametSad();
    slametSad.anchor = Anchor.center;

    word2 = Word2(
      button: await loadSprite('word.png'),
      size: Vector2(size.x / 2, 84),
      position: Vector2(size.x / 2 - 100, size.y * (1 / 12)),
      onPressed: () {},
    );

    button1 = Button1(
      button: await loadSprite('button.png'),
      size: Vector2(90, 84),
      position: Vector2(size.x * (1 / 5) - 45, size.y * (6 / 7)),
      onPressed: () {},
    );
    button2 = Button2(
      button: await loadSprite('button.png'),
      size: Vector2(90, 84),
      position: Vector2(size.x / 2 - 45, size.y * (6 / 7)),
      onPressed: () {},
    );
    button3 = Button3(
      button: await loadSprite('button.png'),
      size: Vector2(90, 84),
      position: Vector2(size.x * (4 / 5) - 45, size.y * (6 / 7)),
      onPressed: () {},
    );
    clickedButton1 = ClickedButton1(
      button: await loadSprite('button.png'),
      size: Vector2(90, 84),
      position: Vector2(size.x * (1 / 5) - 45, size.y * (6 / 7)),
      onPressed: () {},
    );
    clickedButton2 = ClickedButton2(
      button: await loadSprite('button.png'),
      size: Vector2(90, 84),
      position: Vector2(size.x / 2 - 45, size.y * (6 / 7)),
      onPressed: () {},
    );
    clickedButton3 = ClickedButton3(
      button: await loadSprite('button.png'),
      size: Vector2(90, 84),
      position: Vector2(size.x * (4 / 5) - 45, size.y * (6 / 7)),
      onPressed: () {},
    );

    text1 = Text1(
      text: 'A',
      textRenderer: TextPaint(
          style: const TextStyle(fontFamily: "LapsusProBold", fontSize: 80)),
      // size: Vector2(100, 60),
      position: Vector2(size.x * (1 / 5) + 30, size.y * (1 / 12)),
    );
    text2 = Text2(
      text: 'B',
      textRenderer: TextPaint(
          style: const TextStyle(fontFamily: "LapsusProBold", fontSize: 80)),
      // size: Vector2(100, 60),
      position: Vector2(size.x / 2 - 25, size.y * (1 / 12)),
    );
    text3 = Text3(
      text: 'C',
      textRenderer: TextPaint(
          style: const TextStyle(fontFamily: "LapsusProBold", fontSize: 80)),
      // size: Vector2(100, 60),
      position: Vector2(size.x * (4 / 5) - 80, size.y * (1 / 12)),
    );

    buttonText1 = ButtonText1(
      text: 'A',
      textRenderer: TextPaint(
          style: const TextStyle(
              fontFamily: "LapsusProBold", fontSize: 50, color: Colors.white)),
      // size: Vector2(100, 60),
      position: Vector2(size.x * (1 / 5) - 16, size.y * (6 / 7) + 14),
    );
    buttonText2 = ButtonText2(
      text: 'B',
      textRenderer: TextPaint(
          style: const TextStyle(
              fontFamily: "LapsusProBold", fontSize: 50, color: Colors.white)),
      // size: Vector2(100, 60),
      position: Vector2(size.x / 2 - 16, size.y * (6 / 7) + 14),
    );
    buttonText3 = ButtonText3(
      text: 'C',
      textRenderer: TextPaint(
          style: const TextStyle(
              fontFamily: "LapsusProBold", fontSize: 50, color: Colors.white)),
      // size: Vector2(100, 60),
      position: Vector2(size.x * (4 / 5) - 16, size.y * (6 / 7) + 14),
    );

    clickedText1 = ClickedText1(
      text: 'A',
      textRenderer: TextPaint(
          style: const TextStyle(
              fontFamily: "LapsusProBold", fontSize: 50, color: Colors.yellow)),
      // size: Vector2(100, 60),
      position: Vector2(size.x * (1 / 5) - 16, size.y * (6 / 7) + 14),
    );
    clickedText2 = ClickedText2(
      text: 'B',
      textRenderer: TextPaint(
          style: const TextStyle(
              fontFamily: "LapsusProBold", fontSize: 50, color: Colors.yellow)),
      // size: Vector2(100, 60),
      position: Vector2(size.x / 2 - 16, size.y * (6 / 7) + 14),
    );
    clickedText3 = ClickedText3(
      text: 'C',
      textRenderer: TextPaint(
          style: const TextStyle(
              fontFamily: "LapsusProBold", fontSize: 50, color: Colors.yellow)),
      // size: Vector2(100, 60),
      position: Vector2(size.x * (4 / 5) - 16, size.y * (6 / 7) + 14),
    );

    countDown = Timer(1, onTick: () {
      if (remainingTime > 0) {
        remainingTime -= 1;
      }
    }, repeat: true);

    timerText = TimerText(
      text: remainingTime.toString(),
      textRenderer: TextPaint(
          style: const TextStyle(
        fontFamily: "LapsusProBold",
        fontSize: 80,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      )),
      // size: Vector2(100, 60),
      position: Vector2(size.x * (1 / 8) - 19, size.y * (1 / 12)),
    );

    timerButton = TimerButton(
      button: await loadSprite('button.png'),
      size: Vector2(80, 80),
      position: Vector2(size.x * (1 / 8) - 40, size.y * (1 / 12) + 4),
      onPressed: () {},
    );

    if (level == 1) {
      remainingTime = 5;
    }
    if (level == 2) {
      remainingTime = 4;
    }
    if (level == 3) {
      remainingTime = 3;
    }

    add(background);
    add(slamet1);
    add(button1);
    add(button2);
    add(button3);
    add(word2);
    add(text1);
    add(text2);
    add(text3);
    add(buttonText1);
    add(buttonText2);
    add(buttonText3);
    add(timerButton);
    add(timerText);

    slamet1Active = true;
  }

  void startGame() {
    Map<String, dynamic> basket = Provider.of(context!, listen: false);
    if (level == 1) {
      text1.text = 'C';
      text2.text = 'A';
      text3.text = 'B';
      buttonText1.text = 'A';
      buttonText2.text = 'B';
      buttonText3.text = 'C';
    }
    if (level == 2) {
      text1.text = 'J';
      text2.text = 'I';
      text3.text = '7';
      buttonText1.text = '7';
      buttonText2.text = 'J';
      buttonText3.text = 'I';
    }
    if (level == 3) {
      text1.text = '6';
      text2.text = '9';
      text3.text = '8';
      buttonText1.text = '8';
      buttonText2.text = '6';
      buttonText3.text = '9';
    }
    if (turn == 1) {
      button1.onPressed = () async {
        if (buttonText1.text == text1.text) {
          turn += 1;
          correct += 1;
          add(clickedButton1);
          clickedText1.text = buttonText1.text;
          add(clickedText1);
          text1.textRenderer = TextPaint(
              style: const TextStyle(
                  fontFamily: "LapsusProBold",
                  fontSize: 80,
                  color: Colors.green));
        } else if (buttonText1.text != text1.text) {
          remove(button1);
          remove(button2);
          remove(button3);
          remove(word2);
          remove(text1);
          remove(text2);
          remove(text3);
          remove(buttonText1);
          remove(buttonText2);
          remove(buttonText3);
          remove(timerButton);
          remove(timerText);
          Future.delayed(const Duration(milliseconds: 100)).then((value) async {
            if (slamet1Active) {
              slametSad.position = slamet1.position;
              remove(slamet1);
              add(slametSad);
            }
            if (slamet2Active) {
              slametSad.position = slamet2.position;
              remove(slamet2);
              add(slametSad);
            }
            if (slamet4Active) {
              slametSad.position = slamet4.position;
              remove(slamet4);
              add(slametSad);
            }
            if (slamet5Active) {
              slametSad.position = slamet5.position;
              remove(slamet5);
              add(slametSad);
            }
          });
          Future.delayed(const Duration(milliseconds: 2100))
              .then((value) async {
            pauseEngine();
            overlays.add(GameOverMenu.id);
            end = DateTime.now().toString();
            result = 0;
            basket.addAll({
              'idGame': idGame,
              'level': level,
              'result': result,
              'start': start,
              'end': end,
            });
            log(basket['idGame'].toString());
            log(basket['level'].toString());
            log(basket['result'].toString());
            log(basket['start']);
            log(basket['end']);
          });
        }
      };
      button2.onPressed = () {
        if (buttonText2.text == text1.text) {
          turn += 1;
          correct += 1;
          add(clickedButton2);
          clickedText2.text = buttonText2.text;
          add(clickedText2);
          text1.textRenderer = TextPaint(
              style: const TextStyle(
                  fontFamily: "LapsusProBold",
                  fontSize: 80,
                  color: Colors.green));
        } else if (buttonText2.text != text1.text) {
          remove(button1);
          remove(button2);
          remove(button3);
          remove(word2);
          remove(text1);
          remove(text2);
          remove(text3);
          remove(buttonText1);
          remove(buttonText2);
          remove(buttonText3);
          remove(timerButton);
          remove(timerText);
          Future.delayed(const Duration(milliseconds: 100)).then((value) async {
            if (slamet1Active) {
              slametSad.position = slamet1.position;
              remove(slamet1);
              add(slametSad);
            }
            if (slamet2Active) {
              slametSad.position = slamet2.position;
              remove(slamet2);
              add(slametSad);
            }
            if (slamet4Active) {
              slametSad.position = slamet4.position;
              remove(slamet4);
              add(slametSad);
            }
            if (slamet5Active) {
              slametSad.position = slamet5.position;
              remove(slamet5);
              add(slametSad);
            }
          });
          Future.delayed(const Duration(milliseconds: 2100))
              .then((value) async {
            pauseEngine();
            overlays.add(GameOverMenu.id);
            end = DateTime.now().toString();
            result = 0;
            basket.addAll({
              'idGame': idGame,
              'level': level,
              'result': result,
              'start': start,
              'end': end,
            });
            log(basket['idGame'].toString());
            log(basket['level'].toString());
            log(basket['result'].toString());
            log(basket['start']);
            log(basket['end']);
          });
        }
      };
      button3.onPressed = () async {
        if (buttonText3.text == text1.text) {
          turn += 1;
          correct += 1;
          add(clickedButton3);
          clickedText3.text = buttonText3.text;
          add(clickedText3);
          text1.textRenderer = TextPaint(
              style: const TextStyle(
                  fontFamily: "LapsusProBold",
                  fontSize: 80,
                  color: Colors.green));
        } else if (buttonText3.text != text1.text) {
          remove(button1);
          remove(button2);
          remove(button3);
          remove(word2);
          remove(text1);
          remove(text2);
          remove(text3);
          remove(buttonText1);
          remove(buttonText2);
          remove(buttonText3);
          remove(timerButton);
          remove(timerText);
          Future.delayed(const Duration(milliseconds: 100)).then((value) async {
            if (slamet1Active) {
              slametSad.position = slamet1.position;
              remove(slamet1);
              add(slametSad);
            }
            if (slamet2Active) {
              slametSad.position = slamet2.position;
              remove(slamet2);
              add(slametSad);
            }
            if (slamet4Active) {
              slametSad.position = slamet4.position;
              remove(slamet4);
              add(slametSad);
            }
            if (slamet5Active) {
              slametSad.position = slamet5.position;
              remove(slamet5);
              add(slametSad);
            }
          });
          Future.delayed(const Duration(milliseconds: 2100))
              .then((value) async {
            pauseEngine();
            overlays.add(GameOverMenu.id);
            end = DateTime.now().toString();
            result = 0;
            basket.addAll({
              'idGame': idGame,
              'level': level,
              'result': result,
              'start': start,
              'end': end,
            });
            log(basket['idGame'].toString());
            log(basket['level'].toString());
            log(basket['result'].toString());
            log(basket['start']);
            log(basket['end']);
          });
        }
      };
    }
    if (turn == 2) {
      button1.onPressed = () {
        if (buttonText1.text == text2.text) {
          turn += 1;
          correct += 1;
          add(clickedButton1);
          clickedText1.text = buttonText1.text;
          add(clickedText1);
          text2.textRenderer = TextPaint(
              style: const TextStyle(
                  fontFamily: "LapsusProBold",
                  fontSize: 80,
                  color: Colors.green));
        } else if (buttonText1.text != text2.text) {
          remove(button1);
          remove(button2);
          remove(button3);
          remove(word2);
          remove(text1);
          remove(text2);
          remove(text3);
          remove(buttonText1);
          remove(buttonText2);
          remove(buttonText3);
          remove(timerButton);
          remove(timerText);
          Future.delayed(const Duration(milliseconds: 100)).then((value) async {
            if (slamet1Active) {
              slametSad.position = slamet1.position;
              remove(slamet1);
              add(slametSad);
            }
            if (slamet2Active) {
              slametSad.position = slamet2.position;
              remove(slamet2);
              add(slametSad);
            }
            if (slamet4Active) {
              slametSad.position = slamet4.position;
              remove(slamet4);
              add(slametSad);
            }
            if (slamet5Active) {
              slametSad.position = slamet5.position;
              remove(slamet5);
              add(slametSad);
            }
          });
          Future.delayed(const Duration(milliseconds: 2100))
              .then((value) async {
            pauseEngine();
            overlays.add(GameOverMenu.id);
            end = DateTime.now().toString();
            result = 0;
            basket.addAll({
              'idGame': idGame,
              'level': level,
              'result': result,
              'start': start,
              'end': end,
            });
            log(basket['idGame'].toString());
            log(basket['level'].toString());
            log(basket['result'].toString());
            log(basket['start']);
            log(basket['end']);
          });
        }
      };
      button2.onPressed = () {
        if (buttonText2.text == text2.text) {
          turn += 1;
          correct += 1;
          add(clickedButton2);
          clickedText2.text = buttonText2.text;
          add(clickedText2);
          text2.textRenderer = TextPaint(
              style: const TextStyle(
                  fontFamily: "LapsusProBold",
                  fontSize: 80,
                  color: Colors.green));
        } else if (buttonText2.text != text2.text) {
          remove(button1);
          remove(button2);
          remove(button3);
          remove(word2);
          remove(text1);
          remove(text2);
          remove(text3);
          remove(buttonText1);
          remove(buttonText2);
          remove(buttonText3);
          remove(timerButton);
          remove(timerText);
          Future.delayed(const Duration(milliseconds: 100)).then((value) async {
            if (slamet1Active) {
              slametSad.position = slamet1.position;
              remove(slamet1);
              add(slametSad);
            }
            if (slamet2Active) {
              slametSad.position = slamet2.position;
              remove(slamet2);
              add(slametSad);
            }
            if (slamet4Active) {
              slametSad.position = slamet4.position;
              remove(slamet4);
              add(slametSad);
            }
            if (slamet5Active) {
              slametSad.position = slamet5.position;
              remove(slamet5);
              add(slametSad);
            }
          });
          Future.delayed(const Duration(milliseconds: 2100))
              .then((value) async {
            pauseEngine();
            overlays.add(GameOverMenu.id);
            end = DateTime.now().toString();
            result = 0;
            basket.addAll({
              'idGame': idGame,
              'level': level,
              'result': result,
              'start': start,
              'end': end,
            });
            log(basket['idGame'].toString());
            log(basket['level'].toString());
            log(basket['result'].toString());
            log(basket['start']);
            log(basket['end']);
          });
        }
      };
      button3.onPressed = () {
        if (buttonText3.text == text2.text) {
          turn += 1;
          correct += 1;
          add(clickedButton3);
          clickedText3.text = buttonText3.text;
          add(clickedText3);
          text2.textRenderer = TextPaint(
              style: const TextStyle(
                  fontFamily: "LapsusProBold",
                  fontSize: 80,
                  color: Colors.green));
        } else if (buttonText3.text != text2.text) {
          remove(button1);
          remove(button2);
          remove(button3);
          remove(word2);
          remove(text1);
          remove(text2);
          remove(text3);
          remove(buttonText1);
          remove(buttonText2);
          remove(buttonText3);
          remove(timerButton);
          remove(timerText);
          Future.delayed(const Duration(milliseconds: 100)).then((value) async {
            if (slamet1Active) {
              slametSad.position = slamet1.position;
              remove(slamet1);
              add(slametSad);
            }
            if (slamet2Active) {
              slametSad.position = slamet2.position;
              remove(slamet2);
              add(slametSad);
            }
            if (slamet4Active) {
              slametSad.position = slamet4.position;
              remove(slamet4);
              add(slametSad);
            }
            if (slamet5Active) {
              slametSad.position = slamet5.position;
              remove(slamet5);
              add(slametSad);
            }
          });
          Future.delayed(const Duration(milliseconds: 2100))
              .then((value) async {
            pauseEngine();
            overlays.add(GameOverMenu.id);
            end = DateTime.now().toString();
            result = 0;
            basket.addAll({
              'idGame': idGame,
              'level': level,
              'result': result,
              'start': start,
              'end': end,
            });
            log(basket['idGame'].toString());
            log(basket['level'].toString());
            log(basket['result'].toString());
            log(basket['start']);
            log(basket['end']);
          });
        }
      };
    }
    if (turn == 3) {
      button1.onPressed = () {
        if (buttonText1.text == text3.text) {
          turn += 1;
          correct += 1;
          add(clickedButton1);
          clickedText1.text = buttonText1.text;
          add(clickedText1);
          text3.textRenderer = TextPaint(
              style: const TextStyle(
                  fontFamily: "LapsusProBold",
                  fontSize: 80,
                  color: Colors.green));
          _player.setAsset('assets/audio/loncat.wav').then((value) {
            _player.play();
          });
        } else if (buttonText1.text != text3.text) {
          remove(button1);
          remove(button2);
          remove(button3);
          remove(word2);
          remove(text1);
          remove(text2);
          remove(text3);
          remove(buttonText1);
          remove(buttonText2);
          remove(buttonText3);
          remove(timerButton);
          remove(timerText);
          Future.delayed(const Duration(milliseconds: 100)).then((value) async {
            if (slamet1Active) {
              slametSad.position = slamet1.position;
              remove(slamet1);
              add(slametSad);
            }
            if (slamet2Active) {
              slametSad.position = slamet2.position;
              remove(slamet2);
              add(slametSad);
            }
            if (slamet4Active) {
              slametSad.position = slamet4.position;
              remove(slamet4);
              add(slametSad);
            }
            if (slamet5Active) {
              slametSad.position = slamet5.position;
              remove(slamet5);
              add(slametSad);
            }
          });
          Future.delayed(const Duration(milliseconds: 2100))
              .then((value) async {
            pauseEngine();
            overlays.add(GameOverMenu.id);
            end = DateTime.now().toString();
            result = 0;
            basket.addAll({
              'idGame': idGame,
              'level': level,
              'result': result,
              'start': start,
              'end': end,
            });
            log(basket['idGame'].toString());
            log(basket['level'].toString());
            log(basket['result'].toString());
            log(basket['start']);
            log(basket['end']);
          });
        }
      };
      button2.onPressed = () {
        if (buttonText2.text == text3.text) {
          turn += 1;
          correct += 1;
          add(clickedButton2);
          clickedText2.text = buttonText2.text;
          add(clickedText2);
          text3.textRenderer = TextPaint(
              style: const TextStyle(
                  fontFamily: "LapsusProBold",
                  fontSize: 80,
                  color: Colors.green));
          _player.setAsset('assets/audio/loncat.wav').then((value) {
            _player.play();
          });
        } else if (buttonText2.text != text3.text) {
          remove(button1);
          remove(button2);
          remove(button3);
          remove(word2);
          remove(text1);
          remove(text2);
          remove(text3);
          remove(buttonText1);
          remove(buttonText2);
          remove(buttonText3);
          remove(timerButton);
          remove(timerText);
          Future.delayed(const Duration(milliseconds: 100)).then((value) async {
            if (slamet1Active) {
              slametSad.position = slamet1.position;
              remove(slamet1);
              add(slametSad);
            }
            if (slamet2Active) {
              slametSad.position = slamet2.position;
              remove(slamet2);
              add(slametSad);
            }
            if (slamet4Active) {
              slametSad.position = slamet4.position;
              remove(slamet4);
              add(slametSad);
            }
            if (slamet5Active) {
              slametSad.position = slamet5.position;
              remove(slamet5);
              add(slametSad);
            }
          });
          Future.delayed(const Duration(milliseconds: 2100))
              .then((value) async {
            pauseEngine();
            overlays.add(GameOverMenu.id);
            end = DateTime.now().toString();
            result = 0;
            basket.addAll({
              'idGame': idGame,
              'level': level,
              'result': result,
              'start': start,
              'end': end,
            });
            log(basket['idGame'].toString());
            log(basket['level'].toString());
            log(basket['result'].toString());
            log(basket['start']);
            log(basket['end']);
          });
        }
      };
      button3.onPressed = () async {
        if (buttonText3.text == text3.text) {
          turn += 1;
          correct += 1;
          add(clickedButton3);
          clickedText3.text = buttonText3.text;
          add(clickedText3);
          text3.textRenderer = TextPaint(
              style: const TextStyle(
                  fontFamily: "LapsusProBold",
                  fontSize: 80,
                  color: Colors.green));
          _player.setAsset('assets/audio/loncat.wav').then((value) {
            _player.play();
          });
        } else if (buttonText3.text != text3.text) {
          remove(button1);
          remove(button2);
          remove(button3);
          remove(word2);
          remove(text1);
          remove(text2);
          remove(text3);
          remove(buttonText1);
          remove(buttonText2);
          remove(buttonText3);
          remove(timerButton);
          remove(timerText);
          Future.delayed(const Duration(milliseconds: 100)).then((value) async {
            if (slamet1Active) {
              slametSad.position = slamet1.position;
              remove(slamet1);
              add(slametSad);
            }
            if (slamet2Active) {
              slametSad.position = slamet2.position;
              remove(slamet2);
              add(slametSad);
            }
            if (slamet4Active) {
              slametSad.position = slamet4.position;
              remove(slamet4);
              add(slametSad);
            }
            if (slamet5Active) {
              slametSad.position = slamet5.position;
              remove(slamet5);
              add(slametSad);
            }
          });
          Future.delayed(const Duration(milliseconds: 2100))
              .then((value) async {
            pauseEngine();
            overlays.add(GameOverMenu.id);
            end = DateTime.now().toString();
            result = 0;
            basket.addAll({
              'idGame': idGame,
              'level': level,
              'result': result,
              'start': start,
              'end': end,
            });
            log(basket['idGame'].toString());
            log(basket['level'].toString());
            log(basket['result'].toString());
            log(basket['start']);
            log(basket['end']);
          });
        }
      };
    }
    if (remainingTime == 0) {
      remove(button1);
      remove(button2);
      remove(button3);
      remove(word2);
      remove(text1);
      remove(text2);
      remove(text3);
      remove(buttonText1);
      remove(buttonText2);
      remove(buttonText3);
      remove(timerButton);
      remove(timerText);
      Future.delayed(const Duration(milliseconds: 100)).then((value) async {
        if (slamet1Active) {
          slametSad.position = slamet1.position;
          remove(slamet1);
          add(slametSad);
        }
        if (slamet2Active) {
          slametSad.position = slamet2.position;
          remove(slamet2);
          add(slametSad);
        }
        if (slamet4Active) {
          slametSad.position = slamet4.position;
          remove(slamet4);
          add(slametSad);
        }
        if (slamet5Active) {
          slametSad.position = slamet5.position;
          remove(slamet5);
          add(slametSad);
        }
      });
      Future.delayed(const Duration(milliseconds: 2100)).then((value) async {
        pauseEngine();
        overlays.add(GameOverMenu.id);
        end = DateTime.now().toString();
        result = 0;
        basket.addAll({
          'idGame': idGame,
          'level': level,
          'result': result,
          'start': start,
          'end': end,
        });
        log(basket['idGame'].toString());
        log(basket['level'].toString());
        log(basket['result'].toString());
        log(basket['start']);
        log(basket['end']);
      });
    }
    if (correct == 3) {
      reset();
      stage += 1;
    }
  }

  void reset() {
    correct = 0;
    turn = 1;
    if (level == 1) {
      remainingTime = 5;
    }
    if (level == 2) {
      remainingTime = 4;
    }
    if (level == 3) {
      remainingTime = 3;
    }
    remove(clickedButton1);
    remove(clickedText1);
    remove(clickedButton2);
    remove(clickedText2);
    remove(clickedButton3);
    remove(clickedText3);
    text1.textRenderer = TextPaint(
        style: const TextStyle(
            fontFamily: "LapsusProBold", fontSize: 80, color: Colors.white));
    text2.textRenderer = TextPaint(
        style: const TextStyle(
            fontFamily: "LapsusProBold", fontSize: 80, color: Colors.white));
    text3.textRenderer = TextPaint(
        style: const TextStyle(
            fontFamily: "LapsusProBold", fontSize: 80, color: Colors.white));
  }

  @override
  Future<void> update(double dt) async {
    Map<String, dynamic> basket = Provider.of(context!, listen: false);
    startGame();
    if (remainingTime > 0) {
      countDown.update(dt);
    }
    timerText.text = remainingTime.toString();
    double speed = 50;
    if (stage == 2) {
      background.sprite = await loadSprite('background2.png');
      if (level == 1) {
        text1.text = 'B';
        text2.text = 'C';
        text3.text = 'A';
        buttonText1.text = 'C';
        buttonText2.text = 'A';
        buttonText3.text = 'B';
      }
      if (level == 2) {
        text1.text = '7';
        text2.text = 'I';
        text3.text = 'J';
        buttonText1.text = 'I';
        buttonText2.text = '7';
        buttonText3.text = 'J';
      }
      if (level == 3) {
        text1.text = '9';
        text2.text = '8';
        text3.text = '6';
        buttonText1.text = '9';
        buttonText2.text = '6';
        buttonText3.text = '8';
      }

      if (slamet1.position.y > size.y * (3.6 / 7) - 1) {
        slamet1.position += Vector2(0, -1) * speed * dt;
      }
    }
    if (stage == 3) {
      if (level == 1) {
        text1.text = 'A';
        text2.text = 'B';
        text3.text = 'C';
        buttonText1.text = 'B';
        buttonText2.text = 'A';
        buttonText3.text = 'C';
      }
      if (level == 2) {
        text1.text = 'I';
        text2.text = 'J';
        text3.text = '7';
        buttonText1.text = '7';
        buttonText2.text = 'J';
        buttonText3.text = 'I';
      }
      if (level == 3) {
        text1.text = '8';
        text2.text = '9';
        text3.text = '6';
        buttonText1.text = '9';
        buttonText2.text = '8';
        buttonText3.text = '6';
      }
      background.sprite = await loadSprite('background3.png');

      if (slamet1.position.y > size.y * (3 / 7) - 1) {
        slamet1.position += Vector2(0, -1) * speed * dt;
      }
    }
    if (stage == 4) {
      if (level == 1) {
        text1.text = 'C';
        text2.text = 'A';
        text3.text = 'B';
        buttonText1.text = 'C';
        buttonText2.text = 'B';
        buttonText3.text = 'A';
      }
      if (level == 2) {
        text1.text = 'I';
        text2.text = '7';
        text3.text = 'J';
        buttonText1.text = 'I';
        buttonText2.text = 'J';
        buttonText3.text = '7';
      }
      if (level == 3) {
        text1.text = '9';
        text2.text = '6';
        text3.text = '8';
        buttonText1.text = '6';
        buttonText2.text = '9';
        buttonText3.text = '8';
      }

      background.sprite = await loadSprite('background4.png');
      Future.delayed(const Duration(milliseconds: 10)).then((value) async {
        slamet2.position = slamet1.position;
        remove(slamet1);
        add(slamet2);
        slamet1Active = false;
        slamet2Active = true;
      });
      Future.delayed(const Duration(milliseconds: 100)).then((value) async {
        if (slamet1.position.y > size.y * (2.5 / 7) - 1) {
          slamet1.position += Vector2(0, -1) * speed * dt;
        }
      });
    }
    if (stage == 5) {
      if (level == 1) {
        text1.text = 'A';
        text2.text = 'C';
        text3.text = 'B';
        buttonText1.text = 'C';
        buttonText2.text = 'B';
        buttonText3.text = 'A';
      }
      if (level == 2) {
        text1.text = '7';
        text2.text = 'I';
        text3.text = 'J';
        buttonText1.text = 'J';
        buttonText2.text = 'I';
        buttonText3.text = '7';
      }
      if (level == 3) {
        text1.text = '8';
        text2.text = '9';
        text3.text = '6';
        buttonText1.text = '6';
        buttonText2.text = '8';
        buttonText3.text = '9';
      }

      background.sprite = await loadSprite('background5.png');

      Future.delayed(const Duration(milliseconds: 10)).then((value) async {
        slamet2.position = slamet1.position;
        remove(slamet2);
        add(slamet1);
        slamet2Active = false;
        slamet1Active = true;
      });

      Future.delayed(const Duration(milliseconds: 100)).then((value) async {
        if (slamet1.position.y > size.y * (2.1 / 7) - 1) {
          slamet1.position += Vector2(0, -1) * speed * dt;
        }
      });
    }
    if (stage == 6) {
      text1.text = 'B';
      text2.text = 'A';
      text3.text = 'C';
      buttonText1.text = 'A';
      buttonText2.text = 'C';
      buttonText3.text = 'B';
      if (level == 2) {
        text1.text = '7';
        text2.text = 'J';
        text3.text = 'I';
        buttonText1.text = 'I';
        buttonText2.text = '7';
        buttonText3.text = 'J';
      }
      if (level == 3) {
        text1.text = '8';
        text2.text = '6';
        text3.text = '9';
        buttonText1.text = '9';
        buttonText2.text = '6';
        buttonText3.text = '8';
      }

      background.sprite = await loadSprite('background6.png');

      Future.delayed(const Duration(milliseconds: 10)).then((value) async {
        slamet2.position = slamet1.position;
        remove(slamet1);
        add(slamet2);
        slamet1Active = false;
        slamet2Active = true;
      });

      Future.delayed(const Duration(milliseconds: 100)).then((value) async {
        if (slamet1.position.y > size.y * (1.7 / 7)) {
          slamet1.position += Vector2(0, -1) * speed * dt;
          // slamet1.sprite = await loadSprite('slamet2.png');
        }
      });
    }
    if (stage == 7) {
      if (level == 1) {
        text1.text = 'A';
        text2.text = 'C';
        text3.text = 'B';
        buttonText1.text = 'C';
        buttonText2.text = 'B';
        buttonText3.text = 'A';
      }
      if (level == 2) {
        text1.text = 'I';
        text2.text = '7';
        text3.text = 'J';
        buttonText1.text = '7';
        buttonText2.text = 'J';
        buttonText3.text = 'I';
      }
      if (level == 3) {
        text1.text = '6';
        text2.text = '8';
        text3.text = '9';
        buttonText1.text = '8';
        buttonText2.text = '6';
        buttonText3.text = '9';
      }

      background.sprite = await loadSprite('background8.png');
      slamet2.position = slamet1.position;
      slamet4.position = slamet1.position;
      Future.delayed(const Duration(milliseconds: 100)).then((value) async {
        if (slamet1.position.y > size.y * (1.3 / 7)) {
          slamet1.position += Vector2(0, -1) * speed * dt;
        }
      });
      Future.delayed(const Duration(milliseconds: 1000)).then((value) async {
        // slamet1.sprite = await loadSprite('slamet3.png');
        // background.sprite = await loadSprite('background8.png');
        remove(slamet2);
        add(slamet4);
        slamet2Active = false;
        slamet4Active = true;
      });
    }
    if (stage == 8) {
      if (level == 1) {
        text1.text = 'B';
        text2.text = 'C';
        text3.text = 'A';
        buttonText1.text = 'A';
        buttonText2.text = 'B';
        buttonText3.text = 'C';
      }
      if (level == 2) {
        text1.text = '7';
        text2.text = 'J';
        text3.text = 'I';
        buttonText1.text = 'I';
        buttonText2.text = '7';
        buttonText3.text = 'J';
      }
      if (level == 3) {
        text1.text = '8';
        text2.text = '9';
        text3.text = '6';
        buttonText1.text = '9';
        buttonText2.text = '6';
        buttonText3.text = '8';
      }
      // slamet1.sprite = await loadSprite('slamet4.png');
      background.sprite = await loadSprite('background9.png');
      slamet4.position = slamet1.position;
      slamet5.position = slamet1.position;
      Future.delayed(const Duration(milliseconds: 10)).then((value) async {
        if (slamet1.position.y < size.y * (1.7 / 7)) {
          slamet1.position += Vector2(0, 1) * speed * dt;
        }
      });
      Future.delayed(const Duration(milliseconds: 20)).then((value) async {
        remove(slamet4);
        add(slamet5);
        slamet4Active = false;
        slamet5Active = true;
      });
    }
    if (stage == 9) {
      if (level == 1) {
        text1.text = 'C';
        text2.text = 'B';
        text3.text = 'A';
        buttonText1.text = 'C';
        buttonText2.text = 'A';
        buttonText3.text = 'B';
      }
      if (level == 2) {
        text1.text = 'I';
        text2.text = 'J';
        text3.text = '7';
        buttonText1.text = '7';
        buttonText2.text = 'J';
        buttonText3.text = 'I';
      }
      if (level == 3) {
        text1.text = '9';
        text2.text = '6';
        text3.text = '8';
        buttonText1.text = '9';
        buttonText2.text = '8';
        buttonText3.text = '6';
      }

      // slamet1.sprite = await loadSprite('slamet3.png');
      background.sprite = await loadSprite('background10.png');
      slamet4.position = slamet1.position;
      slamet5.position = slamet1.position;
      Future.delayed(const Duration(milliseconds: 10)).then((value) async {
        if (slamet1.position.y < size.y * (2.1 / 7) + 1) {
          slamet1.position += Vector2(0, 1) * speed * dt;
        }
      });
      Future.delayed(const Duration(milliseconds: 20)).then((value) async {
        remove(slamet5);
        add(slamet4);
        slamet5Active = false;
        slamet4Active = true;
      });
    }
    if (stage == 10) {
      if (level == 1) {
        text1.text = 'A';
        text2.text = 'C';
        text3.text = 'B';
        buttonText1.text = 'A';
        buttonText2.text = 'B';
        buttonText3.text = 'C';
      }
      if (level == 2) {
        text1.text = 'J';
        text2.text = 'I';
        text3.text = '7';
        buttonText1.text = 'I';
        buttonText2.text = 'J';
        buttonText3.text = '7';
      }
      if (level == 3) {
        text1.text = '8';
        text2.text = '9';
        text3.text = '6';
        buttonText1.text = '9';
        buttonText2.text = '8';
        buttonText3.text = '6';
      }

      // slamet1.sprite = await loadSprite('slamet4.png');
      background.sprite = await loadSprite('background11.png');
      slamet4.position = slamet1.position;
      slamet5.position = slamet1.position;
      Future.delayed(const Duration(milliseconds: 10)).then((value) async {
        if (slamet1.position.y < size.y * (2.5 / 7) + 1) {
          slamet1.position += Vector2(0, 1) * speed * dt;
        }
      });
      Future.delayed(const Duration(milliseconds: 20)).then((value) async {
        remove(slamet4);
        add(slamet5);
        slamet4Active = false;
        slamet5Active = true;
      });
    }
    if (stage == 11) {
      if (level == 1) {
        text1.text = 'A';
        text2.text = 'B';
        text3.text = 'C';
        buttonText1.text = 'B';
        buttonText2.text = 'A';
        buttonText3.text = 'C';
      }
      if (level == 2) {
        text1.text = 'I';
        text2.text = '7';
        text3.text = 'J';
        buttonText1.text = 'J';
        buttonText2.text = 'I';
        buttonText3.text = '7';
      }
      if (level == 3) {
        text1.text = '6';
        text2.text = '8';
        text3.text = '9';
        buttonText1.text = '6';
        buttonText2.text = '9';
        buttonText3.text = '8';
      }

      // slamet1.sprite = await loadSprite('slamet3.png');
      background.sprite = await loadSprite('background12.png');
      slamet4.position = slamet1.position;
      slamet5.position = slamet1.position;
      Future.delayed(const Duration(milliseconds: 10)).then((value) async {
        if (slamet1.position.y < size.y * (3 / 7) + 1) {
          slamet1.position += Vector2(0, 1) * speed * dt;
        }
      });
      Future.delayed(const Duration(milliseconds: 20)).then((value) async {
        remove(slamet5);
        add(slamet4);
        slamet5Active = false;
        slamet4Active = true;
      });
    }
    if (stage == 12) {
      if (level == 1) {
        text1.text = 'B';
        text2.text = 'C';
        text3.text = 'A';
        buttonText1.text = 'A';
        buttonText2.text = 'B';
        buttonText3.text = 'C';
      }
      if (level == 2) {
        text1.text = '7';
        text2.text = 'I';
        text3.text = 'J';
        buttonText1.text = 'I';
        buttonText2.text = '7';
        buttonText3.text = 'J';
      }
      if (level == 3) {
        text1.text = '9';
        text2.text = '8';
        text3.text = '6';
        buttonText1.text = '9';
        buttonText2.text = '6';
        buttonText3.text = '8';
      }
      background.sprite = await loadSprite('background13.png');
      slamet4.position = slamet1.position;
      if (slamet1.position.y < size.y * (3.6 / 7) + 1) {
        slamet1.position += Vector2(0, 1) * speed * dt;
      }
    }
    if (stage == 13) {
      remove(button1);
      remove(button2);
      remove(button3);
      remove(word2);
      remove(text1);
      remove(text2);
      remove(text3);
      remove(buttonText1);
      remove(buttonText2);
      remove(buttonText3);
      remove(timerButton);
      remove(timerText);
      // text1.text = 'Y';
      // text2.text = 'O';
      // text3.text = 'U';
      // buttonText1.text = 'W';
      // buttonText2.text = 'O';
      // buttonText3.text = 'N';
      // button1.onPressed = () {};
      // button2.onPressed = () {};
      // button3.onPressed = () {};
      // timerText.text = '';
      background.sprite = await loadSprite('background14.png');
      slamet4.position = slamet1.position;
      if (slamet1.position.y < size.y * (4.5 / 7)) {
        slamet1.position += Vector2(0, 1) * speed * dt;
      }
      Future.delayed(const Duration(milliseconds: 1500)).then((value) async {
        slamet1.position += Vector2(0, 0) * 50 * dt;
        slametHappy.position = slamet1.position;
        remove(slamet4);
        add(slametHappy);
      });
      Future.delayed(const Duration(milliseconds: 3500)).then((value) async {
        pauseEngine();
        overlays.add(GameWinMenu.id);
        end = DateTime.now().toString();
        result = 1;
        basket.addAll({
          'idGame': idGame,
          'level': level,
          'result': result,
          'start': start,
          'end': end,
        });
        log(basket['idGame'].toString());
        log(basket['level'].toString());
        log(basket['result'].toString());
        log(basket['start']);
        log(basket['end']);
      });
    }

    super.update(dt);
  }
}
