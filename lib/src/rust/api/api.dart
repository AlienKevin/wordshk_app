// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// These functions are ignored because they are not marked as `pub`: `english_ranks_to_results`, `get_entry_defs`, `pr_ranks_to_results`, `variant_ranks_to_results`
// These types are ignored because they are not used by any `pub` functions: `log_stream_sink`
// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `deref`, `initialize`

Stream<String> createLogStream() =>
    RustLib.instance.api.crateApiApiCreateLogStream();

Future<void> initApi({required String dictPath, required List<int> dictZip}) =>
    RustLib.instance.api
        .crateApiApiInitApi(dictPath: dictPath, dictZip: dictZip);

Future<List<EntrySummary>> getEntrySummaries({required List<int> entryIds}) =>
    RustLib.instance.api.crateApiApiGetEntrySummaries(entryIds: entryIds);

Future<CombinedSearchResults> combinedSearch(
        {required int capacity,
        required String query,
        required Script script,
        required Romanization romanization}) =>
    RustLib.instance.api.crateApiApiCombinedSearch(
        capacity: capacity,
        query: query,
        script: script,
        romanization: romanization);

Future<List<EgSearchResult>> egSearch(
        {required int capacity,
        required int maxFirstIndexInEg,
        required String query,
        required Script script}) =>
    RustLib.instance.api.crateApiApiEgSearch(
        capacity: capacity,
        maxFirstIndexInEg: maxFirstIndexInEg,
        query: query,
        script: script);

Future<String> getEntryJson({required int id}) =>
    RustLib.instance.api.crateApiApiGetEntryJson(id: id);

Future<List<String>> getEntryGroupJson({required int id}) =>
    RustLib.instance.api.crateApiApiGetEntryGroupJson(id: id);

Future<int?> getEntryId({required String query, required Script script}) =>
    RustLib.instance.api.crateApiApiGetEntryId(query: query, script: script);

class CombinedSearchResults {
  final (int?, List<VariantSearchResult>) variantResults;
  final (int?, List<PrSearchResult>) prResults;
  final (int?, List<EnglishSearchResult>) englishResults;

  const CombinedSearchResults({
    required this.variantResults,
    required this.prResults,
    required this.englishResults,
  });

  @override
  int get hashCode =>
      variantResults.hashCode ^ prResults.hashCode ^ englishResults.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CombinedSearchResults &&
          runtimeType == other.runtimeType &&
          variantResults == other.variantResults &&
          prResults == other.prResults &&
          englishResults == other.englishResults;
}

class EgSearchResult {
  final int id;
  final int defIndex;
  final int egIndex;
  final MatchedInfix matchedEg;

  const EgSearchResult({
    required this.id,
    required this.defIndex,
    required this.egIndex,
    required this.matchedEg,
  });

  @override
  int get hashCode =>
      id.hashCode ^ defIndex.hashCode ^ egIndex.hashCode ^ matchedEg.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EgSearchResult &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          defIndex == other.defIndex &&
          egIndex == other.egIndex &&
          matchedEg == other.matchedEg;
}

class EnglishSearchResult {
  final int id;
  final int defIndex;
  final List<String> variants;
  final List<MatchedSegment> matchedEng;

  const EnglishSearchResult({
    required this.id,
    required this.defIndex,
    required this.variants,
    required this.matchedEng,
  });

  @override
  int get hashCode =>
      id.hashCode ^ defIndex.hashCode ^ variants.hashCode ^ matchedEng.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnglishSearchResult &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          defIndex == other.defIndex &&
          variants == other.variants &&
          matchedEng == other.matchedEng;
}

class EntryDef {
  final String yueTrad;
  final String yueSimp;
  final String eng;

  const EntryDef({
    required this.yueTrad,
    required this.yueSimp,
    required this.eng,
  });

  @override
  int get hashCode => yueTrad.hashCode ^ yueSimp.hashCode ^ eng.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntryDef &&
          runtimeType == other.runtimeType &&
          yueTrad == other.yueTrad &&
          yueSimp == other.yueSimp &&
          eng == other.eng;
}

class EntrySummary {
  final String variantTrad;
  final String variantSimp;
  final List<EntryDef> defs;

  const EntrySummary({
    required this.variantTrad,
    required this.variantSimp,
    required this.defs,
  });

  @override
  int get hashCode =>
      variantTrad.hashCode ^ variantSimp.hashCode ^ defs.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntrySummary &&
          runtimeType == other.runtimeType &&
          variantTrad == other.variantTrad &&
          variantSimp == other.variantSimp &&
          defs == other.defs;
}

class MatchedInfix {
  final String prefix;
  final String query;
  final String suffix;

  const MatchedInfix({
    required this.prefix,
    required this.query,
    required this.suffix,
  });

  @override
  int get hashCode => prefix.hashCode ^ query.hashCode ^ suffix.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchedInfix &&
          runtimeType == other.runtimeType &&
          prefix == other.prefix &&
          query == other.query &&
          suffix == other.suffix;
}

class MatchedSegment {
  final String segment;
  final bool matched;

  const MatchedSegment({
    required this.segment,
    required this.matched,
  });

  @override
  int get hashCode => segment.hashCode ^ matched.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchedSegment &&
          runtimeType == other.runtimeType &&
          segment == other.segment &&
          matched == other.matched;
}

class PrSearchResult {
  final int id;
  final List<String> variants;
  final List<MatchedSegment> matchedPr;
  final List<String> yues;
  final List<String> engs;

  const PrSearchResult({
    required this.id,
    required this.variants,
    required this.matchedPr,
    required this.yues,
    required this.engs,
  });

  @override
  int get hashCode =>
      id.hashCode ^
      variants.hashCode ^
      matchedPr.hashCode ^
      yues.hashCode ^
      engs.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrSearchResult &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          variants == other.variants &&
          matchedPr == other.matchedPr &&
          yues == other.yues &&
          engs == other.engs;
}

enum Romanization {
  jyutping,
  yale,
  ;
}

enum Script {
  simplified,
  traditional,
  ;
}

class VariantSearchResult {
  final int id;
  final MatchedInfix matchedVariant;
  final List<String> prs;
  final List<String> yues;
  final List<String> engs;

  const VariantSearchResult({
    required this.id,
    required this.matchedVariant,
    required this.prs,
    required this.yues,
    required this.engs,
  });

  @override
  int get hashCode =>
      id.hashCode ^
      matchedVariant.hashCode ^
      prs.hashCode ^
      yues.hashCode ^
      engs.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VariantSearchResult &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          matchedVariant == other.matchedVariant &&
          prs == other.prs &&
          yues == other.yues &&
          engs == other.engs;
}
