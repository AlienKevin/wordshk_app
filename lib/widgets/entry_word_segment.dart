import 'package:flutter/material.dart';
import 'package:wordshk/widgets/scalable_text_span.dart';

import '../models/entry.dart';
import 'entry_word.dart';

InlineSpan showWordSegment(WordSegment segment, Color linkColor,
    double fontSize, OnTapLink onTapLink) {
  switch (segment.type) {
    case SegmentType.text:
      return TextSpan(children: showWord(segment.word));
    case SegmentType.link:
      return WidgetSpan(
          child: GestureDetector(
        onTap: () => onTapLink(segment.word.toString()),
        child: Builder(builder: (context) {
          return RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: ScalableTextSpan(context,
                  children: showWord(segment.word),
                  style: TextStyle(color: linkColor, fontSize: fontSize)));
        }),
      ));
  }
}
