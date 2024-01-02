import 'package:flutter/material.dart';
import 'package:wordshk/models/player.dart';
import 'package:wordshk/widgets/pronunciation_button.dart';

class TtsPronunciationButton extends StatelessWidget {
  final String text;
  final Alignment alignment;
  final bool atHeader;

  const TtsPronunciationButton(
      {super.key,
      required this.text,
      required this.alignment,
      required this.atHeader});

  @override
  Widget build(BuildContext context) => PronunciationButton(
        player: TtsPlayer(text: text, atHeader: atHeader),
        alignment: alignment,
      );
}
