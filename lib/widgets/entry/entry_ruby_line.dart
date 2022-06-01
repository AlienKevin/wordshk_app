import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:wordshk/widgets/tts_pronunciation_button.dart';

import '../../models/entry.dart';
import 'entry_ruby_segment.dart';

class EntryRubyLine extends StatelessWidget {
  final RubyLine line;
  final Color textColor;
  final Color linkColor;
  final double rubyFontSize;
  final OnTapLink onTapLink;
  final FlutterTts player;
  const EntryRubyLine(
      {Key? key,
      required this.line,
      required this.textColor,
      required this.linkColor,
      required this.rubyFontSize,
      required this.onTapLink,
      required this.player})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Builder(builder: (context) {
        final textScaleFactor = MediaQuery.of(context).textScaleFactor;
        return Padding(
          padding: EdgeInsets.only(top: rubyFontSize * textScaleFactor / 1.5),
          child: Wrap(
              runSpacing: rubyFontSize * textScaleFactor / 1.4,
              children: [
                ...line.segments
                    .map((segment) => showRubySegment(segment, textColor,
                        linkColor, rubyFontSize, textScaleFactor, onTapLink))
                    .expand((i) => i)
                    .toList(),
                TtsPronunciationButton(
                  player: player,
                  text: Platform.isIOS ? line.toPrs() : line.toString(),
                  alignment: Alignment.topCenter,
                ),
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
