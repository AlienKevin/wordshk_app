import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/widgets/syllable_pronunciation_button.dart';
import 'package:wordshk/widgets/tts_pronunciation_button.dart';

import '../../models/entry.dart';
import '../../models/pronunciation_method.dart';
import '../../states/entry_eg_jumpy_prs_state.dart';
import '../../states/pronunciation_method_state.dart';
import 'entry_ruby_segment.dart';

class EntryRubyLine extends StatelessWidget {
  final RubyLine line;
  final Color textColor;
  final Color linkColor;
  final double rubyFontSize;
  final OnTapLink onTapLink;
  const EntryRubyLine({
    Key? key,
    required this.line,
    required this.textColor,
    required this.linkColor,
    required this.rubyFontSize,
    required this.onTapLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Builder(builder: (context) {
        final textScaleFactor = MediaQuery.of(context).textScaleFactor;
        final isJumpy = context.watch<EntryEgJumpyPrsState>().isJumpy;
        final topPaddingFactor = isJumpy ? 3.5 : 1.0;
        final wrapRunSpacingFactor = isJumpy ? 3 : 1;
        return Padding(
          padding: EdgeInsets.only(
              top: rubyFontSize * topPaddingFactor * textScaleFactor / 1.5),
          child: Wrap(
              runSpacing:
                  rubyFontSize * wrapRunSpacingFactor * textScaleFactor * 0.85,
              children: [
                ...line.segments
                    .map((segment) => showRubySegment(
                        segment,
                        textColor,
                        linkColor,
                        rubyFontSize,
                        textScaleFactor,
                        onTapLink,
                        context))
                    .expand((i) => i)
                    .toList(),
                Consumer<PronunciationMethodState>(
                    builder: (context, pronunciationMethodState, child) =>
                        pronunciationMethodState.entryEgMethod ==
                                PronunciationMethod.tts
                            ? TtsPronunciationButton(
                                text: Platform.isIOS
                                    ? line.toPrs()
                                    : line.toString(),
                                alignment: Alignment.topCenter,
                                atHeader: false,
                              )
                            : SyllablePronunciationButton(
                                prs: line
                                    .toPrs()
                                    .split(RegExp(
                                        r"\s*[^a-zA-Z0-6\s]+\s*[^a-zA-Z0-6\s]*\s*"))
                                    .where((segment) => segment.isNotEmpty)
                                    .map((segment) =>
                                        segment.split(RegExp(r"\s+")))
                                    .toList(),
                                alignment: Alignment.topCenter,
                                atHeader: false,
                              )),
              ]
                  .map((e) => Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        textBaseline: TextBaseline.alphabetic,
                        mainAxisSize: MainAxisSize.min,
                        children: [e],
                      ))
                  .toList()),
        );
      });
}
