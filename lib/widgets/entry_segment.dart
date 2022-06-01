import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../models/entry.dart';

TextSpan showSegment(Segment segment, Color linkColor, OnTapLink onTapLink) {
  switch (segment.type) {
    case SegmentType.text:
      return TextSpan(text: segment.segment);
    case SegmentType.link:
      return TextSpan(
          text: segment.segment,
          style: TextStyle(color: linkColor),
          recognizer: TapGestureRecognizer()
            ..onTap = () => onTapLink(segment.segment));
  }
}
