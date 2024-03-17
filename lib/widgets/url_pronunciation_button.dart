import 'package:flutter/material.dart';
import 'package:wordshk/models/player.dart';
import 'package:wordshk/widgets/pronunciation_button.dart';

class UrlPronunciationButton extends StatelessWidget {
  final String url;
  final Alignment alignment;
  final bool atHeader;

  const UrlPronunciationButton(
      {super.key,
      required this.url,
      required this.alignment,
      required this.atHeader});

  @override
  Widget build(BuildContext context) => PronunciationButton(
        player: UrlPlayer(url: url, atHeader: atHeader),
        alignment: alignment,
      );
}
