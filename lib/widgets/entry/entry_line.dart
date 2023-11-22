import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wordshk/widgets/tts_pronunciation_button.dart';

import '../../models/entry.dart';
import 'entry_segment.dart';

class EntryLine extends StatelessWidget {
  final Line line;
  final String? tag;
  final TextStyle lineTextStyle;
  final OnTapLink onTapLink;
  final bool isCantonese;
  const EntryLine(
      {Key? key,
      required this.line,
      this.tag,
      required this.lineTextStyle,
      required this.onTapLink,
      required this.isCantonese})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (line.segments.length == 1 &&
        line.segments[0] == const Segment(SegmentType.text, "")) {
      return const SizedBox(height: 10);
    } else {
      return Builder(builder: (context) {
        return SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: tag,
                  style: const TextStyle(fontVariations: [FontVariation('wght', 600)])),
              ...line.segments
                  .map((segment) => showSegment(segment,
                      Theme.of(context).colorScheme.secondary, onTapLink))
                  .toList(),
              ...isCantonese
                  ? [
                      WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: TtsPronunciationButton(
                            text: line.toString(),
                            alignment: Alignment.center,
                            atHeader: false,
                          ))
                    ]
                  : []
            ],
          ),
          style: lineTextStyle,
        );
      });
    }
  }
}
