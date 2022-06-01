import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../bridge_generated.dart' show Script;
import '../models/entry.dart';
import 'entry_eg.dart';
import 'expandable.dart';

class EntryEgs extends StatelessWidget {
  final List<Eg> egs;
  final Script script;
  final TextStyle lineTextStyle;
  final Color linkColor;
  final double rubyFontSize;
  final bool isSingleDef;
  final OnTapLink onTapLink;
  final FlutterTts player;

  const EntryEgs(
      {Key? key,
      required this.egs,
      required this.script,
      required this.lineTextStyle,
      required this.linkColor,
      required this.rubyFontSize,
      required this.isSingleDef,
      required this.onTapLink,
      required this.player})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (egs.isEmpty) {
      return Container();
    } else if (egs.length == 1) {
      return EntryEg(
          eg: egs[0],
          script: script,
          lineTextStyle: lineTextStyle,
          linkColor: linkColor,
          rubyFontSize: rubyFontSize,
          onTapLink: onTapLink,
          player: player);
    } else if (isSingleDef) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: egs
              .map((eg) => EntryEg(
                  eg: eg,
                  script: script,
                  lineTextStyle: lineTextStyle,
                  linkColor: linkColor,
                  rubyFontSize: rubyFontSize,
                  onTapLink: onTapLink,
                  player: player))
              .toList());
    } else {
      return ExpandableNotifier(
          child: applyExpandableTheme(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expandable(
              collapsed: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EntryEg(
                        eg: egs[0],
                        script: script,
                        lineTextStyle: lineTextStyle,
                        linkColor: linkColor,
                        rubyFontSize: rubyFontSize,
                        onTapLink: onTapLink,
                        player: player),
                    Builder(builder: (context) {
                      return expandButton(
                          AppLocalizations.of(context)!.entryMoreExamples,
                          Icons.expand_more,
                          lineTextStyle.copyWith(
                              color: Theme.of(context).colorScheme.secondary));
                    })
                  ]),
              expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...egs
                        .map((eg) => EntryEg(
                            eg: eg,
                            script: script,
                            lineTextStyle: lineTextStyle,
                            linkColor: linkColor,
                            rubyFontSize: rubyFontSize,
                            onTapLink: onTapLink,
                            player: player))
                        .toList(),
                    Builder(builder: (context) {
                      return expandButton(
                          AppLocalizations.of(context)!.entryCollapseExamples,
                          Icons.expand_less,
                          lineTextStyle.copyWith(
                              color: Theme.of(context).colorScheme.secondary));
                    })
                  ])),
        ],
      )));
    }
  }
}
