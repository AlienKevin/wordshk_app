import 'package:equatable/equatable.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wordshk/widgets/entry_banner.dart';
import 'package:wordshk/widgets/scalable_text_span.dart';

import '../bridge_generated.dart' show Script;
import '../constants.dart';
import '../widgets/expandable.dart';

typedef OnTapLink = void Function(String entryVariant);
typedef EntryGroup = List<Entry>;

class Entry extends Equatable {
  final int id;
  final List<Variant> variants;
  final List<Variant> variantsSimp;
  final List<Pos> poses;
  final List<Label> labels;
  final List<String> sims;
  final List<String> ants;
  final List<Def> defs;
  final bool published;

  const Entry({
    required this.id,
    required this.variants,
    required this.variantsSimp,
    required this.poses,
    required this.labels,
    required this.sims,
    required this.ants,
    required this.defs,
    required this.published,
  });

  Entry.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        variants = List.from(json['variants']).map((variant) {
          return Variant.fromJson(variant);
        }).toList(),
        variantsSimp = List.from(json['variants_simp']).map((variant) {
          return Variant.fromJson(variant);
        }).toList(),
        poses =
            List.from(json['poses']).map((pos) => stringToPos(pos)).toList(),
        labels = List.from(json['labels'])
            .map((label) => stringToLabel(label))
            .toList(),
        sims = List.from(json['sims']),
        ants = List.from(json['ants']),
        defs = List.from(json['defs']).map((def) {
          return Def.fromJson(def);
        }).toList(),
        published = json['published'];

  @override
  List<Object> get props => [id, variants, poses, labels, sims, ants, defs];
}

class Def extends Equatable {
  final Clause yue;
  final Clause yueSimp;
  final Clause? eng;
  final List<AltClause> alts;
  final List<Eg> egs;

  const Def({
    required this.yue,
    required this.yueSimp,
    required this.eng,
    required this.alts,
    required this.egs,
  });

  Def.fromJson(Map<String, dynamic> json)
      : yue = Clause.fromJson(json['yue']),
        yueSimp = Clause.fromJson(json['yue_simp']),
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
  final RichLine? zhoSimp;
  final RichLine? yue;
  final RichLine? yueSimp;
  final Line? eng;

  const Eg({
    required this.zho,
    required this.zhoSimp,
    required this.yue,
    required this.yueSimp,
    required this.eng,
  });

