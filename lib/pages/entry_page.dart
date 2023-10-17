import 'dart:convert';
import 'dart:developer';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/custom_page_route.dart';
import 'package:wordshk/pages/quality_control_page.dart';
import 'package:wordshk/states/bookmark_state.dart';

import '../ffi.dart';
import '../models/entry.dart';
import '../states/player_state.dart';
import '../utils.dart';
import '../widgets/entry/entry.dart';
import 'entry_not_published_page.dart';

class EntryPage extends StatefulWidget {
  final int id;
  final bool showFirstEntryInGroupInitially;
  final int? defIndex;

  const EntryPage(
      {Key? key,
      required this.id,
      required this.showFirstEntryInGroupInitially,
      this.defIndex})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  late int entryIndex;
  late List<Entry> entryGroup;
  bool hasError = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    () async {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());
      try {
        final json = await api.getEntryGroupJson(id: widget.id);
        setState(() {
          entryGroup = json
              .map((entryJson) => Entry.fromJson(jsonDecode(entryJson)))
              .toList();
          entryIndex = widget.showFirstEntryInGroupInitially
              ? 0
              : entryGroup.indexWhere((entry) => entry.id == widget.id);
          isLoading = false;
        });
      } catch (err) {
        if (kDebugMode) {
          print(err);
        }
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // detect user pressing back button
        onWillPop: () {
          context.read<PlayerState>().refreshPlayerState();
          return Future.value(true);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            actions: [
              Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: !(isLoading ||
                      hasError ||
                      entryGroup[entryIndex].published),
                  child: IconButton(
                      onPressed: () {
                        context.read<PlayerState>().stop();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  icon: Icon(isMaterial(context)
                                      ? Icons.warning_amber_outlined
                                      : CupertinoIcons
                                          .exclamationmark_triangle),
                                  iconColor: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color!,
                                  content: Text(AppLocalizations.of(context)!
                                      .unpublishedWarning),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          CustomPageRoute(
                                              builder: (context) =>
                                                  const QualityControlPage()),
                                        );
                                      },
                                      child: Text(AppLocalizations.of(context)!
                                          .learnMore),
                                    ),
                                    const SizedBox(width: 10),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(AppLocalizations.of(context)!
                                          .dismiss),
                                    ),
                                  ],
                                ));
                      },
                      icon: Icon(isMaterial(context)
                          ? Icons.warning_amber_outlined
                          : CupertinoIcons.exclamationmark_triangle))),
              !(isLoading || hasError)
                  ? Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              context
                                  .read<BookmarkState>()
                                  .toggleBookmark(entryGroup, entryIndex);
                            },
                            icon: context
                                    .watch<BookmarkState>()
                                    .isBookmarked(entryGroup)
                                ? Icon(PlatformIcons(context).bookmarkSolid)
                                : Icon(PlatformIcons(context).bookmarkOutline)),
                        IconButton(
                            onPressed: () {
                              if (kDebugMode) {
                                print(entryGroup[entryIndex].id);
                              }
                              openLink(
                                  "https://words.hk/zidin/v/${entryGroup[entryIndex].id}");
                              context.read<PlayerState>().stop();
                            },
                            icon: Icon(PlatformIcons(context).edit)),
                      ],
                    )
                  : const SizedBox.shrink()
            ],
          ),
          body: showEntry(),
        ));
  }

  void updateEntryIndex(int newIndex) {
    entryIndex = newIndex;
  }

  showEntry() {
    if (hasError) {
      log("Entry page failed to load due to an error.");
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          Text(AppLocalizations.of(context)!.entryFailedToLoad),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                // Back to previous search page
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.backToSearch))
        ]),
      );
    } else if (isLoading) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: EntryWidget(
          entryGroup: entryGroup,
          initialEntryIndex: entryIndex,
          initialDefIndex: widget.defIndex,
          updateEntryIndex: updateEntryIndex,
          onTapLink: (entryVariant) {
            log("Tapped on link $entryVariant");
            api
                .getEntryId(query: entryVariant, script: getScript(context))
                .then((id) {
              context.read<PlayerState>().refreshPlayerState();
              if (id == null) {
                Navigator.push(
                  context,
                  CustomPageRoute(
                      builder: (context) =>
                          EntryNotPublishedPage(entryVariant: entryVariant)),
                );
              } else {
                Navigator.push(
                  context,
                  CustomPageRoute(
                      builder: (context) => EntryPage(
                          id: id, showFirstEntryInGroupInitially: true)),
                );
              }
            });
          },
        ),
      );
    }
  }
}
