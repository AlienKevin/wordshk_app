import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/widgets/pronunciation_button.dart';

import '../states/player_state.dart';

class TtsPronunciationButton extends StatelessWidget {
  final String text;
  final Alignment alignment;

  const TtsPronunciationButton(
      {Key? key, required this.text, required this.alignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) => PronunciationButton(
        play: (key) => context.read<PlayerState>().ttsPlay(key, text),
        alignment: alignment,
      );
}
