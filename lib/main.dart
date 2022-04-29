import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';

import 'bridge_generated.dart';
import 'constants.dart';
import 'entry.dart' show Entry, showEntry;
import 'search_bar.dart';

// @freezed
// class AppState with _$AppState {
//   const factory AppState.home() = Home;
//   const factory AppState.searchResults() = SearchResults;
//   const factory AppState.entry() = Error;
// }

enum AppState { home, searchResults, entry }

enum SearchMode {
  pr,
  variant,
  combined,
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = Set();
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
  runApp(MyApp());
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
    return MaterialApp(
      title: 'words.hk',
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: blueSwatch,
          primaryColor: blueColor,
          fontFamily: 'ChironHeiHK',
          textTheme: const TextTheme(
            headlineSmall:
                TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 28.0),
            bodyMedium: TextStyle(fontSize: 20.0),
            bodySmall: TextStyle(fontSize: 18.0),
          ),
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: Theme.of(context).canvasColor),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
            textStyle: MaterialStateProperty.all(Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: blueColor)),
            foregroundColor:
                MaterialStateProperty.resolveWith((_) => blueColor),
          ))),
      home: const MyHomePage(title: 'words.hk home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SearchBar searchBar;
  final TextEditingController searchController = TextEditingController();
  List<PrSearchResult> prSearchResults = [];
  List<VariantSearchResult> variantSearchResults = [];
  List<Entry> entryGroup = [];
  int entryIndex = 0;
  String query = "";
  SearchMode searchMode = SearchMode.combined;
  AppState appState = AppState.home;

  @override
  void initState() {
    super.initState();
    DefaultAssetBundle.of(context).loadString("assets/api.json").then((json) {
      api.initApi(json: json);
    });
    searchBar = SearchBar(
      setState: setState,
      closeOnSubmit: false,
      clearOnSubmit: false,
      controller: searchController,
      onSubmitted: (query) {
        setState(() {
          prSearchResults.clear();
          variantSearchResults.clear();
          this.query = query;
        });
        api.prSearch(capacity: 10, query: query).then((results) {
          setState(() {
            prSearchResults = results.unique((result) => result.variant);
          });
        });
        api.variantSearch(capacity: 10, query: query).then((results) {
          setState(() {
            appState = AppState.searchResults;
            variantSearchResults = results.unique((result) => result.variant);
          });
        });
      },
      onCleared: () {
        log("Search bar has been cleared");
        searchController.clear();
      },
      onClosed: () {
        log("Search bar has been closed");
        setState(() {
          appState = AppState.home;
        });
      },
      onEntryBacked: () {
        setState(() {
          appState = AppState.searchResults;
          searchBar.searchBarState.value = SearchBarState.searching;
          searchController.text = query;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      drawer: SizedBox(
        width: 250,
        child: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "words.hk",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).canvasColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          height: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .fontSize! /
                              2),
                      Text(
                        'Crowd-sourced Cantonese dictionary for everyone.',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Theme.of(context).canvasColor),
                      )
                    ]),
              ),
              Expanded(
                  child: TextButton.icon(
                icon: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(Icons.search)),
                label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Dictionary',
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
                onPressed: () {
                  // Update the state of the app

                  // Then close the drawer
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        ),
      ),
      body: (() {
        switch (appState) {
          case AppState.home:
            // TODO: Show search history
            return Visibility(
              visible: searchBar.searchBarState.value == SearchBarState.home,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: AppBar().preferredSize.height * 1.5),
                  child: Image(
                      width: MediaQuery.of(context).size.width * 0.7,
                      image: const AssetImage('assets/logo_wide.png')),
                ),
              ),
            );
          case AppState.searchResults:
            return ListView(children: showSearchResults());
          case AppState.entry:
            return showEntry(context, entryGroup, entryIndex, (index) {
              setState(() {
                entryIndex = index;
              });
            });
        }
      })(),
    );
  }

  List<Expanded> showSearchResults() {
    switch (searchMode) {
      case SearchMode.pr:
        return showPrSearchResults();
      case SearchMode.variant:
        return showVariantSearchResults();
      case SearchMode.combined:
        return showCombinedSearchResults();
    }
  }

  List<Expanded> showPrSearchResults() {
    return prSearchResults.map((result) {
      return showSearchResult(
          result.id,
          TextSpan(
            children: [
              TextSpan(
                  text: result.variant + " ",
                  style: Theme.of(context).textTheme.bodyLarge),
              TextSpan(
                  text: result.pr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: greyColor)),
            ],
          ));
    }).toList();
  }

  List<Expanded> showVariantSearchResults() {
    return variantSearchResults.map((result) {
      return showSearchResult(
          result.id,
          TextSpan(
              text: result.variant,
              style: Theme.of(context).textTheme.bodyLarge));
    }).toList();
  }

  List<Expanded> showCombinedSearchResults() {
    return showVariantSearchResults()
        .followedBy(showPrSearchResults())
        .toList();
  }

  Expanded showSearchResult(int id, TextSpan resultText) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: greyColor, width: 2))),
        child: TextButton(
          style: TextButton.styleFrom(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.zero,
          ),
          onPressed: () {
            api.getEntryGroupJson(id: id).then((json) {
              setState(() {
                searchBar.searchBarState.value = SearchBarState.entry;
                searchController.clear();
                appState = AppState.entry;
                entryGroup = json
                    .map((entryJson) => Entry.fromJson(jsonDecode(entryJson)))
                    .toList();
                entryIndex = 0;
              });
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
            child: RichText(text: resultText, textAlign: TextAlign.start),
          ),
        ),
      ),
    );
  }
}
