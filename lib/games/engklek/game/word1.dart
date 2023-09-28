import 'package:isilahtitiktitik/games/engklek/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';

class Word1 extends SpriteButtonComponent with HasGameRef<EngklekGame> {
  Word1({
    Sprite? button,
    Vector2? size,
    Vector2? position,
    Function()? onPressed,
  }) : super(
          button: button,
          size: size,
          position: position,
          onPressed: onPressed,
        );
}
