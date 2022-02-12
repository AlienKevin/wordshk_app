import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:path_provider/path_provider.dart';

import 'bridge_generated.dart';
import 'entry.dart'
    show Clause, Def, Entry, Line, Segment, SegmentType, Variant;

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
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        // Define the default font family.
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 24.0),
          bodyMedium: TextStyle(fontSize: 20.0),
          bodySmall: TextStyle(fontSize: 18.0),
        ),
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
  Entry? entry;
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
          style: const ButtonStyle(alignment: Alignment.centerLeft),
          onPressed: () {
            api.getEntryJson(id: result.id).then((json) {
              setState(() {
                bodyState = BodyState.entry;
                entry = Entry.fromJson(jsonDecode(json));
              });
            });
          },
          child: Text(result.variant + " " + result.pr,
              style: const TextStyle(fontSize: 18), textAlign: TextAlign.start),
        ),
      );
    }).toList());
  }

  Widget showVariantSearchResults() {
    return ListView(
        children: variantSearchResults.map((result) {
      return ListTile(
        title: TextButton(
          style: const ButtonStyle(alignment: Alignment.centerLeft),
          onPressed: () {
            api.getEntryJson(id: result.id).then((json) {
              setState(() {
                bodyState = BodyState.entry;
                entry = Entry.fromJson(jsonDecode(json));
              });
            });
          },
          child: Text(result.variant,
              style: const TextStyle(fontSize: 18), textAlign: TextAlign.start),
        ),
      );
    }).toList());
  }

  Widget showEntry() {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          showVariants(entry!.variants),
          const SizedBox(height: 10),
          showPoses(entry!.poses),
          const SizedBox(height: 10),
          showDefs(entry!.defs),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    ));
  }

  Widget showVariants(List<Variant> variants) {
    return Column(
        children: variants.map((variant) {
      return RichText(
          text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: variant.word,
              style: Theme.of(context).textTheme.headlineSmall),
          const TextSpan(text: '  '),
          TextSpan(
              text: variant.prs, style: Theme.of(context).textTheme.bodySmall),
        ],
      ));
    }).toList());
  }

  Widget showPoses(List<String> poses) {
    return Wrap(
      children: poses.map((pos) {
        return Text(
          "詞性：" + pos,
          style: Theme.of(context).textTheme.bodyLarge,
        );
      }).toList(),
    );
  }

  Widget showDefs(List<Def> defs) {
    return Column(
      children: defs.map(showDef).toList(),
    );
  }

  Widget showDef(Def def) {
    return Column(
      children: [
        showClause(def.yue, "(粵) "),
        def.eng == null
            ? const SizedBox.shrink()
            : showClause(def.eng!, "(英) "),
      ],
    );
  }

  Widget showClause(Clause clause, String? tag) {
    return Column(
      children: clause.lines.asMap().keys.toList().map((index) {
        return showLine(clause.lines[index], index == 0 ? tag : null);
      }).toList(),
    );
  }

  RichText showLine(Line line, String? tag) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: tag),
          ...line.segments.map(showSegment).toList()
        ],
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  TextSpan showSegment(Segment segment) {
    switch (segment.type) {
      case SegmentType.text:
        return TextSpan(text: segment.segment);
      case SegmentType.link:
        return TextSpan(
            text: segment.segment,
            style: const TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                // TODO: go to linked entry
              });
    }
  }
}
