import 'package:flutter/material.dart';

import '../../models/entry.dart';
import 'entry_word.dart';

InlineSpan showWordSegment(WordSegment segment, Color linkColor,
    double fontSize, OnTapLink onTapLink) {
  switch (segment.type) {
    case SegmentType.text:
      return WidgetSpan(
          child: Builder(
              builder: (context) => Text.rich(TextSpan(
                  children: showWord(segment.word),
                  style: TextStyle(fontSize: fontSize)))));
    case SegmentType.link:
      return WidgetSpan(
          child: GestureDetector(
        onTap: () => onTapLink(segment.word.toString()),
        child: Text.rich(TextSpan(
            children: showWord(segment.word),
            style: TextStyle(color: linkColor, fontSize: fontSize))),
      ));
  }
}
