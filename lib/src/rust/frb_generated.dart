// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.11.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables

import 'api/api.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.io.dart' if (dart.library.html) 'frb_generated.web.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

/// Main entrypoint of the Rust API
class RustLib extends BaseEntrypoint<RustLibApi, RustLibApiImpl, RustLibWire> {
  @internal
  static final instance = RustLib._();

  RustLib._();

  /// Initialize flutter_rust_bridge
  static Future<void> init({
    RustLibApi? api,
    BaseHandler? handler,
    ExternalLibrary? externalLibrary,
  }) async {
    await instance.initImpl(
      api: api,
      handler: handler,
      externalLibrary: externalLibrary,
    );
  }

  /// Dispose flutter_rust_bridge
  ///
  /// The call to this function is optional, since flutter_rust_bridge (and everything else)
  /// is automatically disposed when the app stops.
  static void dispose() => instance.disposeImpl();

  @override
  ApiImplConstructor<RustLibApiImpl, RustLibWire> get apiImplConstructor =>
      RustLibApiImpl.new;

  @override
  WireConstructor<RustLibWire> get wireConstructor =>
      RustLibWire.fromExternalLibrary;

  @override
  Future<void> executeRustInitializers() async {
    await api.initUtils();
  }

  @override
  ExternalLibraryLoaderConfig get defaultExternalLibraryLoaderConfig =>
      kDefaultExternalLibraryLoaderConfig;

  static const kDefaultExternalLibraryLoaderConfig =
      ExternalLibraryLoaderConfig(
    stem: 'rust_lib',
    ioDirectory: 'rust/target/release/',
    webPrefix: 'pkg/',
  );
}

abstract class RustLibApi extends BaseApi {
  Future<CombinedSearchResults> combinedSearch(
      {required int capacity,
      required String query,
      required Script script,
      required Romanization romanization,
      dynamic hint});

  Stream<String> createLogStream({dynamic hint});

  Future<List<EgSearchResult>> egSearch(
      {required int capacity,
      required int maxFirstIndexInEg,
      required String query,
      required Script script,
      dynamic hint});

  Future<void> generatePrIndices(
      {required Romanization romanization, dynamic hint});

  Future<List<String>> getEntryGroupJson({required int id, dynamic hint});

  Future<int?> getEntryId(
      {required String query, required Script script, dynamic hint});

  Future<String> getEntryJson({required int id, dynamic hint});

  Future<List<EntrySummary>> getEntrySummaries(
      {required Uint32List entryIds, dynamic hint});

  Future<List<String>> getJyutping({required String query, dynamic hint});

  Future<void> initApi({dynamic hint});

  Future<void> initUtils({dynamic hint});
}

