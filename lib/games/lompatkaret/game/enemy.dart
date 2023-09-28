import 'package:flame/components.dart';

class Enemy extends SpriteAnimationComponent {
  Enemy({
    SpriteAnimation? animation,
    Vector2? position,
    Anchor? anchor,
  }) : super(animation: animation, position: position, anchor: anchor);
}
