import 'package:isilahtitiktitik/games/engklek/game/game.dart';
import 'package:flame/components.dart';

class Background extends SpriteComponent with HasGameRef<EngklekGame> {
  Background({
    Sprite? sprite,
    Vector2? size,
  }) : super(sprite: sprite, size: size);
}
