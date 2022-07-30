import 'package:equatable/equatable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef OnTapLink = void Function(String entryVariant);
typedef EntryGroup = List<Entry>;

class Entry extends Equatable {
  final int id;
  final List<Variant> variants;
  final List<Variant> variantsSimp;
  final List<Pos> poses;
  final List<Label> labels;
  final List<Segment> sims;
  final List<String> simsSimp;
  final List<Segment> ants;
  final List<String> antsSimp;
  final List<Def> defs;
  final bool published;

  const Entry({
    required this.id,
    required this.variants,
    required this.variantsSimp,
    required this.poses,
    required this.labels,
    required this.sims,
    required this.simsSimp,
    required this.ants,
    required this.antsSimp,
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
        sims = List.from(json['sims']).map((segment) {
          return Segment.fromJson(segment);
        }).toList(),
        simsSimp = List.from(json['sims_simp']),
        ants = List.from(json['ants']).map((segment) {
          return Segment.fromJson(segment);
        }).toList(),
        antsSimp = List.from(json['ants_simp']),
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
  final List<Eg> egs;

  const Def({
    required this.yue,
    required this.yueSimp,
    required this.eng,
    required this.egs,
  });

  Def.fromJson(Map<String, dynamic> json)
      : yue = Clause.fromJson(json['yue']),
        yueSimp = Clause.fromJson(json['yue_simp']),
        eng = json['eng'] == null ? null : Clause.fromJson(json['eng']),
        egs = List.from(json['egs']).map((eg) {
          return Eg.fromJson(eg);
        }).toList();

  @override
  List<Object?> get props => [yue, eng, egs];
}

class Clause extends Equatable {
  final List<Line> lines;

  const Clause(this.lines);

  Clause.fromJson(List<dynamic> json)
      : lines = List.from(json).map((line) {
          return Line.fromJson(line);
        }).toList();

  @override
  String toString() => lines.map((line) => line.toString()).join("\n");

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
  String toString() => segments.join("");

  @override
  List<Object?> get props => [segments];
}

enum SegmentType {
  text,
  link,
}

SegmentType segmentTypeFromString(String string) {
  return string == 'T' ? SegmentType.text : SegmentType.link;
}

class Segment extends Equatable {
  final SegmentType type;
  final String segment;

  const Segment(this.type, this.segment);

  Segment.fromJson(List<dynamic> json)
      : type = segmentTypeFromString(json[0]),
        segment = json[1];

  @override
  String toString() => segment;

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
      : type = json['R'] != null ? RichLineType.ruby : RichLineType.word,
        line = json['R'] != null
            ? RubyLine.fromJson(json['R'])
            : WordLine.fromJson(json['T']);

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
  String toString() => segments.map((seg) => seg.toString()).join("");

  String toPrs() => segments.map((seg) => seg.toPrs()).join(" ");

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
      : type = json['P'] != null
            ? RubySegmentType.punc
            : (json['W'] != null
                ? RubySegmentType.word
                : RubySegmentType.linkedWord),
        segment = json['P'] ??
            (json['W'] != null
                ? RubySegmentWord.fromJson(json['W'])
                : RubySegmentLinkedWord.fromJson(json['L']));

  @override
  String toString() => segment.toString();

  String toPrs() {
    switch (type) {
      case RubySegmentType.punc:
        return segment;
      case RubySegmentType.word:
        return segment.toPrs();
      case RubySegmentType.linkedWord:
        return segment.toPrs();
    }
  }

  @override
  List<Object?> get props => [type, segment];
}

class RubySegmentWord extends Equatable {
  final EntryWord word;
  final List<String> prs;
  final List<int?> prsTones;

  const RubySegmentWord(this.word, this.prs, this.prsTones);

  RubySegmentWord.fromJson(List<dynamic> json)
      : word = EntryWord.fromJson(json[0]),
        prs = List.from(json[1]),
        prsTones = List.from(json[1])
            .map((pr) => int.tryParse(pr[pr.length - 1]))
            .toList();

  @override
  String toString() => word.toString();

  String toPrs() => prs.join(" ");

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

  String toPrs() => words.map((word) => word.toPrs()).join(" ");
}

class WordLine extends Equatable {
  final List<WordSegment> segments;

  const WordLine(this.segments);

  WordLine.fromJson(List<dynamic> json)
      : segments = List.from(json).map((word) {
          return WordSegment.fromJson(word);
        }).toList();

  @override
  String toString() => segments.join("");

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
  String toString() => word.toString();

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
      : style = json[0] == 'B' ? EntryTextStyle.bold : EntryTextStyle.normal,
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
