import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/states/input_mode_state.dart';
import 'package:wordshk/widgets/digital_ink_view.dart';
import 'package:wordshk/widgets/search_bar.dart';
import 'package:wordshk/widgets/syllable_pronunciation_button.dart';

import '../bridge_generated.dart';
import '../constants.dart';
import '../custom_page_route.dart';
import '../main.dart';
import '../models/input_mode.dart';
import '../models/search_mode.dart';
import '../states/romanization_state.dart';
import '../states/search_mode_state.dart';
import '../states/search_query_state.dart';
import '../states/search_romanization_state.dart';
import '../utils.dart';
import '../widgets/navigation_drawer.dart';
import 'entry_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PrSearchResult> prSearchResults = [];
  List<VariantSearchResult> variantSearchResults = [];
  List<EnglishSearchResult> englishSearchResults = [];
  bool finishedSearch = false;
  bool queryEmptied = true;
  bool showSearchModeSelector = false;
  OverlayEntry? searchModeSelectors;

  @override
  void initState() {
    super.initState();
    final query = context.read<SearchQueryState>().query;
    if (query.isNotEmpty) {
      queryEmptied = false;
      doSearch(query, context);
    }
    context.read<SearchModeState>().addListener(() {
      final query = context.read<SearchQueryState>().query;
      doSearch(query, context);
    });
    context
        .read<InputModeState>()
        .setOnDone(() => onSearchDone(context.read<SearchQueryState>().query));
  }

  onSearchDone(String query) {
    final state = context.read<SearchModeState>();
    if (state.mode == SearchMode.variant || state.mode == SearchMode.combined) {
      // No search results should be produced in other modes
      if (state.mode == SearchMode.combined) {
        if (prSearchResults.isNotEmpty || englishSearchResults.isNotEmpty) {
          return;
        }
      }
      final exactMatchVariant = variantSearchResults
          .firstWhereOrNull((result) => result.variant == query);
      if (exactMatchVariant != null) {
        Navigator.push(
          context,
          CustomPageRoute(
              builder: (context) => EntryPage(id: exactMatchVariant.id)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSearchResultsEmpty;
    final SearchModeState searchMode = context.watch<SearchModeState>();
    switch (searchMode.mode) {
      case SearchMode.pr:
        isSearchResultsEmpty = prSearchResults.isEmpty;
        break;
      case SearchMode.variant:
        isSearchResultsEmpty = variantSearchResults.isEmpty;
        break;
      case SearchMode.combined:
        isSearchResultsEmpty = prSearchResults.isEmpty &&
            variantSearchResults.isEmpty &&
            englishSearchResults.isEmpty;
        break;
      case SearchMode.english:
        isSearchResultsEmpty = englishSearchResults.isEmpty;
        break;
    }
    final InputMode inputMode = context.watch<InputModeState>().mode;

    return KeyboardVisibilityProvider(
        child: Scaffold(
            appBar: SearchBar(
              onChanged: (query) {
                if (query.isEmpty) {
                  setState(() {
                    queryEmptied = true;
                    finishedSearch = false;
                  });
                } else {
                  setState(() {
                    queryEmptied = false;
                    finishedSearch = false;
                  });
                }
                doSearch(query, context);
              },
              onCleared: () {
                setState(() {
                  // TODO: hide search results
                  queryEmptied = true;
                });
              },
              onSubmitted: onSearchDone,
            ),
            drawer: const NavigationDrawer(),
            body: inputMode == InputMode.ink
                ? DigitalInkView(
                    typeCharacter: (character) {
                      context.read<SearchQueryState>().typeCharacter(character);
                    },
                    backspace: () {
                      context.read<SearchQueryState>().backspace();
                    },
                    moveToEndOfSelection: () {
                      context.read<SearchQueryState>().moveToEndOfSelection();
                    },
                  )
                : ((finishedSearch && isSearchResultsEmpty)
                    ? showResultsNotFound()
                    : (queryEmptied ? showWatermark() : showSearchResults()))));
  }

  Widget showWatermark() {
    double watermarkSize = min(MediaQuery.of(context).size.width * 0.6, 300);
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: appBarHeight),
        child: MediaQuery.of(context).platformBrightness == Brightness.light
            ? Image(
                width: watermarkSize,
                image: const AssetImage('assets/icon.png'))
            : Image(
                width: watermarkSize,
                image: const AssetImage('assets/icon_grey.png')),
      ),
    );
  }

  Widget showResultsNotFound() => FutureBuilder<List<String>>(
      future: api.getJyutping(
          query: context
              .watch<SearchQueryState>()
              .query), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) =>
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: snapshot.hasData
                      ? (snapshot.data!.isNotEmpty
                          ? [
                              Text(AppLocalizations.of(context)!
                                  .searchDictionaryOnlyPronunciationFound),
                              RichText(
                                  textScaleFactor:
                                      MediaQuery.of(context).textScaleFactor,
                                  text: TextSpan(
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      children: snapshot.data!
                                          .map((pr) => [
                                                TextSpan(text: pr),
                                                WidgetSpan(
                                                    child:
                                                        SyllablePronunciationButton(
                                                  prs: pr.split(" "),
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  atHeader: true,
                                                ))
                                              ])
                                          .expand((i) => i)
                                          .toList()))
                            ]
                          : [
                              Text(AppLocalizations.of(context)!
                                  .searchDictionaryNoResultsFound)
                            ])
                      : snapshot.hasError
                          ? [const Text("Error loading jyutping data.")]
                          : [])));

  void doSearch(String query, BuildContext context) {
    if (query.isEmpty) {
      setState(() {
        variantSearchResults.clear();
        prSearchResults.clear();
        englishSearchResults.clear();
        finishedSearch = false;
      });
    } else {
      final searchMode = context.read<SearchModeState>().mode;
      final script = getScript(context);
      final searchRomanization =
          context.read<SearchRomanizationState>().romanization;
      switch (searchMode) {
        case SearchMode.pr:
          api
              .prSearch(
                  capacity: 10,
                  query: query,
                  script: script,
                  romanization: searchRomanization)
              .then((results) {
            setState(() {
              prSearchResults = results.unique((result) => result.variant);
              finishedSearch = true;
            });
          });
          break;
        case SearchMode.variant:
          api
              .variantSearch(capacity: 10, query: query, script: script)
              .then((results) {
            setState(() {
              variantSearchResults = results.unique((result) => result.variant);
              finishedSearch = true;
            });
          });
          break;
        case SearchMode.combined:
          api
              .combinedSearch(
                  capacity: 10,
                  query: query,
                  script: script,
                  romanization: searchRomanization)
              .then((results) {
            setState(() {
              prSearchResults =
                  results.prResults.unique((result) => result.variant);
              variantSearchResults =
                  results.variantResults.unique((result) => result.variant);
              englishSearchResults = results.englishResults;
              finishedSearch = true;
            });
          });
          break;
        case SearchMode.english:
          api
              .englishSearch(capacity: 10, query: query, script: script)
              .then((results) {
            setState(() {
              englishSearchResults = results;
              finishedSearch = true;
            });
          });
          break;
      }
    }
  }

  Widget showSearchResults() =>
      Consumer<SearchModeState>(builder: (context, searchModeState, child) {
        final results = showSearchResultsHelper(
            Theme.of(context).textTheme.bodyLarge!, searchModeState.mode);
        return ListView.separated(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, index) => results[index],
          itemCount: results.length,
        );
      });

  List<Widget> showSearchResultsHelper(
      TextStyle textStyle, SearchMode searchMode) {
    switch (searchMode) {
      case SearchMode.pr:
        return showPrSearchResults(textStyle);
      case SearchMode.variant:
        return showVariantSearchResults(textStyle);
      case SearchMode.combined:
        return showCombinedSearchResults(textStyle);
      case SearchMode.english:
        return showEnglishSearchResults(textStyle);
    }
  }

  List<Widget> showEnglishSearchResults(TextStyle textStyle) {
    return englishSearchResults.map((result) {
      return showSearchResult(
          result.id,
          defIndex: result.defIndex,
          TextSpan(
            children: [
              TextSpan(text: result.variant + " ", style: textStyle),
              TextSpan(
                  text: result.pr, style: textStyle.copyWith(color: greyColor)),
              TextSpan(
                  text: "\n" + result.eng,
                  style: textStyle.copyWith(
                      fontWeight: FontWeight.normal, color: greyColor)),
            ],
          ));
    }).toList();
  }

  List<Widget> showPrSearchResults(TextStyle textStyle) {
    return prSearchResults.map((result) {
      return showSearchResult(
          result.id,
          TextSpan(
            children: [
              TextSpan(text: result.variant + " ", style: textStyle),
              TextSpan(
                  text: context.read<RomanizationState>().showPrs(
                      result.pr.split(" "),
                      romanization:
                          context.read<SearchRomanizationState>().romanization),
                  style: textStyle.copyWith(color: greyColor)),
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

  Widget showSearchResultCategory(String category) => DecoratedBox(
      decoration: BoxDecoration(color: Theme.of(context).dividerColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
        child: Text(category),
      ));

  List<Widget> showCombinedSearchResults(TextStyle textStyle) {
    final s = AppLocalizations.of(context)!;
    final searchRomanization =
        context.read<SearchRomanizationState>().romanization;
    final searchRomanizationName = getRomanizationName(searchRomanization, s);
    return [
      ...variantSearchResults.isNotEmpty
          ? [
              showSearchResultCategory(
                  s.searchResults(s.searchResultsCategoryCantonese))
            ]
          : [],
      ...showVariantSearchResults(textStyle),
      ...prSearchResults.isNotEmpty
          ? [showSearchResultCategory(s.searchResults(searchRomanizationName))]
          : [],
      ...showPrSearchResults(textStyle),
      ...englishSearchResults.isNotEmpty
          ? [
              showSearchResultCategory(
                  s.searchResults(s.searchResultsCategoryEnglish))
            ]
          : [],
      ...showEnglishSearchResults(textStyle)
    ];
  }

  Widget showSearchResult(int id, TextSpan resultText, {int? defIndex}) {
    return Column(
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
                  builder: (context) => EntryPage(id: id, defIndex: defIndex)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: RichText(
              text: resultText,
              textAlign: TextAlign.start,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <Id>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}
