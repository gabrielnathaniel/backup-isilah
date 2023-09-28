import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:hive/hive.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:isilahtitiktitik/games/isiboyrun/widgets/first_win_menu.dart';
import 'package:isilahtitiktitik/games/isiboyrun/widgets/second_win_menu.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../widgets/first_checkpoint.dart';
import '../widgets/game_win_menu.dart';
import '../widgets/second_checkpoint.dart';
import '../game/dino.dart';
import '../widgets/hud.dart';
import '../models/settings.dart';
import '../game/enemy_manager.dart';
import '../widgets/pause_menu.dart';
import '../widgets/game_over_menu.dart';

// This is the main flame game class.
class RunningGame extends FlameGame with TapDetector, HasCollisionDetection {
  // List of all the image assets.
  static const _imageAssets = [
    'peta_jakarta4.png',
    'road.png',
    'road2.png',
    'pig_run_redesign.png',
    'goblin_walk_redesign.png',
    'bird_fly_redesign.png',
    'isiboy_redesign.png',
    'counterbackground.png'
  ];

  late Dino _dino;
  late Settings settings;
  late EnemyManager _enemyManager;
  late TextComponent _scoreText;
  late int score;
  bool scoreOn = false;

  late String start = DateTime.now().toString();
  late String end = DateTime.now().toString();
  late int result = 0;

  late int idGame = 2;
  late int level = 1;

  bool firstCheckpoint = false;
  bool secondCheckpoint = false;

  final world = World();
  late final CameraComponent cameraComponent;

  BuildContext? context;

  RunningGame(this.context);

  final _player = AudioPlayer();
  // final _player2 = AudioPlayer();

