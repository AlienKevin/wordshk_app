import 'package:flutter/material.dart';
import 'package:wordshk/models/player.dart';
import 'package:wordshk/widgets/pronunciation_button.dart';

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
  Widget build(BuildContext context) => PronunciationButton(
        player: TtsPlayer(text: text, atHeader: atHeader),
        alignment: alignment,
      );
}
