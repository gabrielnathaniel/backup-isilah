import 'package:isilahtitiktitik/games/engklek/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/text.dart';

class ButtonText3 extends TextComponent with HasGameRef<EngklekGame> {
  ButtonText3({
    String? text,
    TextRenderer? textRenderer,
    Vector2? position,
  }) : super(text: text, textRenderer: textRenderer, position: position);
}
