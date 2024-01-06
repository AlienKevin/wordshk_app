import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/states/entry_eg_jumpy_prs_state.dart';

import '../../models/entry.dart';
import '../../states/romanization_state.dart';
import 'entry_word.dart';

List<Widget> showRubySegment(
  RubySegment segment,
  Color textColor,
  Color linkColor,
  double rubySize,
  double textScaleFactor,
  OnTapLink onTapLink,
  BuildContext context,
) {
  final double rubyYPos = rubySize * textScaleFactor;
  late final Widget text;
  late final String prs;
  late final List<int?> prsTones;
  switch (segment.type) {
    case RubySegmentType.punc:
      text = Text.rich(TextSpan(
          text: segment.segment as String,
          style: TextStyle(fontSize: rubySize, height: 1, color: textColor)));
      prs = "";
      prsTones = [6]; // empty pr defaults to 6 tones (this is arbitrary)
      break;
    case RubySegmentType.word:
      text = Text.rich(TextSpan(
          children: showWord(segment.segment.word as EntryWord),
          style: TextStyle(fontSize: rubySize, height: 1, color: textColor)));
      prs = context.read<RomanizationState>().showPrs(segment.segment.prs);
      prsTones = segment.segment.prsTones;
      break;
    case RubySegmentType.linkedWord:
      return (segment.segment.words as List<RubySegmentWord>)
          .map((word) => showRubySegment(
              RubySegment(RubySegmentType.word, word),
              textColor,
              linkColor,
              rubySize,
              textScaleFactor,
              onTapLink,
              context))
          .expand((i) => i)
          .map((seg) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => onTapLink(segment.segment.toString()),
              child: seg))
          .toList();
  }
  final isJumpy = context.watch<EntryEgJumpyPrsState>().isJumpy;
  return [
    Stack(alignment: Alignment.center, children: [
      ...(isJumpy
          // jumpy version
          ? [
              Positioned.fill(
                  bottom: 0,
                  child: Transform(
                      transform:
                          Matrix4.translationValues(0, -rubyYPos * 1.3, 0),
                      child: Container(
                        color: Theme.of(context).dividerColor,
                        height: rubyYPos,
                      ))),
              Positioned.fill(
                  bottom: 0,
                  child: Transform(
                      transform:
                          Matrix4.translationValues(0, -rubyYPos * 1.15 * 2, 0),
                      child: Container(
                        color: Theme.of(context).dividerColor.withOpacity(0.5),
                        height: rubyYPos,
                      ))),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: IterableZip([prs.split(" "), prsTones]).map((pair) {
                    final pr = pair[0] as String;
                    final tone = (pair[1] as int?) ?? 1;
                    final double yPos = ((tone == 1)
                            ? 2.4
                            : tone == 2
                                ? 2.1
                                : tone == 3
                                    ? 1.75
                                    : tone == 5
                                        ? 1.4
                                        : tone == 4
                                            ? 1.0
                                            : 1.2) *
                        -rubyYPos *
                        1.15;
                    final double angle = (tone == 1 || tone == 3 || tone == 6)
                        ? 0
                        : tone == 2
                            ? -pi / 6.0
                            : (tone == 5 ? -pi / 7.0 : pi / 7.0);
                    return Container(
                        alignment: Alignment.bottomCenter,
                        child: Center(
                            child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.translationValues(0, yPos, 0)
                                  ..rotateZ(angle),
                                child: Text.rich(TextSpan(
                                    text: pr,
                                    style: TextStyle(
                                        fontSize: rubySize * 0.5,
                                        color: textColor))))));
                  }).toList())
            ]
          // normal non-jumpy version
          : [
              Container(
                  alignment: Alignment.bottomCenter,
                  child: Center(
                      child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.translationValues(0, -rubySize * 0.8, 0),
                          child: Text.rich(TextSpan(
                              text: prs,
                              style: TextStyle(
                                  fontSize: rubySize * 0.5,
                                  color: textColor))))))
            ]),
      text
    ])
  ];
}
