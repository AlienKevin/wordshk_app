import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/widgets/syllable_pronunciation_button.dart';
import 'package:wordshk/widgets/tts_pronunciation_button.dart';

import '../../models/entry.dart';
import '../../models/font_size.dart';
import '../../models/pronunciation_method.dart';
import '../../states/entry_eg_font_size_state.dart';
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
        final rubyFontSizePreference =
            context.watch<EntryEgFontSizeState>().size!;
        late final double rubyFontSizeFactor;
        switch (rubyFontSizePreference) {
          case FontSize.small:
            rubyFontSizeFactor = 0.8;
            break;
          case FontSize.medium:
            rubyFontSizeFactor = 1;
            break;
          case FontSize.large:
            rubyFontSizeFactor = 1.2;
            break;
          case FontSize.veryLarge:
            rubyFontSizeFactor = 1.5;
            break;
        }
        final renderedRubyFontSize = rubyFontSize * rubyFontSizeFactor;
        return Padding(
          padding: EdgeInsets.only(
              top: renderedRubyFontSize * 3.5 * textScaleFactor / 1.5),
          child: Wrap(
              runSpacing: renderedRubyFontSize * 3.6 * textScaleFactor / 1.4,
              children: [
                ...line.segments
                    .map((segment) => showRubySegment(
                        segment,
                        textColor,
                        linkColor,
                        renderedRubyFontSize,
                        textScaleFactor,
                        onTapLink,
                        context))
                    .expand((i) => i)
                    .toList(),
                Consumer<PronunciationMethodState>(
                    builder: (context, pronunciationMethodState, child) =>
                        pronunciationMethodState.entryEgMethod ==
                                PronunciationMethod.syllableRecordings
                            ? SyllablePronunciationButton(
                                prs: line
                                    .toPrs()
                                    .replaceAll(RegExp(r"[^a-z0-6 ]"), "")
                                    .trim()
                                    .split(RegExp(r"\s+")),
                                alignment: Alignment.topCenter)
                            : TtsPronunciationButton(
                                text: Platform.isIOS
                                    ? line.toPrs()
                                    : line.toString(),
                                alignment: Alignment.topCenter,
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
