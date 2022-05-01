import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wordshk/bridge_generated.dart';

import 'constants.dart';
import 'entry_page.dart';
import 'main.dart';

class SearchResultsPage extends StatelessWidget {
  SearchMode searchMode;
  List<PrSearchResult> prSearchResults;
  List<VariantSearchResult> variantSearchResults;
  SearchResultsPage(
      {Key? key,
      required this.searchMode,
      required this.prSearchResults,
      required this.variantSearchResults})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("building SearchResultsPage.");
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search Results'),
        ),
        body: ListView(
            children:
                showSearchResults(Theme.of(context).textTheme.bodyLarge)));
  }

  List<Expanded> showSearchResults(textStyle) {
    switch (searchMode) {
      case SearchMode.pr:
        return showPrSearchResults(textStyle);
      case SearchMode.variant:
        return showVariantSearchResults(textStyle);
      case SearchMode.combined:
        return showCombinedSearchResults(textStyle);
    }
  }

  List<Expanded> showPrSearchResults(TextStyle textStyle) {
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

  List<Expanded> showVariantSearchResults(TextStyle textStyle) {
    return variantSearchResults.map((result) {
      return showSearchResult(
          result.id, TextSpan(text: result.variant, style: textStyle));
    }).toList();
  }

  List<Expanded> showCombinedSearchResults(TextStyle textStyle) {
    return showVariantSearchResults(textStyle)
        .followedBy(showPrSearchResults(textStyle))
        .toList();
  }

  Expanded showSearchResult(int id, TextSpan resultText) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: lightGreyColor, width: 2))),
        child: Builder(
            builder: (BuildContext context) => TextButton(
                  style: TextButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EntryPage(id: id)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10.0),
                    child:
                        RichText(text: resultText, textAlign: TextAlign.start),
                  ),
                )),
      ),
    );
  }
}
