import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/states/pronunciation_method_state.dart';
import 'package:wordshk/states/speech_rate_state.dart';
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
            visible: jyutpingFemaleSyllableNames.containsAll(prs),
            child: PronunciationButton(
              play: (key) {
                final prMethodState = context.read<PronunciationMethodState>();
                final method = prMethodState.entryEgMethod;
                final speechRateState = context.read<SpeechRateState>();
                final rate = atHeader
                    ? speechRateState.entryHeaderRate
                    : speechRateState.entryEgRate;
                context
                    .read<PlayerState>()
                    .syllablesPlay(key, prs, method, rate);
              },
              alignment: alignment,
            ),
          ));
}
