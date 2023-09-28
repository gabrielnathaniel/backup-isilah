import 'dart:developer';

import 'package:flame/components.dart';
import 'dart:math' as math;
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/games/lompatkaret/game/actor.dart';
import 'package:isilahtitiktitik/games/lompatkaret/game/enemy.dart';
import 'package:isilahtitiktitik/games/lompatkaret/game/enemy_happy.dart';
import 'package:isilahtitiktitik/games/lompatkaret/game/enemy_sad.dart';
import 'package:isilahtitiktitik/games/lompatkaret/game/player.dart';
import 'package:isilahtitiktitik/games/lompatkaret/game/rope.dart';
import 'package:isilahtitiktitik/games/lompatkaret/game/ufo.dart';
import 'package:isilahtitiktitik/games/lompatkaret/game/ufo2.dart';
import 'package:isilahtitiktitik/games/lompatkaret/widgets/game_over_menu.dart';
import 'package:isilahtitiktitik/games/lompatkaret/widgets/game_win_menu.dart';
import 'package:provider/provider.dart';

class LompatKaretGame extends FlameGame {
  late Player player;
  late Enemy enemy;
  late EnemyHappy enemyHappy;
  late EnemySad enemySad;
  late Rope rope;
  late Actor actor;
  late Ufo ufo;
  late Ufo2 ufo2;

  bool halfScreen = false;

  late String start = DateTime.now().toString();
  late String end = DateTime.now().toString();
  late int result = 0;

  late int idGame = 3;

  BuildContext? context;
  int level;
  double finalValue;

  LompatKaretGame(this.context, this.level, this.finalValue);

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void>? onLoad() async {
    await images.load('ufo_loncattali_idle.png');
    await images.load('ufo_loncattali_absorb.png');
    await images.load('isiboy_loncattali_idle.png');
    await images.load('isiboy_loncattali_ufo.png');
    await images.load('goblin_loncattali_idle.png');
    await images.load('goblin_loncattali_happy.png');
    await images.load('goblin_loncattali_sad.png');

    player = Player(
      animation: SpriteAnimation.fromFrameData(
        images.fromCache('isiboy_loncattali_idle.png'),
        SpriteAnimationData.sequenced(
          amount: 60,
          stepTime: 0.1,
          textureSize: Vector2.all(100),
        ),
      ),
      // size: Vector2(55, 73),
      position: Vector2(size.x * (3 / 12) - 7, size.y * (6 / 7)),
      anchor: Anchor.center,
    );

    enemy = Enemy(
      animation: SpriteAnimation.fromFrameData(
        images.fromCache('goblin_loncattali_idle.png'),
        SpriteAnimationData.sequenced(
          amount: 186,
          stepTime: 0.05,
          textureSize: Vector2(248, 80),
          amountPerRow: 93,
        ),
      ),
      position: Vector2(size.x * (1 / 2) + 5, size.y * (3.7 / 5)),
      anchor: Anchor.center,
    );

    enemySad = EnemySad(
      animation: SpriteAnimation.fromFrameData(
        images.fromCache('goblin_loncattali_sad.png'),
        SpriteAnimationData.sequenced(
          amount: 122,
          stepTime: 0.05,
          textureSize: Vector2(248, 80),
        ),
      ),
      position: Vector2(size.x * (1 / 2) + 5, size.y * (3.7 / 5)),
      anchor: Anchor.center,
    );

    enemyHappy = EnemyHappy(
      animation: SpriteAnimation.fromFrameData(
        images.fromCache('goblin_loncattali_happy.png'),
        SpriteAnimationData.sequenced(
          amount: 122,
          stepTime: 0.04,
          textureSize: Vector2(248, 80),
        ),
      ),
      position: Vector2(size.x * (1 / 2) + 5, size.y * (3.7 / 5)),
      anchor: Anchor.center,
    );

    ufo = Ufo();
    ufo.position = Vector2(size.x * (1 / 3), -90);
    ufo.size = Vector2(159, 202);

    ufo2 = Ufo2();
    ufo2.size = Vector2(159, 202);

    add(enemy);
    add(player);
    add(ufo);
  }

