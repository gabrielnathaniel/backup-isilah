import 'package:flame/components.dart';
import 'package:isilahtitiktitik/games/tariktambang/game/game.dart';

class PlayerLose extends SpriteAnimationComponent
    with HasGameRef<TarikTambangGame> {
  PlayerLose({
    SpriteAnimation? animation,
    Vector2? position,
  }) : super(animation: animation, position: position);
}
