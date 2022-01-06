import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'dart:ffi';
import 'package:path_provider/path_provider.dart';

import 'bridge_generated.dart';

// const base = 'wordshk_api';
// final path = Platform.isWindows
//     ? '$base.dll'
//     : Platform.isMacOS
//     ? 'lib$base.dylib'
//     : 'lib$base.so';
// late final dylib = Platform.isIOS ? DynamicLibrary.process() : DynamicLibrary.open(path);
late final dylib = DynamicLibrary.process();
late final api = WordshkApi(dylib);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'words.hk',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
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
  String? searchQuery;
  List<PrSearchResult> prSearchResults = [];
  List<VariantSearchResult> variantSearchResults = [];

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        title: Text(searchQuery ?? "Search here..."),
        actions: [searchBar.getSearchAction(context)]);
  }

  _MyHomePageState() {
    getApplicationDocumentsDirectory().then((appDir) {
      api.initApi(inputAppDir: appDir.path);
    });

    searchBar = SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: (query) {
          setState(() {
            searchQuery = query;
          });
          api.prSearch(capacity: 10, query: query).then((results) {
            setState(() {
              prSearchResults = results;
              variantSearchResults.clear();
            });
          });
        },
        onCleared: () {
          print("Search bar has been cleared");
        },
        onClosed: () {
          print("Search bar has been closed");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: ListView(
          children: prSearchResults.isNotEmpty
              ? prSearchResults.map((result) {
                  return ListTile(
                    title: Text(result.variant + " " + result.pr),
                  );
                }).toList()
              : variantSearchResults.map((result) {
                  return ListTile(
                    title: Text(result.variant),
                  );
                }).toList()),
    );
  }
}
