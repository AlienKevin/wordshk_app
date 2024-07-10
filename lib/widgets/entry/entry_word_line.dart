import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/models/pronunciation_method.dart';
import 'package:wordshk/src/rust/api/api.dart';
import 'package:wordshk/states/language_state.dart';
import 'package:wordshk/states/pronunciation_method_state.dart';
import 'package:wordshk/widgets/online_tts_pronunciation_button.dart';
import 'package:wordshk/widgets/tts_pronunciation_button.dart';

import '../../models/entry.dart';
import 'entry_word_segment.dart';

class EntryWordLine extends StatelessWidget {
  final WordLine lineSimp;
  final WordLine lineTrad;
  final Color textColor;
  final Color linkColor;
  final double fontSize;
  final OnTapLink? onTapLink;

  const EntryWordLine({
    Key? key,
    required this.lineSimp,
    required this.lineTrad,
    required this.textColor,
    required this.linkColor,
    required this.fontSize,
    required this.onTapLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Builder(builder: (context) {
        final line = switch (context.read<LanguageState>().getScript()) {
          Script.simplified => lineSimp,
          Script.traditional => lineTrad,
        };
        return Text.rich(
          TextSpan(
            children: [
              ...line.segments.map((segment) =>
                  showWordSegment(segment, linkColor, fontSize, onTapLink)),
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Consumer<PronunciationMethodState>(
                      builder: (context, pronunciationMethodState, child) =>
                          switch (pronunciationMethodState.entryEgMethod) {
                            PronunciationMethod.onlineTts =>
                              OnlineTtsPronunciationButton(
                                  text: lineTrad.toString(),
                                  alignment: Alignment.topCenter,
                                  atHeader: false),
                            _ => TtsPronunciationButton(
                                text: lineTrad.toString(),
                                alignment: Alignment.topCenter,
                                atHeader: false,
                              )
                          }))
            ],
            style: TextStyle(fontSize: fontSize, height: 1.2, color: textColor),
          ),
        );
      });
}
