import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wordshk/bridge_generated.dart';
import 'package:wordshk/search_bar.dart';

import 'constants.dart';
import 'entry_page.dart';
import 'main.dart';

class SearchResultsPage extends StatefulWidget {
  SearchMode searchMode;

  SearchResultsPage({Key? key, required this.searchMode}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultsPage> {
  List<PrSearchResult> prSearchResults = [];
  List<VariantSearchResult> variantSearchResults = [];

  @override
  Widget build(BuildContext context) {
    log("building SearchResultsPage.");
    return Scaffold(
        appBar: SearchBar(onSubmitted: (query) {
          api.prSearch(capacity: 10, query: query).then((results) {
            setState(() {
              prSearchResults = results.unique((result) => result.variant);
            });
          }).catchError((_) {
            return; // it's fine that pr search failed due to user inputting Chinese characters
          });
          api.variantSearch(capacity: 10, query: query).then((results) {
            setState(() {
              variantSearchResults = results.unique((result) => result.variant);
            });
          }).catchError((_) {
            return; // impossible: put here just in case variant search fails
          });
          log("Going into Search results.");
        }),
        body: ListView(
            children:
                showSearchResults(Theme.of(context).textTheme.bodyLarge)));
  }

  List<Widget> showSearchResults(textStyle) {
    switch (widget.searchMode) {
      case SearchMode.pr:
        return showPrSearchResults(textStyle);
      case SearchMode.variant:
        return showVariantSearchResults(textStyle);
      case SearchMode.combined:
        return showCombinedSearchResults(textStyle);
    }
  }

  List<Widget> showPrSearchResults(TextStyle textStyle) {
    return prSearchResults.map((result) {
      return showSearchResult(
          result.id,
          TextSpan(
            children: [
              TextSpan(text: result.variant + " ", style: textStyle),
              TextSpan(
                  text: result.pr, style: textStyle.copyWith(color: greyColor)),
            ],
          ));
    }).toList();
  }

  List<Widget> showVariantSearchResults(TextStyle textStyle) {
    return variantSearchResults.map((result) {
      return showSearchResult(
          result.id, TextSpan(text: result.variant, style: textStyle));
    }).toList();
  }

  List<Widget> showCombinedSearchResults(TextStyle textStyle) {
    return showVariantSearchResults(textStyle)
        .followedBy(showPrSearchResults(textStyle))
        .toList();
  }

  Widget showSearchResult(int id, TextSpan resultText) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: lightGreyColor, width: 2))),
      child: Builder(
          builder: (BuildContext context) => TextButton(
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EntryPage(id: id)),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10.0),
                  child: RichText(text: resultText, textAlign: TextAlign.start),
                ),
              )),
    );
  }
}