  Eg.fromJson(Map<String, dynamic> json)
      : zho = json['zho'] == null ? null : RichLine.fromJson(json['zho']),
        zhoSimp = json['zho_simp'] == null
            ? null
            : RichLine.fromJson(json['zho_simp']),
        yue = json['yue'] == null ? null : RichLine.fromJson(json['yue']),
        yueSimp = json['yue_simp'] == null
            ? null
            : RichLine.fromJson(json['yue_simp']),
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

enum Pos {
  noun,
  verb,
  adjective,
  adverb,
  localiser,
  conjunction,
  expression,
  affix,
  pronoun,
  preposition,
  quantifier,
  particle,
  modalVerb,
  number,
  time,
  other,
  morpheme,
  interjection,
  nonPredicateAdjective,
  onomatopoeia,
  unknown
}

Pos stringToPos(String str) {
  switch (str) {
    case "名詞":
      return Pos.noun;
    case "動詞":
      return Pos.verb;
    case "形容詞":
      return Pos.adjective;
    case "副詞":
      return Pos.adverb;
    case "方位詞":
      return Pos.localiser;
    case "連詞":
      return Pos.conjunction;
    case "語句":
      return Pos.expression;
    case "詞綴":
      return Pos.affix;
    case "代詞":
      return Pos.pronoun;
    case "介詞":
      return Pos.preposition;
    case "量詞":
      return Pos.quantifier;
    case "助詞":
      return Pos.particle;
    case "情態動詞":
      return Pos.modalVerb;
    case "數詞":
      return Pos.number;
    case "時間詞":
      return Pos.time;
    case "其他":
      return Pos.other;
    case "語素":
      return Pos.morpheme;
    case "感嘆詞":
      return Pos.interjection;
    case "區別詞":
      return Pos.nonPredicateAdjective;
    case "擬聲詞":
      return Pos.onomatopoeia;
    default:
      return Pos.unknown;
  }
}

translatePos(Pos pos, AppLocalizations context) {
  switch (pos) {
    case Pos.noun:
      return context.posNoun;
    case Pos.verb:
      return context.posVerb;
    case Pos.adjective:
      return context.posAdjective;
    case Pos.adverb:
      return context.posAdverb;
    case Pos.localiser:
      return context.posLocaliser;
    case Pos.conjunction:
      return context.posConjunction;
    case Pos.expression:
      return context.posExpression;
    case Pos.affix:
      return context.posAffix;
    case Pos.pronoun:
      return context.posPronoun;
    case Pos.preposition:
      return context.posPreposition;
    case Pos.quantifier:
      return context.posQuantifier;
    case Pos.particle:
      return context.posParticle;
    case Pos.modalVerb:
      return context.posModalVerb;
    case Pos.number:
      return context.posNumber;
    case Pos.time:
      return context.posTime;
    case Pos.other:
      return context.posOther;
    case Pos.morpheme:
      return context.posMorpheme;
    case Pos.interjection:
      return context.posInterjection;
    case Pos.nonPredicateAdjective:
      return context.posNonPredicateAdjective;
    case Pos.onomatopoeia:
      return context.posOnomatopoeia;
    case Pos.unknown:
      return context.posUnknown;
  }
}

enum Label {
  vulgar,
  slang,
  controversial,
  buzzword,
  properNoun,
  jargon,
  obsolete,
  hongKong,
  mainland,
  taiwan,
  macau,
  japan,
  loanword,
  invented,
  justForFun,
  plastictrans,
  written,
  spoken,
  wrong,
  classical,
  nsfw,
  folkEtymology,
}

Label stringToLabel(String str) {
  switch (str) {
    case "粗俗":
      return Label.vulgar;
    case "俚語":
      return Label.slang;
    case "爭議":
      return Label.controversial;
    case "潮語":
      return Label.buzzword;
    case "專名":
      return Label.properNoun;
    case "術語":
      return Label.jargon;
    case "舊式":
      return Label.obsolete;
    case "香港":
      return Label.hongKong;
    case "大陸":
      return Label.mainland;
    case "台灣":
      return Label.taiwan;
    case "澳門":
      return Label.macau;
    case "日本":
      return Label.japan;
    case "外來語":
      return Label.loanword;
    case "自創":
      return Label.invented;
    case "玩嘢":
      return Label.justForFun;
    case "膠譯":
      return Label.plastictrans;
    case "書面語":
      return Label.written;
    case "口語":
      return Label.spoken;
    case "錯字":
      return Label.wrong;
    case "文言":
      return Label.classical;
    case "黃賭毒":
      return Label.nsfw;
    case "民間傳説":
      return Label.folkEtymology;
    default:
      throw "Invalid label \"$str\".";
  }
}

translateLabel(Label label, AppLocalizations context) {
  switch (label) {
    case Label.vulgar:
      return context.labelVulgar;
    case Label.slang:
      return context.labelSlang;
    case Label.controversial:
      return context.labelControversial;
    case Label.buzzword:
      return context.labelBuzzword;
    case Label.properNoun:
      return context.labelProperNoun;
    case Label.jargon:
      return context.labelJargon;
    case Label.obsolete:
      return context.labelObsolete;
    case Label.hongKong:
      return context.labelHongKong;
    case Label.mainland:
      return context.labelMainland;
    case Label.taiwan:
      return context.labelTaiwan;
    case Label.macau:
      return context.labelMacau;
    case Label.japan:
      return context.labelJapan;
    case Label.loanword:
      return context.labelLoanword;
    case Label.invented:
      return context.labelInvented;
    case Label.justForFun:
      return context.labelJustForFun;
    case Label.plastictrans:
      return context.labelPlastictrans;
    case Label.written:
      return context.labelWritten;
    case Label.spoken:
      return context.labelSpoken;
    case Label.wrong:
      return context.labelWrong;
    case Label.classical:
      return context.labelClassical;
    case Label.nsfw:
      return context.labelNsfw;
    case Label.folkEtymology:
      return context.labelFolkEtymology;
  }
}

Widget showEntry(BuildContext context, List<Entry> entryGroup, int entryIndex,
    Script script, void Function(int) updateEntryIndex, OnTapLink onTapLink) {
  double rubyFontSize = Theme.of(context).textTheme.headlineSmall!.fontSize!;
  TextStyle lineTextStyle = Theme.of(context).textTheme.bodyMedium!;
  final localizationContext = AppLocalizations.of(context)!;
  return Column(
    children: [
      DefaultTabController(
        length: entryGroup.length,
        child: Expanded(
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
                insets: const EdgeInsets.symmetric(
                    horizontal: 30), // Indicator width
              ),
              tabs: entryGroup
                  .asMap()
                  .entries
                  .map((entry) => Tab(
                      text: (entry.key + 1).toString() +
                          " " +
                          entry.value.poses
                              .map((pos) =>
                                  translatePos(pos, localizationContext))
                              .join("/")))
                  .toList(),
            ),
            showTab(
                entryGroup[entryIndex],
                script,
                Theme.of(context).textTheme.headlineSmall!,
                Theme.of(context).textTheme.bodySmall!,
                lineTextStyle,
                Theme.of(context).colorScheme.secondary,
                rubyFontSize,
                onTapLink)
          ]),
        ),
      ),
    ],
    crossAxisAlignment: CrossAxisAlignment.start,
  );
}

