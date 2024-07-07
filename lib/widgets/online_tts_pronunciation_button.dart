import 'package:flutter/material.dart';
import 'package:wordshk/models/player.dart';
import 'package:wordshk/widgets/pronunciation_button.dart';

class OnlineTtsPronunciationButton extends StatelessWidget {
  final String text;
  final Alignment alignment;
  final bool atHeader;

  const OnlineTtsPronunciationButton(
      {super.key,
      required this.text,
      required this.alignment,
      required this.atHeader});

  @override
  Widget build(BuildContext context) => PronunciationButton(
        player: OnlineTtsPlayer(text: text, atHeader: atHeader),
        alignment: alignment,
      );
}
