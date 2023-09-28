import 'package:flame/components.dart';
import 'package:isilahtitiktitik/games/engklek/game/game.dart';

class SlametHappy extends SpriteAnimationComponent
    with HasGameRef<EngklekGame> {
  @override
  Future<void>? onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('isiboy_engklek_happy.png'),
      SpriteAnimationData.sequenced(
        amount: 75,
        stepTime: 0.03,
        textureSize: Vector2(172, 180),
      ),
    );
  }
}
