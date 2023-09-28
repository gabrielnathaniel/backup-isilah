import 'package:flame/components.dart';

class Player extends SpriteAnimationComponent {
  Player({
    SpriteAnimation? animation,
    Vector2? position,
    Anchor? anchor,
  }) : super(animation: animation, position: position, anchor: anchor);
}
