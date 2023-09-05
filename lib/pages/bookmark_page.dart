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
import '../states/entry_language_state.dart';
import '../utils.dart';
import '../widgets/navigation_drawer.dart';
import 'entry_page.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

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
                  itemCount: s.bookmarks.length,
                  itemBuilder: (context, index) {
                    var bookmarkedEntryId = s.bookmarks.elementAt(index);

                    return FutureBuilder<EntrySummary>(
                      future: api.getEntrySummary(
                          entryId: bookmarkedEntryId,
                          script: getScript(context),
                          isEngDef:
                              context.read<EntryLanguageState>().language ==
                                  EntryLanguage.english),
                      builder: (BuildContext context,
                          AsyncSnapshot<EntrySummary> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            title:
                                const LinearProgressIndicator(), // Show a loading indicator while waiting
                            trailing: IconButton(
                              icon: Icon(PlatformIcons(context).deleteOutline),
                              onPressed:
                                  null, // Disable the button while fetching
                            ),
                          );
                        } else if (snapshot.hasError) {
                          // TODO: Figure out how to add await before captureMessage
                          Sentry.captureMessage(
                              'bookmark_page.dart failed to getEntrySummary: ${snapshot.error}');
                          return const SizedBox.shrink();
                        } else {
                          return ListTile(
                            title: Text(snapshot.data!.variant),
                            subtitle: Text(
                              snapshot.data!.def,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: Icon(PlatformIcons(context).deleteOutline),
                              onPressed: () async {
                                await s.removeBookmark(bookmarkedEntryId);
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                CustomPageRoute(
                                    builder: (context) => EntryPage(
                                          id: bookmarkedEntryId,
                                          showFirstEntryInGroupInitially: false,
                                        )),
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                )),
    );
  }
}
