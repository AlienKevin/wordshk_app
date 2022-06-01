import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../bridge_generated.dart' show Script;
import '../models/entry.dart';
import 'entry_clause.dart';
import 'entry_egs.dart';

class EntryDef extends StatelessWidget {
  final Def def;
  final Script script;
  final TextStyle lineTextStyle;
  final Color linkColor;
  final double rubyFontSize;
  final bool isSingleDef;
  final OnTapLink onTapLink;
  final FlutterTts player;

  const EntryDef(
      {Key? key,
      required this.def,
      required this.script,
      required this.lineTextStyle,
      required this.linkColor,
      required this.rubyFontSize,
      required this.isSingleDef,
      required this.onTapLink,
      required this.player})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Builder(builder: (context) {
        return Column(
          children: [
            EntryClause(
                clause: script == Script.Simplified ? def.yueSimp : def.yue,
                player: player,
                tag: "(" + AppLocalizations.of(context)!.cantonese + ") ",
                lineTextStyle: lineTextStyle,
                onTapLink: onTapLink),
            def.eng == null
                ? const SizedBox.shrink()
                : EntryClause(
                    clause: def.eng!,
                    tag: "(" + AppLocalizations.of(context)!.english + ") ",
                    lineTextStyle: lineTextStyle,
                    onTapLink: onTapLink),
            EntryEgs(
                egs: def.egs,
                script: script,
                lineTextStyle: lineTextStyle,
                linkColor: linkColor,
                rubyFontSize: rubyFontSize,
                isSingleDef: isSingleDef,
                onTapLink: onTapLink,
                player: player)
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        );
      });
}
