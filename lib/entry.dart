class Entry {
  final int id;
  final List<Variant> variants;
  final List<String> poses;
  final List<String> labels;
  final List<String> sims;
  final List<String> ants;
  final List<Def> defs;

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
}

class Def {
  final Clause yue;
  final Clause? eng;
  final List<AltClause> alts;
  final List<Eg> egs;

  Def.fromJson(Map<String, dynamic> json)
      : yue = Clause.fromJson(json['yue']),
        eng = json['eng'] == null ? null : Clause.fromJson(json['eng']),
        alts = List.from(json['alts']).map((alt) {
          return AltClause.fromJson(alt);
        }).toList(),
        egs = List.from(json['egs']).map((eg) {
          return Eg.fromJson(eg);
        }).toList();
}

class Clause {
  final List<Line> lines;

  Clause.fromJson(List<String> json)
      : lines = List.from(json).map((line) {
          return Line.fromJson(line);
        }).toList();
}

class Line {
  final List<Segment> segments;

  Line.fromJson(List<String> json)
      : segments = List.from(json).map((segment) {
          return Segment.fromJson(segment);
        }).toList();
}

enum SegmentType {
  text,
  link,
}

SegmentType segmentTypeFromString(String string) {
  return string == 'Text' ? SegmentType.text : SegmentType.link;
}

class Segment {
  final SegmentType type;
  final String segment;

  Segment.fromJson(List<String> json)
      : type = segmentTypeFromString(json[0]),
        segment = json[1];
}

enum RichLineType {
  ruby,
  word,
}

class RichLine {
  final RichLineType type;
  final dynamic line;

  RichLine.fromJson(Map<String, dynamic> json)
      : type = json['Ruby'] != null ? RichLineType.ruby : RichLineType.word,
        line = json['Ruby'] != null
            ? RubyLine.fromJson(json['Ruby'])
            : WordLine.fromJson(json['Word']);
}

class RubyLine {
  final List<RubySegment> segments;

  RubyLine.fromJson(List<dynamic> json)
      : segments = json.map((segment) {
          return RubySegment.fromJson(segment);
        }).toList();
}

enum RubySegmentType {
  punc,
  word,
  linkedWord,
}

class RubySegment {
  final RubySegmentType type;
  final dynamic segment;

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
}

class RubySegmentWord {
  final Word word;
  final List<String> prs;

  RubySegmentWord.fromJson(List<dynamic> json)
      : word = Word.fromJson(json[0]),
        prs = List.from(json);
}

class RubySegmentLinkedWord {
  final List<RubySegmentWord> words;

  RubySegmentLinkedWord.fromJson(List<dynamic> json)
      : words = List.from(json).map((word) {
          return RubySegmentWord.fromJson(word);
        }).toList();
}

class WordLine {
  final List<WordSegment> segments;

  WordLine.fromJson(List<dynamic> json)
      : segments = List.from(json).map((word) {
          return WordSegment.fromJson(word);
        }).toList();
}

class WordSegment {
  final SegmentType type;
  final Word word;

  WordSegment.fromJson(List<dynamic> json)
      : type = segmentTypeFromString(json[0]),
        word = Word.fromJson(json[1]);
}

class Word {
  final List<Text> texts;

  Word.fromJson(List<dynamic> json)
      : texts = List.from(json).map((text) {
          return Text.fromJson(text);
        }).toList();
}

enum TextStyle {
  bold,
  normal,
}

class Text {
  final TextStyle style;
  final String text;

  Text.fromJson(List<String> json)
      : style = json[0] == 'Bold' ? TextStyle.bold : TextStyle.normal,
        text = json[1];
}

class Eg {
  final RichLine? zho;
  final RichLine? yue;
  final Line? eng;

  Eg.fromJson(Map<String, dynamic> json)
      : zho = json['zho'] == null ? null : RichLine.fromJson(json['zho']),
        yue = json['yue'] == null ? null : RichLine.fromJson(json['yue']),
        eng = json['eng'] == null ? null : Line.fromJson(json['eng']);
}

class AltClause {
  // TODO: Change to enum
  final String altLang;
  final Clause clause;

  AltClause.fromJson(List<dynamic> json)
      : altLang = json[0],
        clause = Clause.fromJson(json[1]);
}

class Variant {
  final String word;
  final String prs;

  Variant.fromJson(Map<String, dynamic> json)
      : word = json['word'],
        prs = json['prs'];
}
