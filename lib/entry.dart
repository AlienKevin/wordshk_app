import 'package:equatable/equatable.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_audio/just_audio.dart';

import 'constants.dart';

typedef OnTapLink = void Function(String entryVariant);
typedef EntryGroup = List<Entry>;

ExpandableTheme applyExpandableTheme(Widget child) => ExpandableTheme(
    data: const ExpandableThemeData(
        animationDuration: Duration(milliseconds: 200), useInkWell: false),
    child: child);

class Entry extends Equatable {
  final int id;
  final List<Variant> variants;
  final List<String> poses;
  final List<String> labels;
  final List<String> sims;
  final List<String> ants;
  final List<Def> defs;

  const Entry(
      {required this.id,
      required this.variants,
      required this.poses,
      required this.labels,
      required this.sims,
      required this.ants,
      required this.defs});

  Entry.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        variants = List.from(json['variants']).map((variant) {
          return Variant.fromJson(variant);
        }).toList(),
        poses = List.from(json['poses']),
        labels = List.from(json['labels']),
        sims = List.from(json['sims']),
        ants = List.from(json['ants']),
        defs = List.from(json['defs']).map((def) {
          return Def.fromJson(def);
        }).toList();

  @override
  List<Object> get props => [id, variants, poses, labels, sims, ants, defs];
}

class Def extends Equatable {
  final Clause yue;
  final Clause? eng;
  final List<AltClause> alts;
  final List<Eg> egs;

  const Def({
    required this.yue,
    required this.eng,
    required this.alts,
    required this.egs,
  });

  Def.fromJson(Map<String, dynamic> json)
      : yue = Clause.fromJson(json['yue']),
        eng = json['eng'] == null ? null : Clause.fromJson(json['eng']),
        alts = List.from(json['alts']).map((alt) {
          return AltClause.fromJson(alt);
        }).toList(),
        egs = List.from(json['egs']).map((eg) {
          return Eg.fromJson(eg);
        }).toList();

  @override
  List<Object?> get props => [yue, eng, alts, egs];
}

class Clause extends Equatable {
  final List<Line> lines;

  const Clause(this.lines);

  Clause.fromJson(List<dynamic> json)
      : lines = List.from(json).map((line) {
          return Line.fromJson(line);
        }).toList();

  @override
  List<Object?> get props => [lines];
}

class Line extends Equatable {
  final List<Segment> segments;

  const Line(this.segments);

  Line.fromJson(List<dynamic> json)
      : segments = List.from(json).map((segment) {
          return Segment.fromJson(segment);
        }).toList();

  @override
  List<Object?> get props => [segments];
}

enum SegmentType {
  text,
  link,
}

SegmentType segmentTypeFromString(String string) {
  return string == 'Text' ? SegmentType.text : SegmentType.link;
}

class Segment extends Equatable {
  final SegmentType type;
  final String segment;

  const Segment(this.type, this.segment);

  Segment.fromJson(List<dynamic> json)
      : type = segmentTypeFromString(json[0]),
        segment = json[1];

  @override
  List<Object?> get props => [type, segment];
}

enum RichLineType {
  ruby,
  word,
}

class RichLine extends Equatable {
  final RichLineType type;
  final dynamic line;

  const RichLine(this.type, this.line);

  RichLine.fromJson(Map<String, dynamic> json)
      : type = json['Ruby'] != null ? RichLineType.ruby : RichLineType.word,
        line = json['Ruby'] != null
            ? RubyLine.fromJson(json['Ruby'])
            : WordLine.fromJson(json['Text']);

  @override
  List<Object?> get props => [type, line];
}

class RubyLine extends Equatable {
  final List<RubySegment> segments;

  const RubyLine(this.segments);

  RubyLine.fromJson(List<dynamic> json)
      : segments = json.map((segment) {
          return RubySegment.fromJson(segment);
        }).toList();

  @override
  List<Object?> get props => [segments];
}

enum RubySegmentType {
  punc,
  word,
  linkedWord,
}

class RubySegment extends Equatable {
  final RubySegmentType type;
  final dynamic segment;

  const RubySegment(this.type, this.segment);

  RubySegment.fromJson(Map<String, dynamic> json)
      : type = json['Punc'] != null
            ? RubySegmentType.punc
            : (json['Word'] != null
                ? RubySegmentType.word
                : RubySegmentType.linkedWord),
        segment = json['Punc'] ??
            (json['Word'] != null
                ? RubySegmentWord.fromJson(json['Word'])
                : RubySegmentLinkedWord.fromJson(json['LinkedWord']));

