import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/widgets/scalable_text_span.dart';

import '../../constants.dart';
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
  late final List<String> prs;
  switch (segment.type) {
    case RubySegmentType.punc:
      text = Builder(builder: (context) {
        return RichText(
            text: ScalableTextSpan(context,
                text: segment.segment as String,
                style: TextStyle(
                    fontSize: rubySize, height: 1, color: textColor)));
      });
      prs = [""];
      break;
    case RubySegmentType.word:
      text = Builder(builder: (context) {
        return RichText(
            text: ScalableTextSpan(context,
                children: showWord(segment.segment.word as EntryWord),
                style: TextStyle(
                    fontSize: rubySize, height: 1, color: textColor)));
      });
      prs = context
          .read<RomanizationState>()
          .showPrs(segment.segment.prs)
          .split(" ");
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
  return [
    Stack(alignment: Alignment.center, children: [
      Positioned.fill(
          bottom: 0,
          child: Transform(
              transform: Matrix4.translationValues(0, -rubySize * 1.25, 0),
              child: Container(
                color: lightGreyColor,
                height: rubySize,
              ))),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: prs.map((pr) {
            final int tone = pr.isEmpty ? 6 : int.parse(pr[pr.length - 1]);
            final double yPos = ((tone == 1)
                    ? 2.6
                    : tone == 2
                        ? 2.3
                        : tone == 3
                            ? 2
                            : tone == 5
                                ? 1.7
                                : tone == 4
                                    ? 1.4
                                    : 1.5) *
                -rubyYPos;
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
                        child: Builder(builder: (context) {
                          return RichText(
                              text: ScalableTextSpan(context,
                                  text: pr,
                                  style: TextStyle(
                                      fontSize: rubySize * 0.5,
                                      color: textColor)));
                        }))));
          }).toList()),
      text
    ])
  ];
}
