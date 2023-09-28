import 'package:flame/components.dart';
import 'package:isilahtitiktitik/games/engklek/game/game.dart';

class SlametSad extends SpriteAnimationComponent with HasGameRef<EngklekGame> {
  @override
  Future<void>? onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('isiboy_engklek_sad.png'),
      SpriteAnimationData.sequenced(
        amount: 94,
        stepTime: 0.03,
        textureSize: Vector2(172, 180),
      ),
    );
  }
}
