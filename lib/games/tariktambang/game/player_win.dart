import 'package:flame/components.dart';
import 'package:isilahtitiktitik/games/tariktambang/game/game.dart';

class PlayerWin extends SpriteAnimationComponent
    with HasGameRef<TarikTambangGame> {
  PlayerWin({
    SpriteAnimation? animation,
    Vector2? position,
  }) : super(animation: animation, position: position);
}