class RustLibApiImpl extends RustLibApiImplPlatform implements RustLibApi {
  RustLibApiImpl({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  @override
  Future<CombinedSearchResults> combinedSearch(
      {required int capacity,
      required String query,
      required Script script,
      required Romanization romanization,
      dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        var arg0 = cst_encode_u_32(capacity);
        var arg1 = cst_encode_String(query);
        var arg2 = cst_encode_script(script);
        var arg3 = cst_encode_romanization(romanization);
        return wire.wire_combined_search(port_, arg0, arg1, arg2, arg3);
      },
      codec: DcoCodec(
        decodeSuccessData: dco_decode_combined_search_results,
        decodeErrorData: null,
      ),
      constMeta: kCombinedSearchConstMeta,
      argValues: [capacity, query, script, romanization],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kCombinedSearchConstMeta => const TaskConstMeta(
        debugName: "combined_search",
        argNames: ["capacity", "query", "script", "romanization"],
      );

  @override
  Stream<String> createLogStream({dynamic hint}) {
    return handler.executeStream(StreamTask(
      callFfi: (port_) {
        return wire.wire_create_log_stream(port_);
      },
      codec: DcoCodec(
        decodeSuccessData: dco_decode_String,
        decodeErrorData: null,
      ),
      constMeta: kCreateLogStreamConstMeta,
      argValues: [],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kCreateLogStreamConstMeta => const TaskConstMeta(
        debugName: "create_log_stream",
        argNames: [],
      );

  @override
  Future<List<EgSearchResult>> egSearch(
      {required int capacity,
      required int maxFirstIndexInEg,
      required String query,
      required Script script,
      dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        var arg0 = cst_encode_u_32(capacity);
        var arg1 = cst_encode_u_32(maxFirstIndexInEg);
        var arg2 = cst_encode_String(query);
        var arg3 = cst_encode_script(script);
        return wire.wire_eg_search(port_, arg0, arg1, arg2, arg3);
      },
      codec: DcoCodec(
        decodeSuccessData: dco_decode_list_eg_search_result,
        decodeErrorData: null,
      ),
      constMeta: kEgSearchConstMeta,
      argValues: [capacity, maxFirstIndexInEg, query, script],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kEgSearchConstMeta => const TaskConstMeta(
        debugName: "eg_search",
        argNames: ["capacity", "maxFirstIndexInEg", "query", "script"],
      );

  @override
  Future<void> generatePrIndices(
      {required Romanization romanization, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        var arg0 = cst_encode_romanization(romanization);
        return wire.wire_generate_pr_indices(port_, arg0);
      },
      codec: DcoCodec(
        decodeSuccessData: dco_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kGeneratePrIndicesConstMeta,
      argValues: [romanization],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kGeneratePrIndicesConstMeta => const TaskConstMeta(
        debugName: "generate_pr_indices",
        argNames: ["romanization"],
      );

  @override
  Future<List<String>> getEntryGroupJson({required int id, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        var arg0 = cst_encode_u_32(id);
        return wire.wire_get_entry_group_json(port_, arg0);
      },
      codec: DcoCodec(
        decodeSuccessData: dco_decode_list_String,
        decodeErrorData: null,
      ),
      constMeta: kGetEntryGroupJsonConstMeta,
      argValues: [id],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kGetEntryGroupJsonConstMeta => const TaskConstMeta(
        debugName: "get_entry_group_json",
        argNames: ["id"],
      );

  @override
  Future<int?> getEntryId(
      {required String query, required Script script, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        var arg0 = cst_encode_String(query);
        var arg1 = cst_encode_script(script);
        return wire.wire_get_entry_id(port_, arg0, arg1);
      },
      codec: DcoCodec(
        decodeSuccessData: dco_decode_opt_box_autoadd_u_32,
        decodeErrorData: null,
      ),
      constMeta: kGetEntryIdConstMeta,
      argValues: [query, script],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kGetEntryIdConstMeta => const TaskConstMeta(
        debugName: "get_entry_id",
        argNames: ["query", "script"],
      );

  @override
  Future<String> getEntryJson({required int id, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        var arg0 = cst_encode_u_32(id);
        return wire.wire_get_entry_json(port_, arg0);
      },
      codec: DcoCodec(
        decodeSuccessData: dco_decode_String,
        decodeErrorData: null,
      ),
      constMeta: kGetEntryJsonConstMeta,
      argValues: [id],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kGetEntryJsonConstMeta => const TaskConstMeta(
        debugName: "get_entry_json",
        argNames: ["id"],
      );

  @override
  Future<List<EntrySummary>> getEntrySummaries(
      {required Uint32List entryIds, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        var arg0 = cst_encode_list_prim_u_32(entryIds);
        return wire.wire_get_entry_summaries(port_, arg0);
      },
      codec: DcoCodec(
        decodeSuccessData: dco_decode_list_entry_summary,
        decodeErrorData: null,
      ),
      constMeta: kGetEntrySummariesConstMeta,
      argValues: [entryIds],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kGetEntrySummariesConstMeta => const TaskConstMeta(
        debugName: "get_entry_summaries",
        argNames: ["entryIds"],
      );

  @override
  Future<List<String>> getJyutping({required String query, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        var arg0 = cst_encode_String(query);
        return wire.wire_get_jyutping(port_, arg0);
      },
      codec: DcoCodec(
        decodeSuccessData: dco_decode_list_String,
        decodeErrorData: null,
      ),
      constMeta: kGetJyutpingConstMeta,
      argValues: [query],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kGetJyutpingConstMeta => const TaskConstMeta(
        debugName: "get_jyutping",
        argNames: ["query"],
      );

  @override
  Future<void> initApi({dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        return wire.wire_init_api(port_);
      },
      codec: DcoCodec(
        decodeSuccessData: dco_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kInitApiConstMeta,
      argValues: [],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kInitApiConstMeta => const TaskConstMeta(
        debugName: "init_api",
        argNames: [],
      );

  @override
  Future<void> initUtils({dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        return wire.wire_init_utils(port_);
      },
      codec: DcoCodec(
        decodeSuccessData: dco_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kInitUtilsConstMeta,
      argValues: [],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kInitUtilsConstMeta => const TaskConstMeta(
        debugName: "init_utils",
        argNames: [],
      );

  @protected
  String dco_decode_String(dynamic raw) {
    return raw as String;
  }

  @protected
  bool dco_decode_bool(dynamic raw) {
    return raw as bool;
  }

  @protected
  int dco_decode_box_autoadd_u_32(dynamic raw) {
    return raw as int;
  }

  @protected
  int dco_decode_box_autoadd_usize(dynamic raw) {
    return dco_decode_usize(raw);
  }

  @protected
  CombinedSearchResults dco_decode_combined_search_results(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 3)
      throw Exception('unexpected arr length: expect 3 but see ${arr.length}');
    return CombinedSearchResults(
      variantResults:
          dco_decode_record_opt_box_autoadd_usize_list_variant_search_result(
              arr[0]),
      prResults:
          dco_decode_record_opt_box_autoadd_usize_list_pr_search_result(arr[1]),
      englishResults:
          dco_decode_record_opt_box_autoadd_usize_list_english_search_result(
              arr[2]),
    );
  }

  @protected
  EgSearchResult dco_decode_eg_search_result(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 4)
      throw Exception('unexpected arr length: expect 4 but see ${arr.length}');
    return EgSearchResult(
      id: dco_decode_u_32(arr[0]),
      defIndex: dco_decode_u_32(arr[1]),
      egIndex: dco_decode_u_32(arr[2]),
      matchedEg: dco_decode_matched_infix(arr[3]),
    );
  }

  @protected
  EnglishSearchResult dco_decode_english_search_result(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 4)
      throw Exception('unexpected arr length: expect 4 but see ${arr.length}');
    return EnglishSearchResult(
      id: dco_decode_u_32(arr[0]),
      defIndex: dco_decode_u_32(arr[1]),
      variants: dco_decode_list_String(arr[2]),
      matchedEng: dco_decode_list_matched_segment(arr[3]),
    );
  }

  @protected
  EntryDef dco_decode_entry_def(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 3)
      throw Exception('unexpected arr length: expect 3 but see ${arr.length}');
    return EntryDef(
      yueTrad: dco_decode_String(arr[0]),
      yueSimp: dco_decode_String(arr[1]),
      eng: dco_decode_String(arr[2]),
    );
  }

  @protected
  EntrySummary dco_decode_entry_summary(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 3)
      throw Exception('unexpected arr length: expect 3 but see ${arr.length}');
    return EntrySummary(
      variantTrad: dco_decode_String(arr[0]),
      variantSimp: dco_decode_String(arr[1]),
      defs: dco_decode_list_entry_def(arr[2]),
    );
  }

  @protected
  int dco_decode_i_32(dynamic raw) {
    return raw as int;
  }

  @protected
  List<String> dco_decode_list_String(dynamic raw) {
    return (raw as List<dynamic>).map(dco_decode_String).toList();
  }

  @protected
  List<EgSearchResult> dco_decode_list_eg_search_result(dynamic raw) {
    return (raw as List<dynamic>).map(dco_decode_eg_search_result).toList();
  }

  @protected
  List<EnglishSearchResult> dco_decode_list_english_search_result(dynamic raw) {
    return (raw as List<dynamic>)
        .map(dco_decode_english_search_result)
        .toList();
  }

  @protected
  List<EntryDef> dco_decode_list_entry_def(dynamic raw) {
    return (raw as List<dynamic>).map(dco_decode_entry_def).toList();
  }

  @protected
  List<EntrySummary> dco_decode_list_entry_summary(dynamic raw) {
    return (raw as List<dynamic>).map(dco_decode_entry_summary).toList();
  }

  @protected
  List<MatchedSegment> dco_decode_list_matched_segment(dynamic raw) {
    return (raw as List<dynamic>).map(dco_decode_matched_segment).toList();
  }

  @protected
  List<PrSearchResult> dco_decode_list_pr_search_result(dynamic raw) {
    return (raw as List<dynamic>).map(dco_decode_pr_search_result).toList();
  }

  @protected
  Uint32List dco_decode_list_prim_u_32(dynamic raw) {
    return raw as Uint32List;
  }

  @protected
  Uint8List dco_decode_list_prim_u_8(dynamic raw) {
    return raw as Uint8List;
  }

  @protected
  List<VariantSearchResult> dco_decode_list_variant_search_result(dynamic raw) {
    return (raw as List<dynamic>)
        .map(dco_decode_variant_search_result)
        .toList();
  }

  @protected
  MatchedInfix dco_decode_matched_infix(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 3)
      throw Exception('unexpected arr length: expect 3 but see ${arr.length}');
    return MatchedInfix(
      prefix: dco_decode_String(arr[0]),
      query: dco_decode_String(arr[1]),
      suffix: dco_decode_String(arr[2]),
    );
  }

  @protected
  MatchedSegment dco_decode_matched_segment(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 2)
      throw Exception('unexpected arr length: expect 2 but see ${arr.length}');
    return MatchedSegment(
      segment: dco_decode_String(arr[0]),
      matched: dco_decode_bool(arr[1]),
    );
  }

  @protected
  int? dco_decode_opt_box_autoadd_u_32(dynamic raw) {
    return raw == null ? null : dco_decode_box_autoadd_u_32(raw);
  }

  @protected
  int? dco_decode_opt_box_autoadd_usize(dynamic raw) {
    return raw == null ? null : dco_decode_box_autoadd_usize(raw);
  }

  @protected
  PrSearchResult dco_decode_pr_search_result(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 5)
      throw Exception('unexpected arr length: expect 5 but see ${arr.length}');
    return PrSearchResult(
      id: dco_decode_u_32(arr[0]),
      variants: dco_decode_list_String(arr[1]),
      matchedPr: dco_decode_list_matched_segment(arr[2]),
      yues: dco_decode_list_String(arr[3]),
      engs: dco_decode_list_String(arr[4]),
    );
  }

  @protected
  (int?, List<EnglishSearchResult>)
      dco_decode_record_opt_box_autoadd_usize_list_english_search_result(
          dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 2) {
      throw Exception('Expected 2 elements, got ${arr.length}');
    }
    return (
      dco_decode_opt_box_autoadd_usize(arr[0]),
      dco_decode_list_english_search_result(arr[1]),
    );
  }

  @protected
  (
    int?,
    List<PrSearchResult>
  ) dco_decode_record_opt_box_autoadd_usize_list_pr_search_result(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 2) {
      throw Exception('Expected 2 elements, got ${arr.length}');
    }
    return (
      dco_decode_opt_box_autoadd_usize(arr[0]),
      dco_decode_list_pr_search_result(arr[1]),
    );
  }

  @protected
  (int?, List<VariantSearchResult>)
      dco_decode_record_opt_box_autoadd_usize_list_variant_search_result(
          dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 2) {
      throw Exception('Expected 2 elements, got ${arr.length}');
    }
    return (
      dco_decode_opt_box_autoadd_usize(arr[0]),
      dco_decode_list_variant_search_result(arr[1]),
    );
  }

  @protected
  Romanization dco_decode_romanization(dynamic raw) {
    return Romanization.values[raw as int];
  }

  @protected
  Script dco_decode_script(dynamic raw) {
    return Script.values[raw as int];
  }

  @protected
  int dco_decode_u_32(dynamic raw) {
    return raw as int;
  }

  @protected
  int dco_decode_u_8(dynamic raw) {
    return raw as int;
  }

  @protected
  void dco_decode_unit(dynamic raw) {
    return;
  }

  @protected
  int dco_decode_usize(dynamic raw) {
    return dcoDecodeI64OrU64(raw);
  }

  @protected
  VariantSearchResult dco_decode_variant_search_result(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 4)
      throw Exception('unexpected arr length: expect 4 but see ${arr.length}');
    return VariantSearchResult(
      id: dco_decode_u_32(arr[0]),
      matchedVariant: dco_decode_matched_infix(arr[1]),
      yues: dco_decode_list_String(arr[2]),
      engs: dco_decode_list_String(arr[3]),
    );
  }

  @protected
  String sse_decode_String(SseDeserializer deserializer) {
    var inner = sse_decode_list_prim_u_8(deserializer);
    return utf8.decoder.convert(inner);
  }

  @protected
  bool sse_decode_bool(SseDeserializer deserializer) {
    return deserializer.buffer.getUint8() != 0;
  }

  @protected
  int sse_decode_box_autoadd_u_32(SseDeserializer deserializer) {
    return (sse_decode_u_32(deserializer));
  }

  @protected
  int sse_decode_box_autoadd_usize(SseDeserializer deserializer) {
    return (sse_decode_usize(deserializer));
  }

  @protected
  CombinedSearchResults sse_decode_combined_search_results(
      SseDeserializer deserializer) {
    var var_variantResults =
        sse_decode_record_opt_box_autoadd_usize_list_variant_search_result(
            deserializer);
    var var_prResults =
        sse_decode_record_opt_box_autoadd_usize_list_pr_search_result(
            deserializer);
    var var_englishResults =
        sse_decode_record_opt_box_autoadd_usize_list_english_search_result(
            deserializer);
    return CombinedSearchResults(
        variantResults: var_variantResults,
        prResults: var_prResults,
        englishResults: var_englishResults);
  }

  @protected
  EgSearchResult sse_decode_eg_search_result(SseDeserializer deserializer) {
    var var_id = sse_decode_u_32(deserializer);
    var var_defIndex = sse_decode_u_32(deserializer);
    var var_egIndex = sse_decode_u_32(deserializer);
    var var_matchedEg = sse_decode_matched_infix(deserializer);
    return EgSearchResult(
        id: var_id,
        defIndex: var_defIndex,
        egIndex: var_egIndex,
        matchedEg: var_matchedEg);
  }

  @protected
  EnglishSearchResult sse_decode_english_search_result(
      SseDeserializer deserializer) {
    var var_id = sse_decode_u_32(deserializer);
    var var_defIndex = sse_decode_u_32(deserializer);
    var var_variants = sse_decode_list_String(deserializer);
    var var_matchedEng = sse_decode_list_matched_segment(deserializer);
    return EnglishSearchResult(
        id: var_id,
        defIndex: var_defIndex,
        variants: var_variants,
        matchedEng: var_matchedEng);
  }

  @protected
  EntryDef sse_decode_entry_def(SseDeserializer deserializer) {
    var var_yueTrad = sse_decode_String(deserializer);
    var var_yueSimp = sse_decode_String(deserializer);
    var var_eng = sse_decode_String(deserializer);
    return EntryDef(yueTrad: var_yueTrad, yueSimp: var_yueSimp, eng: var_eng);
  }

  @protected
  EntrySummary sse_decode_entry_summary(SseDeserializer deserializer) {
    var var_variantTrad = sse_decode_String(deserializer);
    var var_variantSimp = sse_decode_String(deserializer);
    var var_defs = sse_decode_list_entry_def(deserializer);
    return EntrySummary(
        variantTrad: var_variantTrad,
        variantSimp: var_variantSimp,
        defs: var_defs);
  }

  @protected
  int sse_decode_i_32(SseDeserializer deserializer) {
    return deserializer.buffer.getInt32();
  }

  @protected
  List<String> sse_decode_list_String(SseDeserializer deserializer) {
    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <String>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_String(deserializer));
    }
    return ans_;
  }

  @protected
  List<EgSearchResult> sse_decode_list_eg_search_result(
      SseDeserializer deserializer) {
    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <EgSearchResult>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_eg_search_result(deserializer));
    }
    return ans_;
  }

  @protected
  List<EnglishSearchResult> sse_decode_list_english_search_result(
      SseDeserializer deserializer) {
    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <EnglishSearchResult>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_english_search_result(deserializer));
    }
    return ans_;
  }

