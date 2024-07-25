import 'package:flutter/material.dart';

import '../../models/entry.dart';
import 'entry_line.dart';

class EntryClause extends StatelessWidget {
  final Clause clause;
  final String? tag;
  final TextStyle lineTextStyle;
  final OnTapLink? onTapLink;
  final Clause? prClause;
  const EntryClause(
      {Key? key,
      required this.clause,
      this.tag,
      required this.lineTextStyle,
      required this.onTapLink,
      this.prClause})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: clause.lines.asMap().keys.toList().map((index) {
          return EntryLine(
            line: clause.lines[index],
            tag: index == 0 ? tag : null,
            lineTextStyle: lineTextStyle,
            onTapLink: onTapLink,
            prString: prClause?.lines[index].toString(),
          );
        }).toList(),
      );
}