  // This method get called while flame is preparing this game.
  @override
  Future<void> onLoad() async {
    /// Read [PlayerData] and [Settings] from hive.
    settings = await _readSettings();

    /// Initilize [AudioManager].
    // await AudioManager.instance.init(_audioAssets, settings);

    // Start playing background music. Internally takes care
    // of checking user settings.
    // AudioManager.instance.startBgm('8Bit Platformer Loop.wav');
    // FlameAudio.audioCache.loop('8Bit Platformer Loop.wav');

    // Cache all the images.
    await images.loadAll(_imageAssets);
    // await FlameAudio.audioCache.loadAll(_audioAssets);

    // Set a fixed viewport to avoid manually scaling
    // and handling different screen sizes.
    // camera.viewport = FixedResolutionViewport(Vector2(360, 180));
    cameraComponent =
        CameraComponent.withFixedResolution(width: 380, height: 180);
    add(cameraComponent);

    /// Create a [ParallaxComponent] and add it to game.
    final parallaxBackground = await loadParallaxComponent(
      [
        // ParallaxImageData('parallax/plx-1.png'),
        // ParallaxImageData('parallax/plx-2.png'),
        // ParallaxImageData('parallax/plx-3.png'),
        // ParallaxImageData('parallax/plx-4.png'),
        // ParallaxImageData('parallax/plx-5.png'),
        ParallaxImageData('peta_jakarta4.png'),
        ParallaxImageData('road2.png'),
      ],
      size: Vector2(size.x, size.y),
      baseVelocity: Vector2(120, 0),
      velocityMultiplierDelta: Vector2(2, 0),
    );
    add(parallaxBackground);

    score = 0;
    _scoreText = TextComponent(
      text: score.toString(),
      position: Vector2(size.x / 12, 0) / 4 + Vector2(6, 4),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontFamily: "LapsusProBold",
          fontSize: 32,
        ),
      ),
    );

    start = DateTime.now().toString();

    return super.onLoad();
  }

  /// This method add the already created [Dino]
  /// and [EnemyManager] to this game.
  void startGamePlay() async {
    // _player2.setAsset('assets/audio/slametrun.wav').then((value) {
    //   _player2.play();
    // });
    _dino = Dino(images.fromCache('isiboy_redesign.png'));
    _enemyManager = EnemyManager();

    // final SpriteComponent sun = SpriteComponent(
    //   sprite: await loadSprite('sun.png'),
    //   anchor: Anchor.topRight,
    //   size: Vector2.all(50),
    //   position: Vector2(size.x - 10, 0),
    // );

    final SpriteComponent counterBackground = SpriteComponent(
      sprite: await loadSprite('counterbackground.png'),
      // anchor: Anchor.topLeft,
      size: Vector2(80, 45),
      position: Vector2(size.x / 12, 0) / 4,
    );

    final parallaxBackground = await loadParallaxComponent(
      [
        ParallaxImageData('peta_jakarta4.png'),
        ParallaxImageData('road2.png'),
      ],
      size: Vector2(size.x, size.y),
      baseVelocity: Vector2(120, 0),
      velocityMultiplierDelta: Vector2(2, 0),
    );
    add(parallaxBackground);

    add(_dino);
    add(_enemyManager);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await add(_scoreText);
    });
    // add(sun);
    add(counterBackground);
    scoreOn = true;
  }

  // This method remove all the actors from the game.
  void _disconnectActors() {
    _dino.removeFromParent();
    _enemyManager.removeAllEnemies();
    _enemyManager.removeFromParent();
    _scoreText.removeFromParent();
    _player.stop();
    // _player2.stop();
    Dino.isHit = false;
    scoreOn = false;
    firstCheckpoint = false;
    secondCheckpoint = false;
  }

  // This method reset the whole game world to initial state.
  void reset() {
    // First disconnect all actions from game world.
    _disconnectActors();

    // Reset player data to inital values.
    score = 0;
    // _player.dispose();
  }

  // This method gets called for each tick/frame of the game.
  @override
  void update(double dt) {
    Map<String, dynamic> basket = Provider.of(context!, listen: false);

    if (scoreOn == true) {
      score += (130 * dt).ceil();
      _scoreText.text = score.toString();
    }

    if (Dino.isHit == true) {
      // FlameAudio.audioCache.play('hurt7.wav');
      if (score < 2000) {
        pauseEngine();
        overlays.remove(Hud.id);
        overlays.add(GameOverMenu.id);
        level = 1;
        result = 0;
        end = DateTime.now().toString();
        basket.addAll({
          'idGame': idGame,
          'level': level,
          'result': result,
          'start': start,
          'end': end,
        });
      } else if (score >= 2000 && score < 4000) {
        pauseEngine();
        overlays.remove(Hud.id);
        overlays.add(FirstWinMenu.id);
        level = 1;
        result = 1;
        end = DateTime.now().toString();
        basket.addAll({
          'idGame': idGame,
          'level': level,
          'result': result,
          'start': start,
          'end': end,
        });
      } else if (score >= 4000 && score < 6000) {
        pauseEngine();
        overlays.remove(Hud.id);
        overlays.add(SecondWinMenu.id);
        level = 2;
        result = 1;
        end = DateTime.now().toString();
        basket.addAll({
          'idGame': idGame,
          'level': level,
          'result': result,
          'start': start,
          'end': end,
        });
      }
    }

    if (score >= 2000 && firstCheckpoint == false) {
      overlays.add(FirstCheckpoint.id);
      Future.delayed(const Duration(seconds: 2)).then((value) {
        overlays.remove(FirstCheckpoint.id);
      });
      firstCheckpoint = true;
    }

    if (score >= 4000 && secondCheckpoint == false) {
      overlays.add(SecondCheckpoint.id);
      Future.delayed(const Duration(seconds: 2)).then((value) {
        overlays.remove(SecondCheckpoint.id);
      });
      secondCheckpoint = true;
    }

    if (score >= 6000) {
      level = 3;
      result = 1;
      end = DateTime.now().toString();
      pauseEngine();
      overlays.remove(Hud.id);
      overlays.add(GameWinMenu.id);
      basket.addAll({
        'idGame': idGame,
        'level': level,
        'result': result,
        'start': start,
        'end': end,
      });
    }
    super.update(dt);
  }

  // This will get called for each tap on the screen.
  @override
  void onTapDown(TapDownInfo info) {
    // Make dino jump only when game is playing.
    // When game is in playing state, only Hud will be the active overlay.
    if (overlays.isActive(Hud.id)) {
      // FlameAudio.audioCache.play('jump14.wav');
      _player.setAsset('assets/audio/loncat.wav').then((value) {
        _player.play();
      });
      _dino.jump();
    }
    super.onTapDown(info);
  }

  /// This method reads [Settings] from the hive box.
  Future<Settings> _readSettings() async {
    final settingsBox = await Hive.openBox<Settings>('DinoRun.SettingsBox');
    final settings = settingsBox.get('DinoRun.Settings');

    // If data is null, this is probably a fresh launch of the game.
    if (settings == null) {
      // In such cases store default values in hive.
      await settingsBox.put(
        'DinoRun.Settings',
        Settings(bgm: true, sfx: true),
      );
    }

    // Now it is safe to return the stored value.
    return settingsBox.get('DinoRun.Settings')!;
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // On resume, if active overlay is not PauseMenu,
        // resume the engine (lets the parallax effect play).
        if (!(overlays.isActive(PauseMenu.id)) &&
            !(overlays.isActive(GameOverMenu.id))) {
          resumeEngine();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
        // If game is active, then remove Hud and add PauseMenu
        // before pausing the game.
        if (overlays.isActive(Hud.id)) {
          overlays.remove(Hud.id);
          overlays.add(PauseMenu.id);
        }
        pauseEngine();

        break;
    }
    super.lifecycleStateChange(state);
  }
}
