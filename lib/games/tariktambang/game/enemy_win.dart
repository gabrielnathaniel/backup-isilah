import 'package:flame/components.dart';
import 'package:isilahtitiktitik/games/tariktambang/game/game.dart';

class EnemyWin extends SpriteAnimationComponent
    with HasGameRef<TarikTambangGame> {
  EnemyWin({
    SpriteAnimation? animation,
    Vector2? position,
  }) : super(animation: animation, position: position);
}
