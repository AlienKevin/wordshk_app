import 'dart:convert';
import 'dart:developer';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:wordshk/custom_page_route.dart';

import '../bridge_generated.dart' show Script;
import '../main.dart';
import '../models/entry.dart';
import '../models/language.dart';
import '../states/language_state.dart';
import '../states/player_state.dart';
import '../utils.dart';
import '../widgets/entry/entry.dart';
import 'entry_not_published_page.dart';

class EntryPage extends StatefulWidget {
  final int id;
  final int? defIndex;

  const EntryPage({Key? key, required this.id, this.defIndex})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  int entryIndex = 0;
  late List<Entry> entryGroup;
  late final AutoScrollController scrollController;
  bool scrolledToInitialDef = false;

  @override
  void initState() {
    super.initState();
    scrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
    () async {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());
    }();
  }

  @override
  Widget build(BuildContext context) {
    final script = context.read<LanguageState>().language == Language.zhHansCN
        ? Script.Simplified
        : Script.Traditional;
    return WillPopScope(
        // detect user pressing back button
        onWillPop: () {
          context.read<PlayerState>().refreshPlayerState();
          return Future.value(true);
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.entry),
              actions: [
                IconButton(
                    onPressed: () {
                      openLink(
                          "https://words.hk/zidin/v/${entryGroup[entryIndex].id}");
                      context.read<PlayerState>().stop();
                    },
                    icon: Icon(PlatformIcons(context).edit))
              ],
            ),
            body: FutureBuilder(
              future: api.getEntryGroupJson(id: widget.id).then((json) {
                var newEntryGroup = json
                    .map((entryJson) => Entry.fromJson(jsonDecode(entryJson)))
                    .toList();
                entryGroup = newEntryGroup;
                return newEntryGroup;
              }),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    if (widget.defIndex != null) {
                      await scrollController.scrollToIndex(widget.defIndex!,
                          preferPosition: AutoScrollPosition.begin);
                      scrollController.highlight(widget.defIndex!);
                    }
                  });
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: EntryWidget(
                      entryGroup: snapshot.data,
                      entryIndex: entryIndex,
                      script: script,
                      updateEntryIndex: (index) {
                        if (index != entryIndex) {
                          setState(() {
                            entryIndex = index;
                          });
                          context.read<PlayerState>().stop();
                        }
                      },
                      onTapLink: (entryVariant) {
                        log("Tapped on link $entryVariant");
                        api
                            .getEntryId(query: entryVariant, script: script)
                            .then((id) {
                          context.read<PlayerState>().refreshPlayerState();
                          if (id == null) {
                            Navigator.push(
                              context,
                              CustomPageRoute(
                                  builder: (context) => EntryNotPublishedPage(
                                      entryVariant: entryVariant)),
                            );
                          } else {
                            Navigator.push(
                              context,
                              CustomPageRoute(
                                  builder: (context) => EntryPage(id: id)),
                            );
                          }
                        });
                      },
                      scrollController: scrollController,
                    ),
                  );
                } else if (snapshot.hasError) {
                  log("Entry page failed to load due to an error.");
                  log(snapshot.error.toString());
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Entry failed to load."),
                  );
                } else {
                  // TODO: handle snapshot.hasError and loading screen
                  return Container();
                }
              },
            )));
  }
}
