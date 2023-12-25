import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
                      entryLanguage: entryLanguage,
                      script: script,
                      lineTextStyle: lineTextStyle,
                      linkColor: linkColor,
                      rubyFontSize: rubyFontSize,
                      onTapLink: onTapLink,
                    ),
                    Builder(builder: (context) {
                      return expandButton(
                          AppLocalizations.of(context)!.entryMoreExamples,
                          isMaterial(context)
                              ? Icons.expand_more
                              : CupertinoIcons.chevron_down,
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
                              entryLanguage: entryLanguage,
                              script: script,
                              lineTextStyle: lineTextStyle,
                              linkColor: linkColor,
                              rubyFontSize: rubyFontSize,
                              onTapLink: onTapLink,
                            ))
                        .toList(),
                    Builder(builder: (context) {
                      return expandButton(
                          AppLocalizations.of(context)!.entryCollapseExamples,
                          isMaterial(context)
                              ? Icons.expand_less
                              : CupertinoIcons.chevron_up,
                          lineTextStyle.copyWith(
                              color: Theme.of(context).colorScheme.secondary));
                    })
                  ])),
        ],
      )));
    }
  }
}
