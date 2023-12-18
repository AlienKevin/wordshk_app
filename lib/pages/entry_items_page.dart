import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart' hide NavigationDrawer;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';
import 'package:wordshk/bridge_generated.dart';
import 'package:wordshk/widgets/constrained_content.dart';

import '../constants.dart';
import '../custom_page_route.dart';
import '../ffi.dart';
import '../models/embedded.dart';
import '../models/summary_def_language.dart';
import '../states/entry_item_state.dart';
import '../utils.dart';
import '../widgets/navigation_drawer.dart';
import 'entry_page.dart';

class EntryItemsPage<T extends EntryItemState> extends StatefulWidget {
  final String title;
  final String emptyMessage;
  final String deletionConfirmationMessage;
  const EntryItemsPage(
      {Key? key,
      required this.title,
      required this.emptyMessage,
      required this.deletionConfirmationMessage})
      : super(key: key);

  @override
  _EntryItemsState<T> createState() => _EntryItemsState<T>();
}

sealed class Mode {}

class ViewMode extends Mode {}

class EditMode extends Mode {
  HashSet<int> selectedEntryItems;

  EditMode({required this.selectedEntryItems});
}

class _EntryItemsState<T extends EntryItemState>
    extends State<EntryItemsPage<T>> {
  final LinkedHashMap<int, EntrySummary> _entryItemSummaries = LinkedHashMap();
  late final RemoveItemCallback removeEntryItemListener;
  late final AddItemCallback addEntryItemListener;
  bool _isLoading = false;
  bool _hasMore = true;
  Mode _mode = ViewMode();
  // The EntryId corresponding to the select item (used in wide screens)
  int? selectedEntryId;
  late SummaryDefLanguage summaryDefLanguage;

  @override
  void initState() {
    super.initState();

    summaryDefLanguage = getSummaryDefLanguage(context);

    removeEntryItemListener = (id) {
      setState(() {
        _entryItemSummaries.remove(id);
        if (selectedEntryId == id) {
          selectedEntryId = null;
        }
      });
    };
    context.read<T>().registerRemoveItemListener(removeEntryItemListener);

    addEntryItemListener = (id) async {
      final summaries = await fetchSummaries([id]);
      setState(() {
        _entryItemSummaries.addAll(summaries);
      });
    };
    context.read<T>().registerAddItemListener(addEntryItemListener);

    _loadMore();
  }

  @override
  void activate() {
    super.activate();
    context.read<T>().registerRemoveItemListener(removeEntryItemListener);
    context.read<T>().registerAddItemListener(addEntryItemListener);
  }

  @override
  void deactivate() {
    context.read<T>().unregisterRemoveItemListener(removeEntryItemListener);
    context.read<T>().unregisterAddItemListener(addEntryItemListener);
    super.deactivate();
  }

  Future<LinkedHashMap<int, EntrySummary>> fetchSummaries(List<int> ids) {
    final script = getScript(context);

    return api().then((api) => api
        .getEntrySummaries(
          entryIds: Uint32List.fromList(ids),
          script: script,
        )
        .then((summaries) => LinkedHashMap.fromIterables(ids, summaries)));
  }

  Future<LinkedHashMap<int, EntrySummary>> _fetchMoreEntryItems(int amount) {
    final allEntryItems = context.read<T>().items;
    if (allEntryItems.length > _entryItemSummaries.length) {
      final ids = allEntryItems.sublist(_entryItemSummaries.length,
          min(_entryItemSummaries.length + amount, allEntryItems.length));
      return fetchSummaries(ids);
    } else {
      return Future.value(LinkedHashMap<int, EntrySummary>());
    }
  }

  _loadMore() {
    if (!_hasMore || _isLoading) {
      return;
    }

    _isLoading = true;
    _fetchMoreEntryItems(10).then((newEntryItems) {
      if (newEntryItems.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _entryItemSummaries.addAll(newEntryItems);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: _entryItemSummaries.isEmpty
            ? []
            : [
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  child: Text(switch (_mode) {
                    ViewMode() => AppLocalizations.of(context)!.edit,
                    EditMode() => AppLocalizations.of(context)!.done,
                  }),
                  onPressed: () {
                    setState(() {
                      _mode = switch (_mode) {
                        ViewMode() =>
                          EditMode(selectedEntryItems: HashSet<int>()),
                        EditMode() => ViewMode(),
                      };
                    });
                  },
                ),
              ],
      ),
      drawer: const NavigationDrawer(),
      body: Consumer<T>(
          builder: (BuildContext context, EntryItemState s, Widget? child) => s
                  .items.isEmpty
              ? Center(child: Text(widget.emptyMessage))
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // Embedded search results in the right column on wide screens
                    final embedded = constraints.maxWidth > wideScreenThreshold
                        ? Embedded.embedded
                        : Embedded.topLevel;
                    // Select the first item by default
                    if (selectedEntryId == null && s.items.isNotEmpty) {
                      selectedEntryId = s.items.first;
                    }
                    return embedded == Embedded.embedded
                        ? Row(
                            children: [
                              Expanded(child: itemsList(s, embedded)),
                              const VerticalDivider(
                                width: 1,
                                thickness: 1,
                              ),
                              Expanded(
                                  flex: 2,
                                  child: selectedEntryId != null
                                      ? Navigator(
                                          key: ValueKey(selectedEntryId!),
                                          onGenerateRoute: (settings) =>
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EntryPage(
                                                        key: ValueKey(
                                                            selectedEntryId!),
                                                        id: selectedEntryId!,
                                                        showFirstEntryInGroupInitially:
                                                            false,
                                                        embedded: embedded,
                                                      )))
                                      : Container()),
                            ],
                          )
                        : itemsList(s, embedded);
                  },
                )),
      bottomNavigationBar: switch (_mode) {
        EditMode(selectedEntryItems: var selectedEntryItems)
            when _entryItemSummaries.isNotEmpty =>
          BottomAppBar(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: Theme.of(context)
                    .elevatedButtonTheme
                    .style!
                    .textStyle!
                    .resolve({})!.fontSize! *
                4,
            child: ConstrainedContent(
              child: Row(
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                        ),
                      ),
                      onPressed: () async {
                        final allEntryItems = context.read<T>().items;
                        switch (_mode) {
                          case ViewMode():
                            {
                              await Sentry.captureMessage(
                                  'entryItem_page: All button pressed in ViewMode even though it should only be present in EditMode.');
                              break;
                            }
                          case EditMode(
                              selectedEntryItems: var selectedEntryItems
                            ):
                            if (selectedEntryItems.length <
                                allEntryItems.length) {
                              setState(() {
                                selectedEntryItems.addAll(allEntryItems);
                              });
                            } else {
                              setState(() {
                                selectedEntryItems.clear();
                              });
                            }
                            break;
                        }
                      },
                      child: (() {
                        return ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 80),
                          child: Text(
                            selectedEntryItems.length <
                                    _entryItemSummaries.length
                                ? AppLocalizations.of(context)!.all
                                : AppLocalizations.of(context)!.none,
                            textAlign: TextAlign.center,
                          ),
                        );
                      })()),
                  const Spacer(),
                  ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      ),
                    ),
                    onPressed: selectedEntryItems.isEmpty
                        ? null
                        : () {
                            showPlatformDialog(
                              context: context,
                              builder: (_) => PlatformAlertDialog(
                                title: Text(widget.deletionConfirmationMessage),
                                actions: [
                                  PlatformDialogAction(
                                    child: PlatformText(
                                        AppLocalizations.of(context)!.cancel),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  PlatformDialogAction(
                                    child: PlatformText(
                                        AppLocalizations.of(context)!.confirm),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      for (final id in selectedEntryItems) {
                                        context.read<T>().removeItem(id);
                                      }
                                      setState(() {
                                        _mode = EditMode(
                                            selectedEntryItems: HashSet());
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 80),
                        child: Text(
                          AppLocalizations.of(context)!.delete,
                          textAlign: TextAlign.center,
                        )),
                  ),
                ],
              ),
            ),
          ),
        _ => null,
      },
    );
  }

  itemsList(EntryItemState s, Embedded embedded) =>
      embedded == Embedded.topLevel
          ? rawItemList(s, embedded)
          : Column(
              children: [
                Container(
                  color: Theme.of(context).dividerColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SegmentedButton<SummaryDefLanguage>(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => states
                                        .contains(MaterialState.selected)
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).colorScheme.surface),
                            visualDensity: VisualDensity.compact,
                          ),
                          segments: [
                            ButtonSegment(
                                value: SummaryDefLanguage.cantonese,
                                label: Text(AppLocalizations.of(context)!
                                    .entryLanguageCantonese)),
                            ButtonSegment(
                                value: SummaryDefLanguage.english,
                                label: Text(AppLocalizations.of(context)!
                                    .entryLanguageEnglish)),
                          ],
                          onSelectionChanged: (value) {
                            setState(() {
                              summaryDefLanguage = value.first;
                            });
                          },
                          selected: {summaryDefLanguage},
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(child: rawItemList(s, embedded)),
              ],
            );

  getSummaryDef(List<(String, String)> summaryDefs,
          SummaryDefLanguage summaryDefLanguage) =>
      switch (summaryDefLanguage) {
        SummaryDefLanguage.cantonese =>
          summaryDefs.map((pair) => pair.$1).toList(),
        SummaryDefLanguage.english =>
          summaryDefs.map((pair) => pair.$2).toList()
      };

  rawItemList(EntryItemState s, Embedded embedded) => ListView.separated(
        itemCount: _hasMore
            ? _entryItemSummaries.length + 1
            : _entryItemSummaries.length,
        itemBuilder: (context, index) {
          if (index >= _entryItemSummaries.length) {
            _loadMore();
            return const Center(child: CircularProgressIndicator());
          }
          final summaryEntry = _entryItemSummaries.entries.elementAt(index);
          final id = summaryEntry.key;
          final summary = summaryEntry.value;
          final selected =
              embedded == Embedded.embedded && id == selectedEntryId;
          return ListTile(
            selected: selected,
            selectedTileColor: Theme.of(context).primaryColor,
            selectedColor: Theme.of(context).colorScheme.onPrimary,
            leading: switch (_mode) {
              ViewMode() => null,
              EditMode(selectedEntryItems: var selectedEntryItems) => Checkbox(
                  value: selectedEntryItems.contains(id),
                  visualDensity: VisualDensity.compact,
                  onChanged: (value) {
                    if (value!) {
                      setState(() {
                        selectedEntryItems.add(id);
                      });
                    } else {
                      setState(() {
                        selectedEntryItems.remove(id);
                      });
                    }
                  },
                  side: selected
                      ? BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary,
                          width: 2)
                      : null,
                )
            },
            title: Text(
              summary.variant,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: RichText(
                text: TextSpan(
                    children: showDefSummary(
                        context,
                        getSummaryDef(summary.defs, summaryDefLanguage),
                        Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: selected
                                ? Theme.of(context).colorScheme.onPrimary
                                : null))),
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: MediaQuery.of(context).textScaleFactor),
            onTap: switch (_mode) {
              ViewMode() => () {
                  setState(() {
                    selectedEntryId = id;
                  });
                  if (embedded != Embedded.embedded) {
                    Navigator.push(
                      context,
                      CustomPageRoute(
                          builder: (context) => EntryPage(
                                key: ValueKey(selectedEntryId!),
                                id: selectedEntryId!,
                                showFirstEntryInGroupInitially: false,
                                embedded: embedded,
                              )),
                    );
                  }
                },
              EditMode(selectedEntryItems: var selectedEntryItems) => () {
                  // Toggles entryItem selected state
                  if (selectedEntryItems.contains(id)) {
                    setState(() {
                      selectedEntryItems.remove(id);
                    });
                  } else {
                    setState(() {
                      selectedEntryItems.add(id);
                    });
                  }
                }
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      );
}
