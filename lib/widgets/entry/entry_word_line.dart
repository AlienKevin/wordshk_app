import 'package:flutter/material.dart';
import 'package:wordshk/widgets/tts_pronunciation_button.dart';

import '../../models/entry.dart';
import 'entry_word_segment.dart';

class EntryWordLine extends StatelessWidget {
  final WordLine line;
  final Color textColor;
  final Color linkColor;
  final double fontSize;
  final OnTapLink onTapLink;

  const EntryWordLine({
    Key? key,
    required this.line,
    required this.textColor,
    required this.linkColor,
    required this.fontSize,
    required this.onTapLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Builder(builder: (context) {
        return RichText(
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          text: TextSpan(
            children: [
              ...line.segments
                  .map((segment) =>
                      showWordSegment(segment, linkColor, fontSize, onTapLink))
                  .toList(),
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: TtsPronunciationButton(
                    text: line.toString(),
                    alignment: Alignment.center,
                    atHeader: false,
                  ))
            ],
            style: TextStyle(fontSize: fontSize, height: 1.2, color: textColor),
          ),
        );
      });
}
