import 'package:flame/components.dart';
import 'package:isilahtitiktitik/games/tariktambang/game/game.dart';

class EnemyLose extends SpriteAnimationComponent
    with HasGameRef<TarikTambangGame> {
  EnemyLose({
    SpriteAnimation? animation,
    Vector2? position,
  }) : super(animation: animation, position: position);
}
