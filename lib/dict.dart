import 'package:wordshk/bridge_generated.dart';

import 'models/entry.dart';

late final Dict dict;

int? getEntryId(String query, Script script) {
  for (var entry in dict.values) {
    final variants = switch (script) {
      Script.Simplified => entry.variants,
      Script.Traditional => entry.variantsSimp,
    };
    for (final variant in variants) {
      if (variant.word == query) {
        return entry.id;
      }
    }
  }
  return null;
}