Widget showVariants(
  List<Variant> variants,
  List<Variant> variantsSimp,
  Script script,
  TextStyle variantTextStyle,
  TextStyle prTextStyle,
  TextStyle lineTextStyle,
) =>
    variants.length <= 1
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: showVariant(
                script == Script.Simplified ? variantsSimp[0] : variants[0],
                variantTextStyle,
                prTextStyle))
        : ExpandableNotifier(
            child: applyExpandableTheme(Expandable(
                collapsed: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          showVariant(
                              script == Script.Simplified
                                  ? variantsSimp[0]
                                  : variants[0],
                              variantTextStyle,
                              prTextStyle),
                          Builder(builder: (context) {
                            return expandButton(
                                AppLocalizations.of(context)!.entryMoreVariants,
                                Icons.expand_more,
                                lineTextStyle.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary));
                          })
                        ])),
                expanded: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: variants
                                  .asMap()
                                  .entries
                                  .map((variant) => showVariant(
                                      script == Script.Simplified
                                          ? variantsSimp[variant.key]
                                          : variant.value,
                                      variantTextStyle,
                                      prTextStyle))
                                  .toList())),
                      Builder(builder: (context) {
                        return expandButton(
                            AppLocalizations.of(context)!.entryCollapseVariants,
                            Icons.expand_less,
                            lineTextStyle.copyWith(
                                color:
                                    Theme.of(context).colorScheme.secondary));
                      })
                    ]))));

