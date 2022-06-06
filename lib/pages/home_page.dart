import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordshk/widgets/search_bar.dart';
import 'package:wordshk/widgets/syllable_pronunciation_button.dart';

import '../bridge_generated.dart';
import '../constants.dart';
import '../custom_page_route.dart';
import '../main.dart';
import '../models/entry_language.dart';
import '../models/language.dart';
import '../models/pronunciation_method.dart';
import '../models/romanization.dart';
import '../models/search_mode.dart';
import '../states/entry_language_state.dart';
import '../states/language_state.dart';
import '../states/pronunciation_method_state.dart';
import '../states/romanization_state.dart';
import '../states/search_mode_state.dart';
import '../states/search_query_state.dart';
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
    Future.wait([
      DefaultAssetBundle.of(context).loadString("assets/api.json"),
      DefaultAssetBundle.of(context).loadString("assets/english_index.json"),
      DefaultAssetBundle.of(context).loadString("assets/word_list.tsv"),
    ]).then((files) {
      api.initApi(
          apiJson: files[0], englishIndexJson: files[1], wordList: files[2]);
    });
    final query = context.read<SearchQueryState>().query;
    if (query.isNotEmpty) {
      queryEmptied = false;
      doSearch(query, context);
    }
    context.read<SearchModeState>().addListener(() {
      final query = context.read<SearchQueryState>().query;
      doSearch(query, context);
    });

    final languageState = context.read<LanguageState>();
    if (languageState.language == null) {
      SharedPreferences.getInstance().then((prefs) async {
        final languageIndex = prefs.getInt("language");
        if (languageIndex == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final languageCode = Localizations.localeOf(context).toString();
            final language =
                Language.values.byName(languageCode.replaceAll("_", ""));
            context.read<LanguageState>().updateLanguage(language);
          });
        } else {
          context
              .read<LanguageState>()
              .updateLanguage(Language.values[languageIndex]);
        }
      });
    }

    final entryLanguageState = context.read<EntryLanguageState>();
    if (entryLanguageState.language == null) {
      SharedPreferences.getInstance().then((prefs) async {
        final languageIndex = prefs.getInt("entryLanguage");
        if (languageIndex == null) {
          context.read<EntryLanguageState>().updateLanguage(EntryLanguage.both);
        } else {
          context
              .read<EntryLanguageState>()
              .updateLanguage(EntryLanguage.values[languageIndex]);
        }
      });
    }

    final pronunciationMethodState = context.read<PronunciationMethodState>();
    if (pronunciationMethodState.entryEgMethod == null) {
      SharedPreferences.getInstance().then((prefs) async {
        final methodIndex = prefs.getInt("entryEgPronunciationMethod");
        if (methodIndex == null) {
          context.read<PronunciationMethodState>().updatePronunciationMethod(
              Platform.isIOS
                  ? PronunciationMethod.tts
                  : PronunciationMethod.syllableRecordings);
        } else {
          context.read<PronunciationMethodState>().updatePronunciationMethod(
              PronunciationMethod.values[methodIndex]);
        }
      });
    }

    final romanizationState = context.read<RomanizationState>();
    if (romanizationState.romanization == null) {
      SharedPreferences.getInstance().then((prefs) async {
        final romanizationIndex = prefs.getInt("romanization");
        if (romanizationIndex == null) {
          romanizationState.updateRomanization(Romanization.jyutping);
        } else {
          romanizationState
              .updateRomanization(Romanization.values[romanizationIndex]);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSearchResultsEmpty;
    switch (context.watch<SearchModeState>().mode) {
      case SearchMode.pr:
        isSearchResultsEmpty = prSearchResults.isEmpty;
        break;
      case SearchMode.variant:
        isSearchResultsEmpty = variantSearchResults.isEmpty;
        break;
      case SearchMode.combined:
        isSearchResultsEmpty =
            prSearchResults.isEmpty && variantSearchResults.isEmpty;
        break;
      case SearchMode.english:
        isSearchResultsEmpty = englishSearchResults.isEmpty;
        break;
    }

    return KeyboardVisibilityProvider(
        child: Scaffold(
            appBar: SearchBar(onChanged: (query) {
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
            }, onCleared: () {
              setState(() {
                // TODO: hide search results
                queryEmptied = true;
              });
            }),
            drawer: const NavigationDrawer(),
            body: ((finishedSearch && isSearchResultsEmpty)
                ? showResultsNotFound()
                : (queryEmptied ? showWatermark() : showSearchResults()))));
  }

  Widget showWatermark() {
    double watermarkSize = min(MediaQuery.of(context).size.width * 0.8, 500);
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
                                                            alignment: Alignment
                                                                .bottomCenter))
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
      final script = context.read<LanguageState>().language == Language.zhHansCN
          ? Script.Simplified
          : Script.Traditional;
      switch (searchMode) {
        case SearchMode.pr:
          api
              .prSearch(capacity: 10, query: query, script: script)
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
              .combinedSearch(capacity: 10, query: query, script: script)
              .then((results) {
            setState(() {
              prSearchResults =
                  results.prSearchResults.unique((result) => result.variant);
              variantSearchResults = results.variantSearchResults
                  .unique((result) => result.variant);
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
                  style: textStyle.copyWith(color: greyColor)),
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
            child: RichText(text: resultText, textAlign: TextAlign.start),
          ),
        ),
      ],
    );
  }
}
