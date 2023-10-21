import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart' hide NavigationDrawer;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';
import 'package:wordshk/bridge_generated.dart';
import 'package:wordshk/models/entry_language.dart';

import '../custom_page_route.dart';
import '../ffi.dart';
import '../states/bookmark_state.dart';
import '../states/entry_item_state.dart';
import '../states/entry_language_state.dart';
import '../utils.dart';
import '../widgets/navigation_drawer.dart';
import 'entry_page.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

sealed class Mode {}

class ViewMode extends Mode {}

class EditMode extends Mode {
  HashSet<int> selectedBookmarks;

  EditMode({required this.selectedBookmarks});
}

class _BookmarkPageState extends State<BookmarkPage> {
  final _bookmarkSummaries = <int, EntrySummary>{};
  late final RemoveItemCallback removeBookmarkListener;
  late final AddItemCallback addBookmarkListener;
  bool _isLoading = false;
  bool _hasMore = true;
  Mode _mode = ViewMode();

  @override
  void initState() {
    super.initState();

    removeBookmarkListener = (id) {
      setState(() {
        _bookmarkSummaries.remove(id);
      });
    };
    context
        .read<BookmarkState>()
        .registerRemoveItemListener(removeBookmarkListener);

    addBookmarkListener = (id) async {
      final summaries = await fetchSummaries([id]);
      setState(() {
        _bookmarkSummaries.addAll(summaries);
      });
    };
    context.read<BookmarkState>().registerAddItemListener(addBookmarkListener);

    _loadMore();
  }

  @override
  void activate() {
    super.activate();
    context
        .read<BookmarkState>()
        .registerRemoveItemListener(removeBookmarkListener);
    context
        .read<BookmarkState>()
        .registerAddItemListener(addBookmarkListener);
  }

  @override
  void deactivate() {
    context
        .read<BookmarkState>()
        .unregisterRemoveItemListener(removeBookmarkListener);
    context
        .read<BookmarkState>()
        .unregisterAddItemListener(addBookmarkListener);
    super.deactivate();
  }

  Future<LinkedHashMap<int, EntrySummary>> fetchSummaries(List<int> ids) {
    final script = getScript(context);
    final isEngDef =
        context.read<EntryLanguageState>().language == EntryLanguage.english;
    return api
        .getEntrySummaries(
          entryIds: Uint32List.fromList(ids),
          script: script,
          isEngDef: isEngDef,
        )
        .then((summaries) => LinkedHashMap.fromIterables(ids, summaries));
  }

