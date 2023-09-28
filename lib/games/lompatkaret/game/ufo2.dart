import 'package:flame/components.dart';
import 'package:isilahtitiktitik/games/lompatkaret/game/game.dart';

class Ufo2 extends SpriteAnimationComponent with HasGameRef<LompatKaretGame> {
  @override
  Future<void>? onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('ufo_loncattali_absorb.png'),
      SpriteAnimationData.sequenced(
        amount: 48,
        stepTime: 0.1,
        textureSize: Vector2(159, 202),
      ),
    );
  }
}
