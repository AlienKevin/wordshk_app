import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/src/rust/api/api.dart';
import 'package:wordshk/states/language_state.dart';
import 'package:wordshk/widgets/online_tts_pronunciation_button.dart';
import 'package:wordshk/widgets/syllable_pronunciation_button.dart';
import 'package:wordshk/widgets/tts_pronunciation_button.dart';
import 'package:wordshk/widgets/url_pronunciation_button.dart';

import '../../models/entry.dart';
import '../../models/pronunciation_method.dart';
import '../../states/entry_eg_jumpy_prs_state.dart';
import '../../states/pronunciation_method_state.dart';
import 'entry_ruby_segment.dart';

class EntryRubyLine extends StatelessWidget {
  final RubyLine lineSimp;
  final RubyLine lineTrad;
  final Color textColor;
  final Color linkColor;
  final double rubyFontSize;
  final OnTapLink? onTapLink;
  final bool showPrsButton;
  final String? prUrl;
  const EntryRubyLine({
    Key? key,
    required this.lineSimp,
    required this.lineTrad,
    required this.textColor,
    required this.linkColor,
    required this.rubyFontSize,
    required this.onTapLink,
    this.showPrsButton = true,
    this.prUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Builder(builder: (context) {
        final line = switch (context.read<LanguageState>().getScript()) {
          Script.simplified => lineSimp,
          Script.traditional => lineTrad,
        };
        return Wrap(
            runSpacing: context.watch<EntryEgJumpyPrsState>().isJumpy ? 10 : 0,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              ...line.segments
                  .map((segment) => showRubySegment(segment, textColor,
                      linkColor, rubyFontSize, onTapLink, context,
                      isEndingPunctuation:
                          segment.type == RubySegmentType.punc &&
                              line.segments.last == segment))
                  .expand((i) => i),
              ...showPrsButton
                  ? [
                      Consumer<PronunciationMethodState>(
                          builder: (context, pronunciationMethodState, child) =>
                              prUrl != null
                                  ? UrlPronunciationButton(
                                      url: prUrl!,
                                      alignment: Alignment.topCenter,
                                      atHeader: false,
                                    )
                                  : switch (
                                      pronunciationMethodState.entryEgMethod) {
                                      PronunciationMethod.onlineTts =>
                                        OnlineTtsPronunciationButton(
                                          text: lineTrad.toString(),
                                          alignment: Alignment.topCenter,
                                          atHeader: false,
                                        ),
                                      PronunciationMethod.tts =>
                                        TtsPronunciationButton(
                                          text: Platform.isIOS
                                              ? lineTrad.toPrs()
                                              : lineTrad.toString(),
                                          alignment: Alignment.topCenter,
                                          atHeader: false,
                                        ),
                                      _ => SyllablePronunciationButton(
                                          prs: lineTrad
                                              .toPrs()
                                              .split(RegExp(
                                                  r"\s*[^a-zA-Z0-6\s]+\s*[^a-zA-Z0-6\s]*\s*"))
                                              .where((segment) =>
                                                  segment.isNotEmpty)
                                              .map((segment) =>
                                                  segment.split(RegExp(r"\s+")))
                                              .toList(),
                                          alignment: Alignment.topCenter,
                                          atHeader: false,
                                        )
                                    })
                    ]
                  : [],
            ]
                .map((e) => Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisSize: MainAxisSize.min,
                      children: [e],
                    ))
                .toList());
      });
}
