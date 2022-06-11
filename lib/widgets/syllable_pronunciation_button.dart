import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/widgets/pronunciation_button.dart';

import '../constants.dart';
import '../states/player_state.dart';

class SyllablePronunciationButton extends StatelessWidget {
  final List<String> prs;
  final Alignment alignment;

  const SyllablePronunciationButton(
      {Key? key, required this.prs, required this.alignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Visibility(
        visible: jyutpingFemaleSyllableNames.containsAll(prs),
        child: PronunciationButton(
          play: (key) => context.read<PlayerState>().syllablesPlay(key, prs),
          alignment: alignment,
        ),
      );
}