  @override
  List<Object?> get props => [type, segment];
}

class RubySegmentWord extends Equatable {
  final EntryWord word;
  final List<String> prs;

  const RubySegmentWord(this.word, this.prs);

  RubySegmentWord.fromJson(List<dynamic> json)
      : word = EntryWord.fromJson(json[0]),
        prs = List.from(json[1]);

  @override
  List<Object?> get props => [word, prs];
}

class RubySegmentLinkedWord extends Equatable {
  final List<RubySegmentWord> words;

  const RubySegmentLinkedWord(this.words);

  RubySegmentLinkedWord.fromJson(List<dynamic> json)
      : words = List.from(json).map((word) {
          return RubySegmentWord.fromJson(word);
        }).toList();

  @override
  List<Object?> get props => [words];

  @override
  String toString() {
    return words.map((segmentWord) => segmentWord.word.toString()).join("");
  }
}

class WordLine extends Equatable {
  final List<WordSegment> segments;

  const WordLine(this.segments);

  WordLine.fromJson(List<dynamic> json)
      : segments = List.from(json).map((word) {
          return WordSegment.fromJson(word);
        }).toList();

  @override
  List<Object?> get props => [segments];
}

class WordSegment extends Equatable {
  final SegmentType type;
  final EntryWord word;

  const WordSegment(this.type, this.word);

  WordSegment.fromJson(List<dynamic> json)
      : type = segmentTypeFromString(json[0]),
        word = EntryWord.fromJson(json[1]);

  @override
  List<Object?> get props => [type, word];
}

class EntryWord extends Equatable {
  final List<EntryText> texts;

  const EntryWord(this.texts);

  EntryWord.fromJson(List<dynamic> json)
      : texts = List.from(json).map((text) {
          return EntryText.fromJson(text);
        }).toList();

  @override
  String toString() => texts.map((entryText) => entryText.text).join("");

  @override
  List<Object?> get props => [texts];
}

enum EntryTextStyle {
  bold,
  normal,
}

class EntryText extends Equatable {
  final EntryTextStyle style;
  final String text;

  const EntryText(this.style, this.text);

  EntryText.fromJson(List<dynamic> json)
      : style = json[0] == 'Bold' ? EntryTextStyle.bold : EntryTextStyle.normal,
        text = json[1];

  @override
  List<Object?> get props => [style, text];
}

class Eg extends Equatable {
  final RichLine? zho;
  final RichLine? yue;
  final Line? eng;

  const Eg({
    required this.zho,
    required this.yue,
    required this.eng,
  });

  Eg.fromJson(Map<String, dynamic> json)
      : zho = json['zho'] == null ? null : RichLine.fromJson(json['zho']),
        yue = json['yue'] == null ? null : RichLine.fromJson(json['yue']),
        eng = json['eng'] == null ? null : Line.fromJson(json['eng']);

  @override
  List<Object?> get props => [zho, yue, eng];
}

class AltClause extends Equatable {
  // TODO: Change to enum
  final String altLang;
  final Clause clause;

  const AltClause(this.altLang, this.clause);

  AltClause.fromJson(List<dynamic> json)
      : altLang = json[0],
        clause = Clause.fromJson(json[1]);

  @override
  List<Object?> get props => [altLang, clause];
}

class Variant extends Equatable {
  final String word;
  final String prs;

  const Variant(this.word, this.prs);

  Variant.fromJson(Map<String, dynamic> json)
      : word = json['word'],
        prs = json['prs'];

  @override
  List<Object?> get props => [word, prs];
}

Widget showEntry(BuildContext context, List<Entry> entryGroup, int entryIndex,
    void Function(int) updateEntryIndex, OnTapLink onTapLink) {
  double titleFontSize = Theme.of(context).textTheme.headlineSmall!.fontSize!;
  double rubyFontSize = Theme.of(context).textTheme.headlineSmall!.fontSize!;
  TextStyle lineTextStyle = Theme.of(context).textTheme.bodyMedium!;
  double padding = titleFontSize / 2;
  double definitionHeight = MediaQuery.of(context).size.height -
      AppBar().preferredSize.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom -
      titleFontSize * 3;
  return Column(
    children: [
      DefaultTabController(
        length: entryGroup.length,
        child: Column(children: [
          TabBar(
            onTap: updateEntryIndex,
            isScrollable: true, // Required
            labelColor: lineTextStyle.color,
            unselectedLabelColor: lineTextStyle.color, // Other tabs color
            labelPadding: const EdgeInsets.symmetric(
                horizontal: 30), // Space between tabs
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                  color: lineTextStyle.color!, width: 2), // Indicator height
              insets:
                  const EdgeInsets.symmetric(horizontal: 60), // Indicator width
            ),
            tabs: entryGroup
                .asMap()
                .entries
                .map((entry) => Tab(
                    text: (entry.key + 1).toString() +
                        " " +
                        entry.value.poses.join("/")))
                .toList(),
          ),
          SizedBox(
              height: definitionHeight,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: padding),
                child: showTab(
                    entryGroup[entryIndex],
                    Theme.of(context).textTheme.headlineSmall!,
                    Theme.of(context).textTheme.bodySmall!,
                    lineTextStyle,
                    rubyFontSize,
                    onTapLink),
              ))
        ]),
      ),
    ],
    crossAxisAlignment: CrossAxisAlignment.start,
  );
}

