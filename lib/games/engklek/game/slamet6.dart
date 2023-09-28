import 'package:flame/components.dart';
import 'package:isilahtitiktitik/games/engklek/game/game.dart';

class Slamet6 extends SpriteAnimationComponent with HasGameRef<EngklekGame> {
  @override
  Future<void>? onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('isiboy_engklek_depan2.png'),
      SpriteAnimationData.sequenced(
        amount: 151,
        stepTime: 0.03,
        textureSize: Vector2(172, 180),
      ),
    );
  }
}
