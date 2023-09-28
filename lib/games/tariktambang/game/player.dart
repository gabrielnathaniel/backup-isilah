import 'package:flame/components.dart';
import 'package:isilahtitiktitik/games/tariktambang/game/game.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef<TarikTambangGame> {
  Player({
    SpriteAnimation? animation,
    Vector2? position,
  }) : super(animation: animation, position: position);
}
