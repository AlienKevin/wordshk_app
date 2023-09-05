import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../bridge_generated.dart' show Script;
import '../../constants.dart';
import '../../models/entry.dart';
import '../../states/entry_language_state.dart';
import 'entry_def.dart';
import 'entry_labels.dart';
import 'entry_sims_or_ants.dart';
import 'entry_variants.dart';

class EntryTab extends StatefulWidget {
  final Entry entry;
  final Script script;
  final TextStyle variantTextStyle;
  final TextStyle prTextStyle;
  final TextStyle lineTextStyle;
  final Color linkColor;
  final double rubyFontSize;
  final OnTapLink onTapLink;
  final int? initialDefIndex;

  const EntryTab({
    Key? key,
    required this.entry,
    required this.script,
    required this.variantTextStyle,
    required this.prTextStyle,
    required this.lineTextStyle,
    required this.linkColor,
    required this.rubyFontSize,
    required this.onTapLink,
    required this.initialDefIndex,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EntryTabState();
}

class _EntryTabState extends State<EntryTab> {
  AutoScrollController? scrollController;

  @override
  initState() {
    super.initState();
    if (widget.initialDefIndex != null) {
      scrollController = AutoScrollController(
          viewportBoundaryGetter: () =>
              Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
          axis: Axis.vertical);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await scrollController!.scrollToIndex(widget.initialDefIndex!,
            preferPosition: AutoScrollPosition.begin,
            duration: const Duration(milliseconds: 15));
        scrollController!.highlight(widget.initialDefIndex!);
      });
    }
  }

  showDef(Widget Function(Widget content) wrapContent, BuildContext context,
      int index, int itemCount) {
    final content = wrapContent(Padding(
      padding: const EdgeInsets.all(10.0),
      child: EntryDef(
        def: widget.entry.defs[index - 1],
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

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.entry.defs.length + 1;
    final tab = ListView.separated(
      scrollDirection: Axis.vertical,
      key: PageStorageKey(widget.entry.id),
      controller: scrollController,
      itemBuilder: (context, index) => index == 0
          ? Padding(
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
                    EntryLabels(
                        labels: widget.entry.labels,
                        lineTextStyle: widget.lineTextStyle),
                    EntrySimsOrAnts(
                        label:
                            "[${AppLocalizations.of(context)!.synonym}]",
                        simsOrAnts: widget.entry.sims,
                        simsOrAntsSimp: widget.entry.simsSimp,
                        script: widget.script,
                        lineTextStyle: widget.lineTextStyle,
                        onTapLink: widget.onTapLink),
                    EntrySimsOrAnts(
                        label:
                            "[${AppLocalizations.of(context)!.antonym}]",
                        simsOrAnts: widget.entry.ants,
                        simsOrAntsSimp: widget.entry.antsSimp,
                        script: widget.script,
                        lineTextStyle: widget.lineTextStyle,
                        onTapLink: widget.onTapLink),
                  ]))
          : (scrollController == null
              ? showDef((x) => x, context, index, itemCount)
              : AutoScrollTag(
                  key: ValueKey(index - 1),
                  controller: scrollController!,
                  index: index - 1,
                  highlightColor: greyColor,
                  builder: (BuildContext context, Animation<double> highlight) {
                    highlightContent(content) => DecoratedBoxTransition(
                        position: DecorationPosition.foreground,
                        decoration: DecorationTween(
                            begin: const BoxDecoration(),
                            end: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            )).animate(highlight),
                        child: content);
                    return showDef(highlightContent, context, index, itemCount);
                  })),
      separatorBuilder: (_, index) => index == 0
          ? const SizedBox()
          : Divider(height: widget.lineTextStyle.fontSize!),
      itemCount: itemCount,
    );
    return tab;
  }
}
