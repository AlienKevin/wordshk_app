import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/entry.dart';
import '../../models/font_size.dart';
import '../../states/entry_eg_font_size_state.dart';
import 'entry_ruby_line.dart';
import 'entry_word_line.dart';

class EntryRichLine extends StatelessWidget {
  final RichLine lineSimp;
  final RichLine lineTrad;
  final TextStyle lineTextStyle;
  final Color linkColor;
  final double rubyFontSize;
  final OnTapLink? onTapLink;

  const EntryRichLine({
    Key? key,
    required this.lineSimp,
    required this.lineTrad,
    required this.lineTextStyle,
    required this.linkColor,
    required this.rubyFontSize,
    required this.onTapLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rubyFontSizePreference = context.watch<EntryEgFontSizeState>().size;
    late final double rubyFontSizeFactor;
    switch (rubyFontSizePreference) {
      case FontSize.small:
        rubyFontSizeFactor = 0.8;
        break;
      case FontSize.medium:
        rubyFontSizeFactor = 1;
        break;
      case FontSize.large:
        rubyFontSizeFactor = 1.2;
        break;
      case FontSize.veryLarge:
        rubyFontSizeFactor = 1.5;
        break;
    }
    final renderedRubyFontSize = rubyFontSize * rubyFontSizeFactor;

    switch (lineTrad.type) {
      case RichLineType.ruby:
        return EntryRubyLine(
          lineSimp: lineSimp.line,
          lineTrad: lineTrad.line,
          textColor: lineTextStyle.color!,
          linkColor: linkColor,
          rubyFontSize: renderedRubyFontSize,
          onTapLink: onTapLink,
        );
      case RichLineType.word:
        return EntryWordLine(
          lineSimp: lineSimp.line,
          lineTrad: lineTrad.line,
          textColor: lineTextStyle.color!,
          linkColor: linkColor,
          fontSize: renderedRubyFontSize,
          onTapLink: onTapLink,
        );
    }
  }
}
