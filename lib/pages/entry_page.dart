import 'dart:convert';
import 'dart:developer';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:wordshk/custom_page_route.dart';

import '../main.dart';
import '../models/entry.dart';
import '../smtp_credentials.dart' as smtp;
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
    final script = getScript(context);
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
                  // Check that host is defined
                  if (smtp.host.isNotEmpty) {
                    print("sending bug report email");
                    final smtpServer = SmtpServer(smtp.host,
                        username: smtp.username, password: smtp.password);
                    // Create our message.
                    final message = Message()
                      ..from = Address(smtp.username, 'Wordshk')
                      ..recipients.add(smtp.recipient)
                      ..subject = 'Entry ${widget.id} failed to load';
                    try {
                      send(message, smtpServer).then((sendReport) {
                        print('Message sent: ' + sendReport.toString());
                      });
                    } on MailerException catch (e) {
                      print('Message not sent.');
                      print(e);
                    }
                  }
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
                          child:
                              Text(AppLocalizations.of(context)!.backToSearch))
                    ]),
                  );
                } else {
                  // TODO: handle snapshot.hasError and loading screen
                  return Container();
                }
              },
            )));
  }
}