Widget showVariant(
    Variant variant, TextStyle variantTextStyle, TextStyle prTextStyle) {
  var prs = variant.prs.split(", ");
  return Row(children: [
    SelectableText.rich(
      TextSpan(text: variant.word),
      style: variantTextStyle,
    ),
    const SizedBox(width: 10),
    ...prs.takeWhile((pr) => !pr.contains("!")).expand((pr) => [
          SelectableText.rich(
            TextSpan(text: pr),
            style: prTextStyle,
            // selectionWidthStyle: BoxWidthStyle.max,
          ),
          Visibility(
            visible: jyutpingFemaleSyllableNames.containsAll(pr.split(" ")),
            child: Builder(builder: (context) {
              return IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: "Pronunciation",
                alignment: Alignment.bottomLeft,
                icon: const Icon(Icons.volume_up),
                color: Theme.of(context).colorScheme.secondary,
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
              );
            }),
          )
        ])
  ]);
}

Widget showTab(
        Entry entry,
        Script script,
        TextStyle variantTextStyle,
        TextStyle prTextStyle,
        TextStyle lineTextStyle,
        Color linkColor,
        double rubyFontSize,
        OnTapLink onTapLink) =>
    Expanded(
      child: ListView.separated(
        itemBuilder: (context, index) => index == 0
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                showUnpublishedWarning(entry.published),
                showVariants(entry.variants, entry.variantsSimp, script,
                    variantTextStyle, prTextStyle, lineTextStyle),
                showLabels(entry.labels, lineTextStyle),
                showSimsOrAnts(
                    "[" + AppLocalizations.of(context)!.synonym + "]",
                    entry.sims,
                    lineTextStyle,
                    onTapLink),
                showSimsOrAnts(
                    "[" + AppLocalizations.of(context)!.antonym + "]",
                    entry.ants,
                    lineTextStyle,
                    onTapLink),
              ])
            : showDef(entry.defs[index - 1], script, lineTextStyle, linkColor,
                rubyFontSize, entry.defs.length == 1, onTapLink),
        separatorBuilder: (_, index) => index == 0
            ? SizedBox(height: lineTextStyle.fontSize!)
            : Divider(height: lineTextStyle.fontSize! * 2),
        itemCount: entry.defs.length + 1,
      ),
    );

Widget showUnpublishedWarning(bool published) =>
    EntryBanner(published: published);

Widget showSimsOrAnts(String label, List<String> simsOrAnts,
        TextStyle lineTextStyle, OnTapLink onTapLink) =>
    Visibility(
        visible: simsOrAnts.isNotEmpty,
        child: Builder(builder: (context) {
          return RichText(
              text: TextSpan(style: lineTextStyle, children: [
            WidgetSpan(
                child: RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                        text: label,
                        style: lineTextStyle.copyWith(
                            fontWeight: FontWeight.bold)))),
            const WidgetSpan(child: SizedBox(width: 10)),
            ...simsOrAnts.asMap().entries.map((sim) => TextSpan(children: [
                  ScalableTextSpan(context,
                      text: sim.value,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => onTapLink(sim.value)),
                  TextSpan(text: sim.key == simsOrAnts.length - 1 ? "" : " · ")
                ]))
          ]));
        }));

Widget showLabels(List<Label> labels, TextStyle lineTextStyle) => Visibility(
      visible: labels.isNotEmpty,
      child: Builder(builder: (context) {
        return RichText(
            text: TextSpan(children: [
          WidgetSpan(
              child: RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                      text: "[" + AppLocalizations.of(context)!.label + "]",
                      style: lineTextStyle.copyWith(
                          fontWeight: FontWeight.bold)))),
          ...labels
              .map((label) => [
                    const WidgetSpan(child: SizedBox(width: 10)),
                    WidgetSpan(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Chip(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: EdgeInsets.zero,
                          labelPadding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 2),
                          labelStyle: lineTextStyle.copyWith(color: whiteColor),
                          backgroundColor: greyColor,
                          label: Text(translateLabel(
                              label, AppLocalizations.of(context)!))),
                    ))
                  ])
              .expand((i) => i)
        ]));
      }),
    );

