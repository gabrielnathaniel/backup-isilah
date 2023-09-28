import 'dart:math';

import 'package:flame/components.dart';

import '../game/enemy.dart';
import '../game/game.dart';
import '../models/enemy_data.dart';

// This class is responsible for spawning random enemies at certain
// interval of time depending upon players current score.
class EnemyManager extends Component with HasGameRef<RunningGame> {
  // A list to hold data for all the enemies.
  final List<EnemyData> _data = [];

  // Random generator required for randomly selecting enemy type.
  final Random _random = Random();

  // Timer to decide when to spawn next enemy.
  final Timer _timer = Timer(1.5, repeat: true);

  EnemyManager() {
    _timer.onTick = spawnRandomEnemy;
  }

  // This method is responsible for spawning a random enemy.
  void spawnRandomEnemy() {
    /// Generate a random index within [_data] and get an [EnemyData].
    final randomIndex = _random.nextInt(_data.length);
    final enemyData = _data.elementAt(randomIndex);
    final enemy = Enemy(enemyData);

    // Help in setting all enemies on ground.
    enemy.anchor = Anchor.bottomLeft;
    enemy.position = Vector2(
      gameRef.size.x + 32,
      gameRef.size.y - 40,
    );

    // If this enemy can fly, set its y position randomly.
    if (enemyData.canFly) {
      final newHeight = _random.nextDouble() * 2 * enemyData.textureSize.y;
      enemy.position.y -= newHeight;
    }

    // Due to the size of our viewport, we can
    // use textureSize as size for the components.
    enemy.size = enemyData.textureSize;
    gameRef.add(enemy);
  }

  @override
  void onMount() {
    if (isMounted) {
      removeFromParent();
    }

    // Don't fill list again and again on every mount.
    if (_data.isEmpty) {
      // As soon as this component is mounted, initilize all the data.
      _data.addAll([
        EnemyData(
          image: gameRef.images.fromCache('goblin_walk_redesign.png'),
          nFrames: 49,
          stepTime: 0.03,
          // textureSize: Vector2(61, 60),
          textureSize: Vector2(153, 150),
          speedX: 250,
          canFly: false,
        ),
        EnemyData(
          image: gameRef.images.fromCache('bird_fly_redesign.png'),
          nFrames: 121,
          stepTime: 0.05,
          // textureSize: Vector2(40, 35),
          textureSize: Vector2(127, 125),
          speedX: 270,
          canFly: true,
        ),
        EnemyData(
          image: gameRef.images.fromCache('pig_run_redesign.png'),
          nFrames: 213,
          stepTime: 0.04,
          // textureSize: Vector2(47, 40),
          textureSize: Vector2(132.5, 130),
          speedX: 300,
          canFly: false,
        ),
      ]);
    }
    _timer.start();
    super.onMount();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    super.update(dt);
  }

  void removeAllEnemies() {
    final enemies = gameRef.children.whereType<Enemy>();
    for (var enemy in enemies) {
      enemy.removeFromParent();
    }
  }
}
