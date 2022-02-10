import 'dart:convert';
import 'package:test/test.dart';
import '../lib/entry.dart';

void main() {
  test('simple', () {
    var json = """{
	"id": 56534,
	"variants": [
		{
			"word": "命",
			"prs": "ming6"
		}
	],
	"poses": [
		"語素"
	],
	"labels": [],
	"sims": [],
	"ants": [],
	"defs": [
		{
			"yue": [
				[
					[
						"Link",
						"命"
					],
					[
						"Text",
						"（meng6）嘅讀書音，通常用喺配詞"
					]
				]
			],
			"eng": [
				[
					[
						"Text",
						"life; fate; the literary pronunciation for 命 meng6, usually used in compounds"
					]
				]
			],
			"alts": [],
			"egs": [
				{
					"zho": null,
					"yue": {
						"Ruby": [
							{
								"LinkedWord": [
									[
										[
											[
												"Normal",
												"性"
											]
										],
										[
											"sing3"
										]
									],
									[
										[
											[
												"Bold",
												"命"
											]
										],
										[
											"ming6"
										]
									]
								]
							}
						]
					},
					"eng": [
						[
							"Text",
							"life; lives"
						]
					]
				}
			]
		}
	]
}""";
    var expectedEntry = const Entry(
      id: 56534,
      variants: [Variant("命", "ming6")],
      poses: ["語素"],
      labels: [],
      sims: [],
      ants: [],
      defs: [
        Def(
            yue: Clause([
              Line([
                Segment(SegmentType.link, "命"),
                Segment(SegmentType.text, "（meng6）嘅讀書音，通常用喺配詞")
              ])
            ]),
            eng: Clause([
              Line([
                Segment(SegmentType.text,
                    "life; fate; the literary pronunciation for 命 meng6, usually used in compounds")
              ])
            ]),
            alts: [],
            egs: [
              Eg(
                  zho: null,
                  yue: RichLine(
                      RichLineType.ruby,
                      RubyLine([
                        RubySegment(
                            RubySegmentType.linkedWord,
                            RubySegmentLinkedWord([
                              RubySegmentWord(
                                  Word([Text(TextStyle.normal, "性")]),
                                  ["sing3"]),
                              RubySegmentWord(
                                  Word([Text(TextStyle.bold, "命")]), ["ming6"])
                            ]))
                      ])),
                  eng: Line([Segment(SegmentType.text, "life; lives")]))
            ])
      ],
    );
    expect(Entry.fromJson(jsonDecode(json)), equals(expectedEntry));
  });
}
