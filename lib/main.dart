import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/widgets/search_bar.dart';

import 'bridge_generated.dart';
import 'constants.dart';
import 'custom_page_route.dart';
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
  runApp(ChangeNotifierProvider(
    // Initialize the model in the builder. That way, Provider
    // can own SearchModeState's lifecycle, making sure to call `dispose`
    // when not needed anymore.
    create: (context) => SearchModeState(),
    child: MyApp(),
  ));
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
        dividerTheme: dividerTheme.copyWith(color: lightGreyColor));
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
      dividerTheme: dividerTheme.copyWith(color: darkGreyColor),
    );
    return Portal(
        child: MaterialApp(
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
        } else if (supportedLocales.contains(locale) ||
            locale?.languageCode == 'zh') {
          return locale;
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

class SearchModeState with ChangeNotifier {
  SearchMode mode = SearchMode.combined;
  bool showSearchModeSelector = false;

  void updateSearchMode(SearchMode newMode) {
    mode = newMode;
    notifyListeners();
  }

  void toggleSearchModeSelector() {
    showSearchModeSelector = !showSearchModeSelector;
    notifyListeners();
  }
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
      DefaultAssetBundle.of(context).loadString("assets/english_index.json")
    ]).then((jsons) {
      api.initApi(apiJson: jsons[0], englishIndexJson: jsons[1]);
    });
    if (persistentQuery.isNotEmpty) {
      queryEmptied = false;
      doSearch(persistentQuery, context.read<SearchModeState>().mode);
    }
    context.read<SearchModeState>().addListener(() {
      doSearch(persistentQuery, context.read<SearchModeState>().mode);
    });
  }

  @override
  Widget build(BuildContext context) {
    var watermarkSize = MediaQuery.of(context).size.width * 0.8;
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

    return Scaffold(
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
          doSearch(query, context.read<SearchModeState>().mode);
        }, onCleared: () {
          setState(() {
            // TODO: hide search results
            queryEmptied = true;
          });
        }),
        drawer: const NavigationDrawer(),
        body: ((finishedSearch && isSearchResultsEmpty)
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                child: Text(AppLocalizations.of(context)!
                    .searchDictionaryNoResultsFound))
            : (queryEmptied
                ? Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: (MediaQuery.of(context).size.height / 2 -
                              watermarkSize * 1.2)),
                      child: MediaQuery.of(context).platformBrightness ==
                              Brightness.light
                          ? Image(
                              width: watermarkSize,
                              image: const AssetImage('assets/icon.png'))
                          : Image(
                              width: watermarkSize,
                              image: const AssetImage('assets/icon_grey.png')),
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
                  }))));
  }

  void doSearch(String query, SearchMode searchMode) {
    if (query.isEmpty) {
      setState(() {
        variantSearchResults.clear();
        prSearchResults.clear();
        englishSearchResults.clear();
        finishedSearch = true;
      });
    } else {
      switch (searchMode) {
        case SearchMode.pr:
          api.prSearch(capacity: 10, query: query).then((results) {
            setState(() {
              prSearchResults = results.unique((result) => result.variant);
              finishedSearch = true;
            });
          });
          break;
        case SearchMode.variant:
          api.variantSearch(capacity: 10, query: query).then((results) {
            setState(() {
              variantSearchResults = results.unique((result) => result.variant);
              finishedSearch = true;
            });
          });
          break;
        case SearchMode.combined:
          api.combinedSearch(capacity: 10, query: query).then((results) {
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
          api.englishSearch(capacity: 10, query: query).then((results) {
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

  Widget showSearchResult(int id, TextSpan resultText) {
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
                  builder: (context) => EntryPage(
                        id: id,
                        searchMode: context.read<SearchModeState>().mode,
                      )),
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
