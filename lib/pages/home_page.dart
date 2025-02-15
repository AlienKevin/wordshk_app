import 'dart:io';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide SearchBar, NavigationDrawer;
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:wordshk/models/embedded.dart';
import 'package:wordshk/models/search_bar_position.dart';
import 'package:wordshk/pages/sensitive_content_filter.dart';
import 'package:wordshk/src/rust/api/api.dart';
import 'package:wordshk/states/auto_paste_search_state.dart';
import 'package:wordshk/states/history_state.dart';
import 'package:wordshk/states/input_mode_state.dart';
import 'package:wordshk/states/search_bar_position_state.dart';
import 'package:wordshk/widgets/digital_ink_view.dart';
import 'package:wordshk/widgets/search_bar.dart';

import '../constants.dart';
import '../main.dart';
import '../models/input_mode.dart';
import '../models/search_result_type.dart';
import '../models/summary_def_language.dart';
import '../states/bookmark_state.dart';
import '../states/language_state.dart';
import '../states/romanization_state.dart';
import '../states/search_query_state.dart';
import '../utils.dart';
import 'entry_items_page.dart';
import 'entry_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<PrSearchResult> prSearchResults = [];
  List<VariantSearchResult> variantSearchResults = [];
  List<MandarinVariantSearchResult> mandarinVariantSearchResults = [];
  List<EnglishSearchResult> englishSearchResults = [];
  List<SearchResultType> searchResultOrder = [];
  List<EgSearchResult> egSearchResults = [];
  int lastSearchStartTime = 0;
  bool finishedSearch = false;
  bool isSearchResultsEmpty = false;
  bool queryEmptied = true;
  // The EntryPage corresponding to the select search result (used in wide screens)
  EntryPage? selectedSearchResultEntryPage;
  late final TabController _historyAndBookmarksTabController;
  String? previousClipboardText;
  late TabController _searchResultTabController;
  late final ScrollController _searchResultScrollController;
  late final ListObserverController _observerController;
  bool _isScrollingToSearchResult = false;
  int? searchResultGroupIndex;

  @override
  void initState() {
    super.initState();

    _historyAndBookmarksTabController =
        TabController(vsync: this, initialIndex: 0, length: 2);

    _searchResultTabController = TabController(
      vsync: this,
      length: 0,
      initialIndex: 0,
    );
    _searchResultScrollController = ScrollController();
    _observerController =
        ListObserverController(controller: _searchResultScrollController)
          ..initialIndexModel = ObserverIndexPositionModel(
            index: 0,
          );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AutoPasteSearchState>().autoPasteSearch) {
        autoPasteSearch();
      }

      final query = context.read<SearchQueryState>().query;
      if (query.isNotEmpty) {
        queryEmptied = false;
        doSearch(query, context);
      }
      context.read<InputModeState>().setOnDone(() {
        onSearchSubmitted(
            context.read<SearchQueryState>().query, getEmbedded());
      });
    });
  }

  onSearchSubmitted(String query, Embedded embedded) {
    if (query.isEmpty) {
      return;
    }

    if (prSearchResults.isNotEmpty || englishSearchResults.isNotEmpty) {
      return;
    }
    final exactMatchVariant = variantSearchResults.indexed.firstWhereOrNull(
        (item) =>
            item.$2.matchedVariant.prefix.isEmpty &&
            item.$2.matchedVariant.suffix.isEmpty);
    if (exactMatchVariant != null) {
      final (index, variant) = exactMatchVariant;
      context.read<HistoryState>().addItem(variant.id);
      if (embedded != Embedded.embedded) {
        context.push("/entry/id/${variant.id}");
      } else {
        setState(() {
          selectedSearchResultEntryPage = EntryPage(
              key: ValueKey(index),
              id: variant.id,
              showFirstEntryInGroupInitially: false);
        });
      }
    }
  }

  autoPasteSearch() {
    Clipboard.getData("text/plain").then((value) {
      if (kDebugMode) {
        debugPrint("Clipboard text: ${value?.text}");
      }
      if (value != null && value.text != null) {
        final text = value.text!.replaceAll('\n', '');
        final tokenCounts = countTokens(text);
        if (tokenCounts.total < 12 &&
            tokenCounts.english <= 5 &&
            text.characters.length <= 30) {
          if (kDebugMode) {
            debugPrint(
                "Replacing query text: ${context.read<SearchQueryState>().query}");
          }
          context.read<SearchQueryState>().clear();
          context.read<SearchQueryState>().typeString(text);
        } else if (Platform.isIOS && text != previousClipboardText) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.textTooLongNotPasted),
            duration: const Duration(seconds: 2),
          ));
        }
        previousClipboardText = text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final InputMode inputMode = context.watch<InputModeState>().mode;
    final searchBar = SearchBar(
      key: const Key("homePageSearchBar"),
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
          queryEmptied = true;
          selectedSearchResultEntryPage = null;
        });
        _clearSearchResults();
      },
      onSubmitted: (query) {
        onSearchSubmitted(query, getEmbedded());
      },
    );

    return FGBGNotifier(
      onEvent: (FGBGType value) async {
        if (value == FGBGType.foreground &&
            context.read<AutoPasteSearchState>().autoPasteSearch) {
          debugPrint("App is in the foreground");
          // Your app cannot access clipboard data on Android 10 or higher unless it currently has focus.
          // So we have to wait until the widget is rendered to access the clipboard data.
          // https://stackoverflow.com/questions/65465361/null-from-clipboard
          // https://developer.android.com/about/versions/10/privacy/changes#clipboard-data
          WidgetsBinding.instance.addPostFrameCallback((_) {
            autoPasteSearch();
          });
        }
      },
      child: KeyboardVisibilityProvider(
        child: Scaffold(
          bottomNavigationBar:
              Column(mainAxisSize: MainAxisSize.min, children: [
            ...context.watch<SearchBarPositionState>().getSearchBarPosition() ==
                    SearchBarPosition.bottom
                ? [
                    Container(
                      color: Theme.of(context).appBarTheme.backgroundColor ??
                          Theme.of(context).colorScheme.surface,
                      width: double.maxFinite,
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 14, right: 10, top: 10, bottom: 10),
                          child: searchBar),
                    )
                  ]
                : [],
            ...inputMode == InputMode.ink
                ? [
                    DigitalInkView(
                      typeCharacter: (character) {
                        context.read<SearchQueryState>().typeString(character);
                      },
                      backspace: () {
                        context.read<SearchQueryState>().backspace();
                      },
                      moveToEndOfSelection: () {
                        context.read<SearchQueryState>().moveToEndOfSelection();
                      },
                    ),
                  ]
                : [],
          ]),
          appBar:
              context.watch<SearchBarPositionState>().getSearchBarPosition() ==
                      SearchBarPosition.top
                  ? AppBar(
                      title: searchBar,
                      toolbarHeight:
                          context.watch<RomanizationState>().romanization ==
                                  Romanization.yale
                              ? 110
                              : appBarHeight,
                    )
                  : null,
          body: SafeArea(
              child: (finishedSearch && isSearchResultsEmpty)
                  ? showResultsNotFound()
                  : (queryEmptied
                      ? showHistoryAndBookmarks()
                      : showSearchResults(selectedSearchResultEntryPage))),
        ),
      ),
    );
  }

  Widget showHistoryAndBookmarks() {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
              controller: _historyAndBookmarksTabController,
              children: [
                EntryItemsPage<HistoryState>(
                  emptyMessage: AppLocalizations.of(context)!.noHistory,
                  deletionConfirmationMessage:
                      AppLocalizations.of(context)!.historyDeleteConfirmation,
                  allowEdits: false,
                ),
                EntryItemsPage<BookmarkState>(
                  emptyMessage: AppLocalizations.of(context)!.noBookmarks,
                  deletionConfirmationMessage:
                      AppLocalizations.of(context)!.bookmarkDeleteConfirmation,
                  allowEdits: true,
                )
              ]),
        ),
        TabBar(
          controller: _historyAndBookmarksTabController,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.history),
            Tab(text: AppLocalizations.of(context)!.bookmarks),
          ],
          labelColor: Theme.of(context).textTheme.bodyMedium!.color!,
          unselectedLabelColor: Theme.of(context).textTheme.bodyMedium!.color!,
          indicator: BubbleTabIndicator(
            indicatorHeight:
                Theme.of(context).textTheme.bodyMedium!.fontSize! * 1.5,
            indicatorColor: Theme.of(context).splashColor,
            tabBarIndicatorSize: TabBarIndicatorSize.label,
          ),
        ),
      ],
    );
  }

  Widget showResultsNotFound() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(AppLocalizations.of(context)!.searchDictionaryNoResultsFound)
      ]));

  void _clearSearchResults() {
    setState(() {
      variantSearchResults.clear();
      mandarinVariantSearchResults.clear();
      prSearchResults.clear();
      englishSearchResults.clear();
      egSearchResults.clear();
      finishedSearch = false;
    });
  }

  void doSearch(String query, BuildContext context) {
    if (!context.mounted) return;

    setState(() => selectedSearchResultEntryPage = null);
    if (query.isEmpty) {
      _clearSearchResults();
    } else {
      final searchStartTime = DateTime.now().millisecondsSinceEpoch;
      setState(() {
        finishedSearch = false;
        lastSearchStartTime = searchStartTime;
      });
      final script = context.read<LanguageState>().getScript();
      final romanization = context.read<RomanizationState>().romanization;

      combinedSearch(
              capacity: 100,
              query: query,
              script: script,
              romanization: romanization)
          .then((results) {
        if (!context.mounted) return;
        if (searchStartTime >= lastSearchStartTime) {
          if (appFlavor == "huawei") {
            // Hide sensitive results
            final filteredPrResults = (
              results.prResults.$1,
              results.prResults.$2
                  .where((result) => !containsSensitiveContent(
                      "${result.variants.join(" ")} ${result.yues.join(" ")}"))
                  .toList()
            );
            final filteredVariantResults = (
              results.variantResults.$1,
              results.variantResults.$2
                  .where((result) => !containsSensitiveContent(
                      "${result.matchedVariant.prefix}${result.matchedVariant.query}${result.matchedVariant.suffix} ${result.yues.join(" ")}"))
                  .toList()
            );
            final filteredMandarinVariantResults = (
              results.mandarinVariantResults.$1,
              results.mandarinVariantResults.$2
                  .where((result) => !containsSensitiveContent(
                      "${result.variant} ${result.yue}"))
                  .toList()
            );
            final filteredEnglishResults = (
              results.englishResults.$1,
              results.englishResults.$2
                  .where((result) =>
                      !containsSensitiveContent(result.variants.join(" ")))
                  .toList()
            );
            final filteredEgResults = (
              results.egResults.$1,
              results.egResults.$2
                  .where((result) => !containsSensitiveContent(
                      "${result.matchedEg.prefix}${result.matchedEg.query}${result.matchedEg.suffix}"))
                  .toList()
            );
            results = CombinedSearchResults(
              prResults: filteredPrResults,
              variantResults: filteredVariantResults,
              mandarinVariantResults: filteredMandarinVariantResults,
              englishResults: filteredEnglishResults,
              egResults: filteredEgResults,
            );
          }

          final isCombinedResultsEmpty = results.prResults.$2.isEmpty &&
              results.variantResults.$2.isEmpty &&
              results.mandarinVariantResults.$2.isEmpty &&
              results.englishResults.$2.isEmpty &&
              results.egResults.$2.isEmpty;

          setState(() {
            isSearchResultsEmpty = isCombinedResultsEmpty;
            prSearchResults = results.prResults.$2;
            variantSearchResults = results.variantResults.$2;
            mandarinVariantSearchResults = results.mandarinVariantResults.$2;
            englishSearchResults = results.englishResults.$2;
            egSearchResults = results.egResults.$2;

            // Higher priority = higher number
            getSearchResultTypePriority(SearchResultType type) =>
                switch (type) {
                  SearchResultType.variant => results.variantResults.$1!,
                  SearchResultType.mandarinVariant =>
                    results.mandarinVariantResults.$1!,
                  SearchResultType.pr => results.prResults.$1!,
                  SearchResultType.english => results.englishResults.$1!,
                  SearchResultType.eg => results.egResults.$1!,
                };
            searchResultOrder = [
              if (variantSearchResults.isNotEmpty) SearchResultType.variant,
              if (mandarinVariantSearchResults.isNotEmpty)
                SearchResultType.mandarinVariant,
              if (prSearchResults.isNotEmpty) SearchResultType.pr,
              if (englishSearchResults.isNotEmpty) SearchResultType.english,
              if (egSearchResults.isNotEmpty) SearchResultType.eg,
            ].sorted((a, b) => getSearchResultTypePriority(b)
                .compareTo(getSearchResultTypePriority(a)));

            finishedSearch = true;
          });
        }
      });
    }
  }

  Widget showSearchResults(EntryPage? selectedSearchResultEntryPage) {
    // Embedded search results in the right column on wide screens
    final embedded = getEmbedded();
    final results = showCombinedSearchResults(
        Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.normal),
        embedded);
    if (results.length != _searchResultTabController.length) {
      setState(() {
        _searchResultTabController.dispose();
        _searchResultTabController = TabController(
          vsync: this,
          length: results.length,
          initialIndex: 0,
        );
      });
    }

    final resultList = Column(children: [
      Expanded(
        child: ListViewObserver(
            controller: _observerController,
            autoTriggerObserveTypes: const [
              ObserverAutoTriggerObserveType.scrollUpdate,
            ],
            triggerOnObserveType: ObserverTriggerOnObserveType.directly,
            onObserve: (resultModel) {
              if (!_isScrollingToSearchResult &&
                  resultModel.displayingChildModelList.isNotEmpty) {
                final focusedChild = resultModel.displayingChildModelList
                    .reduce((a, b) =>
                        a.displayPercentage >= b.displayPercentage ? a : b);
                setState(() {
                  _searchResultTabController.animateTo(focusedChild.index);
                });
              }
            },
            child: ListView.builder(
              controller: _searchResultScrollController,
              shrinkWrap: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemBuilder: (_, index) => results[index].$2,
              itemCount: results.length,
            )),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Material(
          elevation: 2,
          child: TabBar(
            controller: _searchResultTabController,
            onTap: (newIndex) async {
              if (newIndex != searchResultGroupIndex) {
                setState(() {
                  searchResultGroupIndex = newIndex;
                  _isScrollingToSearchResult = true;
                });
                await _observerController.jumpTo(
                  index: newIndex,
                );
                setState(() {
                  _isScrollingToSearchResult = false;
                });
              }
            },
            isScrollable: true,
            labelColor: Theme.of(context).textTheme.bodyMedium!.color,
            unselectedLabelColor: Theme.of(context).textTheme.bodyMedium!.color,
            // Other tabs color
            labelPadding: const EdgeInsets.symmetric(horizontal: 30),
            // Space between tabs
            indicator: BubbleTabIndicator(
              indicatorHeight:
                  Theme.of(context).textTheme.bodyMedium!.fontSize! * 1.5,
              indicatorColor: Theme.of(context).splashColor,
              tabBarIndicatorSize: TabBarIndicatorSize.label,
            ),
            tabAlignment: TabAlignment.start,
            padding: const EdgeInsets.symmetric(vertical: 6),
            tabs: results
                .map((result) => Tab(
                    text: getSearchResultTypeName(
                        result.$1, context, AppLocalizations.of(context)!)))
                .toList(),
          ),
        ),
      ),
    ]);
    return embedded == Embedded.embedded
        ? Row(
            children: [
              Expanded(child: resultList),
              const VerticalDivider(
                width: 1,
                thickness: 1,
              ),
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
                  WidgetSpan(
                    child: Text.rich(
                      TextSpan(
                        children: result.variants.indexed
                            .expand((variant) => [
                                  TextSpan(
                                    text: (variant.$1 == 0 ? "" : " ") +
                                        variant.$2.$1,
                                    style: selected
                                        ? textStyle.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary)
                                        : textStyle,
                                  ),
                                  TextSpan(text: " "),
                                  TextSpan(
                                      text: variant.$2.$2,
                                      style: textStyle.copyWith(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .fontSize,
                                          color: selected
                                              ? lightGreyColor
                                              : greyColor)),
                                ])
                            .toList(),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const TextSpan(text: "\n"),
                  ...result.matchedEng.map((segment) => TextSpan(
                      text: segment.segment,
                      style: textStyle.copyWith(
                        fontSize:
                            Theme.of(context).textTheme.bodySmall!.fontSize,
                        color: selected
                            ? lightGreyColor
                            : (segment.matched
                                ? Theme.of(context).colorScheme.primary
                                : greyColor),
                        fontWeight: segment.matched ? FontWeight.w600 : null,
                      )))
                ],
              ),
          SearchResultType.english,
          embedded: embedded);
    }).toList();
  }

  List<Widget> showEgSearchResults(int startIndex, Embedded embedded) {
    return egSearchResults.mapIndexed((index, result) {
      egs(bool selected) => [
            TextSpan(
                text: result.matchedEg.prefix.characters.length > 10
                    ? '…${result.matchedEg.prefix.characters.takeLast(10).string}'
                    : result.matchedEg.prefix,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: selected ? lightGreyColor : greyColor)),
            TextSpan(
                text: result.matchedEg.query,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: selected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.primary)),
            TextSpan(
                text: result.matchedEg.suffix,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: selected ? lightGreyColor : greyColor)),
          ];
      return showSearchResult(
          startIndex + index,
          result.id,
          (bool selected) => TextSpan(children: egs(selected)),
          SearchResultType.eg,
          maxLines: 1,
          defIndex: result.defIndex,
          egIndex: result.egIndex,
          embedded: embedded);
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
                    WidgetSpan(
                        child: Text.rich(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            TextSpan(children: [
                              TextSpan(
                                  text: "${result.variants.join(" / ")} ",
                                  style: textStyle.copyWith(
                                      color: selected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onPrimary
                                          : null)),
                              ...result.matchedPr
                                  .map((segment) => segment.segment.characters
                                      .map((c) => MatchedSegment(
                                          segment: c,
                                          matched: segment.matched)))
                                  .expand((x) => x)
                                  .map((segment) => TextSpan(
                                      text: segment.segment,
                                      style: textStyle.copyWith(
                                        color: selected
                                            ? lightGreyColor
                                            : ((segment.matched ||
                                                    segment.segment ==
                                                        "\u{0301}" ||
                                                    segment.segment ==
                                                        "\u{0300}" ||
                                                    segment.segment ==
                                                        "\u{0304}")
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : greyColor),
                                        // Workaround for accent marks not displayed
                                        // in correct position when font weights don't match
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .fontSize,
                                        fontWeight: (segment.matched ||
                                                segment.segment == "\u{0301}" ||
                                                segment.segment == "\u{0300}" ||
                                                segment.segment == "\u{0304}")
                                            ? FontWeight.w600
                                            : null,
                                      )))
                            ]))),
                    TextSpan(text: "\n"),
                    ...showDefSummary(
                        context,
                        switch (watchSummaryDefLanguage(context)) {
                          SummaryDefLanguage.english => result.engs,
                          SummaryDefLanguage.cantonese => result.yues
                        },
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
          WidgetSpan(
              child: Text.rich(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  TextSpan(children: [
                    TextSpan(
                        text: result.matchedVariant.prefix,
                        style: textStyle.copyWith(
                            color: selected
                                ? Theme.of(context).colorScheme.onPrimary
                                : null)),
                    TextSpan(
                        text: result.matchedVariant.query,
                        style: textStyle.copyWith(
                            color: selected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: result.matchedVariant.suffix,
                        style: textStyle.copyWith(
                            color: selected
                                ? Theme.of(context).colorScheme.onPrimary
                                : null)),
                    TextSpan(
                        text: " ${result.prs.join(", ")}",
                        style: textStyle.copyWith(
                          color: selected ? lightGreyColor : greyColor,
                          // Workaround for accent marks not displayed
                          // in correct position when font weights don't match
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                        ))
                  ]))),
          TextSpan(text: "\n"),
          ...showDefSummary(
              context,
              switch (watchSummaryDefLanguage(context)) {
                SummaryDefLanguage.english => result.engs,
                SummaryDefLanguage.cantonese => result.yues
              },
              textStyle.copyWith(color: selected ? lightGreyColor : greyColor)),
        ]),
        SearchResultType.variant,
        embedded: embedded,
      );
    }).toList();
  }

  List<Widget> showMandarinVariantSearchResults(
      int startIndex, TextStyle textStyle, Embedded embedded) {
    return mandarinVariantSearchResults.map((result) {
      return showSearchResult(
          startIndex + mandarinVariantSearchResults.indexOf(result),
          result.id,
          (bool selected) => TextSpan(children: [
                WidgetSpan(
                    child: Text.rich(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        TextSpan(children: [
                          TextSpan(
                              text: result.matchedMandarinVariant.prefix,
                              style: textStyle.copyWith(
                                  color: selected
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : null)),
                          TextSpan(
                              text: result.matchedMandarinVariant.query,
                              style: textStyle.copyWith(
                                  color: selected
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600)),
                          TextSpan(
                              text: result.matchedMandarinVariant.suffix,
                              style: textStyle.copyWith(
                                  color: selected
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : null)),
                          TextSpan(
                              text: " ${result.variant}",
                              style: textStyle.copyWith(
                                color: selected ? lightGreyColor : greyColor,
                              )),
                          TextSpan(
                              text: " ${result.prs.join(", ")} ",
                              style: textStyle.copyWith(
                                color: selected ? lightGreyColor : greyColor,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .fontSize,
                              )),
                        ]))),
                TextSpan(text: "\n"),
                ...showDefSummary(
                    context,
                    switch (watchSummaryDefLanguage(context)) {
                      SummaryDefLanguage.english => [result.eng],
                      SummaryDefLanguage.cantonese => [result.yue]
                    },
                    textStyle.copyWith(
                        color: selected ? lightGreyColor : greyColor)),
              ]),
          SearchResultType.mandarinVariant,
          embedded: embedded);
    }).toList();
  }

  Widget showSearchResultCategory(String category) => Row(
        children: [
          Expanded(
            child: DecoratedBox(
                decoration:
                    BoxDecoration(color: Theme.of(context).dividerColor),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                  child: Text(category),
                )),
          )
        ],
      );

  List<Widget> addSeparator(List<Widget> items) => items.indexed
      .expand((item) =>
          item.$1 == items.length - 1 ? [item.$2] : [item.$2, const Divider()])
      .toList();

  List<(SearchResultType, Widget)> showCombinedSearchResults(
      TextStyle textStyle, Embedded embedded) {
    const startIndex = 0;
    final s = AppLocalizations.of(context)!;
    final romanization = context.read<RomanizationState>().romanization;
    final romanizationName = getRomanizationName(romanization, s);

    showSearchResultsOfType(SearchResultType type) => (
          type,
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: switch (type) {
                SearchResultType.variant => [
                    showSearchResultCategory(
                        s.searchResults(s.searchResultsCategoryCantonese)),
                    ...addSeparator(showVariantSearchResults(
                        startIndex, textStyle, embedded))
                  ],
                SearchResultType.mandarinVariant => [
                    showSearchResultCategory(
                        s.searchResults(s.searchResultsCategoryMandarin)),
                    ...addSeparator(showMandarinVariantSearchResults(
                        startIndex, textStyle, embedded))
                  ],
                SearchResultType.pr => [
                    showSearchResultCategory(s.searchResults(romanizationName)),
                    ...addSeparator(showPrSearchResults(
                        startIndex + variantSearchResults.length,
                        textStyle,
                        embedded))
                  ],
                SearchResultType.english => [
                    showSearchResultCategory(
                        s.searchResults(s.searchResultsCategoryEnglish)),
                    ...addSeparator(showEnglishSearchResults(
                        startIndex +
                            variantSearchResults.length +
                            prSearchResults.length,
                        textStyle,
                        embedded))
                  ],
                SearchResultType.eg => [
                    showSearchResultCategory(
                        s.searchResults(s.searchResultsCategoryExample)),
                    ...addSeparator(showEgSearchResults(
                        startIndex +
                            variantSearchResults.length +
                            prSearchResults.length +
                            englishSearchResults.length,
                        embedded)),
                  ],
              })
        );

    return searchResultOrder
        .map((type) => showSearchResultsOfType(type))
        .toList();
  }

  Widget showSearchResult(int index, int id,
      TextSpan Function(bool selected) resultText, SearchResultType resultType,
      {int maxLines = 2,
      int? defIndex,
      int? egIndex,
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
            shape:
                const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          onPressed: () {
            context.read<HistoryState>().addItem(id);
            final entryPage = EntryPage(
              key: ValueKey(index),
              id: id,
              defIndex: defIndex,
              egIndex: egIndex,
              showFirstEntryInGroupInitially: showFirstEntryInGroupInitially,
              embedded: embedded,
            );

            setState(() {
              selectedSearchResultEntryPage = entryPage;
            });
            analyticsState.clickSearchResultType(resultType);
            if (embedded != Embedded.embedded) {
              context.push(
                  "/entry/id/$id?showFirstInGroup=$showFirstEntryInGroupInitially${defIndex == null ? "" : "&defIndex=$defIndex"}${egIndex == null ? "" : "&egIndex=$egIndex"}&embedded=${embedded.name}");
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text.rich(
              resultText(selected),
              textAlign: TextAlign.start,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Embedded getEmbedded() =>
      MediaQuery.of(context).size.width > wideScreenThreshold
          ? Embedded.embedded
          : Embedded.topLevel;

  @override
  void dispose() {
    _searchResultScrollController.dispose();
    _searchResultTabController.dispose();
    _historyAndBookmarksTabController.dispose();
    super.dispose();
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
