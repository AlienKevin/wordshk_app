import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/entry.dart';
import '../../states/romanization_state.dart';
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
    final prs = variant.prs.split(", ").takeWhile((pr) => !pr.contains("!"));

    return Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
      Text.rich(
        TextSpan(
          text: variant.word +
              (prs.isNotEmpty
                  ? " ⁠" // Use Word Joiner to mark this segment as non-splittable during selection
                  : ""),
          style: variantTextStyle,
        ),
      ),
      ...prs.indexed.map((item) => Text.rich(
            TextSpan(
                text: context
                        .read<RomanizationState>()
                        .showPrs(item.$2.split(" ")) +
                    ((item.$1 < prs.length - 1)
                        ? "⁠" // Use Word Joiner to mark this segment as non-splittable during selection
                        : ""),
                style: prTextStyle,
                children: [
                  WidgetSpan(
                    child: SyllablePronunciationButton(
                      prs: [item.$2.split(" ")],
                      alignment: Alignment.center,
                      atHeader: true,
                    ),
                    alignment: PlaceholderAlignment.middle,
                  ),
                  ...(item.$1 < prs.length - 1
                      ? [
                          const TextSpan(text: "  ⁠")
                        ] // Use Word Joiner to mark this segment as non-splittable during selection
                      : []),
                ]),
          ))
    ]);
  }
}
