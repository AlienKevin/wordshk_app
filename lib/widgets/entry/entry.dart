import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../bridge_generated.dart' show Script;
import '../../models/entry.dart';
import 'entry_tab.dart';

class EntryWidget extends StatelessWidget {
  final List<Entry> entryGroup;
  final int entryIndex;
  final Script script;
  final void Function(int) updateEntryIndex;
  final OnTapLink onTapLink;
  final AutoScrollController scrollController;

  const EntryWidget({
    Key? key,
    required this.entryGroup,
    required this.entryIndex,
    required this.script,
    required this.updateEntryIndex,
    required this.onTapLink,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rubyFontSize = Theme.of(context).textTheme.headlineSmall!.fontSize!;
    TextStyle lineTextStyle = Theme.of(context).textTheme.bodyMedium!;
    final localizationContext = AppLocalizations.of(context)!;
    return Column(
      children: [
        DefaultTabController(
          length: entryGroup.length,
          child: Expanded(
            child: Column(children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    onTap: updateEntryIndex,
                    isScrollable: true,
                    // Required
                    labelColor: lineTextStyle.color,
                    unselectedLabelColor: lineTextStyle.color,
                    // Other tabs color
                    labelPadding: const EdgeInsets.symmetric(horizontal: 30),
                    // Space between tabs
                    indicator: UnderlineTabIndicator(
                      borderSide:
                          BorderSide(color: lineTextStyle.color!, width: 2),
                      // Indicator height
                      insets: const EdgeInsets.symmetric(
                          horizontal: 30), // Indicator width
                    ),
                    tabs: entryGroup
                        .asMap()
                        .entries
                        .map((entry) => Tab(
                            text: (entry.key + 1).toString() +
                                " " +
                                entry.value.poses
                                    .map((pos) =>
                                        translatePos(pos, localizationContext))
                                    .join("/")))
                        .toList(),
                  )),
              EntryTab(
                entry: entryGroup[entryIndex],
                script: script,
                variantTextStyle: Theme.of(context).textTheme.headlineSmall!,
                prTextStyle: Theme.of(context).textTheme.bodySmall!,
                lineTextStyle: lineTextStyle,
                linkColor: Theme.of(context).colorScheme.secondary,
                rubyFontSize: rubyFontSize,
                onTapLink: onTapLink,
                scrollController: scrollController,
              )
            ]),
          ),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
