import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart' hide NavigationDrawer;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';
import 'package:wordshk/src/rust/api/api.dart';
import 'package:wordshk/states/language_state.dart';

import '../constants.dart';
import '../models/embedded.dart';
import '../models/summary_def_language.dart';
import '../states/entry_item_state.dart';
import '../utils.dart';
import 'entry_page.dart';

class EntryItemsPage<T extends EntryItemState> extends StatefulWidget {
  final String emptyMessage;
  final String deletionConfirmationMessage;
  const EntryItemsPage(
      {Key? key,
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
    final script = context.read<LanguageState>().getScript();

    return getEntrySummaries(
      entryIds: Uint32List.fromList(ids),
      script: script,
    ).then((summaries) => LinkedHashMap.fromIterables(ids, summaries));
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
      floatingActionButton: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) => Visibility(
            visible: _entryItemSummaries.isNotEmpty && !isKeyboardVisible,
            child: ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                ),
              ),
              child: Text(
                switch (_mode) {
                  ViewMode() => AppLocalizations.of(context)!.edit,
                  EditMode() => AppLocalizations.of(context)!.done,
                },
              ),
              onPressed: () {
                setState(() {
                  _mode = switch (_mode) {
                    ViewMode() => EditMode(selectedEntryItems: HashSet<int>()),
                    EditMode() => ViewMode(),
                  };
                });
              },
            )),
      ),
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
            child: Center(
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

  getSummaryDef(List<(String, String)> summaryDefs,
          SummaryDefLanguage summaryDefLanguage) =>
      switch (summaryDefLanguage) {
        SummaryDefLanguage.cantonese =>
          summaryDefs.map((pair) => pair.$1).toList(),
        SummaryDefLanguage.english =>
          summaryDefs.map((pair) => pair.$2).toList()
      };

  itemsList(EntryItemState s, Embedded embedded) => ListView.separated(
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
            subtitle: Text.rich(
              TextSpan(
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
            ),
            onTap: switch (_mode) {
              ViewMode() => () {
                  setState(() {
                    selectedEntryId = id;
                  });
                  if (embedded != Embedded.embedded) {
                    context.push(
                        "/entry/id/$id?key=$id&embedded=${embedded.name}");
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
