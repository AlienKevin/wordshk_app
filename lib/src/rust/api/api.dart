// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.4.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Stream<String> createLogStream({dynamic hint}) =>
    RustLib.instance.api.createLogStream(hint: hint);

Future<void> initApi(
        {required Uint8List dictData,
        required Uint8List englishIndexData,
        dynamic hint}) =>
    RustLib.instance.api.initApi(
        dictData: dictData, englishIndexData: englishIndexData, hint: hint);

Future<List<EntrySummary>> getEntrySummaries(
        {required Uint32List entryIds, required Script script, dynamic hint}) =>
    RustLib.instance.api
        .getEntrySummaries(entryIds: entryIds, script: script, hint: hint);

Future<void> generatePrIndices(
        {required Romanization romanization, dynamic hint}) =>
    RustLib.instance.api
        .generatePrIndices(romanization: romanization, hint: hint);

Future<List<PrSearchResult>> prSearch(
        {required int capacity,
        required String query,
        required Script script,
        required Romanization romanization,
        dynamic hint}) =>
    RustLib.instance.api.prSearch(
        capacity: capacity,
        query: query,
        script: script,
        romanization: romanization,
        hint: hint);

Future<List<VariantSearchResult>> variantSearch(
        {required int capacity,
        required String query,
        required Script script,
        dynamic hint}) =>
    RustLib.instance.api.variantSearch(
        capacity: capacity, query: query, script: script, hint: hint);

Future<CombinedSearchResults> combinedSearch(
        {required int capacity,
        required String query,
        required Script script,
        required Romanization romanization,
        dynamic hint}) =>
    RustLib.instance.api.combinedSearch(
        capacity: capacity,
        query: query,
        script: script,
        romanization: romanization,
        hint: hint);

Future<List<EnglishSearchResult>> englishSearch(
        {required int capacity,
        required String query,
        required Script script,
        dynamic hint}) =>
    RustLib.instance.api.englishSearch(
        capacity: capacity, query: query, script: script, hint: hint);

Future<(String?, List<EgSearchResult>)> egSearch(
        {required int capacity,
        required int maxFirstIndexInEg,
        required String query,
        required Script script,
        dynamic hint}) =>
    RustLib.instance.api.egSearch(
        capacity: capacity,
        maxFirstIndexInEg: maxFirstIndexInEg,
        query: query,
        script: script,
        hint: hint);

Future<List<SpotlightEntrySummary>> getSplotlightSummaries({dynamic hint}) =>
    RustLib.instance.api.getSplotlightSummaries(hint: hint);

Future<String> getEntryJson({required int id, dynamic hint}) =>
    RustLib.instance.api.getEntryJson(id: id, hint: hint);

Future<List<String>> getEntryGroupJson({required int id, dynamic hint}) =>
    RustLib.instance.api.getEntryGroupJson(id: id, hint: hint);

Future<int?> getEntryId(
        {required String query, required Script script, dynamic hint}) =>
    RustLib.instance.api.getEntryId(query: query, script: script, hint: hint);

Future<List<String>> getJyutping({required String query, dynamic hint}) =>
    RustLib.instance.api.getJyutping(query: query, hint: hint);

class CombinedSearchResults {
  final List<VariantSearchResult> variantResults;
  final List<PrSearchResult> prResults;
  final List<EnglishSearchResult> englishResults;

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
  final String eg;

  const EgSearchResult({
    required this.id,
    required this.defIndex,
    required this.egIndex,
    required this.eg,
  });

  @override
  int get hashCode =>
      id.hashCode ^ defIndex.hashCode ^ egIndex.hashCode ^ eg.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EgSearchResult &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          defIndex == other.defIndex &&
          egIndex == other.egIndex &&
          eg == other.eg;
}

class EnglishSearchResult {
  final int id;
  final int defIndex;
  final String variant;
  final String pr;
  final List<MatchedSegment> matchedEng;

  const EnglishSearchResult({
    required this.id,
    required this.defIndex,
    required this.variant,
    required this.pr,
    required this.matchedEng,
  });

  @override
  int get hashCode =>
      id.hashCode ^
      defIndex.hashCode ^
      variant.hashCode ^
      pr.hashCode ^
      matchedEng.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnglishSearchResult &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          defIndex == other.defIndex &&
          variant == other.variant &&
          pr == other.pr &&
          matchedEng == other.matchedEng;
}

class EntrySummary {
  final String variant;
  final List<(String, String)> defs;

  const EntrySummary({
    required this.variant,
    required this.defs,
  });

  @override
  int get hashCode => variant.hashCode ^ defs.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntrySummary &&
          runtimeType == other.runtimeType &&
          variant == other.variant &&
          defs == other.defs;
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

class MatchedVariant {
  final String prefix;
  final String query;
  final String suffix;

  const MatchedVariant({
    required this.prefix,
    required this.query,
    required this.suffix,
  });

  @override
  int get hashCode => prefix.hashCode ^ query.hashCode ^ suffix.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchedVariant &&
          runtimeType == other.runtimeType &&
          prefix == other.prefix &&
          query == other.query &&
          suffix == other.suffix;
}

class PrSearchResult {
  final int id;
  final String variant;
  final List<MatchedSegment> matchedPr;
  final List<String> yues;
  final List<String> engs;

  const PrSearchResult({
    required this.id,
    required this.variant,
    required this.matchedPr,
    required this.yues,
    required this.engs,
  });

  @override
  int get hashCode =>
      id.hashCode ^
      variant.hashCode ^
      matchedPr.hashCode ^
      yues.hashCode ^
      engs.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrSearchResult &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          variant == other.variant &&
          matchedPr == other.matchedPr &&
          yues == other.yues &&
          engs == other.engs;
}

enum Romanization {
  jyutping,
  yale,
}

enum Script {
  simplified,
  traditional,
}

class SpotlightEntrySummary {
  final int id;
  final List<String> variants;
  final List<String> variantsSimp;
  final List<String> jyutpings;
  final List<String> yales;
  final String def;
  final String defSimp;
  final String defEn;

  const SpotlightEntrySummary({
    required this.id,
    required this.variants,
    required this.variantsSimp,
    required this.jyutpings,
    required this.yales,
    required this.def,
    required this.defSimp,
    required this.defEn,
  });

  @override
  int get hashCode =>
      id.hashCode ^
      variants.hashCode ^
      variantsSimp.hashCode ^
      jyutpings.hashCode ^
      yales.hashCode ^
      def.hashCode ^
      defSimp.hashCode ^
      defEn.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpotlightEntrySummary &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          variants == other.variants &&
          variantsSimp == other.variantsSimp &&
          jyutpings == other.jyutpings &&
          yales == other.yales &&
          def == other.def &&
          defSimp == other.defSimp &&
          defEn == other.defEn;
}

class VariantSearchResult {
  final int id;
  final MatchedVariant matchedVariant;
  final List<String> yues;
  final List<String> engs;

  const VariantSearchResult({
    required this.id,
    required this.matchedVariant,
    required this.yues,
    required this.engs,
  });

  @override
  int get hashCode =>
      id.hashCode ^ matchedVariant.hashCode ^ yues.hashCode ^ engs.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VariantSearchResult &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          matchedVariant == other.matchedVariant &&
          yues == other.yues &&
          engs == other.engs;
}
