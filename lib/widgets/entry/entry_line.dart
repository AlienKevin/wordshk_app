import 'package:flutter/material.dart';
import 'package:wordshk/widgets/online_tts_pronunciation_button.dart';

import '../../models/entry.dart';
import 'entry_segment.dart';

class EntryLine extends StatelessWidget {
  final Line line;
  final String? tag;
  final TextStyle lineTextStyle;
  final OnTapLink? onTapLink;
  final String? prString;
  const EntryLine(
      {Key? key,
      required this.line,
      this.tag,
      required this.lineTextStyle,
      required this.onTapLink,
      this.prString})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (line.segments.length == 1 &&
        line.segments[0] == const Segment(SegmentType.text, "")) {
      return const SizedBox(height: 10);
    } else {
      return Builder(builder: (context) {
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: tag,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              ...line.segments.map((segment) => showSegment(
                  segment, Theme.of(context).colorScheme.secondary, onTapLink)),
              ...prString != null
                  ? [
                      WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: OnlineTtsPronunciationButton(
                            text: prString!,
                            alignment: Alignment.center,
                            atHeader: false,
                          ))
                    ]
                  : []
            ],
            style: lineTextStyle,
          ),
        );
      });
    }
  }
}