Widget showVariants(List<Variant> variants, TextStyle variantTextStyle,
        TextStyle prTextStyle, TextStyle lineTextStyle) =>
    variants.length <= 1
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: showVariant(variants[0], variantTextStyle, prTextStyle))
        : ExpandableNotifier(
            child: applyExpandableTheme(Expandable(
                collapsed: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          showVariant(
                              variants[0], variantTextStyle, prTextStyle),
                          egExpandableButton(
                              "More variants", Icons.expand_more, lineTextStyle)
                        ])),
                expanded: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: variants
                                  .map((variant) => showVariant(
                                      variant, variantTextStyle, prTextStyle))
                                  .toList())),
                      egExpandableButton(
                          "Collapse variants", Icons.expand_less, lineTextStyle)
                    ]))));

Widget showVariant(
    Variant variant, TextStyle variantTextStyle, TextStyle prTextStyle) {
  var prs = variant.prs.split(", ");
  return Row(
    children: [
      RichText(
          text: TextSpan(children: <TextSpan>[
        TextSpan(text: variant.word, style: variantTextStyle),
        const TextSpan(text: '  '),
        ...prs.takeWhile((pr) => !pr.contains("!")).map(
              (pr) => TextSpan(children: [
                TextSpan(text: pr),
                WidgetSpan(
                    child: Visibility(
                  visible:
                      jyutpingFemaleSyllableNames.containsAll(pr.split(" ")),
                  child: IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: "Pronunciation",
                    alignment: Alignment.bottomLeft,
                    icon: const Icon(Icons.volume_up),
                    color: blueColor,
                    onPressed: () async {
                      var player = AudioPlayer();
                      await player.setAudioSource(ConcatenatingAudioSource(
                          children: pr
                              .split(" ")
                              .map((syllable) => AudioSource.uri(Uri.parse(
                                  "asset:///assets/jyutping_female/$syllable.mp3")))
                              .toList()));
                      await player.seek(Duration.zero, index: 0);
                      await player.play();
                    },
                  ),
                )),
              ], style: prTextStyle),
            )
      ])),
    ],
  );
}

Widget showPoses(List<String> poses, TextStyle style) {
  return Wrap(
    children: poses.map((pos) {
      return Text(
        "詞性：" + pos,
        style: style, // Theme.of(context).textTheme.bodyMedium
      );
    }).toList(),
  );
}

Widget showTab(Entry entry, TextStyle variantTextStyle, TextStyle prTextStyle,
        TextStyle lineTextStyle, double rubyFontSize, OnTapLink onTapLink) =>
    ListView.separated(
      itemBuilder: (context, index) => index == 0
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              showVariants(
                  entry.variants, variantTextStyle, prTextStyle, lineTextStyle),
              showLabels(entry.labels, lineTextStyle),
              showSimsOrAnts("[近義]", entry.sims, lineTextStyle, onTapLink),
              showSimsOrAnts("[反義]", entry.ants, lineTextStyle, onTapLink),
            ])
          : showDef(entry.defs[index - 1], lineTextStyle, rubyFontSize,
              entry.defs.length == 1, onTapLink),
      separatorBuilder: (_, index) => index == 0
          ? SizedBox(height: lineTextStyle.fontSize!)
          : Divider(height: lineTextStyle.fontSize! * 2),
      itemCount: entry.defs.length + 1,
    );