  @protected
  List<EntryDef> sse_decode_list_entry_def(SseDeserializer deserializer) {
    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <EntryDef>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_entry_def(deserializer));
    }
    return ans_;
  }

  @protected
  List<EntrySummary> sse_decode_list_entry_summary(
      SseDeserializer deserializer) {
    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <EntrySummary>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_entry_summary(deserializer));
    }
    return ans_;
  }

  @protected
  List<MatchedSegment> sse_decode_list_matched_segment(
      SseDeserializer deserializer) {
    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <MatchedSegment>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_matched_segment(deserializer));
    }
    return ans_;
  }

  @protected
  List<PrSearchResult> sse_decode_list_pr_search_result(
      SseDeserializer deserializer) {
    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <PrSearchResult>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_pr_search_result(deserializer));
    }
    return ans_;
  }

  @protected
  Uint32List sse_decode_list_prim_u_32(SseDeserializer deserializer) {
    var len_ = sse_decode_i_32(deserializer);
    return deserializer.buffer.getUint32List(len_);
  }

  @protected
  Uint8List sse_decode_list_prim_u_8(SseDeserializer deserializer) {
    var len_ = sse_decode_i_32(deserializer);
    return deserializer.buffer.getUint8List(len_);
  }

  @protected
  List<VariantSearchResult> sse_decode_list_variant_search_result(
      SseDeserializer deserializer) {
    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <VariantSearchResult>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_variant_search_result(deserializer));
    }
    return ans_;
  }

  @protected
  MatchedInfix sse_decode_matched_infix(SseDeserializer deserializer) {
    var var_prefix = sse_decode_String(deserializer);
    var var_query = sse_decode_String(deserializer);
    var var_suffix = sse_decode_String(deserializer);
    return MatchedInfix(
        prefix: var_prefix, query: var_query, suffix: var_suffix);
  }

  @protected
  MatchedSegment sse_decode_matched_segment(SseDeserializer deserializer) {
    var var_segment = sse_decode_String(deserializer);
    var var_matched = sse_decode_bool(deserializer);
    return MatchedSegment(segment: var_segment, matched: var_matched);
  }

  @protected
  int? sse_decode_opt_box_autoadd_u_32(SseDeserializer deserializer) {
    if (sse_decode_bool(deserializer)) {
      return (sse_decode_box_autoadd_u_32(deserializer));
    } else {
      return null;
    }
  }

  @protected
  int? sse_decode_opt_box_autoadd_usize(SseDeserializer deserializer) {
    if (sse_decode_bool(deserializer)) {
      return (sse_decode_box_autoadd_usize(deserializer));
    } else {
      return null;
    }
  }

  @protected
  PrSearchResult sse_decode_pr_search_result(SseDeserializer deserializer) {
    var var_id = sse_decode_u_32(deserializer);
    var var_variants = sse_decode_list_String(deserializer);
    var var_matchedPr = sse_decode_list_matched_segment(deserializer);
    var var_yues = sse_decode_list_String(deserializer);
    var var_engs = sse_decode_list_String(deserializer);
    return PrSearchResult(
        id: var_id,
        variants: var_variants,
        matchedPr: var_matchedPr,
        yues: var_yues,
        engs: var_engs);
  }

  @protected
  (int?, List<EnglishSearchResult>)
      sse_decode_record_opt_box_autoadd_usize_list_english_search_result(
          SseDeserializer deserializer) {
    var var_field0 = sse_decode_opt_box_autoadd_usize(deserializer);
    var var_field1 = sse_decode_list_english_search_result(deserializer);
    return (var_field0, var_field1);
  }

  @protected
  (int?, List<PrSearchResult>)
      sse_decode_record_opt_box_autoadd_usize_list_pr_search_result(
          SseDeserializer deserializer) {
    var var_field0 = sse_decode_opt_box_autoadd_usize(deserializer);
    var var_field1 = sse_decode_list_pr_search_result(deserializer);
    return (var_field0, var_field1);
  }

  @protected
  (int?, List<VariantSearchResult>)
      sse_decode_record_opt_box_autoadd_usize_list_variant_search_result(
          SseDeserializer deserializer) {
    var var_field0 = sse_decode_opt_box_autoadd_usize(deserializer);
    var var_field1 = sse_decode_list_variant_search_result(deserializer);
    return (var_field0, var_field1);
  }

  @protected
  Romanization sse_decode_romanization(SseDeserializer deserializer) {
    var inner = sse_decode_i_32(deserializer);
    return Romanization.values[inner];
  }

  @protected
  Script sse_decode_script(SseDeserializer deserializer) {
    var inner = sse_decode_i_32(deserializer);
    return Script.values[inner];
  }

  @protected
  int sse_decode_u_32(SseDeserializer deserializer) {
    return deserializer.buffer.getUint32();
  }

  @protected
  int sse_decode_u_8(SseDeserializer deserializer) {
    return deserializer.buffer.getUint8();
  }

  @protected
  void sse_decode_unit(SseDeserializer deserializer) {}

  @protected
  int sse_decode_usize(SseDeserializer deserializer) {
    return deserializer.buffer.getUint64();
  }

  @protected
  VariantSearchResult sse_decode_variant_search_result(
      SseDeserializer deserializer) {
    var var_id = sse_decode_u_32(deserializer);
    var var_matchedVariant = sse_decode_matched_infix(deserializer);
    var var_yues = sse_decode_list_String(deserializer);
    var var_engs = sse_decode_list_String(deserializer);
    return VariantSearchResult(
        id: var_id,
        matchedVariant: var_matchedVariant,
        yues: var_yues,
        engs: var_engs);
  }

  @protected
  bool cst_encode_bool(bool raw) {
    return raw;
  }

  @protected
  int cst_encode_i_32(int raw) {
    return raw;
  }

  @protected
  int cst_encode_romanization(Romanization raw) {
    return cst_encode_i_32(raw.index);
  }

  @protected
  int cst_encode_script(Script raw) {
    return cst_encode_i_32(raw.index);
  }

  @protected
  int cst_encode_u_32(int raw) {
    return raw;
  }

  @protected
  int cst_encode_u_8(int raw) {
    return raw;
  }

  @protected
  void cst_encode_unit(void raw) {
    return raw;
  }

  @protected
  int cst_encode_usize(int raw) {
    return raw;
  }

  @protected
  void sse_encode_String(String self, SseSerializer serializer) {
    sse_encode_list_prim_u_8(utf8.encoder.convert(self), serializer);
  }

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer) {
    serializer.buffer.putUint8(self ? 1 : 0);
  }

  @protected
  void sse_encode_box_autoadd_u_32(int self, SseSerializer serializer) {
    sse_encode_u_32(self, serializer);
  }

  @protected
  void sse_encode_box_autoadd_usize(int self, SseSerializer serializer) {
    sse_encode_usize(self, serializer);
  }

  @protected
  void sse_encode_combined_search_results(
      CombinedSearchResults self, SseSerializer serializer) {
    sse_encode_record_opt_box_autoadd_usize_list_variant_search_result(
        self.variantResults, serializer);
    sse_encode_record_opt_box_autoadd_usize_list_pr_search_result(
        self.prResults, serializer);
    sse_encode_record_opt_box_autoadd_usize_list_english_search_result(
        self.englishResults, serializer);
  }

  @protected
  void sse_encode_eg_search_result(
      EgSearchResult self, SseSerializer serializer) {
    sse_encode_u_32(self.id, serializer);
    sse_encode_u_32(self.defIndex, serializer);
    sse_encode_u_32(self.egIndex, serializer);
    sse_encode_matched_infix(self.matchedEg, serializer);
  }

  @protected
  void sse_encode_english_search_result(
      EnglishSearchResult self, SseSerializer serializer) {
    sse_encode_u_32(self.id, serializer);
    sse_encode_u_32(self.defIndex, serializer);
    sse_encode_list_String(self.variants, serializer);
    sse_encode_list_matched_segment(self.matchedEng, serializer);
  }

  @protected
  void sse_encode_entry_def(EntryDef self, SseSerializer serializer) {
    sse_encode_String(self.yueTrad, serializer);
    sse_encode_String(self.yueSimp, serializer);
    sse_encode_String(self.eng, serializer);
  }

  @protected
  void sse_encode_entry_summary(EntrySummary self, SseSerializer serializer) {
    sse_encode_String(self.variantTrad, serializer);
    sse_encode_String(self.variantSimp, serializer);
    sse_encode_list_entry_def(self.defs, serializer);
  }

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer) {
    serializer.buffer.putInt32(self);
  }

  @protected
  void sse_encode_list_String(List<String> self, SseSerializer serializer) {
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_String(item, serializer);
    }
  }

  @protected
  void sse_encode_list_eg_search_result(
      List<EgSearchResult> self, SseSerializer serializer) {
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_eg_search_result(item, serializer);
    }
  }

  @protected
  void sse_encode_list_english_search_result(
      List<EnglishSearchResult> self, SseSerializer serializer) {
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_english_search_result(item, serializer);
    }
  }

  @protected
  void sse_encode_list_entry_def(
      List<EntryDef> self, SseSerializer serializer) {
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_entry_def(item, serializer);
    }
  }

  @protected
  void sse_encode_list_entry_summary(
      List<EntrySummary> self, SseSerializer serializer) {
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_entry_summary(item, serializer);
    }
  }

  @protected
  void sse_encode_list_matched_segment(
      List<MatchedSegment> self, SseSerializer serializer) {
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_matched_segment(item, serializer);
    }
  }

  @protected
  void sse_encode_list_pr_search_result(
      List<PrSearchResult> self, SseSerializer serializer) {
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_pr_search_result(item, serializer);
    }
  }

  @protected
  void sse_encode_list_prim_u_32(Uint32List self, SseSerializer serializer) {
    sse_encode_i_32(self.length, serializer);
    serializer.buffer.putUint32List(self);
  }

  @protected
  void sse_encode_list_prim_u_8(Uint8List self, SseSerializer serializer) {
    sse_encode_i_32(self.length, serializer);
    serializer.buffer.putUint8List(self);
  }

  @protected
  void sse_encode_list_variant_search_result(
      List<VariantSearchResult> self, SseSerializer serializer) {
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_variant_search_result(item, serializer);
    }
  }

  @protected
  void sse_encode_matched_infix(MatchedInfix self, SseSerializer serializer) {
    sse_encode_String(self.prefix, serializer);
    sse_encode_String(self.query, serializer);
    sse_encode_String(self.suffix, serializer);
  }

  @protected
  void sse_encode_matched_segment(
      MatchedSegment self, SseSerializer serializer) {
    sse_encode_String(self.segment, serializer);
    sse_encode_bool(self.matched, serializer);
  }

  @protected
  void sse_encode_opt_box_autoadd_u_32(int? self, SseSerializer serializer) {
    sse_encode_bool(self != null, serializer);
    if (self != null) {
      sse_encode_box_autoadd_u_32(self, serializer);
    }
  }

  @protected
  void sse_encode_opt_box_autoadd_usize(int? self, SseSerializer serializer) {
    sse_encode_bool(self != null, serializer);
    if (self != null) {
      sse_encode_box_autoadd_usize(self, serializer);
    }
  }

  @protected
  void sse_encode_pr_search_result(
      PrSearchResult self, SseSerializer serializer) {
    sse_encode_u_32(self.id, serializer);
    sse_encode_list_String(self.variants, serializer);
    sse_encode_list_matched_segment(self.matchedPr, serializer);
    sse_encode_list_String(self.yues, serializer);
    sse_encode_list_String(self.engs, serializer);
  }

  @protected
  void sse_encode_record_opt_box_autoadd_usize_list_english_search_result(
      (int?, List<EnglishSearchResult>) self, SseSerializer serializer) {
    sse_encode_opt_box_autoadd_usize(self.$1, serializer);
    sse_encode_list_english_search_result(self.$2, serializer);
  }

  @protected
  void sse_encode_record_opt_box_autoadd_usize_list_pr_search_result(
      (int?, List<PrSearchResult>) self, SseSerializer serializer) {
    sse_encode_opt_box_autoadd_usize(self.$1, serializer);
    sse_encode_list_pr_search_result(self.$2, serializer);
  }

  @protected
  void sse_encode_record_opt_box_autoadd_usize_list_variant_search_result(
      (int?, List<VariantSearchResult>) self, SseSerializer serializer) {
    sse_encode_opt_box_autoadd_usize(self.$1, serializer);
    sse_encode_list_variant_search_result(self.$2, serializer);
  }

  @protected
  void sse_encode_romanization(Romanization self, SseSerializer serializer) {
    sse_encode_i_32(self.index, serializer);
  }

  @protected
  void sse_encode_script(Script self, SseSerializer serializer) {
    sse_encode_i_32(self.index, serializer);
  }

  @protected
  void sse_encode_u_32(int self, SseSerializer serializer) {
    serializer.buffer.putUint32(self);
  }

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer) {
    serializer.buffer.putUint8(self);
  }

  @protected
  void sse_encode_unit(void self, SseSerializer serializer) {}

  @protected
  void sse_encode_usize(int self, SseSerializer serializer) {
    serializer.buffer.putUint64(self);
  }

  @protected
  void sse_encode_variant_search_result(
      VariantSearchResult self, SseSerializer serializer) {
    sse_encode_u_32(self.id, serializer);
    sse_encode_matched_infix(self.matchedVariant, serializer);
    sse_encode_list_String(self.yues, serializer);
    sse_encode_list_String(self.engs, serializer);
  }
}
