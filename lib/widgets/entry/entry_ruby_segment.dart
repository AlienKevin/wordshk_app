import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/main.dart';
import 'package:wordshk/widgets/scalable_text_span.dart';

import '../../models/entry.dart';
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
  double rubyYPos = rubySize * textScaleFactor;
  Widget text;
  String ruby;
  switch (segment.type) {
    case RubySegmentType.punc:
      text = Builder(builder: (context) {
        return RichText(
            text: ScalableTextSpan(context,
                text: segment.segment as String,
                style: TextStyle(
                    fontSize: rubySize, height: 1, color: textColor)));
      });
      ruby = "";
      break;
    case RubySegmentType.word:
      text = Builder(builder: (context) {
        return RichText(
            text: ScalableTextSpan(context,
                children: showWord(segment.segment.word as EntryWord),
                style: TextStyle(
                    fontSize: rubySize, height: 1, color: textColor)));
      });
      ruby = context.read<RomanizationState>().showPrs(segment.segment.prs);
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
      Container(
          alignment: Alignment.bottomCenter,
          child: Center(
              child: Transform(
                  transform: Matrix4.translationValues(0, -(rubyYPos), 0),
                  child: Builder(builder: (context) {
                    return RichText(
                        text: ScalableTextSpan(context,
                            text: ruby,
                            style: TextStyle(
                                fontSize: rubySize * 0.5, color: textColor)));
                  })))),
      text
    ])
  ];
}
