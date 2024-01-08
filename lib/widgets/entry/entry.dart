import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:wordshk/states/language_state.dart';

import '../../models/entry.dart';
import '../../states/entry_language_state.dart';
import 'entry_def.dart';
import 'entry_labels.dart';
import 'entry_sims_or_ants.dart';
import 'entry_variants.dart';

class EntryWidget extends StatefulWidget {
  final List<Entry> entryGroup;
  final int initialEntryIndex;
  final int? initialDefIndex;
  final OnTapLink onTapLink;

  const EntryWidget({
    Key? key,
    required this.entryGroup,
    required this.initialEntryIndex,
    required this.initialDefIndex,
    required this.onTapLink,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EntryWidgetState();
}

class _EntryWidgetState extends State<EntryWidget>
    with SingleTickerProviderStateMixin {
  int? entryIndex;
  late TabController _tabController;
  late ScrollController _scrollController;
  late ListObserverController _observerController;
  bool isScrollingToTarget = false;
  late final List<(int, int)> defIndexRanges;

  int getStartDefIndex(int entryIndex) => defIndexRanges[entryIndex].$1;

  @override
  void initState() {
    super.initState();

    innerGetStartDefIndex(int entryIndex) => widget.entryGroup
        .take(entryIndex)
        .fold(0, (len, entry) => len + (entry.defs.length + 1));

    defIndexRanges = widget.entryGroup
        .mapIndexed((entryIndex, entry) => (
              innerGetStartDefIndex(entryIndex),
              innerGetStartDefIndex(entryIndex) + entry.defs.length + 1
            ))
        .toList();

    _tabController = TabController(
      length: widget.entryGroup.length,
      initialIndex: widget.initialEntryIndex,
      vsync: this,
    );
    _scrollController = ScrollController();

    final targetDefIndex = getStartDefIndex(widget.initialEntryIndex) +
        (widget.initialDefIndex != null ? widget.initialDefIndex! + 1 : 0);
    // debugPrint("defIndexRanges: $defIndexRanges");
    // debugPrint("initialEntryIndex: ${widget.initialEntryIndex}");
    // debugPrint("initialDefIndex: ${widget.initialDefIndex}");
    // debugPrint("targetDefIndex: $targetDefIndex");

    _observerController = ListObserverController(controller: _scrollController)
      ..initialIndexModel = ObserverIndexPositionModel(
        index: targetDefIndex,
      );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isScrollingToTarget = true;
      });
      await _observerController.animateTo(
        index: targetDefIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
        alignment: 1,
      );
      setState(() {
        isScrollingToTarget = false;
      });
      // Trigger an observation manually after layout
      if (mounted) {
        _observerController.dispatchOnceObserve();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double rubyFontSize = Theme.of(context).textTheme.headlineSmall!.fontSize!;
    TextStyle lineTextStyle = Theme.of(context).textTheme.bodyMedium!;
    final localizationContext = AppLocalizations.of(context)!;

    final items = widget.entryGroup.indexed
        .map((item) => showDefs(
              entryIndex: item.$1,
              script: context.watch<LanguageState>().getScript(),
              variantTextStyle: Theme.of(context).textTheme.headlineSmall!,
              prTextStyle: Theme.of(context).textTheme.bodySmall!,
              lineTextStyle: lineTextStyle,
              linkColor: Theme.of(context).colorScheme.secondary,
              rubyFontSize: rubyFontSize,
              onTapLink: widget.onTapLink,
            ))
        .expand((x) => x)
        .toList();

    return Column(children: [
      Expanded(
          child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ListViewObserver(
                controller: _observerController,
                autoTriggerObserveTypes: const [
                  ObserverAutoTriggerObserveType.scrollUpdate,
                ],
                triggerOnObserveType: ObserverTriggerOnObserveType.directly,
                onObserve: (resultModel) {
                  // debugPrint('visible -- ${resultModel.visible}');
                  // debugPrint('firstChild.index -- ${resultModel.firstChild?.index}');
                  // debugPrint('displaying -- ${resultModel.displayingChildIndexList}');

                  // for (var item in resultModel.displayingChildModelList) {
                  //   debugPrint(
                  //       'item - ${item.index} ${item.leadingMarginToViewport} ${item.trailingMarginToViewport} ${item.displayPercentage}');
                  // }

                  if (!isScrollingToTarget &&
                      resultModel.displayingChildModelList.isNotEmpty) {
                    final RenderSliverMultiBoxAdaptor list =
                        resultModel.sliverList;
                    List<
                        ({
                          RenderIndexedSemantics child,
                          ListViewObserveDisplayingChildModel? displayingChild
                        })> items = [];
                    list.visitChildren((child) {
                      if (child is! RenderIndexedSemantics) {
                        return;
                      }
                      final displayingChild = resultModel
                          .displayingChildModelList
                          .firstWhereOrNull((displayingChild) =>
                              displayingChild.renderObject == child);
                      items.add(
                          (child: child, displayingChild: displayingChild));
                    });

                    final targetEntryIndex = groupBy(
                            items,
                            (item) => defIndexRanges.indexWhere((entryRange) =>
                                item.child.index >= entryRange.$1 &&
                                item.child.index < entryRange.$2))
                        .map((defIndex, items) {
                          final entryDisplayingHeight = items
                              .map((item) => (item.displayingChild == null)
                                  ? 0
                                  : item.displayingChild!.displayPercentage *
                                      item.displayingChild!.mainAxisSize)
                              .reduce((entryHeight, defHeight) =>
                                  entryHeight + defHeight);
                          final entryTotalHeight = items
                              .map((item) => item.child.size.height)
                              .reduce((entryHeight, defHeight) =>
                                  entryHeight + defHeight);
                          return MapEntry(defIndex,
                              entryDisplayingHeight / entryTotalHeight);
                        })
                        .entries
                        .fold(
                            (tallestEntryIndex: -1, tallestEntryHeight: -1.0),
                            (tallestEntry, entryHeight) =>
                                tallestEntry.tallestEntryHeight >
                                        entryHeight.value
                                    ? tallestEntry
                                    : (
                                        tallestEntryIndex: entryHeight.key,
                                        tallestEntryHeight: entryHeight.value
                                      ))
                        .tallestEntryIndex;

                    debugPrint("targetEntryIndex: $targetEntryIndex");
                    setState(() {
                      _tabController.animateTo(targetEntryIndex);
                    });
                  }
                },
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(10),
                  itemCount: items.length,
                  cacheExtent: double.infinity,
                  separatorBuilder: (context, index) => SizedBox(
                    height: defIndexRanges.firstWhereOrNull(
                                (range) => range.$2 - 1 == index) !=
                            null
                        ? 20
                        : 10,
                  ),
                  itemBuilder: (context, index) => items[index],
                ),
              ))),
      Row(children: [
        Visibility(
          visible: Navigator.of(context).canPop(),
          child: IconButton(
            icon: Icon(
                isMaterial(context)
                    ? Icons.arrow_back
                    : CupertinoIcons.chevron_left,
                color: Theme.of(context).textTheme.bodyMedium!.color!),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        Expanded(
            child: Align(
          alignment: Alignment.centerLeft,
          child: Material(
            elevation: 2,
            child: TabBar(
              controller: _tabController,
              onTap: (newIndex) async {
                if (newIndex != entryIndex) {
                  // context.read<PlayerState>().stop();
                  setState(() {
                    entryIndex = newIndex;
                    isScrollingToTarget = true;
                  });
                  final targetDefIndex = getStartDefIndex(newIndex);
                  await _observerController.animateTo(
                    index: targetDefIndex,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                  setState(() {
                    isScrollingToTarget = false;
                  });
                }
              },
              isScrollable: true,
              // Required
              labelColor: lineTextStyle.color,
              unselectedLabelColor: lineTextStyle.color,
              // Other tabs color
              labelPadding: const EdgeInsets.symmetric(horizontal: 30),
              // Space between tabs
              indicator: BubbleTabIndicator(
                indicatorHeight:
                    Theme.of(context).textTheme.bodyMedium!.fontSize! * 1.5,
                indicatorColor: Theme.of(context).splashColor,
                tabBarIndicatorSize: TabBarIndicatorSize.label,
              ),
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.symmetric(vertical: 6),
              tabs: widget.entryGroup
                  .asMap()
                  .entries
                  .map((entry) => Tab(
                      text:
                          "${entry.key + 1} ${entry.value.poses.map((pos) => translatePos(pos, localizationContext)).join("/")}"))
                  .toList(),
            ),
          ),
        )),
      ]),
    ]);
  }

  showDef(int entryIndex, int index, lineTextStyle, linkColor,
      rubyFontSize) {
    final entry = widget.entryGroup[entryIndex];
    return EntryDef(
      def: entry.defs[index - 1],
      defIndex: index - 1,
      entryLanguage: context.watch<EntryLanguageState>().language,
      script: context.watch<LanguageState>().getScript(),
      lineTextStyle: lineTextStyle,
      linkColor: linkColor,
      rubyFontSize: rubyFontSize,
      isSingleDef: entry.defs.length == 1 && widget.entryGroup.length == 1,
      onTapLink: widget.onTapLink,
    );
  }

  List<Widget> showDefs(
      {required entryIndex,
      required script,
      required onTapLink,
      required variantTextStyle,
      required prTextStyle,
      required lineTextStyle,
      required linkColor,
      required rubyFontSize}) {
    final entry = widget.entryGroup[entryIndex];
    return [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        EntryVariants(
          variants: entry.variants,
          variantsSimp: entry.variantsSimp,
          script: script,
          variantTextStyle: variantTextStyle,
          prTextStyle: prTextStyle,
          lineTextStyle: lineTextStyle,
        ),
        EntryLabels(
            entryId: entry.id, poses: entry.poses, labels: entry.labels),
        EntrySimsOrAnts(
            label: "[${AppLocalizations.of(context)!.synonym}]",
            simsOrAnts: entry.sims,
            simsOrAntsSimp: entry.simsSimp,
            script: script,
            onTapLink: onTapLink),
        EntrySimsOrAnts(
            label: "[${AppLocalizations.of(context)!.antonym}]",
            simsOrAnts: entry.ants,
            simsOrAntsSimp: entry.antsSimp,
            script: script,
            onTapLink: onTapLink),
      ]),
      ...entry.defs.indexed.map((item) {
        final index = item.$1 + 1;
        return showDef(entryIndex, index, lineTextStyle, linkColor,
            rubyFontSize);
      })
    ];
  }
}