Widget showDef(Def def, Script script, TextStyle lineTextStyle, Color linkColor,
        double rubyFontSize, bool isSingleDef, OnTapLink onTapLink) =>
    Builder(builder: (context) {
      return Column(
        children: [
          showClause(
              script == Script.Simplified ? def.yueSimp : def.yue,
              "(" + AppLocalizations.of(context)!.cantonese + ") ",
              lineTextStyle,
              onTapLink),
          def.eng == null
              ? const SizedBox.shrink()
              : showClause(
                  def.eng!,
                  "(" + AppLocalizations.of(context)!.english + ") ",
                  lineTextStyle,
                  onTapLink),
          showEgs(def.egs, script, lineTextStyle, linkColor, rubyFontSize,
              isSingleDef, onTapLink)
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    });

Widget showEgs(
    List<Eg> egs,
    Script script,
    TextStyle lineTextStyle,
    Color linkColor,
    double rubyFontSize,
    bool isSingleDef,
    OnTapLink onTapLink) {
  if (egs.isEmpty) {
    return Container();
  } else if (egs.length == 1) {
    return showEg(
        egs[0], script, lineTextStyle, linkColor, rubyFontSize, onTapLink);
  } else if (isSingleDef) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: egs
            .map((eg) => showEg(
                eg, script, lineTextStyle, linkColor, rubyFontSize, onTapLink))
            .toList());
  } else {
    return ExpandableNotifier(
        child: applyExpandableTheme(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expandable(
            collapsed:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              showEg(egs[0], script, lineTextStyle, linkColor, rubyFontSize,
                  onTapLink),
              Builder(builder: (context) {
                return expandButton(
                    AppLocalizations.of(context)!.entryMoreExamples,
                    Icons.expand_more,
                    lineTextStyle.copyWith(
                        color: Theme.of(context).colorScheme.secondary));
              })
            ]),
            expanded:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ...egs
                  .map((eg) => showEg(eg, script, lineTextStyle, linkColor,
                      rubyFontSize, onTapLink))
                  .toList(),
              Builder(builder: (context) {
                return expandButton(
                    AppLocalizations.of(context)!.entryCollapseExamples,
                    Icons.expand_less,
                    lineTextStyle.copyWith(
                        color: Theme.of(context).colorScheme.secondary));
              })
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
    return Builder(builder: (context) {
      return SelectableText.rich(
        TextSpan(
          children: [
            TextSpan(
                text: tag, style: const TextStyle(fontWeight: FontWeight.bold)),
            ...line.segments
                .map((segment) => showSegment(segment,
                    Theme.of(context).colorScheme.secondary, onTapLink))
                .toList()
          ],
        ),
        style: lineTextStyle,
      );
    });
  }
}

TextSpan showSegment(Segment segment, Color linkColor, OnTapLink onTapLink) {
  switch (segment.type) {
    case SegmentType.text:
      return TextSpan(text: segment.segment);
    case SegmentType.link:
      return TextSpan(
          text: segment.segment,
          style: TextStyle(color: linkColor),
          recognizer: TapGestureRecognizer()
            ..onTap = () => onTapLink(segment.segment));
  }
}

Widget showEg(Eg eg, Script script, TextStyle lineTextStyle, Color linkColor,
    double rubyFontSize, OnTapLink onTapLink) {
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
                : showRichLine(
                    script == Script.Simplified ? eg.zhoSimp! : eg.zho!,
                    lineTextStyle,
                    linkColor,
                    rubyFontSize,
                    onTapLink),
            eg.yue == null
                ? const SizedBox.shrink()
                : showRichLine(
                    script == Script.Simplified ? eg.yueSimp! : eg.yue!,
                    lineTextStyle,
                    linkColor,
                    rubyFontSize,
                    onTapLink),
            eg.eng == null
                ? const SizedBox.shrink()
                : showLine(eg.eng!, "", lineTextStyle, onTapLink),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ));
}

