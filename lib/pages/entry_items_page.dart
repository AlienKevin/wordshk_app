import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart' hide NavigationDrawer;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';
import 'package:wordshk/src/rust/api/api.dart';
import 'package:wordshk/states/language_state.dart';

import '../constants.dart';
import '../models/embedded.dart';
import '../models/summary_def_language.dart';
import '../states/entry_items_state.dart';
import '../utils.dart';
import 'entry_page.dart';

class EntryItemsPage<T extends EntryItemsState> extends StatefulWidget {
  final String emptyMessage;
  final String deletionConfirmationMessage;
  final bool allowEdits;
  const EntryItemsPage({
    Key? key,
    required this.emptyMessage,
    required this.deletionConfirmationMessage,
    required this.allowEdits,
  }) : super(key: key);

  @override
  _EntryItemsState<T> createState() => _EntryItemsState<T>();
}

sealed class Mode {}

class ViewMode extends Mode {}

class EditMode extends Mode {
  HashSet<int> selectedEntryItems;

  EditMode({required this.selectedEntryItems});
}

typedef EntryItemSummaries = ListQueue<(int, EntrySummary)>;

class _EntryItemsState<T extends EntryItemsState>
    extends State<EntryItemsPage<T>> {
  // TODO: find a more scalable data structure for removal or summaries by entryId
  final EntryItemSummaries _entryItemSummaries = EntryItemSummaries();
  late final RemoveItemCallback removeEntryItemListener;
  late final AddItemCallback addEntryItemListener;
  late final LoadedItemsCallback loadedItemsListener;
  bool _isLoading = false;
  bool _hasMore = true;
  Mode _mode = ViewMode();
  // The EntryId corresponding to the select item (used in wide screens)
  int? selectedEntryId;

  @override
  void initState() {
    super.initState();

    loadedItemsListener = _loadMore;
    context.read<T>().registerLoadedItemsListener(loadedItemsListener);

    removeEntryItemListener = (id) {
      setState(() {
        var removeIndex = 0;
        var found = false;
        _entryItemSummaries.removeWhere((item) {
          final itemFound = item.$1 == id;
          found |= itemFound;
          if (!found) {
            removeIndex++;
          }
          return itemFound;
        });
        if (selectedEntryId == id) {
          selectedEntryId = removeIndex < _entryItemSummaries.length
              ? _entryItemSummaries.elementAt(removeIndex).$1
              : null;
        }
      });
    };
    context.read<T>().registerRemoveItemListener(removeEntryItemListener);

    addEntryItemListener = (id) async {
      final summaries = await fetchSummaries([id]);
      assert(summaries.length == 1);
      setState(() {
        _entryItemSummaries.addFirst((id, summaries.first.$2));
      });
    };
    context.read<T>().registerAddItemListener(addEntryItemListener);
  }

  @override
  void activate() {
    super.activate();
    context.read<T>().registerLoadedItemsListener(loadedItemsListener);
    context.read<T>().registerRemoveItemListener(removeEntryItemListener);
    context.read<T>().registerAddItemListener(addEntryItemListener);
  }

  @override
  void deactivate() {
    context.read<T>().unregisterLoadedItemsListener(loadedItemsListener);
    context.read<T>().unregisterRemoveItemListener(removeEntryItemListener);
    context.read<T>().unregisterAddItemListener(addEntryItemListener);
    super.deactivate();
  }

  Future<EntryItemSummaries> fetchSummaries(List<int> ids) {
    return getEntrySummaries(entryIds: Uint32List.fromList(ids)).then(
        (summaries) => EntryItemSummaries.of(
            summaries.indexed.map((item) => (ids[item.$1], item.$2))));
  }

  Future<EntryItemSummaries> _fetchMoreEntryItems(int amount) {
    final allEntryItems = context.read<T>().items;
    if (allEntryItems.length > _entryItemSummaries.length) {
      final ids = allEntryItems.sublist(_entryItemSummaries.length,
          min(_entryItemSummaries.length + amount, allEntryItems.length));
      return fetchSummaries(ids);
    } else {
      return Future.value(EntryItemSummaries());
    }
  }

  _loadMore() {
    if (!_hasMore || _isLoading) {
      return;
    }

    _isLoading = true;
    _fetchMoreEntryItems(10).then((newEntryItems) {
      // Issue: https://kevin-li-f0196b65e.sentry.io/issues/4927414021/events/956194d0a1c0447fb78de8da4ac596e0/?project=4505785578487808
      // ?Fix: Check if the widget is still mounted
      if (!mounted) return;

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
            visible: widget.allowEdits &&
                _entryItemSummaries.isNotEmpty &&
                !isKeyboardVisible,
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
          builder: (BuildContext context, EntryItemsState s, Widget? child) => s
                  .items.isEmpty
              ? Center(child: Text(widget.emptyMessage))
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // Embedded search results in the right column on wide screens
                    final embedded = constraints.maxWidth > wideScreenThreshold
                        ? Embedded.embedded
                        : Embedded.topLevel;
                    // TODO: Fix keyboard automatically unfocused when selectedEntryId is set.
                    //       For now, have to disable default selection.
                    // Select the first item by default
                    // if (selectedEntryId == null && s.items.isNotEmpty) {
                    //   selectedEntryId = s.items.first;
                    // }
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
                            showDialog(
                              useRootNavigator: false,
                              context: context,
                              builder: (_) => AlertDialog(
                                content: ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 200),
                                    child: Text(
                                        widget.deletionConfirmationMessage)),
                                actions: [
                                  TextButton(
                                    child: Text(
                                        AppLocalizations.of(context)!.cancel,
                                        style: TextStyle(
                                            color: MediaQuery.of(context)
                                                        .platformBrightness ==
                                                    Brightness.light
                                                ? null
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary)),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  TextButton(
                                    child: Text(
                                        AppLocalizations.of(context)!.confirm,
                                        style: TextStyle(
                                            color: MediaQuery.of(context)
                                                        .platformBrightness ==
                                                    Brightness.light
                                                ? null
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
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

  List<String> getSummaryDef(List<EntryDef> summaryDefs,
          SummaryDefLanguage summaryDefLanguage, Script script) =>
      switch ((summaryDefLanguage, script)) {
        (SummaryDefLanguage.cantonese, Script.traditional) =>
          summaryDefs.map((def) => def.yueTrad).toList(),
        (SummaryDefLanguage.cantonese, Script.simplified) =>
          summaryDefs.map((def) => def.yueSimp).toList(),
        (SummaryDefLanguage.english, _) =>
          summaryDefs.map((def) => def.eng).toList()
      };

  itemsList(EntryItemsState s, Embedded embedded) => ListView.separated(
        itemCount: _hasMore
            ? _entryItemSummaries.length + 1
            : _entryItemSummaries.length,
        itemBuilder: (context, index) {
          if (index >= _entryItemSummaries.length) {
            _loadMore();
            return const Center(child: CircularProgressIndicator());
          }
          final summaryEntry = _entryItemSummaries.elementAt(index);
          final id = summaryEntry.$1;
          final summary = summaryEntry.$2;
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
              switch (context.watch<LanguageState>().getScript()) {
                Script.traditional => summary.variantTrad,
                Script.simplified => summary.variantSimp,
              },
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text.rich(
              TextSpan(
                  children: showDefSummary(
                      context,
                      getSummaryDef(
                          summary.defs,
                          watchSummaryDefLanguage(context),
                          context.watch<LanguageState>().getScript()),
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
