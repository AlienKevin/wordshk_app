import 'package:flutter/material.dart';
import 'package:wordshk/models/entry_language.dart';
import 'package:wordshk/src/rust/api/api.dart' show Script;

import '../../models/entry.dart';
import 'entry_clause.dart';
import 'entry_egs.dart';

class EntryDef extends StatelessWidget {
  final Def def;
  final int defIndex;
  final EntryLanguage entryLanguage;
  final Script script;
  final TextStyle lineTextStyle;
  final Color linkColor;
  final double rubyFontSize;
  final bool isSingleDef;
  final OnTapLink? onTapLink;
  final bool showEgs;

  const EntryDef({
    Key? key,
    required this.def,
    required this.defIndex,
    required this.entryLanguage,
    required this.script,
    required this.lineTextStyle,
    required this.linkColor,
    required this.rubyFontSize,
    required this.isSingleDef,
    required this.onTapLink,
    required this.showEgs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Builder(builder: (context) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
                "${defIndex + 1} ⁠", // Use Word Joiner to mark this segment as non-splittable during selection
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...entryLanguage == EntryLanguage.cantonese ||
                          entryLanguage == EntryLanguage.both
                      ? [
                          EntryClause(
                              clause: script == Script.simplified
                                  ? def.yueSimp
                                  : def.yue,
                              lineTextStyle: lineTextStyle,
                              onTapLink: onTapLink,
                              isCantonese: true)
                        ]
                      : [],
                  ...entryLanguage == EntryLanguage.english ||
                          entryLanguage == EntryLanguage.both
                      ? [
                          def.eng == null
                              ? const SizedBox.shrink()
                              : EntryClause(
                                  clause: def.eng!,
                                  lineTextStyle: lineTextStyle,
                                  onTapLink: onTapLink,
                                  isCantonese: false)
                        ]
                      : [],
                ],
              ),
            ),
          ]),
          ...showEgs
              ? [
                  EntryEgs(
                    egs: def.egs,
                    entryLanguage: entryLanguage,
                    script: script,
                    lineTextStyle: lineTextStyle,
                    linkColor: linkColor,
                    rubyFontSize: rubyFontSize,
                    isSingleDef: isSingleDef,
                    onTapLink: onTapLink,
                  )
                ]
              : []
        ]);
      });
}