Widget showSimsOrAnts(String label, List<String> simsOrAnts,
        TextStyle lineTextStyle, OnTapLink onTapLink) =>
    Visibility(
        visible: simsOrAnts.isNotEmpty,
        child: RichText(
            text: TextSpan(style: lineTextStyle, children: [
          WidgetSpan(
              child: Text(label,
                  style: lineTextStyle.copyWith(fontWeight: FontWeight.bold))),
          const WidgetSpan(child: SizedBox(width: 10)),
          ...simsOrAnts.asMap().entries.map((sim) => TextSpan(children: [
                TextSpan(
                    text: sim.value,
                    style: const TextStyle(color: blueColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => onTapLink(sim.value)),
                TextSpan(text: sim.key == simsOrAnts.length - 1 ? "" : " · ")
              ]))
        ])));

Widget showLabels(List<String> labels, TextStyle lineTextStyle) => Visibility(
      visible: labels.isNotEmpty,
      child: RichText(
          text: TextSpan(children: [
        WidgetSpan(
            child: Text("[標籤]",
                style: lineTextStyle.copyWith(fontWeight: FontWeight.bold))),
        ...labels
            .map((label) => [
                  const WidgetSpan(child: SizedBox(width: 10)),
                  WidgetSpan(
                      child: Chip(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: EdgeInsets.zero,
                          labelPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10),
                          labelStyle: lineTextStyle.copyWith(color: whiteColor),
                          backgroundColor: greyColor,
                          label: RichText(text: TextSpan(text: label))))
                ])
            .expand((i) => i)
      ])),
    );

Widget showDef(Def def, TextStyle lineTextStyle, double rubyFontSize,
        bool isSingleDef, OnTapLink onTapLink) =>
    Column(
      children: [
        showClause(def.yue, "(粵) ", lineTextStyle, onTapLink),
        def.eng == null
            ? const SizedBox.shrink()
            : showClause(def.eng!, "(英) ", lineTextStyle, onTapLink),
        showEgs(def.egs, lineTextStyle, rubyFontSize, isSingleDef, onTapLink)
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );

Widget egExpandableButton(
        String text, IconData icon, TextStyle lineTextStyle) =>
    ExpandableButton(
        child: RichText(
            text: TextSpan(
      children: [
        TextSpan(text: text, style: lineTextStyle.copyWith(color: blueColor)),
        WidgetSpan(child: Icon(icon, color: blueColor))
      ],
    )));

Widget showEgs(List<Eg> egs, TextStyle lineTextStyle, double rubyFontSize,
    bool isSingleDef, OnTapLink onTapLink) {
  if (egs.isEmpty) {
    return Container();
  } else if (egs.length == 1) {
    return showEg(egs[0], lineTextStyle, rubyFontSize, onTapLink);
  } else if (isSingleDef) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: egs
            .map((eg) => showEg(eg, lineTextStyle, rubyFontSize, onTapLink))
            .toList());
  } else {
    return ExpandableNotifier(
        child: applyExpandableTheme(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expandable(
            collapsed:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              showEg(egs[0], lineTextStyle, rubyFontSize, onTapLink),
              egExpandableButton(
                  "More examples", Icons.expand_more, lineTextStyle)
            ]),
            expanded:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ...egs
                  .map((eg) =>
                      showEg(eg, lineTextStyle, rubyFontSize, onTapLink))
                  .toList(),
              egExpandableButton(
                  "Collapse examples", Icons.expand_less, lineTextStyle)
            ])),
      ],
    )));
  }
  // return ExpandablePanel(
  //   header: const Text("Examples"),
  //   collapsed: showEg(egs[0], lineTextStyle, rubyFontSize, onTapLink),
  //   expanded: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: egs
  //           .map((eg) => showEg(eg, lineTextStyle, rubyFontSize, onTapLink))
  //           .toList()),
  // );
}

Widget showClause(
    Clause clause, String? tag, TextStyle lineTextStyle, OnTapLink onTapLink) {
  return Column(
    children: clause.lines.asMap().keys.toList().map((index) {
      return showLine(clause.lines[index], index == 0 ? tag : null,
          lineTextStyle, onTapLink);
    }).toList(),
    crossAxisAlignment: CrossAxisAlignment.start,
  );
}

Widget showLine(
    Line line, String? tag, TextStyle lineTextStyle, OnTapLink onTapLink) {
  if (line.segments.length == 1 &&
      line.segments[0] == const Segment(SegmentType.text, "")) {
    return const SizedBox(height: 10);
  } else {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: tag, style: const TextStyle(fontWeight: FontWeight.bold)),
          ...line.segments
              .map((segment) => showSegment(segment, onTapLink))
              .toList()
        ],
        style: lineTextStyle,
      ),
    );
  }
}

