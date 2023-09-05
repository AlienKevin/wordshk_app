import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart' hide NavigationDrawer;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/bridge_generated.dart';
import 'package:wordshk/models/entry_language.dart';

import '../custom_page_route.dart';
import '../ffi.dart';
import '../states/bookmark_state.dart';
import '../states/entry_language_state.dart';
import '../utils.dart';
import '../widgets/navigation_drawer.dart';
import 'entry_page.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final _bookmarkSummaries = <EntrySummary>[];
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadMore();
  }

  Future<List<EntrySummary>> _fetchMoreBookmarks(int amount) {
    final allBookmarks = context.read<BookmarkState>().bookmarks;
    if (allBookmarks.length > _bookmarkSummaries.length) {
      final ids = allBookmarks.sublist(_bookmarkSummaries.length,
          min(_bookmarkSummaries.length + amount, allBookmarks.length));
      final script = getScript(context);
      final isEngDef =
          context.read<EntryLanguageState>().language == EntryLanguage.english;
      return api.getEntrySummaries(
        entryIds: Uint32List.fromList(ids),
        script: script,
        isEngDef: isEngDef,
      );
    } else {
      return Future.value([]);
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
      ),
      drawer: const NavigationDrawer(),
      body: Consumer<BookmarkState>(
          builder: (BuildContext context, BookmarkState s, Widget? child) => s
                  .bookmarks.isEmpty
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
                    var summary = _bookmarkSummaries.elementAt(index);
                    return ListTile(
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
                      trailing: IconButton(
                        icon: Icon(PlatformIcons(context).deleteOutline),
                        onPressed: _isLoading
                            ? null
                            : () async {
                                _bookmarkSummaries.removeAt(index);
                                await s.removeBookmark(context
                                    .read<BookmarkState>()
                                    .bookmarks[index]);
                              },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CustomPageRoute(
                              builder: (context) => EntryPage(
                                    id: context
                                        .read<BookmarkState>()
                                        .bookmarks[index],
                                    showFirstEntryInGroupInitially: false,
                                  )),
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                )),
    );
  }
}
