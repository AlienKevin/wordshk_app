import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

typedef OnTapLink = void Function(String entryVariant);
typedef EntryGroup = List<Entry>;

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
            : WordLine.fromJson(json['Word']);

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
                onTap: updateEntryIndex,
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
                  child: showDefs(entryGroup[entryIndex].defs, lineTextStyle,
                      rubyFontSize, onTapLink))
            ]),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ));
}

Widget showVariants(List<Variant> variants) {
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

Widget showDefs(List<Def> defs, TextStyle lineTextStyle, double rubyFontSize,
    OnTapLink onTapLink) {
  return ListView(
    children: defs
        .map((def) => showDef(def, lineTextStyle, rubyFontSize, onTapLink))
        .toList(),
  );
}

Widget showDef(Def def, TextStyle lineTextStyle, double rubyFontSize,
    OnTapLink onTapLink) {
  return Padding(
    padding: EdgeInsets.only(bottom: lineTextStyle.fontSize! * 2),
    child: Column(
      children: [
        showClause(def.yue, "(粵) ", lineTextStyle, onTapLink),
        def.eng == null
            ? const SizedBox.shrink()
            : showClause(def.eng!, "(英) ", lineTextStyle, onTapLink),
        ...def.egs
            .map((eg) => showEg(eg, lineTextStyle, rubyFontSize, onTapLink))
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    ),
  );
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
              color: Colors.grey,
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
      return showRubyLine(line.line, rubyFontSize);
    case RichLineType.word:
      return showWordLine(line.line, lineTextStyle, onTapLink);
  }
}

Widget showRubyLine(RubyLine line, double rubyFontSize) {
  return Padding(
    padding: EdgeInsets.only(top: rubyFontSize / 1.5),
    child: Wrap(
      runSpacing: rubyFontSize / 1.4,
      children: line.segments
          .map((segment) => showRubySegment(segment, rubyFontSize))
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

Widget showRubySegment(RubySegment segment, double rubySize) {
  double rubyYPos = rubySize / 1.1;
  Widget text;
  String ruby;
  switch (segment.type) {
    case RubySegmentType.punc:
      text = Text(segment.segment as String,
          style: TextStyle(fontSize: rubySize, height: 0.8));
      ruby = "";
      break;
    case RubySegmentType.word:
      text = RichText(
          text: TextSpan(
              children: showWord(segment.segment.word as EntryWord),
              style: TextStyle(fontSize: rubySize, height: 0.8)));
      ruby = segment.segment.prs.join(" ");
      break;
    case RubySegmentType.linkedWord:
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        textBaseline: TextBaseline.alphabetic,
        mainAxisSize: MainAxisSize.min,
        children: (segment.segment.words as List<RubySegmentWord>)
            .map((word) => showRubySegment(
                RubySegment(RubySegmentType.word, word), rubySize))
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

Widget showWordLine(
    WordLine line, TextStyle lineTextStyle, OnTapLink onTapLink) {
  return RichText(
    text: TextSpan(
      children: line.segments
          .map((segment) => showWordSegment(segment, onTapLink))
          .toList(),
      style: lineTextStyle,
    ),
  );
}

TextSpan showWordSegment(WordSegment segment, OnTapLink onTapLink) {
  switch (segment.type) {
    case SegmentType.text:
      return TextSpan(children: showWord(segment.word));
    case SegmentType.link:
      return TextSpan(
          children: showWord(segment.word),
          style: const TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () => onTapLink(segment.word.toString()));
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
              : FontWeight.bold,
          color: Colors.black));
}
