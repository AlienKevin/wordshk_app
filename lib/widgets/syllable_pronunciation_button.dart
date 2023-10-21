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
  final Key? buttonKey;

  const SyllablePronunciationButton({
    Key? key,
    this.buttonKey,
    required this.prs,
    required this.alignment,
    required this.atHeader,
    this.large = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<PronunciationMethodState>(
      builder: (context, prMethodState, child) => Visibility(
            visible:
                jyutpingFemaleSyllableNames.containsAll(prs.expand((x) => x)),
            child: PronunciationButton(
              key: buttonKey,
              player: SyllablesPlayer(prs: prs, atHeader: atHeader),
              alignment: alignment,
              large: large,
            ),
          ));
}
