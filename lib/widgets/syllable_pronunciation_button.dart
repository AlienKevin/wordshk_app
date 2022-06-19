import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/models/pronunciation_method.dart';
import 'package:wordshk/states/pronunciation_method_state.dart';
import 'package:wordshk/widgets/pronunciation_button.dart';

import '../constants.dart';
import '../states/player_state.dart';

class SyllablePronunciationButton extends StatelessWidget {
  final List<String> prs;
  final Alignment alignment;
  final bool atHeader;

  const SyllablePronunciationButton(
      {Key? key,
      required this.prs,
      required this.alignment,
      required this.atHeader})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<PronunciationMethodState>(
      builder: (context, prMethodState, child) => Visibility(
            visible: (atHeader
                        ? prMethodState.entryHeaderMethod
                        : prMethodState.entryEgMethod) ==
                    PronunciationMethod.syllableRecordingsMale
                ? jyutpingMaleSyllableNames.containsAll(prs)
                : jyutpingFemaleSyllableNames.containsAll(prs),
            child: PronunciationButton(
              play: (key) {
                final state = context.read<PronunciationMethodState>();
                final method =
                    atHeader ? state.entryHeaderMethod : state.entryEgMethod;
                context.read<PlayerState>().syllablesPlay(key, prs, method);
              },
              alignment: alignment,
            ),
          ));
}
