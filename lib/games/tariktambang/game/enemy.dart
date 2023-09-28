import 'package:flame/components.dart';
import 'package:isilahtitiktitik/games/tariktambang/game/game.dart';

class Enemy extends SpriteAnimationComponent with HasGameRef<TarikTambangGame> {
  Enemy({
    SpriteAnimation? animation,
    Vector2? position,
  }) : super(animation: animation, position: position);
}
