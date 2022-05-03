import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wordshk/custom_page_route.dart';
import 'package:wordshk/search_results_page.dart';

import 'entry.dart';
import 'entry_not_published_page.dart';
import 'main.dart';

class EntryPage extends StatefulWidget {
  int id;
  SearchMode searchMode;

  EntryPage({Key? key, required this.id, required this.searchMode})
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
          title: const Text('Entry'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: "Search",
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.push(
                  context,
                  CustomPageRoute(
                      builder: (context) =>
                          SearchResultsPage(searchMode: widget.searchMode)),
                );
              },
            ),
          ],
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
                api
                    .variantSearch(capacity: 1, query: entryVariant)
                    .then((results) {
                  if (results.isEmpty) {
                    Navigator.push(
                      context,
                      CustomPageRoute(
                          builder: (context) => EntryNotPublishedPage(
                              entryVariant: entryVariant)),
                    );
                  } else {
                    log(results[0].variant);
                    Navigator.push(
                      context,
                      CustomPageRoute(
                          builder: (context) => EntryPage(
                                id: results[0].id,
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
