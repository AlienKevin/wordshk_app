import 'package:flutter/material.dart';

import '../../models/entry.dart';
import 'entry_ruby_line.dart';
import 'entry_word_line.dart';

class EntryRichLine extends StatelessWidget {
  final RichLine line;
  final TextStyle lineTextStyle;
  final Color linkColor;
  final double rubyFontSize;
  final OnTapLink onTapLink;

  const EntryRichLine({
    Key? key,
    required this.line,
    required this.lineTextStyle,
    required this.linkColor,
    required this.rubyFontSize,
    required this.onTapLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (line.type) {
      case RichLineType.ruby:
        return EntryRubyLine(
          line: line.line,
          textColor: lineTextStyle.color!,
          linkColor: linkColor,
          rubyFontSize: rubyFontSize,
          onTapLink: onTapLink,
        );
      case RichLineType.word:
        return EntryWordLine(
          line: line.line,
          textColor: lineTextStyle.color!,
          linkColor: linkColor,
          fontSize: rubyFontSize,
          onTapLink: onTapLink,
        );
    }
  }
}
