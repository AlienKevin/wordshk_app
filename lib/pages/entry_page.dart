import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wordshk/custom_page_route.dart';

import '../main.dart';
import '../models/entry.dart';
import 'entry_not_published_page.dart';

class EntryPage extends StatefulWidget {
  final int id;
  final SearchMode searchMode;

  const EntryPage({Key? key, required this.id, required this.searchMode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  int entryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.entry),
        ),
        body: FutureBuilder(
          future: api.getEntryGroupJson(id: widget.id).then((json) {
            // log("json is ${json.toString()}");
            var entryGroup = json
                .map((entryJson) => Entry.fromJson(jsonDecode(entryJson)))
                .toList();
            return entryGroup;
          }),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return showEntry(context, snapshot.data, entryIndex, (index) {
                setState(() {
                  entryIndex = index;
                });
              }, (entryVariant) {
                log("Tapped on link $entryVariant");
                api.getEntryId(query: entryVariant).then((id) {
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
                          builder: (context) => EntryPage(
                                id: id,
                                searchMode: widget.searchMode,
                              )),
                    );
                  }
                });
              });
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
