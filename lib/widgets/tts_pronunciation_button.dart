import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/states/speech_rate_state.dart';
import 'package:wordshk/widgets/pronunciation_button.dart';

import '../states/player_state.dart';

class TtsPronunciationButton extends StatelessWidget {
  final String text;
  final Alignment alignment;
  final bool atHeader;

  const TtsPronunciationButton(
      {Key? key,
      required this.text,
      required this.alignment,
      required this.atHeader})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Consumer<SpeechRateState>(builder: (context, speechRateState, child) {
        final rate = atHeader
            ? speechRateState.entryHeaderRate
            : speechRateState.entryEgRate;
        return PronunciationButton(
          play: (key) => context.read<PlayerState>().ttsPlay(key, text, rate),
          alignment: alignment,
        );
      });
}