TextSpan showSegment(Segment segment, OnTapLink onTapLink) {
  switch (segment.type) {
    case SegmentType.text:
      return TextSpan(text: segment.segment);
    case SegmentType.link:
      return TextSpan(
          text: segment.segment,
          style: const TextStyle(color: blueColor),
          recognizer: TapGestureRecognizer()
            ..onTap = () => onTapLink(segment.segment));
  }
}

Widget showEg(
    Eg eg, TextStyle lineTextStyle, double rubyFontSize, OnTapLink onTapLink) {
  return Padding(
      padding: EdgeInsets.only(top: lineTextStyle.fontSize!),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(
              color: greyColor,
              width: 2.0,
            ),
          ),
        ),
        padding: EdgeInsets.only(left: lineTextStyle.fontSize! / 1.5),
        child: Column(
          children: [
            // TODO: add tags for chinese vs cantonese
            eg.zho == null
                ? const SizedBox.shrink()
                : showRichLine(eg.zho!, lineTextStyle, rubyFontSize, onTapLink),
            eg.yue == null
                ? const SizedBox.shrink()
                : showRichLine(eg.yue!, lineTextStyle, rubyFontSize, onTapLink),
            eg.eng == null
                ? const SizedBox.shrink()
                : showLine(eg.eng!, "", lineTextStyle, onTapLink),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ));
}

Widget showRichLine(RichLine line, TextStyle lineTextStyle, double rubyFontSize,
    OnTapLink onTapLink) {
  switch (line.type) {
    case RichLineType.ruby:
      return showRubyLine(
          line.line, lineTextStyle.color!, rubyFontSize, onTapLink);
    case RichLineType.word:
      return showWordLine(line.line, lineTextStyle, onTapLink);
  }
}

Widget showRubyLine(
    RubyLine line, Color textColor, double rubyFontSize, OnTapLink onTapLink) {
  return Padding(
    padding: EdgeInsets.only(top: rubyFontSize / 1.5),
    child: Wrap(
      runSpacing: rubyFontSize / 1.4,
      children: line.segments
          .map((segment) =>
              showRubySegment(segment, textColor, rubyFontSize, onTapLink))
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

Widget showRubySegment(RubySegment segment, Color textColor, double rubySize,
    OnTapLink onTapLink) {
  double rubyYPos = rubySize / 1.1;
  Widget text;
  String ruby;
  switch (segment.type) {
    case RubySegmentType.punc:
      text = Text(segment.segment as String,
          style: TextStyle(fontSize: rubySize, height: 0.8, color: textColor));
      ruby = "";
      break;
    case RubySegmentType.word:
      text = RichText(
          text: TextSpan(
              children: showWord(segment.segment.word as EntryWord),
              style: TextStyle(
                  fontSize: rubySize, height: 0.8, color: textColor)));
      ruby = segment.segment.prs.join(" ");
      break;
    case RubySegmentType.linkedWord:
      return GestureDetector(
        onTap: () => onTapLink(segment.segment.toString()),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          textBaseline: TextBaseline.alphabetic,
          mainAxisSize: MainAxisSize.min,
          children: (segment.segment.words as List<RubySegmentWord>)
              .map(
                (word) => showRubySegment(
                    RubySegment(RubySegmentType.word, word),
                    blueColor,
                    rubySize,
                    onTapLink),
              )
              .toList(),
        ),
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

Widget showWordLine(
    WordLine line, TextStyle lineTextStyle, OnTapLink onTapLink) {
  return RichText(
    text: TextSpan(
      children: line.segments
          .map((segment) => showWordSegment(segment, lineTextStyle, onTapLink))
          .toList(),
      style: lineTextStyle,
    ),
  );
}

InlineSpan showWordSegment(
    WordSegment segment, TextStyle lineTextStyle, OnTapLink onTapLink) {
  switch (segment.type) {
    case SegmentType.text:
      return TextSpan(children: showWord(segment.word));
    case SegmentType.link:
      return WidgetSpan(
          child: GestureDetector(
        onTap: () => onTapLink(segment.word.toString()),
        child: RichText(
            text: TextSpan(
                children: showWord(segment.word),
                style: lineTextStyle.copyWith(color: blueColor))),
      ));
  }
}

List<TextSpan> showWord(EntryWord word) {
  return word.texts.map(showText).toList();
}

TextSpan showText(EntryText text) {
  return TextSpan(
      text: text.text,
      style: TextStyle(
          fontWeight: text.style == EntryTextStyle.normal
              ? FontWeight.normal
              : FontWeight.bold));
}