Widget showRichLine(RichLine line, TextStyle lineTextStyle, Color linkColor,
    double rubyFontSize, OnTapLink onTapLink) {
  switch (line.type) {
    case RichLineType.ruby:
      return showRubyLine(
          line.line, lineTextStyle.color!, linkColor, rubyFontSize, onTapLink);
    case RichLineType.word:
      return showWordLine(
          line.line, lineTextStyle.color!, linkColor, rubyFontSize, onTapLink);
  }
}

Widget showRubyLine(RubyLine line, Color textColor, Color linkColor,
    double rubyFontSize, OnTapLink onTapLink) {
  return Builder(builder: (context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Padding(
      padding: EdgeInsets.only(top: rubyFontSize * textScaleFactor / 1.5),
      child: Wrap(
        runSpacing: rubyFontSize * textScaleFactor / 1.4,
        children: line.segments
            .map((segment) => showRubySegment(segment, textColor, linkColor,
                rubyFontSize, textScaleFactor, onTapLink))
            .expand((i) => i)
            .toList()
            .map((e) => Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisSize: MainAxisSize.min,
                  children: [e],
                ))
            .toList(),
      ),
    );
  });
}

List<Widget> showRubySegment(
    RubySegment segment,
    Color textColor,
    Color linkColor,
    double rubySize,
    double textScaleFactor,
    OnTapLink onTapLink) {
  double rubyYPos = rubySize * textScaleFactor;
  Widget text;
  String ruby;
  switch (segment.type) {
    case RubySegmentType.punc:
      text = Builder(builder: (context) {
        return RichText(
            text: ScalableTextSpan(context,
                text: segment.segment as String,
                style: TextStyle(
                    fontSize: rubySize, height: 1, color: textColor)));
      });
      ruby = "";
      break;
    case RubySegmentType.word:
      text = Builder(builder: (context) {
        return RichText(
            text: ScalableTextSpan(context,
                children: showWord(segment.segment.word as EntryWord),
                style: TextStyle(
                    fontSize: rubySize, height: 1, color: textColor)));
      });
      ruby = segment.segment.prs.join(" ");
      break;
    case RubySegmentType.linkedWord:
      return (segment.segment.words as List<RubySegmentWord>)
          .map((word) => showRubySegment(
              RubySegment(RubySegmentType.word, word),
              textColor,
              linkColor,
              rubySize,
              textScaleFactor,
              onTapLink))
          .expand((i) => i)
          .map((seg) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => onTapLink(segment.segment.toString()),
              child: seg))
          .toList();
  }
  return [
    Stack(alignment: Alignment.center, children: [
      Container(
          alignment: Alignment.bottomCenter,
          child: Center(
              child: Transform(
                  transform: Matrix4.translationValues(0, -(rubyYPos), 0),
                  child: Builder(builder: (context) {
                    return RichText(
                        text: ScalableTextSpan(context,
                            text: ruby,
                            style: TextStyle(
                                fontSize: rubySize * 0.5, color: textColor)));
                  })))),
      text
    ])
  ];
}

Widget showWordLine(WordLine line, Color textColor, Color linkColor,
    double fontSize, OnTapLink onTapLink) {
  return Builder(builder: (context) {
    return RichText(
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      text: TextSpan(
        children: line.segments
            .map((segment) =>
                showWordSegment(segment, linkColor, fontSize, onTapLink))
            .toList(),
        style: TextStyle(fontSize: fontSize, height: 1.2, color: textColor),
      ),
    );
  });
}

InlineSpan showWordSegment(WordSegment segment, Color linkColor,
    double fontSize, OnTapLink onTapLink) {
  switch (segment.type) {
    case SegmentType.text:
      return TextSpan(children: showWord(segment.word));
    case SegmentType.link:
      return WidgetSpan(
          child: GestureDetector(
        onTap: () => onTapLink(segment.word.toString()),
        child: Builder(builder: (context) {
          return RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: ScalableTextSpan(context,
                  children: showWord(segment.word),
                  style: TextStyle(color: linkColor, fontSize: fontSize)));
        }),
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
