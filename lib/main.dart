import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:path_provider/path_provider.dart';

import 'bridge_generated.dart';
import 'entry.dart' as e;

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
          bodyLarge: TextStyle(fontSize: 28.0),
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

class _MyHomePageState extends State<MyHomePage> {
  late SearchBar searchBar;
  final TextEditingController searchController = TextEditingController();
  List<PrSearchResult> prSearchResults = [];
  List<VariantSearchResult> variantSearchResults = [];
  List<e.Entry> entryGroup = [];
  int entryIndex = 0;
  String query = "";
  SearchMode searchMode = SearchMode.combined;
  AppState appState = AppState.home;

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        leading: appState == AppState.entry
            ? IconButton(
                icon: const BackButtonIcon(),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () {
                  setState(() {
                    appState = AppState.searchResults;
                    searchBar.isSearching.value = true;
                    searchController.text = query;
                  });
                })
            : null,
        title: appState == AppState.home
            ? Text(
                "words.hk",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              )
            : null,
        centerTitle: false,
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: (() {
        switch (appState) {
          case AppState.home:
            // TODO: Show search history
            return Container();
          case AppState.searchResults:
            return ListView(
                children: showSearchResults(),
                padding: const EdgeInsets.only(top: 10.0));
          case AppState.entry:
            return showEntry();
        }
      })(),
    );
  }

  List<ListTile> showSearchResults() {
    switch (searchMode) {
      case SearchMode.pr:
        return showPrSearchResults();
      case SearchMode.variant:
        return showVariantSearchResults();
      case SearchMode.combined:
        return showCombinedSearchResults();
    }
  }

  List<ListTile> showPrSearchResults() {
    return prSearchResults.map((result) {
      return showSearchResult(
          result.id,
          TextSpan(
            children: [
              TextSpan(
                  text: result.variant + " ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.blue)),
              TextSpan(
                  text: result.pr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.grey)),
            ],
          ));
    }).toList();
  }

  List<ListTile> showVariantSearchResults() {
    return variantSearchResults.map((result) {
      return showSearchResult(
          result.id,
          TextSpan(
              text: result.variant,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.blue)));
    }).toList();
  }

  List<ListTile> showCombinedSearchResults() {
    return showVariantSearchResults()
        .followedBy(showPrSearchResults())
        .toList();
  }

  ListTile showSearchResult(int id, TextSpan resultText) {
    return ListTile(
      title: TextButton(
        style: TextButton.styleFrom(
            alignment: Alignment.centerLeft, padding: EdgeInsets.zero),
        onPressed: () {
          api.getEntryGroupJson(id: id).then((json) {
            setState(() {
              searchBar.isSearching.value = false;
              searchController.clear();
              appState = AppState.entry;
              entryGroup = json
                  .map((entryJson) => e.Entry.fromJson(jsonDecode(entryJson)))
                  .toList();
              entryIndex = 0;
            });
          });
        },
        child: RichText(text: resultText, textAlign: TextAlign.start),
      ),
    );
  }

  Widget showEntry() {
    double titleFontSize = Theme.of(context).textTheme.headlineSmall!.fontSize!;
    double padding = titleFontSize / 2;
    double definitionHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        padding * 4 -
        titleFontSize * 2.5;
    return Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            SizedBox(
                height: titleFontSize * 1.5,
                child: showVariants(entryGroup[entryIndex].variants)),
            DefaultTabController(
              length: entryGroup.length,
              child: Column(children: [
                TabBar(
                  onTap: (index) {
                    setState(() {
                      entryIndex = index;
                    });
                  },
                  isScrollable: true, // Required
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black, // Other tabs color
                  labelPadding: const EdgeInsets.symmetric(
                      horizontal: 30), // Space between tabs
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                        color: Colors.black, width: 2), // Indicator height
                    insets:
                        EdgeInsets.symmetric(horizontal: 60), // Indicator width
                  ),
                  tabs: entryGroup
                      .map((entry) => Tab(text: entry.poses.first))
                      .toList(),
                ),
                SizedBox(height: padding),
                SizedBox(
                    height: definitionHeight,
                    child: showDefs(entryGroup[entryIndex].defs))
              ]),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ));
  }

  Widget showVariants(List<e.Variant> variants) {
    return ListView.separated(
      itemCount: variants.length,
      separatorBuilder: (context, index) => SizedBox(
          width: Theme.of(context).textTheme.headlineSmall!.fontSize! / 2),
      itemBuilder: (context, index) => RichText(
          text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: variants[index].word,
              style: Theme.of(context).textTheme.headlineSmall),
          const TextSpan(text: '  '),
          TextSpan(
              text: variants[index].prs,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      )),
      scrollDirection: Axis.horizontal,
    );
  }

  Widget showPoses(List<String> poses) {
    return Wrap(
      children: poses.map((pos) {
        return Text(
          "詞性：" + pos,
          style: Theme.of(context).textTheme.bodyMedium,
        );
      }).toList(),
    );
  }

  Widget showDefs(List<e.Def> defs) {
    return ListView(
      children: defs.map(showDef).toList(),
    );
  }

  Widget showDef(e.Def def) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: Theme.of(context).textTheme.headlineSmall!.fontSize!),
      child: Column(
        children: [
          showClause(def.yue, "(粵) "),
          def.eng == null
              ? const SizedBox.shrink()
              : showClause(def.eng!, "(英) "),
          ...def.egs.map(showEg)
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  Widget showClause(e.Clause clause, String? tag) {
    return Column(
      children: clause.lines.asMap().keys.toList().map((index) {
        return showLine(clause.lines[index], index == 0 ? tag : null);
      }).toList(),
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget showLine(e.Line line, String? tag) {
    if (line.segments.length == 1 &&
        line.segments[0] == const e.Segment(e.SegmentType.text, "")) {
      return const SizedBox(height: 10);
    } else {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: tag, style: const TextStyle(fontWeight: FontWeight.bold)),
            ...line.segments.map(showSegment).toList()
          ],
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
  }

  TextSpan showSegment(e.Segment segment) {
    switch (segment.type) {
      case e.SegmentType.text:
        return TextSpan(text: segment.segment);
      case e.SegmentType.link:
        return TextSpan(
            text: segment.segment,
            style: const TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                // TODO: go to linked entry
              });
    }
  }

  Widget showEg(e.Eg eg) {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            eg.zho == null ? const SizedBox.shrink() : showRichLine(eg.zho!),
            eg.yue == null ? const SizedBox.shrink() : showRichLine(eg.yue!),
            eg.eng == null ? const SizedBox.shrink() : showLine(eg.eng!, ""),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ));
  }

  Widget showRichLine(e.RichLine line) {
    switch (line.type) {
      case e.RichLineType.ruby:
        return showRubyLine(line.line);
      case e.RichLineType.word:
        return showWordLine(line.line);
    }
  }

  Widget showRubyLine(e.RubyLine line) {
    double rubySize = Theme.of(context).textTheme.headlineSmall!.fontSize!;
    return Padding(
      padding: EdgeInsets.only(top: rubySize / 1.5),
      child: Wrap(
        runSpacing: rubySize / 1.4,
        children: line.segments
            .map((segment) => showRubySegment(segment, rubySize))
            .map((e) => Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisSize: MainAxisSize.min,
                  children: [e],
                ))
            .toList(),
      ),
    );
  }

  Widget showRubySegment(e.RubySegment segment, double rubySize) {
    double rubyYPos = rubySize / 1.1;
    Widget text;
    String ruby;
    switch (segment.type) {
      case e.RubySegmentType.punc:
        text = Text(segment.segment as String,
            style: TextStyle(fontSize: rubySize, height: 0.8));
        ruby = "";
        break;
      case e.RubySegmentType.word:
        text = RichText(
            text: TextSpan(
                children: showWord(segment.segment.word as e.Word),
                style: TextStyle(fontSize: rubySize, height: 0.8)));
        ruby = segment.segment.prs.join(" ");
        break;
      case e.RubySegmentType.linkedWord:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          textBaseline: TextBaseline.alphabetic,
          mainAxisSize: MainAxisSize.min,
          children: (segment.segment.words as List<e.RubySegmentWord>)
              .map((word) => showRubySegment(
                  e.RubySegment(e.RubySegmentType.word, word), rubySize))
              .toList(),
        );
    }
    return Stack(alignment: Alignment.center, children: [
      Container(
          alignment: Alignment.bottomCenter,
          child: Center(
              child: Transform(
                  transform: Matrix4.translationValues(0, -(rubyYPos), 0),
                  child:
                      Text(ruby, style: TextStyle(fontSize: rubySize * 0.4))))),
      text
    ]);
  }

  Widget showWordLine(e.WordLine line) {
    return RichText(
      text: TextSpan(
        children: line.segments.map(showWordSegment).toList(),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  TextSpan showWordSegment(e.WordSegment segment) {
    switch (segment.type) {
      case e.SegmentType.text:
        return TextSpan(children: showWord(segment.word));
      case e.SegmentType.link:
        return TextSpan(
            children: showWord(segment.word),
            style: const TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                // TODO: go to linked entry
              });
    }
  }

  List<TextSpan> showWord(e.Word word) {
    return word.texts.map(showText).toList();
  }

  TextSpan showText(e.Text text) {
    return TextSpan(
        text: text.text,
        style: TextStyle(
            fontWeight: text.style == e.TextStyle.normal
                ? FontWeight.normal
                : FontWeight.bold,
            color: Colors.black));
  }
}
