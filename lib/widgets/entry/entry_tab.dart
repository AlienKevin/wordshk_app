import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../bridge_generated.dart' show Script;
import '../../constants.dart';
import '../../models/entry.dart';
import '../../states/entry_language_state.dart';
import 'entry_banner.dart';
import 'entry_def.dart';
import 'entry_labels.dart';
import 'entry_sims_or_ants.dart';
import 'entry_variants.dart';

class EntryTab extends StatelessWidget {
  final Entry entry;
  final Script script;
  final TextStyle variantTextStyle;
  final TextStyle prTextStyle;
  final TextStyle lineTextStyle;
  final Color linkColor;
  final double rubyFontSize;
  final OnTapLink onTapLink;
  final AutoScrollController scrollController;
  final FlutterTts player;

  const EntryTab(
      {Key? key,
      required this.entry,
      required this.script,
      required this.variantTextStyle,
      required this.prTextStyle,
      required this.lineTextStyle,
      required this.linkColor,
      required this.rubyFontSize,
      required this.onTapLink,
      required this.scrollController,
      required this.player})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemCount = entry.defs.length + 1;
    final tab = Expanded(
      child: ListView.separated(
        controller: scrollController,
        itemBuilder: (context, index) => index == 0
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EntryBanner(published: entry.published),
                      EntryVariants(
                        variants: entry.variants,
                        variantsSimp: entry.variantsSimp,
                        script: script,
                        variantTextStyle: variantTextStyle,
                        prTextStyle: prTextStyle,
                        lineTextStyle: lineTextStyle,
                      ),
                      EntryLabels(
                          labels: entry.labels, lineTextStyle: lineTextStyle),
                      EntrySimsOrAnts(
                          label:
                              "[" + AppLocalizations.of(context)!.synonym + "]",
                          simsOrAnts: entry.sims,
                          simsOrAntsSimp: entry.simsSimp,
                          script: script,
                          lineTextStyle: lineTextStyle,
                          onTapLink: onTapLink),
                      EntrySimsOrAnts(
                          label:
                              "[" + AppLocalizations.of(context)!.antonym + "]",
                          simsOrAnts: entry.ants,
                          simsOrAntsSimp: entry.antsSimp,
                          script: script,
                          lineTextStyle: lineTextStyle,
                          onTapLink: onTapLink),
                    ]))
            : AutoScrollTag(
                key: ValueKey(index - 1),
                controller: scrollController,
                index: index - 1,
                highlightColor: greyColor,
                builder: (BuildContext context, Animation<double> highlight) {
                  final content = DecoratedBoxTransition(
                      position: DecorationPosition.foreground,
                      decoration: DecorationTween(
                          begin: const BoxDecoration(),
                          end: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: Theme.of(context).colorScheme.secondary),
                          )).animate(highlight),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: EntryDef(
                          def: entry.defs[index - 1],
                          entryLanguage:
                              context.watch<EntryLanguageState>().language!,
                          script: script,
                          lineTextStyle: lineTextStyle,
                          linkColor: linkColor,
                          rubyFontSize: rubyFontSize,
                          isSingleDef: entry.defs.length == 1,
                          onTapLink: onTapLink,
                          player: player,
                        ),
                      ));
                  return index == itemCount - 1
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [content, const SizedBox(height: 10.0)])
                      : content;
                }),
        separatorBuilder: (_, index) => index == 0
            ? const SizedBox()
            : Divider(height: lineTextStyle.fontSize!),
        itemCount: itemCount,
      ),
    );
    return tab;
  }
}
