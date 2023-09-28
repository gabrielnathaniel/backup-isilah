import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/model/list_game.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math' as math;

import '../game/game.dart';

// This represents the game over overlay,
// displayed with dino runs out of lives.
class SecondCheckpoint extends StatefulWidget {
  // An unique identified for this overlay.
  static const id = 'SecondCheckpoint';

  // Reference to parent game.
  final RunningGame gameRef;
  final List<LevelGame>? levelGame;

  const SecondCheckpoint(this.gameRef, {Key? key, required this.levelGame})
      : super(key: key);

  @override
  State<SecondCheckpoint> createState() => _SecondCheckpointState();
}

class _SecondCheckpointState extends State<SecondCheckpoint> {
  List<String> secondCheckpointVoices = [
    'assets/audio/dikit_lagi_finish_letsgo.wav',
    'assets/audio/jaga_jarak_pak_supir.wav',
  ];
  final _random = math.Random();

  final _player = AudioPlayer();

  @override
  void initState() {
    int randomIndex = _random.nextInt(secondCheckpointVoices.length);
    String secondCheckpointVoice = secondCheckpointVoices[randomIndex];

    _player.setAsset(secondCheckpointVoice).then((value) {
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
          'assets/game/UI/20 Star.png',
          width: MediaQuery.of(context).size.width * (2.5 / 4),
        ),
      ),
    );
  }
}
