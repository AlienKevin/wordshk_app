import 'dart:convert';

import 'package:test/test.dart';
import 'package:wordshk/models/entry.dart';

void main() {
  test('simple', () {
    var json = """{"id":56534,"variants":[{"word":"命","prs":"ming6"}],
        "variants_simp":[{"word":"命","prs":"ming6"}],
        "poses":["語素"],"labels":[],
        "sims":[["L","s1"],["T","s2"]],"ants":[["L","a1"],["T","a2"]],
        "sims_simp":["ss1","ss2"],"ants_simp":["as1","as2"],
        "defs":[
          {"yue":[[["L","命"],["T","（meng6）嘅讀書音，通常用喺配詞"]]],
          "yue_simp":[[["L","命"],["T","（meng6）嘅读书音，通常用喺配词"]]],
          "eng":[[["T","life; fate; the literary pronunciation for 命 meng6, usually used in compounds"]]],
          "egs":[
            {"zho":null,
            "zho_simp":null,
            "yue":{"R":[{"L":[[[["N","性"]],["sing3"]],[[["B","命"]],["ming6"]]]}]},
            "yue_simp":{"R":[{"L":[[[["N","性"]],["sing3"]],[[["B","命"]],["ming6"]]]}]},
            "eng":[["T","life; lives"]]}
          ]}
        ],
        "published":true
    }""";
    var expectedEntry = const Entry(
      id: 56534,
      variants: [Variant("命", "ming6")],
      variantsSimp: [Variant("命", "ming6")],
      poses: [Pos.morpheme],
      labels: [],
      sims: [Segment(SegmentType.link, "s1"), Segment(SegmentType.text, "s2")],
      simsSimp: ["ss1", "ss2"],
      ants: [Segment(SegmentType.link, "a1"), Segment(SegmentType.text, "a2")],
      antsSimp: ["as1", "as2"],
      defs: [
        Def(
            yue: Clause([
              Line([
                Segment(SegmentType.link, "命"),
                Segment(SegmentType.text, "（meng6）嘅讀書音，通常用喺配詞")
              ])
            ]),
            yueSimp: Clause([
              Line([
                Segment(SegmentType.link, "命"),
                Segment(SegmentType.text, "（meng6）嘅读书音，通常用喺配词")
              ])
            ]),
            eng: Clause([
              Line([
                Segment(SegmentType.text,
                    "life; fate; the literary pronunciation for 命 meng6, usually used in compounds")
              ])
            ]),
            egs: [
              Eg(
                  zho: null,
                  zhoSimp: null,
                  yue: RichLine(
                      RichLineType.ruby,
                      RubyLine([
                        RubySegment(
                            RubySegmentType.linkedWord,
                            RubySegmentLinkedWord([
                              RubySegmentWord(
                                  EntryWord(
                                      [EntryText(EntryTextStyle.normal, "性")]),
                                  ["sing3"],
                                  [3]),
                              RubySegmentWord(
                                  EntryWord(
                                      [EntryText(EntryTextStyle.bold, "命")]),
                                  ["ming6"],
                                  [6])
                            ]))
                      ])),
                  yueSimp: RichLine(
                      RichLineType.ruby,
                      RubyLine([
                        RubySegment(
                            RubySegmentType.linkedWord,
                            RubySegmentLinkedWord([
                              RubySegmentWord(
                                  EntryWord(
                                      [EntryText(EntryTextStyle.normal, "性")]),
                                  ["sing3"],
                                  [3]),
                              RubySegmentWord(
                                  EntryWord(
                                      [EntryText(EntryTextStyle.bold, "命")]),
                                  ["ming6"],
                                  [6])
                            ]))
                      ])),
                  eng: Line([Segment(SegmentType.text, "life; lives")]))
            ])
      ],
      published: true,
    );
    expect(Entry.fromJson(jsonDecode(json)), equals(expectedEntry));
  });

  test('Yue eg sentence no prs gloss', () {
    var json = """
    {"id":108744,
    "variants": [{"word":"呢個","prs":"ni1 go3, li1 go3"},{"word":"哩個","prs":"ni1 go3, li1 go3"}],
    "variants_simp": [{"word":"呢个","prs":"ni1 go3, li1 go3"},{"word":"哩个","prs":"ni1 go3, li1 go3"}],
    "poses":["代詞"],"labels":[],
    "sims":[], "sims_simp":[], "ants":[], "ants_simp":[],
    "defs":[
      {"yue":[[["T","指稱接近自己嘅嘢"]]],
      "yue_simp":[[["T","指称接近自己嘅嘢"]]],
      "eng":[[["T","this; something close to the speaker"]]],
      "alts":[],
      "egs":[
      {
        "zho":null,
        "zho_simp":null,
        "yue":{"T":[["T",[["N","我"]]],["T",[["B","呢"]]]]},
        "yue_simp":{"T":[["T",[["N","我"]]],["T",[["B","呢"]]]]},
        "eng":[["T","I think that this person is pretty suspicious."]]
      }
      ]}],
      "published": false
      }""";
    var expectedEntry = const Entry(
      id: 108744,
      variants: [
        Variant("呢個", "ni1 go3, li1 go3"),
        Variant("哩個", "ni1 go3, li1 go3")
      ],
      variantsSimp: [
        Variant("呢个", "ni1 go3, li1 go3"),
        Variant("哩个", "ni1 go3, li1 go3")
      ],
      poses: [Pos.pronoun],
      labels: [],
      sims: [],
      simsSimp: [],
      ants: [],
      antsSimp: [],
      defs: [
        Def(
            yue: Clause([
              Line([
                Segment(SegmentType.text, "指稱接近自己嘅嘢"),
              ])
            ]),
            yueSimp: Clause([
              Line([
                Segment(SegmentType.text, "指称接近自己嘅嘢"),
              ])
            ]),
            eng: Clause([
              Line([
                Segment(
                    SegmentType.text, "this; something close to the speaker")
              ])
            ]),
            egs: [
              Eg(
                  zho: null,
                  zhoSimp: null,
                  yue: RichLine(
                      RichLineType.word,
                      WordLine([
                        WordSegment(
                            SegmentType.text,
                            EntryWord([
                              EntryText(EntryTextStyle.normal, "我"),
                            ])),
                        WordSegment(SegmentType.text,
                            EntryWord([EntryText(EntryTextStyle.bold, "呢")]))
                      ])),
                  yueSimp: RichLine(
                      RichLineType.word,
                      WordLine([
                        WordSegment(
                            SegmentType.text,
                            EntryWord([
                              EntryText(EntryTextStyle.normal, "我"),
                            ])),
                        WordSegment(SegmentType.text,
                            EntryWord([EntryText(EntryTextStyle.bold, "呢")]))
                      ])),
                  eng: Line([
                    Segment(SegmentType.text,
                        "I think that this person is pretty suspicious.")
                  ]))
            ])
      ],
      published: false,
    );
    expect(Entry.fromJson(jsonDecode(json)), equals(expectedEntry));
  });
}
