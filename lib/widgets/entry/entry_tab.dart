import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:wordshk/src/rust/api/api.dart' show Script;

import '../../models/entry.dart';
import '../../states/entry_language_state.dart';
import 'entry_def.dart';
import 'entry_labels.dart';
import 'entry_sims_or_ants.dart';
import 'entry_variants.dart';

class EntryTab extends StatefulWidget {
  final int startDefIndex;
  final int entryGroupSize;
  final Entry entry;
  final Script script;
  final TextStyle variantTextStyle;
  final TextStyle prTextStyle;
  final TextStyle lineTextStyle;
  final Color linkColor;
  final double rubyFontSize;
  final OnTapLink onTapLink;
  final AutoScrollController autoScrollController;

  const EntryTab({
    Key? key,
    required this.startDefIndex,
    required this.entryGroupSize,
    required this.entry,
    required this.script,
    required this.variantTextStyle,
    required this.prTextStyle,
    required this.lineTextStyle,
    required this.linkColor,
    required this.rubyFontSize,
    required this.onTapLink,
    required this.autoScrollController,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EntryTabState();
}

class _EntryTabState extends State<EntryTab> {
  showDef(Widget Function(Widget content) wrapContent, BuildContext context,
      int index, int itemCount) {
    final content = wrapContent(Padding(
      padding: const EdgeInsets.all(10.0),
      child: EntryDef(
        def: widget.entry.defs[index - 1],
        defIndex: index - 1,
        entryLanguage: context.watch<EntryLanguageState>().language,
        script: widget.script,
        lineTextStyle: widget.lineTextStyle,
        linkColor: widget.linkColor,
        rubyFontSize: widget.rubyFontSize,
        isSingleDef: widget.entry.defs.length == 1,
        onTapLink: widget.onTapLink,
      ),
    ));
    return index == itemCount - 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [content, const SizedBox(height: 10.0)])
        : content;
  }

  highlightContent(Animation<double> highlight) => (Widget content) =>
      widget.entryGroupSize == 1 && widget.entry.defs.length == 1
          ? content
          : DecoratedBoxTransition(
              position: DecorationPosition.foreground,
              decoration: DecorationTween(
                  begin: const BoxDecoration(),
                  end: BoxDecoration(
                    border: Border.all(
                        width: 2,
                        color: Theme.of(context).colorScheme.secondary),
                  )).animate(highlight),
              child: content);

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.entry.defs.length + 1;
    final tab = AutoScrollTag(
        key: ValueKey(widget.startDefIndex),
        controller: widget.autoScrollController,
        index: widget.startDefIndex,
        builder: (BuildContext context, Animation<double> highlight) =>
            highlightContent(highlight)(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EntryVariants(
                              variants: widget.entry.variants,
                              variantsSimp: widget.entry.variantsSimp,
                              script: widget.script,
                              variantTextStyle: widget.variantTextStyle,
                              prTextStyle: widget.prTextStyle,
                              lineTextStyle: widget.lineTextStyle,
                            ),
                            EntryLabels(poses: widget.entry.poses, labels: widget.entry.labels),
                            EntrySimsOrAnts(
                                label:
                                    "[${AppLocalizations.of(context)!.synonym}]",
                                simsOrAnts: widget.entry.sims,
                                simsOrAntsSimp: widget.entry.simsSimp,
                                script: widget.script,
                                onTapLink: widget.onTapLink),
                            EntrySimsOrAnts(
                                label:
                                    "[${AppLocalizations.of(context)!.antonym}]",
                                simsOrAnts: widget.entry.ants,
                                simsOrAntsSimp: widget.entry.antsSimp,
                                script: widget.script,
                                onTapLink: widget.onTapLink),
                          ])),
                  ...widget.entry.defs.indexed.map((item) {
                    final index = item.$1 + 1;
                    return AutoScrollTag(
                        key: ValueKey(widget.startDefIndex + index),
                        controller: widget.autoScrollController,
                        index: widget.startDefIndex + index,
                        builder: (BuildContext context,
                            Animation<double> highlight) {
                          return showDef(highlightContent(highlight), context,
                              index, itemCount);
                        });
                  })
                ],
              ),
            ));
    return SelectionArea(child: tab);
  }
}
