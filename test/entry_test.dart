import 'dart:convert';
import 'package:test/test.dart';
import '../lib/entry.dart';

void main() {
  test('header only', () {
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
	"defs": []
}""";
    var expectedEntry = const Entry(
      id: 56534,
      variants: [Variant("命", "ming6")],
      poses: ["語素"],
      labels: [],
      sims: [],
      ants: [],
      defs: [],
    );
    expect(Entry.fromJson(jsonDecode(json)), equals(expectedEntry));
  });
}