  Future<LinkedHashMap<int, EntrySummary>> _fetchMoreBookmarks(int amount) {
    final allBookmarks = context.read<BookmarkState>().items;
    if (allBookmarks.length > _bookmarkSummaries.length) {
      final ids = allBookmarks.sublist(_bookmarkSummaries.length,
          min(_bookmarkSummaries.length + amount, allBookmarks.length));
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
    _fetchMoreBookmarks(10).then((newBookmarks) {
      if (newBookmarks.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _bookmarkSummaries.addAll(newBookmarks);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.bookmarks),
        actions: _bookmarkSummaries.isEmpty
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
                          EditMode(selectedBookmarks: HashSet<int>()),
                        EditMode() => ViewMode(),
                      };
                    });
                  },
                ),
              ],
      ),
      drawer: const NavigationDrawer(),
      body: Consumer<BookmarkState>(
          builder: (BuildContext context, BookmarkState s, Widget? child) => s
                  .items.isEmpty
              ? Center(child: Text(AppLocalizations.of(context)!.noBookmarks))
              : ListView.separated(
                  itemCount: _hasMore
                      ? _bookmarkSummaries.length + 1
                      : _bookmarkSummaries.length,
                  itemBuilder: (context, index) {
                    if (index >= _bookmarkSummaries.length) {
                      _loadMore();
                      return const Center(child: CircularProgressIndicator());
                    }
                    final id = s.items[index];
                    final summary = _bookmarkSummaries[id]!;
                    return ListTile(
                      leading: switch (_mode) {
                        ViewMode() => null,
                        EditMode(selectedBookmarks: var selectedBookmarks) =>
                          Checkbox(
                            value: selectedBookmarks.contains(id),
                            visualDensity: VisualDensity.compact,
                            onChanged: (value) {
                              if (value!) {
                                setState(() {
                                  selectedBookmarks.add(id);
                                });
                              } else {
                                setState(() {
                                  selectedBookmarks.remove(id);
                                });
                              }
                            },
                          )
                      },
                      title: Text(
                        summary.variant,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        summary.def,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: switch (_mode) {
                        ViewMode() => () {
                            Navigator.push(
                              context,
                              CustomPageRoute(
                                  builder: (context) => EntryPage(
                                        id: id,
                                        showFirstEntryInGroupInitially: false,
                                      )),
                            );
                          },
                        EditMode(selectedBookmarks: var selectedBookmarks) =>
                          () {
                            // Toggles bookmark selected state
                            if (selectedBookmarks.contains(id)) {
                              setState(() {
                                selectedBookmarks.remove(id);
                              });
                            } else {
                              setState(() {
                                selectedBookmarks.add(id);
                              });
                            }
                          }
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                )),
      bottomNavigationBar: switch (_mode) {
        EditMode(selectedBookmarks: var selectedBookmarks)
            when _bookmarkSummaries.isNotEmpty =>
          BottomAppBar(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: Theme.of(context)
                    .elevatedButtonTheme
                    .style!
                    .textStyle!
                    .resolve({})!.fontSize! *
                4,
            child: Row(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                  onPressed: selectedBookmarks.isEmpty
                      ? null
                      : () {
                          showPlatformDialog(
                            context: context,
                            builder: (_) => PlatformAlertDialog(
                              title: Text(AppLocalizations.of(context)!
                                  .bookmarkDeleteConfirmation),
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
                                    for (final id in selectedBookmarks) {
                                      context
                                          .read<BookmarkState>()
                                          .removeItem(id);
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                  child: Text(AppLocalizations.of(context)!.delete),
                ),
                const Spacer(),
                ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                    onPressed: () async {
                      final allBookmarks = context.read<BookmarkState>().items;
                      switch (_mode) {
                        case ViewMode():
                          {
                            await Sentry.captureMessage(
                                'bookmark_page: All button pressed in ViewMode even though it should only be present in EditMode.');
                            break;
                          }
                        case EditMode(selectedBookmarks: var selectedBookmarks):
                          if (selectedBookmarks.length <
                              allBookmarks.length) {
                            setState(() {
                              selectedBookmarks.addAll(allBookmarks);
                            });
                          } else {
                            setState(() {
                              selectedBookmarks.clear();
                            });
                          }
                          break;
                      }
                    },
                    child: (() {
                      final textStyle = DefaultTextStyle.of(context).style;
                      final maxWidth = getMaxWidthForTexts(
                        AppLocalizations.of(context)!.all,
                        AppLocalizations.of(context)!.none,
                        textStyle,
                      );
                      return SizedBox(
                        width: maxWidth,
                        child: Text(
                          selectedBookmarks.length < _bookmarkSummaries.length
                              ? AppLocalizations.of(context)!.all
                              : AppLocalizations.of(context)!.none,
                          textAlign: TextAlign.center,
                        ),
                      );
                    })()),
              ],
            ),
          ),
        _ => null,
      },
    );
  }
}

double getMaxWidthForTexts(String text1, String text2, TextStyle style) {
  final textPainter1 = TextPainter(
    text: TextSpan(text: text1, style: style),
    textDirection: TextDirection.ltr,
  );

  final textPainter2 = TextPainter(
    text: TextSpan(text: text2, style: style),
    textDirection: TextDirection.ltr,
  );

  textPainter1.layout();
  textPainter2.layout();

  return [textPainter1.width, textPainter2.width]
          .reduce((a, b) => a > b ? a : b) *
      0.5;
}
