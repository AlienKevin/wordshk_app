import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide SearchBar, NavigationDrawer;
import 'package:flutter_core_spotlight/flutter_core_spotlight.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/main.dart';
import 'package:wordshk/models/embedded.dart';
import 'package:wordshk/states/history_state.dart';
import 'package:wordshk/states/input_mode_state.dart';
import 'package:wordshk/widgets/digital_ink_view.dart';
import 'package:wordshk/widgets/search_bar.dart';
import 'package:wordshk/widgets/syllable_pronunciation_button.dart';

import '../bridge_generated.dart';
import '../constants.dart';
import '../custom_page_route.dart';
import '../ffi.dart';
import '../models/input_mode.dart';
import '../models/search_mode.dart';
import '../models/search_result_type.dart';
import '../states/romanization_state.dart';
import '../states/search_mode_state.dart';
import '../states/search_query_state.dart';
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
  List<EgSearchResult> egSearchResults = [];
  String? egSearchQueryNormalized;
  int lastSearchStartTime = 0;
  bool finishedSearch = false;
  bool isSearchResultsEmpty = false;
  bool queryEmptied = true;
  bool showSearchModeSelector = false;
  OverlayEntry? searchModeSelectors;
  // The EntryPage corresponding to the select search result (used in wide screens)
  EntryPage? selectedSearchResultEntryPage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final query = context.read<SearchQueryState>().query;
      if (query.isNotEmpty) {
        queryEmptied = false;
        doSearch(query, context);
      }
      context.read<SearchModeState>().addListener(() {
        final query = context.read<SearchQueryState>().query;
        doSearch(query, context);
      });
      context.read<InputModeState>().setOnDone(
          () => onSearchSubmitted(context.read<SearchQueryState>().query));

      // Spotlight search only available on apple
      if (Platform.isIOS || Platform.isMacOS) {
        // Callback on searchable item selected
        FlutterCoreSpotlight.instance.configure(
          onSearchableItemSelected: (userActivity) {
            if (userActivity == null) {
              if (kDebugMode) {
                print("Spotlight searched returned null");
              }
              return;
            }
            final query =
                userActivity.userInfo!['kCSSearchQueryString'] as String;
            // Ignore the variant index and optional script type (simp/trad) after the "-"
            final entryId =
                int.parse(userActivity.uniqueIdentifier!.split("-")[0]);
            if (kDebugMode) {
              print("Spotlight searched: $query, result entryId: $entryId");
            }
            context.read<HistoryState>().updateItem(entryId);
            Navigator.push(
              context,
              CustomPageRoute(
                  builder: (context) => EntryPage(
                      id: entryId, showFirstEntryInGroupInitially: false)),
            );
          },
        );
      }
    });
  }

  onSearchSubmitted(String query) {
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
        context.read<HistoryState>().updateItem(exactMatchVariant.id);
        Navigator.push(
          context,
          CustomPageRoute(
              builder: (context) => EntryPage(
                  id: exactMatchVariant.id,
                  showFirstEntryInGroupInitially: true)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final InputMode inputMode = context.watch<InputModeState>().mode;

    return KeyboardVisibilityProvider(
        child: Scaffold(
            appBar: SearchBar(
              onChanged: (query) {
                if (query.isEmpty) {
                  setState(() {
                    queryEmptied = true;
                    finishedSearch = false;
                    selectedSearchResultEntryPage = null;
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
                  selectedSearchResultEntryPage = null;
                });
              },
              onSubmitted: onSearchSubmitted,
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
                : SafeArea(
                    child: (finishedSearch && isSearchResultsEmpty)
                        ? showResultsNotFound()
                        : (queryEmptied
                            ? showWatermark()
                            : showSearchResults(
                                selectedSearchResultEntryPage)))));
  }

  Widget showWatermark() {
    double watermarkSize = min(MediaQuery.of(context).size.width * 0.4, 300);
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: appBarHeight * 1.6),
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
                                                  prs: [pr.split(" ")],
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
    setState(() => selectedSearchResultEntryPage = null);
    if (query.isEmpty) {
      setState(() {
        variantSearchResults.clear();
        prSearchResults.clear();
        englishSearchResults.clear();
        egSearchResults.clear();
        egSearchQueryNormalized = null;
        finishedSearch = false;
      });
    } else {
      final searchStartTime = DateTime.now().millisecondsSinceEpoch;
      setState(() {
        finishedSearch = false;
        lastSearchStartTime = searchStartTime;
      });
      final searchMode = context.read<SearchModeState>().mode;
      final script = getScript(context);
      final romanization = context.read<RomanizationState>().romanization;
      switch (searchMode) {
        case SearchMode.pr:
          api
              .prSearch(
                  capacity: 10,
                  query: query,
                  script: script,
                  romanization: romanization)
              .then((results) {
            if (searchStartTime >= lastSearchStartTime) {
              setState(() {
                prSearchResults = results.unique((result) => result.variant);
                isSearchResultsEmpty = prSearchResults.isEmpty;
                finishedSearch = true;
              });
            }
          });
          break;
        case SearchMode.variant:
          api
              .variantSearch(capacity: 10, query: query, script: script)
              .then((results) {
            if (searchStartTime >= lastSearchStartTime) {
              setState(() {
                variantSearchResults =
                    results.unique((result) => result.variant);
                isSearchResultsEmpty = variantSearchResults.isEmpty;
                finishedSearch = true;
              });
            }
          });
          break;
        case SearchMode.combined:
          final combinedResults = api.combinedSearch(
              capacity: 10,
              query: query,
              script: script,
              romanization: romanization);
          combinedResults.then((results) {
            if (searchStartTime >= lastSearchStartTime) {
              final isCombinedResultsEmpty = results.prResults.isEmpty &&
                  results.variantResults.isEmpty &&
                  results.englishResults.isEmpty;
              if (isCombinedResultsEmpty) {
                api
                    .egSearch(
                        capacity: 10,
                        maxFirstIndexInEg: 10,
                        query: query,
                        script: script)
                    .then((result) {
                  if (searchStartTime >= lastSearchStartTime) {
                    final (queryNormalized, results) = result;
                    // print("Query: $query");
                    // print("Result: ${results.map((res) => res.eg)}");
                    if (isSearchResultsEmpty &&
                        query == context.read<SearchQueryState>().query) {
                      setState(() {
                        egSearchResults = results.unique((result) => result.eg);
                        egSearchQueryNormalized = queryNormalized;
                        isSearchResultsEmpty = egSearchResults.isEmpty;
                        finishedSearch = true;
                      });
                    }
                  }
                });
              }
              setState(() {
                isSearchResultsEmpty = isCombinedResultsEmpty;
                egSearchResults.clear();
                egSearchQueryNormalized = null;
                prSearchResults =
                    results.prResults.unique((result) => result.variant);
                variantSearchResults =
                    results.variantResults.unique((result) => result.variant);
                englishSearchResults = results.englishResults;
                if (!isCombinedResultsEmpty) {
                  finishedSearch = true;
                }
              });
            }
          });
          break;
        case SearchMode.english:
          api
              .englishSearch(capacity: 10, query: query, script: script)
              .then((results) {
            if (searchStartTime >= lastSearchStartTime) {
              setState(() {
                englishSearchResults = results;
                finishedSearch = true;
              });
            }
          });
          break;
      }
    }
  }

  Widget showSearchResults(EntryPage? selectedSearchResultEntryPage) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Embedded search results in the right column on wide screens
        final embedded = constraints.maxWidth > wideScreenThreshold
            ? Embedded.embedded
            : Embedded.topLevel;
        final results = showSearchResultsHelper(
            Theme.of(context).textTheme.bodyLarge!,
            context.watch<SearchModeState>().mode,
            embedded);
        final resultList = ListView.separated(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, index) => results[index],
          itemCount: results.length,
        );
        return embedded == Embedded.embedded
            ? Row(
                children: [
                  Expanded(child: resultList),
                  Expanded(
                      flex: 2,
                      child: selectedSearchResultEntryPage != null
                          ? Navigator(
                              key: selectedSearchResultEntryPage.key,
                              onGenerateRoute: (settings) => MaterialPageRoute(
                                  builder: (context) =>
                                      selectedSearchResultEntryPage))
                          : Container()),
                ],
              )
            : resultList;
      },
    );
  }

  List<Widget> showSearchResultsHelper(
      TextStyle textStyle, SearchMode searchMode, Embedded embedded) {
    switch (searchMode) {
      case SearchMode.pr:
        return showPrSearchResults(0, textStyle, embedded);
      case SearchMode.variant:
        return showVariantSearchResults(0, textStyle, embedded);
      case SearchMode.combined:
        return showCombinedSearchResults(0, textStyle, embedded);
      case SearchMode.english:
        return showEnglishSearchResults(0, textStyle, embedded);
    }
  }

  List<Widget> showEnglishSearchResults(
      int startIndex, TextStyle textStyle, Embedded embedded) {
    return englishSearchResults.mapIndexed((index, result) {
      return showSearchResult(
          startIndex + index,
          result.id,
          defIndex: result.defIndex,
          (bool selected) => TextSpan(
                children: [
                  TextSpan(
                      text: "${result.variant} ",
                      style: selected
                          ? textStyle.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary)
                          : textStyle),
                  TextSpan(
                      text: result.pr,
                      style: textStyle.copyWith(
                          color: selected ? lightGreyColor : greyColor)),
                  TextSpan(
                      text: "\n${result.eng}",
                      style: textStyle.copyWith(
                          fontSize:
                              Theme.of(context).textTheme.bodySmall!.fontSize,
                          fontWeight: FontWeight.normal,
                          color: selected ? lightGreyColor : greyColor)),
                ],
              ),
          SearchResultType.english,
          embedded: embedded);
    }).toList();
  }

  List<Widget> showEgSearchResults(
      int startIndex, String queryFound, Embedded embedded) {
    return egSearchResults.mapIndexed((index, result) {
      egs(bool selected) => result.eg
          .split(queryFound)
          .mapIndexed((i, segment) => <InlineSpan>[
                ...(i == 0
                    ? <InlineSpan>[]
                    : [
                        TextSpan(
                            text: queryFound,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: selected
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                        : null))
                      ]),
                TextSpan(
                    text: segment,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: greyColor)),
              ])
          .expand((x) => x)
          .toList();
      return showSearchResult(startIndex + index, result.id,
          (bool selected) => TextSpan(children: egs(selected)),
          SearchResultType.eg,
          maxLines: 1, defIndex: result.defIndex, embedded: embedded);
    }).toList();
  }

  List<Widget> showPrSearchResults(
      int startIndex, TextStyle textStyle, Embedded embedded) {
    return prSearchResults
        .mapIndexed((index, result) => showSearchResult(
              startIndex + index,
              result.id,
              (bool selected) {
                return TextSpan(
                  children: [
                    TextSpan(
                        text: "${result.variant} ",
                        style: textStyle.copyWith(
                            color: selected
                                ? Theme.of(context).colorScheme.onPrimary
                                : null)),
                    TextSpan(
                        text:
                            "${context.read<RomanizationState>().showPrs(result.pr.split(" "))}\n",
                        style: textStyle.copyWith(
                            color: selected ? lightGreyColor : greyColor)),
                    ...showDefSummary(
                        context,
                        (isEngDef(context) ? result.engs : result.yues),
                        textStyle.copyWith(
                            color: selected ? lightGreyColor : greyColor)),
                  ],
                );
              },
              SearchResultType.pr,
              embedded: embedded,
            ))
        .toList();
  }

  List<Widget> showVariantSearchResults(
      int startIndex, TextStyle textStyle, Embedded embedded) {
    return variantSearchResults.mapIndexed((index, result) {
      return showSearchResult(
        startIndex + index,
        result.id,
        showFirstEntryInGroupInitially: false,
        (bool selected) => TextSpan(children: [
          TextSpan(
              text: "${result.variant}\n",
              style: textStyle.copyWith(
                  color: selected
                      ? Theme.of(context).colorScheme.onPrimary
                      : null)),
          ...showDefSummary(
              context,
              (isEngDef(context) ? result.engs : result.yues),
              textStyle.copyWith(color: selected ? lightGreyColor : greyColor)),
        ]),
        SearchResultType.variant,
        embedded: embedded,
      );
    }).toList();
  }

  Widget showSearchResultCategory(String category) => DecoratedBox(
      decoration: BoxDecoration(color: Theme.of(context).dividerColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
        child: Text(category),
      ));

  List<Widget> showCombinedSearchResults(
      int startIndex, TextStyle textStyle, Embedded embedded) {
    final s = AppLocalizations.of(context)!;
    final romanization = context.read<RomanizationState>().romanization;
    final romanizationName = getRomanizationName(romanization, s);
    return [
      ...variantSearchResults.isNotEmpty
          ? [
              showSearchResultCategory(
                  s.searchResults(s.searchResultsCategoryCantonese))
            ]
          : [],
      ...showVariantSearchResults(startIndex, textStyle, embedded),
      ...prSearchResults.isNotEmpty
          ? [showSearchResultCategory(s.searchResults(romanizationName))]
          : [],
      ...showPrSearchResults(
          startIndex + variantSearchResults.length, textStyle, embedded),
      ...englishSearchResults.isNotEmpty
          ? [
              showSearchResultCategory(
                  s.searchResults(s.searchResultsCategoryEnglish))
            ]
          : [],
      ...showEnglishSearchResults(
          startIndex + variantSearchResults.length + prSearchResults.length,
          textStyle,
          embedded),
      ...egSearchResults.isNotEmpty
          ? [
              showSearchResultCategory(
                  s.searchResults(s.searchResultsCategoryExample)),
              ...showEgSearchResults(
                  startIndex +
                      variantSearchResults.length +
                      prSearchResults.length +
                      englishSearchResults.length,
                  egSearchQueryNormalized!,
                  embedded),
            ]
          : [],
    ];
  }

  Widget showSearchResult(
      int index, int id, TextSpan Function(bool selected) resultText,
      SearchResultType resultType,
      {int maxLines = 2,
      int? defIndex,
      bool showFirstEntryInGroupInitially = false,
      Embedded embedded = Embedded.embedded}) {
    final selected = embedded == Embedded.embedded &&
        ValueKey(index) == selectedSearchResultEntryPage?.key!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.zero,
            backgroundColor: selected ? Theme.of(context).primaryColor : null,
            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          onPressed: () {
            context.read<HistoryState>().updateItem(id);
            final entryPage = EntryPage(
              key: ValueKey(index),
              id: id,
              defIndex: defIndex,
              showFirstEntryInGroupInitially: showFirstEntryInGroupInitially,
              embedded: embedded,
            );

            setState(() {
              selectedSearchResultEntryPage = entryPage;
            });
            if (embedded != Embedded.embedded) {
              analyticsState.clickSearchResultType(resultType);
              Navigator.push(
                context,
                CustomPageRoute(builder: (context) => entryPage),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: RichText(
              text: resultText(selected),
              textAlign: TextAlign.start,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
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
