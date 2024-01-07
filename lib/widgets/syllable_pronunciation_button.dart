import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/models/player.dart';
import 'package:wordshk/states/pronunciation_method_state.dart';
import 'package:wordshk/widgets/pronunciation_button.dart';

import '../constants.dart';

class SyllablePronunciationButton extends StatelessWidget {
  // a list of pr segments
  final List<List<String>> prs;
  final Alignment alignment;
  final bool atHeader;
  final bool large;

  const SyllablePronunciationButton({
    super.key,
    required this.prs,
    required this.alignment,
    required this.atHeader,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) => Consumer<PronunciationMethodState>(
      builder: (context, prMethodState, child) => PronunciationButton(
            key: key,
            player: SyllablesPlayer(prs: prs, atHeader: atHeader, key: key),
            alignment: alignment,
            large: large,
            playable: prs
                .expand((prs) => prs)
                .where((pr) => !jyutpingFemaleSyllableNames.contains(pr))
                .isEmpty,
          ));
}
