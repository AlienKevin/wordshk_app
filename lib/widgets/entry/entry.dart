import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:wordshk/states/language_state.dart';

import '../../models/entry.dart';
import 'entry_tab.dart';

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
  late AutoScrollController _autoScrollController;
  late ListObserverController _observerController;

  getStartDefIndex(int entryIndex) => widget.entryGroup
      .take(entryIndex)
      .fold(0, (len, entry) => len + (entry.defs.length + 1));

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.entryGroup.length,
      initialIndex: widget.initialEntryIndex,
      vsync: this,
    );
    _autoScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);

    final targetDefIndex = getStartDefIndex(widget.initialEntryIndex) +
        (widget.initialDefIndex != null ? widget.initialDefIndex! + 1 : 0);
    // print("initialEntryIndex: ${widget.initialEntryIndex}");
    // print("initialDefIndex: ${widget.initialDefIndex}");
    // print("targetDefIndex: $targetDefIndex");

    _observerController = ListObserverController(controller: _autoScrollController)
      ..initialIndexModel = ObserverIndexPositionModel(
        index: targetDefIndex,
      );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Trigger an observation manually after layout
      if (mounted) {
        _observerController.dispatchOnceObserve();
      }

      await _autoScrollController.scrollToIndex(targetDefIndex,
          preferPosition: AutoScrollPosition.begin,
          duration: const Duration(milliseconds: 15));
      _autoScrollController.highlight(targetDefIndex,
          highlightDuration: const Duration(milliseconds: 500));
    });
  }

  @override
  void dispose() {
    _observerController.controller?.dispose();
    _tabController.dispose();
    _autoScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double rubyFontSize = Theme.of(context).textTheme.headlineSmall!.fontSize!;
    TextStyle lineTextStyle = Theme.of(context).textTheme.bodyMedium!;
    final localizationContext = AppLocalizations.of(context)!;
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

              setState(() {
                if (resultModel.displayingChildModelList.isNotEmpty) {
                  final focusedChild = resultModel.displayingChildModelList.reduce((a, b) => a.displayPercentage >= b.displayPercentage ? a : b);
                  _tabController.animateTo(focusedChild.index);
                }
              });
            },
            child: ListView.separated(
              controller: _autoScrollController,
              itemCount: widget.entryGroup.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, entryIndex) => EntryTab(
                entryGroupSize: widget.entryGroup.length,
                startDefIndex: getStartDefIndex(entryIndex),
                entry: widget.entryGroup[entryIndex],
                script: context.watch<LanguageState>().getScript(),
                variantTextStyle: Theme.of(context).textTheme.headlineSmall!,
                prTextStyle: Theme.of(context).textTheme.bodySmall!,
                lineTextStyle: lineTextStyle,
                linkColor: Theme.of(context).colorScheme.secondary,
                rubyFontSize: rubyFontSize,
                onTapLink: widget.onTapLink,
                autoScrollController: _autoScrollController,
              ),
            ),
          ),
        ),
      ),
      Row(children: [
        IconButton(
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
                  });
                  final targetDefIndex = getStartDefIndex(newIndex);
                  await _autoScrollController.scrollToIndex(targetDefIndex,
                      preferPosition: AutoScrollPosition.begin,
                      duration: const Duration(milliseconds: 15));
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
}
