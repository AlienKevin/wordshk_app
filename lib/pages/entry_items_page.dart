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
  final _entryItemSummaries = <int, EntrySummary>{};
  late final RemoveItemCallback removeEntryItemListener;
  late final AddItemCallback addEntryItemListener;
  bool _isLoading = false;
  bool _hasMore = true;
  Mode _mode = ViewMode();
  // The EntryPage corresponding to the select item (used in wide screens)
  EntryPage? selectedEntryPage;

  @override
  void initState() {
    super.initState();

    removeEntryItemListener = (id) {
      setState(() {
        _entryItemSummaries.remove(id);
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

    return api
        .getEntrySummaries(
          entryIds: Uint32List.fromList(ids),
          script: script,
          isEngDef: isEngDef(context),
        )
        .then((summaries) => LinkedHashMap.fromIterables(ids, summaries));
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
                    return embedded == Embedded.embedded
                        ? Row(
                            children: [
                              Expanded(child: itemsList(s, embedded)),
                              Expanded(
                                  flex: 2,
                                  child: selectedEntryPage != null
                                      ? Navigator(
                                          key: selectedEntryPage!.key,
                                          onGenerateRoute: (settings) =>
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      selectedEntryPage!))
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
                                        if (id == selectedEntryPage?.id) {
                                          setState(() {
                                            selectedEntryPage = null;
                                          });
                                        }
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

  itemsList(EntryItemState s, Embedded embedded) => ListView.separated(
        itemCount: _hasMore
            ? _entryItemSummaries.length + 1
            : _entryItemSummaries.length,
        itemBuilder: (context, index) {
          if (index >= _entryItemSummaries.length) {
            _loadMore();
            return const Center(child: CircularProgressIndicator());
          }
          final id = s.items[index];
          final summary = _entryItemSummaries[id]!;
          final selected = embedded == Embedded.embedded &&
              ValueKey(id) == selectedEntryPage?.key!;
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
                        summary.defs,
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
                  final entryPage = EntryPage(
                    key: ValueKey(id),
                    id: id,
                    showFirstEntryInGroupInitially: false,
                    embedded: embedded,
                  );
                  setState(() {
                    selectedEntryPage = entryPage;
                  });
                  if (embedded != Embedded.embedded) {
                    Navigator.push(
                      context,
                      CustomPageRoute(builder: (context) => entryPage),
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
