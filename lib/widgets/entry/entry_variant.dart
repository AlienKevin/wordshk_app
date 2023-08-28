import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/bridge_generated.dart';

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
    final prs = variant.prs.split(", ");

    return Row(children: [
      SelectableText.rich(
        TextSpan(text: variant.word),
        style: variantTextStyle,
      ),
      const SizedBox(width: 10),
      ...prs.takeWhile((pr) => !pr.contains("!")).expand((pr) => [
            // TODO: Remove the glitch seen when loading Yale pr
            switch (context.read<RomanizationState>().romanization) {
              Romanization.Jyutping => SelectableText.rich(
                  TextSpan(text: pr),
                  style: prTextStyle,
                ),
              Romanization.Yale => FutureBuilder<String>(
                  future:
                      context.read<RomanizationState>().showPrs(pr.split(" ")),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return SelectableText.rich(
                        TextSpan(text: snapshot.data),
                        style: prTextStyle,
                        // selectionWidthStyle: BoxWidthStyle.max,
                      );
                    } else {
                      // You can return an empty container or a loading indicator based on your requirements.
                      return Container();
                    }
                  },
                )
            },
            SyllablePronunciationButton(
              prs: pr.split(" "),
              alignment: Alignment.center,
              atHeader: true,
            )
          ])
    ]);
  }
}
