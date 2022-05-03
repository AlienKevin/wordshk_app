import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wordshk/bridge_generated.dart';
import 'package:wordshk/search_bar.dart';

import 'constants.dart';
import 'custom_page_route.dart';
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
  bool finishedSearch = false;

  @override
  Widget build(BuildContext context) {
    log("building SearchResultsPage.");
    return Scaffold(
        appBar: SearchBar(onChanged: (query) {
          setState(() {
            finishedSearch = false;
          });
        }, onSubmitted: (query) {
          var prSearchFuture =
              api.prSearch(capacity: 10, query: query).then((results) {
            setState(() {
              prSearchResults = results.unique((result) => result.variant);
            });
          }).catchError((_) {
            setState(() {
              prSearchResults.clear();
            });
            return; // it's fine that pr search failed due to user inputting Chinese characters
          });
          var variantSearchFuture =
              api.variantSearch(capacity: 10, query: query).then((results) {
            setState(() {
              variantSearchResults = results.unique((result) => result.variant);
            });
          }).catchError((_) {
            setState(() {
              variantSearchResults.clear();
            });
            return; // impossible: put here just in case variant search fails
          });
          Future.wait([prSearchFuture, variantSearchFuture]).then((_) {
            setState(() {
              finishedSearch = true;
            });
          });
        }),
        body: (finishedSearch &&
                prSearchResults.isEmpty &&
                variantSearchResults.isEmpty)
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                child: Text("No Results Found"))
            : ListView(
                children: showSearchResults(
                    Theme.of(context).textTheme.bodyLarge, widget.searchMode)));
  }

  List<Widget> showSearchResults(textStyle, searchMode) {
    switch (widget.searchMode) {
      case SearchMode.pr:
        return showPrSearchResults(textStyle, searchMode);
      case SearchMode.variant:
        return showVariantSearchResults(textStyle, searchMode);
      case SearchMode.combined:
        return showCombinedSearchResults(textStyle, searchMode);
    }
  }

  List<Widget> showPrSearchResults(TextStyle textStyle, SearchMode searchMode) {
    return prSearchResults.map((result) {
      return showSearchResult(
          result.id,
          TextSpan(
            children: [
              TextSpan(text: result.variant + " ", style: textStyle),
              TextSpan(
                  text: result.pr, style: textStyle.copyWith(color: greyColor)),
            ],
          ),
          searchMode);
    }).toList();
  }

  List<Widget> showVariantSearchResults(
      TextStyle textStyle, SearchMode searchMode) {
    return variantSearchResults.map((result) {
      return showSearchResult(result.id,
          TextSpan(text: result.variant, style: textStyle), searchMode);
    }).toList();
  }

  List<Widget> showCombinedSearchResults(
      TextStyle textStyle, SearchMode searchMode) {
    return showVariantSearchResults(textStyle, searchMode)
        .followedBy(showPrSearchResults(textStyle, searchMode))
        .toList();
  }

  Widget showSearchResult(int id, TextSpan resultText, SearchMode searchMode) {
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
                    CustomPageRoute(
                        builder: (context) => EntryPage(
                              id: id,
                              searchMode: searchMode,
                            )),
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
