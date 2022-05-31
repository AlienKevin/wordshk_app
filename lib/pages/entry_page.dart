import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wordshk/custom_page_route.dart';

import '../bridge_generated.dart' show Script;
import '../main.dart';
import '../models/entry.dart';
import '../utils.dart';
import 'entry_not_published_page.dart';

class EntryPage extends StatefulWidget {
  final int id;

  const EntryPage({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  int entryIndex = 0;
  late List<Entry> entryGroup;

  @override
  Widget build(BuildContext context) {
    final script = Localizations.localeOf(context).scriptCode == "Hans"
        ? Script.Simplified
        : Script.Traditional;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.entry),
          actions: [
            IconButton(
                onPressed: () => openLink(
                    "https://words.hk/zidin/v/${entryGroup[entryIndex].id}"),
                icon: const Icon(Icons.edit))
          ],
        ),
        body: FutureBuilder(
          future: api.getEntryGroupJson(id: widget.id).then((json) {
            var newEntryGroup = json
                .map((entryJson) => Entry.fromJson(jsonDecode(entryJson)))
                .toList();
            setState(() {
              entryGroup = newEntryGroup;
            });
            return newEntryGroup;
          }),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: showEntry(context, snapshot.data, entryIndex, script,
                    (index) {
                  setState(() {
                    entryIndex = index;
                  });
                }, (entryVariant) {
                  log("Tapped on link $entryVariant");
                  api
                      .getEntryId(query: entryVariant, script: script)
                      .then((id) {
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
                }),
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
        ));
  }
}
