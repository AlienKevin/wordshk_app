import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../models/entry.dart';
import '../syllable_pronunciation_button.dart';

class EntryVariant extends StatelessWidget {
  final Variant variant;
  final TextStyle variantTextStyle;
  final TextStyle prTextStyle;

  const EntryVariant({
    Key? key,
    required this.variant,
    required this.variantTextStyle,
    required this.prTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prs = variant.prs.split(", ");
    return Row(children: [
      SelectableText.rich(
        TextSpan(text: variant.word),
        style: variantTextStyle,
      ),
      const SizedBox(width: 10),
      ...prs.takeWhile((pr) => !pr.contains("!")).expand((pr) => [
            SelectableText.rich(
              TextSpan(
                  text:
                      context.read<RomanizationState>().showPrs(pr.split(" "))),
              style: prTextStyle,
              // selectionWidthStyle: BoxWidthStyle.max,
            ),
            SyllablePronunciationButton(
                prs: pr.split(" "), alignment: Alignment.center)
          ])
    ]);
  }
}
