import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordshk/states/entry_language_state.dart';
import 'package:wordshk/states/language_state.dart';
import 'package:wordshk/states/pronunciation_method_state.dart';
import 'package:wordshk/states/romanization_state.dart';
import 'package:wordshk/states/search_mode_state.dart';
import 'package:wordshk/states/search_query_state.dart';
import 'package:wordshk/widgets/search_bar.dart';
import 'package:wordshk/widgets/syllable_pronunciation_button.dart';

import 'bridge_generated.dart';
import 'constants.dart';
import 'custom_page_route.dart';
import 'models/entry_language.dart';
import 'models/language.dart';
import 'models/pronunciation_method.dart';
import 'models/romanization.dart';
import 'models/search_mode.dart';
import 'pages/entry_page.dart';
import 'widgets/navigation_drawer.dart';

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <Id>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

const base = 'wordshk_api';
final path = Platform.isWindows ? '$base.dll' : 'lib$base.so';
late final dylib = Platform.isIOS
    ? DynamicLibrary.process()
    : Platform.isMacOS
        ? DynamicLibrary.executable()
        : DynamicLibrary.open(path);
late final api = WordshkApiImpl(dylib);

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SearchModeState>(
            create: (_) => SearchModeState()),
        ChangeNotifierProvider<SearchQueryState>(
            create: (_) => SearchQueryState()),
        ChangeNotifierProvider<LanguageState>(create: (_) => LanguageState()),
        ChangeNotifierProvider<EntryLanguageState>(
            create: (_) => EntryLanguageState()),
        ChangeNotifierProvider<PronunciationMethodState>(
            create: (_) => PronunciationMethodState()),
        ChangeNotifierProvider<RomanizationState>(
            create: (_) => RomanizationState()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Map<int, Color> blueColorMap = {
    50: blueColor,
    100: blueColor,
    200: blueColor,
    300: blueColor,
    400: blueColor,
    500: blueColor,
    600: blueColor,
    700: blueColor,
    800: blueColor,
    900: blueColor,
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final blueSwatch = MaterialColor(blueColor.value, blueColorMap);
    const headlineSmall =
        TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold);
    const titleLarge = TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold);
    const titleMedium = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
    const titleSmall = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
    const bodyLarge = TextStyle(fontSize: 22.0);
    const bodyMedium = TextStyle(fontSize: 18.0);
    const bodySmall = TextStyle(fontSize: 16.0);
    var textTheme = const TextTheme(
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
    );
    var appBarTheme = AppBarTheme.of(context).copyWith(
      backgroundColor: blueColor,
      centerTitle: true,
    );
    const textSelectionTheme = TextSelectionThemeData(
        selectionColor: greyColor,
        selectionHandleColor: greyColor,
        cursorColor: greyColor);
    var textButtonTheme = TextButtonThemeData(
        style: ButtonStyle(
      textStyle:
          MaterialStateProperty.all(bodyLarge.copyWith(color: blueColor)),
      foregroundColor: MaterialStateProperty.resolveWith((_) => blueColor),
    ));
    var elevatedButtonTheme = ElevatedButtonThemeData(
        style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(blueColor),
      textStyle:
          MaterialStateProperty.all(bodyLarge.copyWith(color: Colors.white)),
      padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 20.0, horizontal: 35.0)),
    ));
    const dividerTheme = DividerThemeData(space: 0, thickness: 1);

    var lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.light,
        accentColor: blueColor,
      ),
      primarySwatch: blueSwatch,
      primaryColor: blueColor,
      appBarTheme: appBarTheme,
      textSelectionTheme: textSelectionTheme,
      fontFamily: 'ChironHeiHK',
      textTheme: textTheme.copyWith(
          bodySmall: bodySmall.copyWith(color: darkGreyColor)),
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
      textButtonTheme: textButtonTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      dividerColor: lightGreyColor,
      dividerTheme: dividerTheme,
    );
    var darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        accentColor: lightBlueColor,
      ),
      scaffoldBackgroundColor: Colors.black,
      backgroundColor: blackColor,
      primarySwatch: blueSwatch,
      primaryColor: blueColor,
      appBarTheme: appBarTheme,
      textSelectionTheme: textSelectionTheme,
      fontFamily: 'ChironHeiHK',
      textTheme: textTheme.copyWith(
          bodySmall: bodySmall.copyWith(color: lightGreyColor)),
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
      textButtonTheme: textButtonTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      dividerColor: darkGreyColor,
      dividerTheme: dividerTheme,
    );
    return Portal(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: context.watch<LanguageState>().language?.toLocale,
      title: 'words.hk',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeResolutionCallback: (
        locale,
        supportedLocales,
      ) {
        if (locale?.languageCode == 'yue') {
          return const Locale.fromSubtags(
              languageCode: 'zh',
              scriptCode: 'Hant',
              countryCode: 'HK'); // 'zh_Hant_HK'
        } else if (supportedLocales.contains(locale)) {
          return locale;
        } else if (locale?.languageCode == 'zh') {
          if (locale?.scriptCode == 'Hant') {
            return const Locale.fromSubtags(
                languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW');
          } else {
            return const Locale.fromSubtags(
                languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN');
          }
        } else {
          return const Locale.fromSubtags(languageCode: 'en');
        }
      },
      supportedLocales: const [
        Locale.fromSubtags(
            languageCode:
                'en'), // generic English (defaults to American English)// 'yue_Hant_HK'
        Locale.fromSubtags(
            languageCode:
                'zh'), // generic Chinese 'zh' (defaults to zh_Hans_CN)
        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode:
                'Hans'), // generic simplified Chinese 'zh_Hans' (defaults to zh_Hans_CN)
        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode:
                'Hant'), // generic traditional Chinese 'zh_Hant' (defaults to zh_Hant_TW)
        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hans',
            countryCode: 'CN'), // 'zh_Hans_CN'
        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant',
            countryCode: 'TW'), // 'zh_Hant_TW'
        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant',
            countryCode: 'HK'), // 'zh_Hant_HK'
      ],
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const HomePage(title: 'words.hk'),
    ));
  }
}

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
    double watermarkSize = min(MediaQuery.of(context).size.width * 0.8, 500);
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
                ? FutureBuilder<List<String>>(
                    future: api.getJyutping(
                        query: context
                            .watch<SearchQueryState>()
                            .query), // a previously-obtained Future<String> or null
                    builder: (BuildContext context,
                            AsyncSnapshot<List<String>> snapshot) =>
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: snapshot.hasData
                                    ? (snapshot.data!.isNotEmpty
                                        ? [
                                            Text(AppLocalizations.of(context)!
                                                .searchDictionaryOnlyPronunciationFound),
                                            RichText(
                                                textScaleFactor:
                                                    MediaQuery.of(context)
                                                        .textScaleFactor,
                                                text: TextSpan(
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                    children: snapshot.data!
                                                        .map((pr) => [
                                                              TextSpan(
                                                                  text: pr),
                                                              WidgetSpan(
                                                                  child: SyllablePronunciationButton(
                                                                      prs: pr.split(
                                                                          " "),
                                                                      alignment:
                                                                          Alignment
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
                                        ? [
                                            const Text(
                                                "Error loading jyutping data.")
                                          ]
                                        : [])))
                : (queryEmptied
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: appBarHeight),
                          child: MediaQuery.of(context).platformBrightness ==
                                  Brightness.light
                              ? Image(
                                  width: watermarkSize,
                                  image: const AssetImage('assets/icon.png'))
                              : Image(
                                  width: watermarkSize,
                                  image:
                                      const AssetImage('assets/icon_grey.png')),
                        ),
                      )
                    : Consumer<SearchModeState>(
                        builder: (context, searchModeState, child) {
                        final results = showSearchResults(
                            Theme.of(context).textTheme.bodyLarge!,
                            searchModeState.mode);
                        return ListView.separated(
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (_, index) => results[index],
                          itemCount: results.length,
                        );
                      })))));
  }

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

  List<Widget> showSearchResults(TextStyle textStyle, SearchMode searchMode) {
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
