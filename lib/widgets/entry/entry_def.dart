import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wordshk/models/entry_language.dart';
import 'package:wordshk/src/rust/api/api.dart' show Script;

import '../../models/entry.dart';
import 'entry_clause.dart';
import 'entry_egs.dart';

class EntryDef extends StatelessWidget {
  final Def def;
  final EntryLanguage entryLanguage;
  final Script script;
  final TextStyle lineTextStyle;
  final Color linkColor;
  final double rubyFontSize;
  final bool isSingleDef;
  final OnTapLink onTapLink;

  const EntryDef({
    Key? key,
    required this.def,
    required this.entryLanguage,
    required this.script,
    required this.lineTextStyle,
    required this.linkColor,
    required this.rubyFontSize,
    required this.isSingleDef,
    required this.onTapLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Builder(builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...entryLanguage == EntryLanguage.cantonese ||
                    entryLanguage == EntryLanguage.both
                ? [
                    EntryClause(
                        clause:
                            script == Script.simplified ? def.yueSimp : def.yue,
                        tag: "(${AppLocalizations.of(context)!.cantonese}) ",
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
                            tag: "(${AppLocalizations.of(context)!.english}) ",
                            lineTextStyle: lineTextStyle,
                            onTapLink: onTapLink,
                            isCantonese: false)
                  ]
                : [],
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
          ],
        );
      });
}
