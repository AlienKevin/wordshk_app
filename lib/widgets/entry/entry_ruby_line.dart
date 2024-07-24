import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/src/rust/api/api.dart';
import 'package:wordshk/states/language_state.dart';
import 'package:wordshk/widgets/online_tts_pronunciation_button.dart';
import 'package:wordshk/widgets/url_pronunciation_button.dart';

import '../../models/entry.dart';
import '../../states/entry_eg_jumpy_prs_state.dart';
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
                      prUrl != null
                          ? UrlPronunciationButton(
                              url: prUrl!,
                              alignment: Alignment.topCenter,
                              atHeader: false,
                            )
                          : OnlineTtsPronunciationButton(
                              text: lineTrad.toString(),
                              alignment: Alignment.topCenter,
                              atHeader: false,
                            )
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
