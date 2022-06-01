import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../models/entry.dart';
import 'entry_line.dart';

class EntryClause extends StatelessWidget {
  final Clause clause;
  final String? tag;
  final TextStyle lineTextStyle;
  final OnTapLink onTapLink;
  final FlutterTts? player;
  const EntryClause(
      {Key? key,
      required this.clause,
      this.tag,
      required this.lineTextStyle,
      required this.onTapLink,
      this.player})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: clause.lines.asMap().keys.toList().map((index) {
          return EntryLine(
            line: clause.lines[index],
            player: player,
            tag: index == 0 ? tag : null,
            lineTextStyle: lineTextStyle,
            onTapLink: onTapLink,
          );
        }).toList(),
        crossAxisAlignment: CrossAxisAlignment.start,
      );
}
