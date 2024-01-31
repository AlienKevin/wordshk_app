import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wordshk/src/rust/api/api.dart' show Script;

import '../../models/entry.dart';
import '../../models/entry_language.dart';
import '../expandable.dart';
import 'entry_eg.dart';

class EntryEgs extends StatelessWidget {
  final List<Eg> egs;
  final EntryLanguage entryLanguage;
  final Script script;
  final TextStyle lineTextStyle;
  final Color linkColor;
  final double rubyFontSize;
  final bool isSingleDef;
  final OnTapLink onTapLink;

  const EntryEgs({
    Key? key,
    required this.egs,
    required this.entryLanguage,
    required this.script,
    required this.lineTextStyle,
    required this.linkColor,
    required this.rubyFontSize,
    required this.isSingleDef,
    required this.onTapLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (egs.isEmpty) {
      return Container();
    } else if (egs.length == 1) {
      return EntryEg(
        eg: egs[0],
        entryLanguage: entryLanguage,
        script: script,
        lineTextStyle: lineTextStyle,
        linkColor: linkColor,
        rubyFontSize: rubyFontSize,
        onTapLink: onTapLink,
      );
    } else if (isSingleDef) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: egs
              .map((eg) => EntryEg(
                    eg: eg,
                    entryLanguage: entryLanguage,
                    script: script,
                    lineTextStyle: lineTextStyle,
                    linkColor: linkColor,
                    rubyFontSize: rubyFontSize,
                    onTapLink: onTapLink,
                  ))
              .toList());
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            EntryEg(
              eg: egs[0],
              entryLanguage: entryLanguage,
              script: script,
              lineTextStyle: lineTextStyle,
              linkColor: linkColor,
              rubyFontSize: rubyFontSize,
              onTapLink: onTapLink,
            ),
          ]),
          MyExpandable(
              expandText: AppLocalizations.of(context)!.entryMoreExamples,
              collapseText: AppLocalizations.of(context)!.entryCollapseExamples,
              lineTextStyle: lineTextStyle.copyWith(
                  color: Theme.of(context).colorScheme.secondary),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...egs.skip(1).map((eg) => EntryEg(
                          eg: eg,
                          entryLanguage: entryLanguage,
                          script: script,
                          lineTextStyle: lineTextStyle,
                          linkColor: linkColor,
                          rubyFontSize: rubyFontSize,
                          onTapLink: onTapLink,
                        )),
                  ]))
        ],
      );
    }
  }
}
