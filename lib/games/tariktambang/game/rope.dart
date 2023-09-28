import 'package:flame/components.dart';
import 'package:isilahtitiktitik/games/tariktambang/game/game.dart';

class Rope extends SpriteComponent with HasGameRef<TarikTambangGame> {
  Rope({
    Sprite? sprite,
    Vector2? size,
    Vector2? position,
  }) : super(sprite: sprite, size: size, position: position);
}
