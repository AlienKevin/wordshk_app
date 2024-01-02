import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/states/language_state.dart';

import '../../models/entry.dart';
import '../../states/player_state.dart';
import 'entry_tab.dart';

class EntryWidget extends StatefulWidget {
  final List<Entry> entryGroup;
  final int initialEntryIndex;
  final int? initialDefIndex;
  final OnTapLink onTapLink;
  final UpdateEntryIndex updateEntryIndex;
  final Widget? entryActionButtons;

  const EntryWidget({
    Key? key,
    required this.entryGroup,
    required this.initialEntryIndex,
    required this.initialDefIndex,
    required this.onTapLink,
    required this.updateEntryIndex,
    this.entryActionButtons,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EntryWidgetState();
}

class _EntryWidgetState extends State<EntryWidget>
    with SingleTickerProviderStateMixin {
  int? entryIndex;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.entryGroup.length,
      initialIndex: widget.initialEntryIndex,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    double rubyFontSize = Theme.of(context).textTheme.headlineSmall!.fontSize!;
    TextStyle lineTextStyle = Theme.of(context).textTheme.bodyMedium!;
    final localizationContext = AppLocalizations.of(context)!;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Expanded(
        child: Column(children: [
          Row(children: [
            Expanded(
                child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                dividerColor: Theme.of(context).dividerColor,
                dividerHeight: 2,
                controller: _tabController,
                onTap: (newIndex) {
                  if (newIndex != entryIndex) {
                    context.read<PlayerState>().stop();
                    setState(() {
                      entryIndex = newIndex;
                    });
                    widget.updateEntryIndex(newIndex);
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
                  indicatorHeight: Theme.of(context).textTheme.bodyMedium!.fontSize! * 1.5,
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
            )),
            widget.entryActionButtons ?? Container(),
          ]),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TabBarView(
                  controller: _tabController,
                  children: widget.entryGroup
                      .mapIndexed((index, entry) => EntryTab(
                            entry: entry,
                            script: context.watch<LanguageState>().getScript(),
                            variantTextStyle:
                                Theme.of(context).textTheme.headlineSmall!,
                            prTextStyle: Theme.of(context).textTheme.bodySmall!,
                            lineTextStyle: lineTextStyle,
                            linkColor: Theme.of(context).colorScheme.secondary,
                            rubyFontSize: rubyFontSize,
                            onTapLink: widget.onTapLink,
                            initialDefIndex: index == widget.initialEntryIndex
                                ? widget.initialDefIndex
                                : null,
                          ))
                      .toList()),
            ),
          ),
        ]),
      )
    ]);
  }
}
