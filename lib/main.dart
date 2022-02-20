import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:path_provider/path_provider.dart';

import 'bridge_generated.dart';
import 'entry.dart' as e;

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
  e.Entry? entry;
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
                entry = e.Entry.fromJson(jsonDecode(json));
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
                entry = e.Entry.fromJson(jsonDecode(json));
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
          showPoses(entry!.poses),
          const SizedBox(height: 5),
          showDefs(entry!.defs),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    ));
  }

  Widget showVariants(List<e.Variant> variants) {
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
                  text: variant.prs,
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ));
        }).toList(),
        crossAxisAlignment: CrossAxisAlignment.start);
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
    return Column(
      children: defs.map(showDef).toList(),
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget showDef(e.Def def) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
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
        runSpacing: rubySize,
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
