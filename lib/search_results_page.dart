import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wordshk/bridge_generated.dart';
import 'package:wordshk/search_bar.dart';

import 'constants.dart';
import 'custom_page_route.dart';
import 'entry_page.dart';
import 'main.dart';

class SearchResultsPage extends StatefulWidget {
  final SearchMode searchMode;

  const SearchResultsPage({Key? key, required this.searchMode})
      : super(key: key);

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
    final results = showSearchResults(
        Theme.of(context).textTheme.bodyLarge, widget.searchMode);
    return Scaffold(
        appBar: SearchBar(onChanged: (query) {
          setState(() {
            finishedSearch = false;
          });
        }, onSubmitted: (query) {
          api.combinedSearch(capacity: 10, query: query).then((results) {
            setState(() {
              prSearchResults =
                  results.prSearchResults.unique((result) => result.variant);
              variantSearchResults = results.variantSearchResults
                  .unique((result) => result.variant);
              finishedSearch = true;
            });
          });
        }),
        body: (finishedSearch &&
                prSearchResults.isEmpty &&
                variantSearchResults.isEmpty)
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                child: Text(AppLocalizations.of(context)!
                    .searchDictionaryNoResultsFound))
            : ListView.separated(
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) => results[index],
                itemCount: results.length,
              ));
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
    return Builder(
        builder: (BuildContext context) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child:
                        RichText(text: resultText, textAlign: TextAlign.start),
                  ),
                ),
              ],
            ));
  }
}
