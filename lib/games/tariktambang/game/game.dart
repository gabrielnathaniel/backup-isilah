import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:isilahtitiktitik/games/tariktambang/game/enemy_lose.dart';
import 'package:isilahtitiktitik/games/tariktambang/game/enemy_win.dart';
import 'package:isilahtitiktitik/games/tariktambang/game/player_lose.dart';
import 'package:isilahtitiktitik/games/tariktambang/game/player_win.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import './enemy.dart';
import './player.dart';
import './rope.dart';
import '../widgets/overlays/game_over.dart';
import '../widgets/overlays/game_win.dart';

class TarikTambangGame extends FlameGame with TapDetector {
  late Player player;
  late PlayerWin playerWin;
  late PlayerLose playerLose;
  late Enemy enemy;
  late EnemyWin enemyWin;
  late EnemyLose enemyLose;
  late Rope rope;

  late String start = DateTime.now().toString();
  late String end = DateTime.now().toString();
  late int result = 0;

  late int idGame = 1;

  BuildContext? context;
  double movementSpeed;
  int level;

  TarikTambangGame(this.context, this.movementSpeed, this.level);

  bool _isAlreadyLoaded = false;

  final _player = AudioPlayer();

  @override
  Future<void> onLoad() async {
    if (!_isAlreadyLoaded) {
      _player.setAsset('assets/audio/tarik_mang.wav').then((value) {
        _player.play();
      });

      await images.load('rope_tilesheet.png');
      await images.load('isiboy_tariktambang_tarik.png');
      await images.load('isiboy_tariktambang_menang.png');
      await images.load('isiboy_tariktambang_kalah.png');
      await images.load('goblin_tariktambang_tarik.png');
      await images.load('goblin_tariktambang_menang.png');
      await images.load('goblin_tariktambang_kalah.png');

      final ropeSheet = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('rope_tilesheet.png'),
        columns: 18,
        rows: 7,
      );

      player = Player(
        animation: SpriteAnimation.fromFrameData(
          images.fromCache('isiboy_tariktambang_tarik.png'),
          SpriteAnimationData.sequenced(
            amount: 144,
            stepTime: 0.01,
            textureSize: Vector2.all(100),
          ),
        ),
        // size: Vector2(60, 80),
        position: Vector2(size.x * (1 / 12) + 40, size.y * (3 / 4) - 10),
      );

      playerWin = PlayerWin(
        animation: SpriteAnimation.fromFrameData(
          images.fromCache('isiboy_tariktambang_menang.png'),
          SpriteAnimationData.sequenced(
            amount: 119,
            stepTime: 0.03,
            textureSize: Vector2.all(100),
          ),
        ),
        position: Vector2((size.x / 2 - 202), size.y * (3 / 4) - 10),
      );

      playerLose = PlayerLose(
        animation: SpriteAnimation.fromFrameData(
          images.fromCache('isiboy_tariktambang_kalah.png'),
          SpriteAnimationData.sequenced(
            amount: 116,
            stepTime: 0.03,
            textureSize: Vector2(150, 100),
          ),
        ),
        position: Vector2((size.x / 2 - 20), size.y * (3 / 4) - 10),
      );

      enemy = Enemy(
        animation: SpriteAnimation.fromFrameData(
          images.fromCache('goblin_tariktambang_tarik.png'),
          SpriteAnimationData.sequenced(
            amount: 144,
            stepTime: 0.01,
            textureSize: Vector2.all(90),
            amountPerRow: 12,
          ),
        ),
        // size: Vector2(60, 80),
        position: Vector2(size.x * (9 / 12) - 65, size.y * (3 / 4) - 8.5),
      );

      enemyWin = EnemyWin(
          animation: SpriteAnimation.fromFrameData(
            images.fromCache('goblin_tariktambang_menang.png'),
            SpriteAnimationData.sequenced(
              amount: 96,
              stepTime: 0.05,
              textureSize: Vector2.all(90),
            ),
          ),
          position: Vector2((size.x / 2 + 137), size.y * (3 / 4) - 8.5));

      enemyLose = EnemyLose(
        animation: SpriteAnimation.fromFrameData(
          images.fromCache('goblin_tariktambang_kalah.png'),
          SpriteAnimationData.sequenced(
            amount: 120,
            stepTime: 0.03,
            textureSize: Vector2(142.5, 95),
          ),
        ),
        position: Vector2((size.x / 2 - 80), size.y * (3 / 4) - 8.5),
      );

      rope = Rope(
        sprite: await loadSprite('talitambang.png'),
        // size: Vector2(size.x * (9 / 10), size.x * (8 / 10) / 12 + 5),
        size: Vector2(124, 30),
        position: Vector2(size.x / 2 - 52, size.y * (3 / 4) + 50),
      );

      SpriteComponent line = SpriteComponent(
        sprite: ropeSheet.getSpriteById(0),
        size: Vector2(10, 150),
        position: Vector2(size.x / 2 - 5, size.y * (3 / 4) - 25),
      );

      SpriteComponent background = SpriteComponent(
        sprite: await loadSprite('monas.png'),
        size: Vector2(size.x, size.y),
        // position: Vector2(-200, -50),
      );

      add(background);
      add(line);
      add(player);
      add(enemy);
      add(rope);

      start = DateTime.now().toString();

      _isAlreadyLoaded = true;
    }
  }

  @override
  void update(double dt) {
    Map<String, dynamic> basket = Provider.of(context!, listen: false);
    super.update(dt);

    double speed = movementSpeed;

    player.position += Vector2(2, 0) * speed * dt;
    enemy.position += Vector2(2, 0) * speed * dt;
    rope.position += Vector2(2, 0) * speed * dt;

    if (player.position.x >= (size.x / 2 - 20)) {
      Future.delayed(const Duration(milliseconds: 100)).then((value) {
        player.position += Vector2(0, 0) * 50 * dt;
        enemy.position += Vector2(0, 0) * 50 * dt;
        rope.position += Vector2(0, 0) * 50 * dt;

        player.position = Vector2(size.x + 100, size.y * (3 / 4) - 10);
        enemy.position = Vector2(size.x + 100, size.y * (3 / 4) - 10);

        // remove(player);
        // remove(enemy);
        add(playerLose);
        add(enemyWin);
      });
      Future.delayed(const Duration(milliseconds: 200)).then((value) {
        // remove(rope);
        rope.position = Vector2(size.x + 100, size.y * (3 / 4) - 10);
      });
      Future.delayed(const Duration(milliseconds: 1500)).then((value) {
        end = DateTime.now().toString();
        result = 0;
        basket.addAll({
          'idGame': idGame,
          'level': level,
          'result': result,
          'start': start,
          'end': end,
        });
        pauseEngine();
        overlays.add(GameOverMenu.id);
      });
    }
    if (enemy.position.x <= (size.x / 2 - 45)) {
      Future.delayed(const Duration(milliseconds: 100)).then((value) {
        player.position += Vector2(0, 0) * 50 * dt;
        enemy.position += Vector2(0, 0) * 50 * dt;
        rope.position += Vector2(0, 0) * 50 * dt;

        player.position = Vector2(size.x / 12, size.y + 100);
        enemy.position = Vector2(size.x + 100, size.y * (3 / 4) - 10);

        // remove(player);
        // remove(enemy);
        add(playerWin);
        add(enemyLose);
      });
      Future.delayed(const Duration(milliseconds: 200)).then((value) {
        // remove(rope);
        rope.position = Vector2(size.x + 100, size.y * (3 / 4) - 10);
      });
      Future.delayed(const Duration(milliseconds: 1500)).then((value) {
        end = DateTime.now().toString();
        result = 1;
        basket.addAll({
          'idGame': idGame,
          'level': level,
          'result': result,
          'start': start,
          'end': end,
        });
        pauseEngine();
        overlays.add(GameWinMenu.id);
      });
    }
  }

  @override
  void onTap() {
    player.position -= Vector2(20, 0);
    enemy.position -= Vector2(20, 0);
    rope.position -= Vector2(20, 0);
  }

  void reset() {
    player.position = Vector2(size.x * (1 / 12) + 40, size.y * (3 / 4) - 10);
    enemy.position = Vector2(size.x * (9 / 12) - 65, size.y * (3 / 4) - 8.5);
    rope.position = Vector2(size.x / 2 - 52, size.y * (3 / 4) + 50);

    remove(playerLose);
    remove(enemyWin);
  }
}
