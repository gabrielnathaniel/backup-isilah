import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/model/list_game.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math' as math;

import '../game/game.dart';

// This represents the game over overlay,
// displayed with dino runs out of lives.
class FirstCheckpoint extends StatefulWidget {
  // An unique identified for this overlay.
  static const id = 'FirstCheckpoint';

  // Reference to parent game.
  final RunningGame gameRef;
  final List<LevelGame>? levelGame;

  const FirstCheckpoint(this.gameRef, {Key? key, required this.levelGame})
      : super(key: key);

  @override
  State<FirstCheckpoint> createState() => _FirstCheckpointState();
}

class _FirstCheckpointState extends State<FirstCheckpoint> {
  List<String> firstCheckpointVoices = [
    'assets/audio/nyerempet_dikit_ga_ngaruh_kok.wav',
    'assets/audio/jaga_jarak_pak_supir.wav',
  ];
  final _random = math.Random();

  final _player = AudioPlayer();

  @override
  void initState() {
    int randomIndex = _random.nextInt(firstCheckpointVoices.length);
    String firstCheckpointVoice = firstCheckpointVoices[randomIndex];

    _player.setAsset(firstCheckpointVoice).then((value) {
      _player.play();
    });

    super.initState();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Card(
        margin: const EdgeInsets.only(top: 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.transparent,
        elevation: 0,
        child: Image.asset(
          'assets/game/UI/10 Star.png',
          width: MediaQuery.of(context).size.width * (2.5 / 4),
        ),
      ),
    );
  }
}
