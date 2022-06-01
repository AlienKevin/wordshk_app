import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:wordshk/widgets/pronunciation_button.dart';

class TtsPronunciationButton extends StatelessWidget {
  final FlutterTts player;
  final String text;
  final Alignment alignment;

  const TtsPronunciationButton(
      {Key? key,
      required this.player,
      required this.text,
      required this.alignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) => PronunciationButton(
        player: player,
        play: (player) async {
          final completer = Completer<void>();
          await (player as FlutterTts).speak(text);
          player.setCompletionHandler(() {
            completer.complete();
          });
          return completer.future;
        },
        stop: (player) async {
          await (player as FlutterTts).stop();
        },
        alignment: alignment,
      );
}
