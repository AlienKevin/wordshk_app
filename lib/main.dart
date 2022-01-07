import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'dart:ffi';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_html/flutter_html.dart';

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

enum BodyState {
  prSearchResults,
  variantSearchResults,
  entry,
}

class _MyHomePageState extends State<MyHomePage> {
  late SearchBar searchBar;
  String? searchQuery;
  List<PrSearchResult> prSearchResults = [];
  List<VariantSearchResult> variantSearchResults = [];
  String? entryHtml;
  BodyState bodyState = BodyState.prSearchResults;

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
              bodyState = BodyState.prSearchResults;
              prSearchResults = results;
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
      body: (() {
        switch (bodyState) {
          case BodyState.prSearchResults:
            return showPrSearchResults();
          case BodyState.variantSearchResults:
            return showVariantSearchResults();
          case BodyState.entry:
            return showEntry();
        }
      })(),
    );
  }

  Widget showPrSearchResults() {
    return ListView(
        children: prSearchResults.map((result) {
      return ListTile(
        title: TextButton(
          onPressed: () {
            api.getEntryHtml(id: result.id).then((html) {
              setState(() {
                bodyState = BodyState.entry;
                entryHtml = html;
              });
            });
          },
          child: Text(result.variant + " " + result.pr),
        ),
      );
    }).toList());
  }

  Widget showVariantSearchResults() {
    return ListView(
        children: variantSearchResults.map((result) {
      return ListTile(
        title: TextButton(
          onPressed: () {
            api.getEntryHtml(id: result.id).then((html) {
              setState(() {
                bodyState = BodyState.entry;
                entryHtml = html;
              });
            });
          },
          child: Text(result.variant),
        ),
      );
    }).toList());
  }

  Widget showEntry() {
    print(entryHtml!);
    return SingleChildScrollView(
      child: Html(
        data: entryHtml!,
        style: {
          "body": Style(
            fontSize: const FontSize(18)
          ),
          "div.entry-head": Style(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
          ),
          "div.tags": Style(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
          ),
          "h1": Style(
            display: Display.INLINE,
            fontSize: FontSize.percent(200),
          ),
          "h2": Style(
            fontSize: FontSize.percent(150),
          ),
          "rt": Style(
            fontSize: const FontSize(10),
          ),
          "ol": Style(
            listStyleType: ListStyleType.NONE,
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
          ),
          "ruby": Style(
            fontSize: FontSize.percent(150),
          ),
          "li": Style(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
          )
        },
        onLinkTap: (url, _, __, ___) {
          print("Opening $url...");
        },
        onImageTap: (src, _, __, ___) {
          print(src);
        },
        onImageError: (exception, stackTrace) {
          print(exception);
        },
        onCssParseError: (css, messages) {
          print("css that errored: $css");
          print("error messages:");
          messages.forEach((element) {
            print(element);
          });
        },
      ),
    );
  }
}