  @override
  void update(double dt) {
    Map<String, dynamic> basket = Provider.of(context!, listen: false);
    super.update(dt);
    double speed = 300;
    if (level == 1) {
      if (finalValue > 69 && finalValue < 86 && halfScreen == false) {
        player.position += Vector2(2, -6) * speed * dt;
        ufo.position += Vector2(0, 5) * speed * dt;
        if (player.position.x > size.x / 2) {
          halfScreen = true;
          Future.delayed(const Duration(milliseconds: 700)).then((value) {
            ufo2.position = ufo.position;
            add(ufo2);
            remove(ufo);
            player.animation = SpriteAnimation.fromFrameData(
              images.fromCache('isiboy_loncattali_ufo.png'),
              SpriteAnimationData.sequenced(
                amount: 60,
                stepTime: 0.05,
                textureSize: Vector2.all(100),
              ),
            );
          });
          Future.delayed(const Duration(milliseconds: 900)).then((value) {
            player.position += Vector2(0, -1) * speed * dt;
            player.size -= Vector2(5, 5) * speed * dt;
          });
          Future.delayed(const Duration(milliseconds: 1300)).then((value) {
            player.position += Vector2(0, -1) * speed * dt;
            player.size -= Vector2(5, 5) * speed * dt;
          });
          Future.delayed(const Duration(milliseconds: 1700)).then((value) {
            remove(player);
          });
          Future.delayed(const Duration(milliseconds: 2000)).then((value) {
            remove(ufo2);
            add(ufo);
          });
          Future.delayed(const Duration(milliseconds: 2500)).then((value) {
            remove(enemy);
            add(enemyHappy);
          });
          Future.delayed(const Duration(milliseconds: 4500)).then((value) {
            end = DateTime.now().toString();
            result = 0;
            basket.addAll({
              'idGame': idGame,
              'level': level,
              'result': result,
              'start': start,
              'end': end,
              'lose': 3,
            });
            log(basket['idGame'].toString());
            log(basket['level'].toString());
            log(basket['result'].toString());
            log(basket['start']);
            log(basket['end']);
            log(basket['lose'].toString());
            pauseEngine();
            overlays.add(GameOverMenu.id);
          });
        }
      }
      if (finalValue > 85 && finalValue <= 100) {
        player.position += Vector2(2, -6) * speed * dt;
        Future.delayed(const Duration(milliseconds: 500)).then((value) {
          remove(enemy);
          add(enemyHappy);
        });
        Future.delayed(const Duration(milliseconds: 2500)).then((value) {
          end = DateTime.now().toString();
          result = 0;
          basket.addAll({
            'idGame': idGame,
            'level': level,
            'result': result,
            'start': start,
            'end': end,
            'lose': 4,
          });
          log(basket['idGame'].toString());
          log(basket['level'].toString());
          log(basket['result'].toString());
          log(basket['start']);
          log(basket['end']);
          log(basket['lose'].toString());
          pauseEngine();
          overlays.add(GameOverMenu.id);
        });
      }
      if (finalValue > 14 && finalValue < 31) {
        player.position += Vector2(6, -8) * 50 * dt;
        if (player.position.x > size.x / 2) {
          player.position += Vector2(0, 15) * 50 * dt;
          player.angle += -10 * dt;
          player.angle %= 2 * math.pi;
          Future.delayed(const Duration(milliseconds: 500)).then((value) {
            remove(enemy);
            add(enemyHappy);
          });
          Future.delayed(const Duration(milliseconds: 2500)).then((value) {
            end = DateTime.now().toString();
            result = 0;
            basket.addAll({
              'idGame': idGame,
              'level': level,
              'result': result,
              'start': start,
              'end': end,
              'lose': 2,
            });
            log(basket['idGame'].toString());
            log(basket['level'].toString());
            log(basket['result'].toString());
            log(basket['start']);
            log(basket['end']);
            log(basket['lose'].toString());
            pauseEngine();
            overlays.add(GameOverMenu.id);
          });
        }
      }
      if (finalValue > 0 && finalValue < 15) {
        player.position += Vector2(2, 0) * speed * dt;
        player.angle += 25 * dt;
        player.angle %= 2 * math.pi;
        Future.delayed(const Duration(milliseconds: 500)).then((value) {
          remove(enemy);
          add(enemyHappy);
        });
        Future.delayed(const Duration(milliseconds: 2500)).then((value) {
          end = DateTime.now().toString();
          result = 0;
          basket.addAll({
            'idGame': idGame,
            'level': level,
            'result': result,
            'start': start,
            'end': end,
            'lose': 1,
          });
          log(basket['idGame'].toString());
          log(basket['level'].toString());
          log(basket['result'].toString());
          log(basket['start']);
          log(basket['end']);
          log(basket['lose'].toString());
          pauseEngine();
          overlays.add(GameOverMenu.id);
        });
      }
      if (finalValue <= 69 && finalValue >= 31 && halfScreen == false) {
        player.position += Vector2(3, -5) * 50 * dt;
        player.size -= Vector2(3, 3) * 10 * dt;
        if (player.position.x > size.x / 2) {
          halfScreen = true;
          Future.delayed(const Duration(milliseconds: 100)).then((value) {
            remove(enemy);
            add(enemySad);
          });
          Future.delayed(const Duration(milliseconds: 1000)).then((value) {
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
      }
    }
    if (level == 2) {
      if (finalValue > 63 && finalValue < 82 && halfScreen == false) {
        player.position += Vector2(2, -6) * speed * dt;
        ufo.position += Vector2(0, 5) * speed * dt;
        if (player.position.x > size.x / 2) {
          halfScreen = true;
          Future.delayed(const Duration(milliseconds: 700)).then((value) {
            ufo2.position = ufo.position;
            add(ufo2);
            remove(ufo);
            player.animation = SpriteAnimation.fromFrameData(
              images.fromCache('isiboy_loncattali_ufo.png'),
              SpriteAnimationData.sequenced(
                amount: 60,
                stepTime: 0.05,
                textureSize: Vector2.all(100),
              ),
            );
          });
          Future.delayed(const Duration(milliseconds: 900)).then((value) {
            player.position += Vector2(0, -1) * speed * dt;
            player.size -= Vector2(5, 5) * speed * dt;
          });
          Future.delayed(const Duration(milliseconds: 1300)).then((value) {
            player.position += Vector2(0, -1) * speed * dt;
            player.size -= Vector2(5, 5) * speed * dt;
          });
          Future.delayed(const Duration(milliseconds: 1700)).then((value) {
            remove(player);
          });
          Future.delayed(const Duration(milliseconds: 2000)).then((value) {
            remove(ufo2);
            add(ufo);
          });
          Future.delayed(const Duration(milliseconds: 2500)).then((value) {
            remove(enemy);
            add(enemyHappy);
          });
          Future.delayed(const Duration(milliseconds: 4500)).then((value) {
            end = DateTime.now().toString();
            result = 0;
            basket.addAll({
              'idGame': idGame,
              'level': level,
              'result': result,
              'start': start,
              'end': end,
              'lose': 3,
            });
            log(basket['idGame'].toString());
            log(basket['level'].toString());
            log(basket['result'].toString());
            log(basket['start']);
            log(basket['end']);
            pauseEngine();
            overlays.add(GameOverMenu.id);
          });
        }
      }
      if (finalValue > 81 && finalValue <= 100) {
        player.position += Vector2(2, -6) * speed * dt;
        Future.delayed(const Duration(milliseconds: 500)).then((value) {
          remove(enemy);
          add(enemyHappy);
        });
        Future.delayed(const Duration(milliseconds: 2500)).then((value) {
          end = DateTime.now().toString();
          result = 0;
          basket.addAll({
            'idGame': idGame,
            'level': level,
            'result': result,
            'start': start,
            'end': end,
            'lose': 4,
          });
          log(basket['idGame'].toString());
          log(basket['level'].toString());
          log(basket['result'].toString());
          log(basket['start']);
          log(basket['end']);
          pauseEngine();
          overlays.add(GameOverMenu.id);
        });
      }
      if (finalValue > 18 && finalValue < 38) {
        player.position += Vector2(6, -8) * 50 * dt;
        if (player.position.x > size.x / 2) {
          player.position += Vector2(0, 15) * 50 * dt;
          player.angle += -10 * dt;
          player.angle %= 2 * math.pi;
          Future.delayed(const Duration(milliseconds: 500)).then((value) {
            remove(enemy);
            add(enemyHappy);
          });
          Future.delayed(const Duration(milliseconds: 2500)).then((value) {
            end = DateTime.now().toString();
            result = 0;
            basket.addAll({
              'idGame': idGame,
              'level': level,
              'result': result,
              'start': start,
              'end': end,
              'lose': 2,
            });
            log(basket['idGame'].toString());
            log(basket['level'].toString());
            log(basket['result'].toString());
            log(basket['start']);
            log(basket['end']);
            log(basket['lose'].toString());
            pauseEngine();
            overlays.add(GameOverMenu.id);
          });
        }
      }
      if (finalValue > 0 && finalValue < 19) {
        player.position += Vector2(2, 0) * speed * dt;
        player.angle += 25 * dt;
        player.angle %= 2 * math.pi;
        Future.delayed(const Duration(milliseconds: 500)).then((value) {
          remove(enemy);
          add(enemyHappy);
        });
        Future.delayed(const Duration(milliseconds: 2500)).then((value) {
          end = DateTime.now().toString();
          result = 0;
          basket.addAll({
            'idGame': idGame,
            'level': level,
            'result': result,
            'start': start,
            'end': end,
            'lose': 1,
          });
          log(basket['idGame'].toString());
          log(basket['level'].toString());
          log(basket['result'].toString());
          log(basket['start']);
          log(basket['end']);
          log(basket['lose'].toString());
          pauseEngine();
          overlays.add(GameOverMenu.id);
        });
      }
      if (finalValue <= 63 && finalValue >= 38 && halfScreen == false) {
        player.position += Vector2(3, -5) * 50 * dt;
        player.size -= Vector2(3, 3) * 10 * dt;
        if (player.position.x > size.x / 2) {
          halfScreen = true;
          Future.delayed(const Duration(milliseconds: 100)).then((value) {
            remove(enemy);
            add(enemySad);
          });
          Future.delayed(const Duration(milliseconds: 1000)).then((value) {
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
      }
    }
    if (level == 3) {
      if (finalValue > 58 && finalValue < 81 && halfScreen == false) {
        player.position += Vector2(2, -6) * speed * dt;
        ufo.position += Vector2(0, 5) * speed * dt;
        if (player.position.x > size.x / 2) {
          halfScreen = true;
          Future.delayed(const Duration(milliseconds: 700)).then((value) {
            ufo2.position = ufo.position;
            add(ufo2);
            remove(ufo);
            player.animation = SpriteAnimation.fromFrameData(
              images.fromCache('isiboy_loncattali_ufo.png'),
              SpriteAnimationData.sequenced(
                amount: 60,
                stepTime: 0.05,
                textureSize: Vector2.all(100),
              ),
            );
          });
          Future.delayed(const Duration(milliseconds: 900)).then((value) {
            player.position += Vector2(0, -1) * speed * dt;
            player.size -= Vector2(5, 5) * speed * dt;
          });
          Future.delayed(const Duration(milliseconds: 1300)).then((value) {
            player.position += Vector2(0, -1) * speed * dt;
            player.size -= Vector2(5, 5) * speed * dt;
          });
          Future.delayed(const Duration(milliseconds: 1700)).then((value) {
            remove(player);
          });
          Future.delayed(const Duration(milliseconds: 2000)).then((value) {
            remove(ufo2);
            add(ufo);
          });
          Future.delayed(const Duration(milliseconds: 2500)).then((value) {
            remove(enemy);
            add(enemyHappy);
          });
          Future.delayed(const Duration(milliseconds: 4500)).then((value) {
            end = DateTime.now().toString();
            result = 0;
            basket.addAll({
              'idGame': idGame,
              'level': level,
              'result': result,
              'start': start,
              'end': end,
              'lose': 3,
            });
            log(basket['idGame'].toString());
            log(basket['level'].toString());
            log(basket['result'].toString());
            log(basket['start']);
            log(basket['end']);
            log(basket['lose'].toString());
            pauseEngine();
            overlays.add(GameOverMenu.id);
          });
        }
      }
      if (finalValue > 80 && finalValue <= 100) {
        player.position += Vector2(2, -6) * speed * dt;
        Future.delayed(const Duration(milliseconds: 500)).then((value) {
          remove(enemy);
          add(enemyHappy);
        });
        Future.delayed(const Duration(milliseconds: 2500)).then((value) {
          end = DateTime.now().toString();
          result = 0;
          basket.addAll({
            'idGame': idGame,
            'level': level,
            'result': result,
            'start': start,
            'end': end,
            'lose': 4,
          });
          log(basket['idGame'].toString());
          log(basket['level'].toString());
          log(basket['result'].toString());
          log(basket['start']);
          log(basket['end']);
          log(basket['lose'].toString());
          pauseEngine();
          overlays.add(GameOverMenu.id);
        });
      }
      if (finalValue > 20 && finalValue < 43) {
        player.position += Vector2(6, -8) * 50 * dt;
        if (player.position.x > size.x / 2) {
          player.position += Vector2(0, 15) * 50 * dt;
          player.angle += -10 * dt;
          player.angle %= 2 * math.pi;
          Future.delayed(const Duration(milliseconds: 500)).then((value) {
            remove(enemy);
            add(enemyHappy);
          });
          Future.delayed(const Duration(milliseconds: 2500)).then((value) {
            end = DateTime.now().toString();
            result = 0;
            basket.addAll({
              'idGame': idGame,
              'level': level,
              'result': result,
              'start': start,
              'end': end,
              'lose': 2
            });
            log(basket['idGame'].toString());
            log(basket['level'].toString());
            log(basket['result'].toString());
            log(basket['start']);
            log(basket['end']);
            log(basket['lose'].toString());
            pauseEngine();
            overlays.add(GameOverMenu.id);
          });
        }
      }
      if (finalValue > 0 && finalValue < 21) {
        player.position += Vector2(2, 0) * speed * dt;
        player.angle += 25 * dt;
        player.angle %= 2 * math.pi;
        Future.delayed(const Duration(milliseconds: 500)).then((value) {
          remove(enemy);
          add(enemyHappy);
        });
        Future.delayed(const Duration(milliseconds: 2500)).then((value) {
          end = DateTime.now().toString();
          result = 0;
          basket.addAll({
            'idGame': idGame,
            'level': level,
            'result': result,
            'start': start,
            'end': end,
            'lose': 1,
          });
          log(basket['idGame'].toString());
          log(basket['level'].toString());
          log(basket['result'].toString());
          log(basket['start']);
          log(basket['end']);
          log(basket['lose'].toString());
          pauseEngine();
          overlays.add(GameOverMenu.id);
        });
      }
      if (finalValue <= 58 && finalValue >= 43 && halfScreen == false) {
        player.position += Vector2(3, -5) * 50 * dt;
        player.size -= Vector2(3, 3) * 10 * dt;
        if (player.position.x > size.x / 2) {
          halfScreen = true;
          Future.delayed(const Duration(milliseconds: 100)).then((value) {
            remove(enemy);
            add(enemySad);
          });
          Future.delayed(const Duration(milliseconds: 1000)).then((value) {
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
      }
    }
  }
}
