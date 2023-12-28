// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.4.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';
import 'dart:ffi' as ffi;

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_io.dart';

import 'api/api.dart';
import 'frb_generated.dart';

abstract class RustLibApiImplPlatform extends BaseApiImpl<RustLibWire> {
  RustLibApiImplPlatform({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw);

  @protected
  String dco_decode_String(dynamic raw);

  @protected
  bool dco_decode_bool(dynamic raw);

  @protected
  int dco_decode_box_autoadd_u_32(dynamic raw);

  @protected
  CombinedSearchResults dco_decode_combined_search_results(dynamic raw);

  @protected
  EgSearchResult dco_decode_eg_search_result(dynamic raw);

  @protected
  EnglishSearchResult dco_decode_english_search_result(dynamic raw);

  @protected
  EntrySummary dco_decode_entry_summary(dynamic raw);

  @protected
  int dco_decode_i_32(dynamic raw);

  @protected
  List<String> dco_decode_list_String(dynamic raw);

  @protected
  List<EgSearchResult> dco_decode_list_eg_search_result(dynamic raw);

  @protected
  List<EnglishSearchResult> dco_decode_list_english_search_result(dynamic raw);

  @protected
  List<EntrySummary> dco_decode_list_entry_summary(dynamic raw);

  @protected
  List<MatchedSegment> dco_decode_list_matched_segment(dynamic raw);

  @protected
  List<PrSearchResult> dco_decode_list_pr_search_result(dynamic raw);

  @protected
  Uint32List dco_decode_list_prim_u_32(dynamic raw);

  @protected
  Uint8List dco_decode_list_prim_u_8(dynamic raw);

  @protected
  List<(String, String)> dco_decode_list_record_string_string(dynamic raw);

  @protected
  List<SpotlightEntrySummary> dco_decode_list_spotlight_entry_summary(
      dynamic raw);

  @protected
  List<VariantSearchResult> dco_decode_list_variant_search_result(dynamic raw);

  @protected
  MatchedSegment dco_decode_matched_segment(dynamic raw);

  @protected
  MatchedVariant dco_decode_matched_variant(dynamic raw);

  @protected
  String? dco_decode_opt_String(dynamic raw);

  @protected
  int? dco_decode_opt_box_autoadd_u_32(dynamic raw);

  @protected
  PrSearchResult dco_decode_pr_search_result(dynamic raw);

  @protected
  (String?, List<EgSearchResult>)
      dco_decode_record_opt_string_list_eg_search_result(dynamic raw);

  @protected
  (String, String) dco_decode_record_string_string(dynamic raw);

  @protected
  Romanization dco_decode_romanization(dynamic raw);

  @protected
  Script dco_decode_script(dynamic raw);

  @protected
  SpotlightEntrySummary dco_decode_spotlight_entry_summary(dynamic raw);

  @protected
  int dco_decode_u_32(dynamic raw);

  @protected
  int dco_decode_u_8(dynamic raw);

  @protected
  void dco_decode_unit(dynamic raw);

  @protected
  VariantSearchResult dco_decode_variant_search_result(dynamic raw);

  @protected
  AnyhowException sse_decode_AnyhowException(SseDeserializer deserializer);

  @protected
  String sse_decode_String(SseDeserializer deserializer);

  @protected
  bool sse_decode_bool(SseDeserializer deserializer);

  @protected
  int sse_decode_box_autoadd_u_32(SseDeserializer deserializer);

  @protected
  CombinedSearchResults sse_decode_combined_search_results(
      SseDeserializer deserializer);

  @protected
  EgSearchResult sse_decode_eg_search_result(SseDeserializer deserializer);

  @protected
  EnglishSearchResult sse_decode_english_search_result(
      SseDeserializer deserializer);

  @protected
  EntrySummary sse_decode_entry_summary(SseDeserializer deserializer);

  @protected
  int sse_decode_i_32(SseDeserializer deserializer);

  @protected
  List<String> sse_decode_list_String(SseDeserializer deserializer);

  @protected
  List<EgSearchResult> sse_decode_list_eg_search_result(
      SseDeserializer deserializer);

  @protected
  List<EnglishSearchResult> sse_decode_list_english_search_result(
      SseDeserializer deserializer);

  @protected
  List<EntrySummary> sse_decode_list_entry_summary(
      SseDeserializer deserializer);

  @protected
  List<MatchedSegment> sse_decode_list_matched_segment(
      SseDeserializer deserializer);

  @protected
  List<PrSearchResult> sse_decode_list_pr_search_result(
      SseDeserializer deserializer);

  @protected
  Uint32List sse_decode_list_prim_u_32(SseDeserializer deserializer);

  @protected
  Uint8List sse_decode_list_prim_u_8(SseDeserializer deserializer);

  @protected
  List<(String, String)> sse_decode_list_record_string_string(
      SseDeserializer deserializer);

  @protected
  List<SpotlightEntrySummary> sse_decode_list_spotlight_entry_summary(
      SseDeserializer deserializer);

  @protected
  List<VariantSearchResult> sse_decode_list_variant_search_result(
      SseDeserializer deserializer);

  @protected
  MatchedSegment sse_decode_matched_segment(SseDeserializer deserializer);

  @protected
  MatchedVariant sse_decode_matched_variant(SseDeserializer deserializer);

  @protected
  String? sse_decode_opt_String(SseDeserializer deserializer);

  @protected
  int? sse_decode_opt_box_autoadd_u_32(SseDeserializer deserializer);

  @protected
  PrSearchResult sse_decode_pr_search_result(SseDeserializer deserializer);

  @protected
  (String?, List<EgSearchResult>)
      sse_decode_record_opt_string_list_eg_search_result(
          SseDeserializer deserializer);

  @protected
  (String, String) sse_decode_record_string_string(
      SseDeserializer deserializer);

  @protected
  Romanization sse_decode_romanization(SseDeserializer deserializer);

  @protected
  Script sse_decode_script(SseDeserializer deserializer);

  @protected
  SpotlightEntrySummary sse_decode_spotlight_entry_summary(
      SseDeserializer deserializer);

  @protected
  int sse_decode_u_32(SseDeserializer deserializer);

  @protected
  int sse_decode_u_8(SseDeserializer deserializer);

  @protected
  void sse_decode_unit(SseDeserializer deserializer);

  @protected
  VariantSearchResult sse_decode_variant_search_result(
      SseDeserializer deserializer);

  @protected
  ffi.Pointer<wire_cst_list_prim_u_8> cst_encode_AnyhowException(
      AnyhowException raw) {
    throw UnimplementedError();
  }

  @protected
  ffi.Pointer<wire_cst_list_prim_u_8> cst_encode_String(String raw) {
    return cst_encode_list_prim_u_8(utf8.encoder.convert(raw));
  }

  @protected
  ffi.Pointer<ffi.Uint32> cst_encode_box_autoadd_u_32(int raw) {
    return wire.cst_new_box_autoadd_u_32(cst_encode_u_32(raw));
  }

  @protected
  ffi.Pointer<wire_cst_list_String> cst_encode_list_String(List<String> raw) {
    final ans = wire.cst_new_list_String(raw.length);
    for (var i = 0; i < raw.length; ++i) {
      ans.ref.ptr[i] = cst_encode_String(raw[i]);
    }
    return ans;
  }

  @protected
  ffi.Pointer<wire_cst_list_eg_search_result> cst_encode_list_eg_search_result(
      List<EgSearchResult> raw) {
    final ans = wire.cst_new_list_eg_search_result(raw.length);
    for (var i = 0; i < raw.length; ++i) {
      cst_api_fill_to_wire_eg_search_result(raw[i], ans.ref.ptr[i]);
    }
    return ans;
  }

  @protected
  ffi.Pointer<wire_cst_list_english_search_result>
      cst_encode_list_english_search_result(List<EnglishSearchResult> raw) {
    final ans = wire.cst_new_list_english_search_result(raw.length);
    for (var i = 0; i < raw.length; ++i) {
      cst_api_fill_to_wire_english_search_result(raw[i], ans.ref.ptr[i]);
    }
    return ans;
  }

  @protected
  ffi.Pointer<wire_cst_list_entry_summary> cst_encode_list_entry_summary(
      List<EntrySummary> raw) {
    final ans = wire.cst_new_list_entry_summary(raw.length);
    for (var i = 0; i < raw.length; ++i) {
      cst_api_fill_to_wire_entry_summary(raw[i], ans.ref.ptr[i]);
    }
    return ans;
  }

  @protected
  ffi.Pointer<wire_cst_list_matched_segment> cst_encode_list_matched_segment(
      List<MatchedSegment> raw) {
    final ans = wire.cst_new_list_matched_segment(raw.length);
    for (var i = 0; i < raw.length; ++i) {
      cst_api_fill_to_wire_matched_segment(raw[i], ans.ref.ptr[i]);
    }
    return ans;
  }

  @protected
  ffi.Pointer<wire_cst_list_pr_search_result> cst_encode_list_pr_search_result(
      List<PrSearchResult> raw) {
    final ans = wire.cst_new_list_pr_search_result(raw.length);
    for (var i = 0; i < raw.length; ++i) {
      cst_api_fill_to_wire_pr_search_result(raw[i], ans.ref.ptr[i]);
    }
    return ans;
  }

  @protected
  ffi.Pointer<wire_cst_list_prim_u_32> cst_encode_list_prim_u_32(
      Uint32List raw) {
    final ans = wire.cst_new_list_prim_u_32(raw.length);
    ans.ref.ptr.asTypedList(raw.length).setAll(0, raw);
    return ans;
  }

  @protected
  ffi.Pointer<wire_cst_list_prim_u_8> cst_encode_list_prim_u_8(Uint8List raw) {
    final ans = wire.cst_new_list_prim_u_8(raw.length);
    ans.ref.ptr.asTypedList(raw.length).setAll(0, raw);
    return ans;
  }

  @protected
  ffi.Pointer<wire_cst_list_record_string_string>
      cst_encode_list_record_string_string(List<(String, String)> raw) {
    final ans = wire.cst_new_list_record_string_string(raw.length);
    for (var i = 0; i < raw.length; ++i) {
      cst_api_fill_to_wire_record_string_string(raw[i], ans.ref.ptr[i]);
    }
    return ans;
  }

  @protected
  ffi.Pointer<wire_cst_list_spotlight_entry_summary>
      cst_encode_list_spotlight_entry_summary(List<SpotlightEntrySummary> raw) {
    final ans = wire.cst_new_list_spotlight_entry_summary(raw.length);
    for (var i = 0; i < raw.length; ++i) {
      cst_api_fill_to_wire_spotlight_entry_summary(raw[i], ans.ref.ptr[i]);
    }
    return ans;
  }

  @protected
  ffi.Pointer<wire_cst_list_variant_search_result>
      cst_encode_list_variant_search_result(List<VariantSearchResult> raw) {
    final ans = wire.cst_new_list_variant_search_result(raw.length);
    for (var i = 0; i < raw.length; ++i) {
      cst_api_fill_to_wire_variant_search_result(raw[i], ans.ref.ptr[i]);
    }
    return ans;
  }

  @protected
  ffi.Pointer<wire_cst_list_prim_u_8> cst_encode_opt_String(String? raw) {
    return raw == null ? ffi.nullptr : cst_encode_String(raw);
  }

  @protected
  ffi.Pointer<ffi.Uint32> cst_encode_opt_box_autoadd_u_32(int? raw) {
    return raw == null ? ffi.nullptr : cst_encode_box_autoadd_u_32(raw);
  }

  @protected
  void cst_api_fill_to_wire_combined_search_results(
      CombinedSearchResults apiObj, wire_cst_combined_search_results wireObj) {
    wireObj.variant_results =
        cst_encode_list_variant_search_result(apiObj.variantResults);
    wireObj.pr_results = cst_encode_list_pr_search_result(apiObj.prResults);
    wireObj.english_results =
        cst_encode_list_english_search_result(apiObj.englishResults);
  }

  @protected
  void cst_api_fill_to_wire_eg_search_result(
      EgSearchResult apiObj, wire_cst_eg_search_result wireObj) {
    wireObj.id = cst_encode_u_32(apiObj.id);
    wireObj.def_index = cst_encode_u_32(apiObj.defIndex);
    wireObj.eg_index = cst_encode_u_32(apiObj.egIndex);
    wireObj.eg = cst_encode_String(apiObj.eg);
  }

  @protected
  void cst_api_fill_to_wire_english_search_result(
      EnglishSearchResult apiObj, wire_cst_english_search_result wireObj) {
    wireObj.id = cst_encode_u_32(apiObj.id);
    wireObj.def_index = cst_encode_u_32(apiObj.defIndex);
    wireObj.variant = cst_encode_String(apiObj.variant);
    wireObj.pr = cst_encode_String(apiObj.pr);
    wireObj.matched_eng = cst_encode_list_matched_segment(apiObj.matchedEng);
  }

  @protected
  void cst_api_fill_to_wire_entry_summary(
      EntrySummary apiObj, wire_cst_entry_summary wireObj) {
    wireObj.variant = cst_encode_String(apiObj.variant);
    wireObj.defs = cst_encode_list_record_string_string(apiObj.defs);
  }

  @protected
  void cst_api_fill_to_wire_matched_segment(
      MatchedSegment apiObj, wire_cst_matched_segment wireObj) {
    wireObj.segment = cst_encode_String(apiObj.segment);
    wireObj.matched = cst_encode_bool(apiObj.matched);
  }

  @protected
  void cst_api_fill_to_wire_matched_variant(
      MatchedVariant apiObj, wire_cst_matched_variant wireObj) {
    wireObj.prefix = cst_encode_String(apiObj.prefix);
    wireObj.query = cst_encode_String(apiObj.query);
    wireObj.suffix = cst_encode_String(apiObj.suffix);
  }

  @protected
  void cst_api_fill_to_wire_pr_search_result(
      PrSearchResult apiObj, wire_cst_pr_search_result wireObj) {
    wireObj.id = cst_encode_u_32(apiObj.id);
    wireObj.variant = cst_encode_String(apiObj.variant);
    wireObj.matched_pr = cst_encode_list_matched_segment(apiObj.matchedPr);
    wireObj.yues = cst_encode_list_String(apiObj.yues);
    wireObj.engs = cst_encode_list_String(apiObj.engs);
  }

  @protected
  void cst_api_fill_to_wire_record_opt_string_list_eg_search_result(
      (String?, List<EgSearchResult>) apiObj,
      wire_cst_record_opt_string_list_eg_search_result wireObj) {
    wireObj.field0 = cst_encode_opt_String(apiObj.$1);
    wireObj.field1 = cst_encode_list_eg_search_result(apiObj.$2);
  }

  @protected
  void cst_api_fill_to_wire_record_string_string(
      (String, String) apiObj, wire_cst_record_string_string wireObj) {
    wireObj.field0 = cst_encode_String(apiObj.$1);
    wireObj.field1 = cst_encode_String(apiObj.$2);
  }

  @protected
  void cst_api_fill_to_wire_spotlight_entry_summary(
      SpotlightEntrySummary apiObj, wire_cst_spotlight_entry_summary wireObj) {
    wireObj.id = cst_encode_u_32(apiObj.id);
    wireObj.variants = cst_encode_list_String(apiObj.variants);
    wireObj.variants_simp = cst_encode_list_String(apiObj.variantsSimp);
    wireObj.jyutpings = cst_encode_list_String(apiObj.jyutpings);
    wireObj.yales = cst_encode_list_String(apiObj.yales);
    wireObj.def = cst_encode_String(apiObj.def);
    wireObj.def_simp = cst_encode_String(apiObj.defSimp);
    wireObj.def_en = cst_encode_String(apiObj.defEn);
  }

  @protected
  void cst_api_fill_to_wire_variant_search_result(
      VariantSearchResult apiObj, wire_cst_variant_search_result wireObj) {
    wireObj.id = cst_encode_u_32(apiObj.id);
    cst_api_fill_to_wire_matched_variant(
        apiObj.matchedVariant, wireObj.matched_variant);
    wireObj.yues = cst_encode_list_String(apiObj.yues);
    wireObj.engs = cst_encode_list_String(apiObj.engs);
  }

  @protected
  bool cst_encode_bool(bool raw);

  @protected
  int cst_encode_i_32(int raw);

  @protected
  int cst_encode_romanization(Romanization raw);

  @protected
  int cst_encode_script(Script raw);

  @protected
  int cst_encode_u_32(int raw);

  @protected
  int cst_encode_u_8(int raw);

  @protected
  void cst_encode_unit(void raw);

  @protected
  void sse_encode_AnyhowException(
      AnyhowException self, SseSerializer serializer);

  @protected
  void sse_encode_String(String self, SseSerializer serializer);

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_u_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_combined_search_results(
      CombinedSearchResults self, SseSerializer serializer);

  @protected
  void sse_encode_eg_search_result(
      EgSearchResult self, SseSerializer serializer);

  @protected
  void sse_encode_english_search_result(
      EnglishSearchResult self, SseSerializer serializer);

  @protected
  void sse_encode_entry_summary(EntrySummary self, SseSerializer serializer);

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_list_String(List<String> self, SseSerializer serializer);

  @protected
  void sse_encode_list_eg_search_result(
      List<EgSearchResult> self, SseSerializer serializer);

  @protected
  void sse_encode_list_english_search_result(
      List<EnglishSearchResult> self, SseSerializer serializer);

  @protected
  void sse_encode_list_entry_summary(
      List<EntrySummary> self, SseSerializer serializer);

  @protected
  void sse_encode_list_matched_segment(
      List<MatchedSegment> self, SseSerializer serializer);

  @protected
  void sse_encode_list_pr_search_result(
      List<PrSearchResult> self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_32(Uint32List self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_8(Uint8List self, SseSerializer serializer);

  @protected
  void sse_encode_list_record_string_string(
      List<(String, String)> self, SseSerializer serializer);

  @protected
  void sse_encode_list_spotlight_entry_summary(
      List<SpotlightEntrySummary> self, SseSerializer serializer);

  @protected
  void sse_encode_list_variant_search_result(
      List<VariantSearchResult> self, SseSerializer serializer);

  @protected
  void sse_encode_matched_segment(
      MatchedSegment self, SseSerializer serializer);

  @protected
  void sse_encode_matched_variant(
      MatchedVariant self, SseSerializer serializer);

  @protected
  void sse_encode_opt_String(String? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_u_32(int? self, SseSerializer serializer);

  @protected
  void sse_encode_pr_search_result(
      PrSearchResult self, SseSerializer serializer);

  @protected
  void sse_encode_record_opt_string_list_eg_search_result(
      (String?, List<EgSearchResult>) self, SseSerializer serializer);

  @protected
  void sse_encode_record_string_string(
      (String, String) self, SseSerializer serializer);

  @protected
  void sse_encode_romanization(Romanization self, SseSerializer serializer);

  @protected
  void sse_encode_script(Script self, SseSerializer serializer);

  @protected
  void sse_encode_spotlight_entry_summary(
      SpotlightEntrySummary self, SseSerializer serializer);

  @protected
  void sse_encode_u_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_unit(void self, SseSerializer serializer);

  @protected
  void sse_encode_variant_search_result(
      VariantSearchResult self, SseSerializer serializer);
}

// Section: wire_class

// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_positional_boolean_parameters, annotate_overrides, constant_identifier_names
// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint

/// generated by flutter_rust_bridge
class RustLibWire implements BaseWire {
  factory RustLibWire.fromExternalLibrary(ExternalLibrary lib) =>
      RustLibWire(lib.ffiDynamicLibrary);

  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  RustLibWire(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  RustLibWire.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void dart_fn_deliver_output(
    int call_id,
    ffi.Pointer<ffi.Uint8> ptr_,
    int rust_vec_len_,
    int data_len_,
  ) {
    return _dart_fn_deliver_output(
      call_id,
      ptr_,
      rust_vec_len_,
      data_len_,
    );
  }

  late final _dart_fn_deliver_outputPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int32, ffi.Pointer<ffi.Uint8>, ffi.Int32,
              ffi.Int32)>>('dart_fn_deliver_output');
  late final _dart_fn_deliver_output = _dart_fn_deliver_outputPtr
      .asFunction<void Function(int, ffi.Pointer<ffi.Uint8>, int, int)>();

  void wire_combined_search(
    int port_,
    int capacity,
    ffi.Pointer<wire_cst_list_prim_u_8> query,
    int script,
    int romanization,
  ) {
    return _wire_combined_search(
      port_,
      capacity,
      query,
      script,
      romanization,
    );
  }

  late final _wire_combined_searchPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64,
              ffi.Uint32,
              ffi.Pointer<wire_cst_list_prim_u_8>,
              ffi.Int32,
              ffi.Int32)>>('wire_combined_search');
  late final _wire_combined_search = _wire_combined_searchPtr.asFunction<
      void Function(int, int, ffi.Pointer<wire_cst_list_prim_u_8>, int, int)>();

  void wire_create_log_stream(
    int port_,
  ) {
    return _wire_create_log_stream(
      port_,
    );
  }

  late final _wire_create_log_streamPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_create_log_stream');
  late final _wire_create_log_stream =
      _wire_create_log_streamPtr.asFunction<void Function(int)>();

  void wire_eg_search(
    int port_,
    int capacity,
    int max_first_index_in_eg,
    ffi.Pointer<wire_cst_list_prim_u_8> query,
    int script,
  ) {
    return _wire_eg_search(
      port_,
      capacity,
      max_first_index_in_eg,
      query,
      script,
    );
  }

  late final _wire_eg_searchPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64,
              ffi.Uint32,
              ffi.Uint32,
              ffi.Pointer<wire_cst_list_prim_u_8>,
              ffi.Int32)>>('wire_eg_search');
  late final _wire_eg_search = _wire_eg_searchPtr.asFunction<
      void Function(int, int, int, ffi.Pointer<wire_cst_list_prim_u_8>, int)>();

  void wire_english_search(
    int port_,
    int capacity,
    ffi.Pointer<wire_cst_list_prim_u_8> query,
    int script,
  ) {
    return _wire_english_search(
      port_,
      capacity,
      query,
      script,
    );
  }

  late final _wire_english_searchPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64,
              ffi.Uint32,
              ffi.Pointer<wire_cst_list_prim_u_8>,
              ffi.Int32)>>('wire_english_search');
  late final _wire_english_search = _wire_english_searchPtr.asFunction<
      void Function(int, int, ffi.Pointer<wire_cst_list_prim_u_8>, int)>();

  void wire_generate_pr_indices(
    int port_,
    int romanization,
  ) {
    return _wire_generate_pr_indices(
      port_,
      romanization,
    );
  }

  late final _wire_generate_pr_indicesPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64, ffi.Int32)>>(
          'wire_generate_pr_indices');
  late final _wire_generate_pr_indices =
      _wire_generate_pr_indicesPtr.asFunction<void Function(int, int)>();

  void wire_get_entry_group_json(
    int port_,
    int id,
  ) {
    return _wire_get_entry_group_json(
      port_,
      id,
    );
  }

  late final _wire_get_entry_group_jsonPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64, ffi.Uint32)>>(
          'wire_get_entry_group_json');
  late final _wire_get_entry_group_json =
      _wire_get_entry_group_jsonPtr.asFunction<void Function(int, int)>();

  void wire_get_entry_id(
    int port_,
    ffi.Pointer<wire_cst_list_prim_u_8> query,
    int script,
  ) {
    return _wire_get_entry_id(
      port_,
      query,
      script,
    );
  }

  late final _wire_get_entry_idPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Pointer<wire_cst_list_prim_u_8>,
              ffi.Int32)>>('wire_get_entry_id');
  late final _wire_get_entry_id = _wire_get_entry_idPtr.asFunction<
      void Function(int, ffi.Pointer<wire_cst_list_prim_u_8>, int)>();

  void wire_get_entry_json(
    int port_,
    int id,
  ) {
    return _wire_get_entry_json(
      port_,
      id,
    );
  }

  late final _wire_get_entry_jsonPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64, ffi.Uint32)>>(
          'wire_get_entry_json');
  late final _wire_get_entry_json =
      _wire_get_entry_jsonPtr.asFunction<void Function(int, int)>();

  void wire_get_entry_summaries(
    int port_,
    ffi.Pointer<wire_cst_list_prim_u_32> entry_ids,
    int script,
  ) {
    return _wire_get_entry_summaries(
      port_,
      entry_ids,
      script,
    );
  }

  late final _wire_get_entry_summariesPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Pointer<wire_cst_list_prim_u_32>,
              ffi.Int32)>>('wire_get_entry_summaries');
  late final _wire_get_entry_summaries =
      _wire_get_entry_summariesPtr.asFunction<
          void Function(int, ffi.Pointer<wire_cst_list_prim_u_32>, int)>();

  void wire_get_jyutping(
    int port_,
    ffi.Pointer<wire_cst_list_prim_u_8> query,
  ) {
    return _wire_get_jyutping(
      port_,
      query,
    );
  }

  late final _wire_get_jyutpingPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64,
              ffi.Pointer<wire_cst_list_prim_u_8>)>>('wire_get_jyutping');
  late final _wire_get_jyutping = _wire_get_jyutpingPtr
      .asFunction<void Function(int, ffi.Pointer<wire_cst_list_prim_u_8>)>();

  void wire_get_splotlight_summaries(
    int port_,
  ) {
    return _wire_get_splotlight_summaries(
      port_,
    );
  }

  late final _wire_get_splotlight_summariesPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_get_splotlight_summaries');
  late final _wire_get_splotlight_summaries =
      _wire_get_splotlight_summariesPtr.asFunction<void Function(int)>();

  void wire_init_api(
    int port_,
    ffi.Pointer<wire_cst_list_prim_u_8> dict_data,
    ffi.Pointer<wire_cst_list_prim_u_8> english_index_data,
  ) {
    return _wire_init_api(
      port_,
      dict_data,
      english_index_data,
    );
  }

  late final _wire_init_apiPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Pointer<wire_cst_list_prim_u_8>,
              ffi.Pointer<wire_cst_list_prim_u_8>)>>('wire_init_api');
  late final _wire_init_api = _wire_init_apiPtr.asFunction<
      void Function(int, ffi.Pointer<wire_cst_list_prim_u_8>,
          ffi.Pointer<wire_cst_list_prim_u_8>)>();

  void wire_pr_search(
    int port_,
    int capacity,
    ffi.Pointer<wire_cst_list_prim_u_8> query,
    int script,
    int romanization,
  ) {
    return _wire_pr_search(
      port_,
      capacity,
      query,
      script,
      romanization,
    );
  }

  late final _wire_pr_searchPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64,
              ffi.Uint32,
              ffi.Pointer<wire_cst_list_prim_u_8>,
              ffi.Int32,
              ffi.Int32)>>('wire_pr_search');
  late final _wire_pr_search = _wire_pr_searchPtr.asFunction<
      void Function(int, int, ffi.Pointer<wire_cst_list_prim_u_8>, int, int)>();

  void wire_variant_search(
    int port_,
    int capacity,
    ffi.Pointer<wire_cst_list_prim_u_8> query,
    int script,
  ) {
    return _wire_variant_search(
      port_,
      capacity,
      query,
      script,
    );
  }

  late final _wire_variant_searchPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64,
              ffi.Uint32,
              ffi.Pointer<wire_cst_list_prim_u_8>,
              ffi.Int32)>>('wire_variant_search');
  late final _wire_variant_search = _wire_variant_searchPtr.asFunction<
      void Function(int, int, ffi.Pointer<wire_cst_list_prim_u_8>, int)>();

  ffi.Pointer<ffi.Uint32> cst_new_box_autoadd_u_32(
    int value,
  ) {
    return _cst_new_box_autoadd_u_32(
      value,
    );
  }

  late final _cst_new_box_autoadd_u_32Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<ffi.Uint32> Function(ffi.Uint32)>>(
          'cst_new_box_autoadd_u_32');
  late final _cst_new_box_autoadd_u_32 = _cst_new_box_autoadd_u_32Ptr
      .asFunction<ffi.Pointer<ffi.Uint32> Function(int)>();

  ffi.Pointer<wire_cst_list_String> cst_new_list_String(
    int len,
  ) {
    return _cst_new_list_String(
      len,
    );
  }

  late final _cst_new_list_StringPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_cst_list_String> Function(
              ffi.Int32)>>('cst_new_list_String');
  late final _cst_new_list_String = _cst_new_list_StringPtr
      .asFunction<ffi.Pointer<wire_cst_list_String> Function(int)>();

  ffi.Pointer<wire_cst_list_eg_search_result> cst_new_list_eg_search_result(
    int len,
  ) {
    return _cst_new_list_eg_search_result(
      len,
    );
  }

  late final _cst_new_list_eg_search_resultPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_cst_list_eg_search_result> Function(
              ffi.Int32)>>('cst_new_list_eg_search_result');
  late final _cst_new_list_eg_search_result = _cst_new_list_eg_search_resultPtr
      .asFunction<ffi.Pointer<wire_cst_list_eg_search_result> Function(int)>();

  ffi.Pointer<wire_cst_list_english_search_result>
      cst_new_list_english_search_result(
    int len,
  ) {
    return _cst_new_list_english_search_result(
      len,
    );
  }

  late final _cst_new_list_english_search_resultPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_cst_list_english_search_result> Function(
              ffi.Int32)>>('cst_new_list_english_search_result');
  late final _cst_new_list_english_search_result =
      _cst_new_list_english_search_resultPtr.asFunction<
          ffi.Pointer<wire_cst_list_english_search_result> Function(int)>();

  ffi.Pointer<wire_cst_list_entry_summary> cst_new_list_entry_summary(
    int len,
  ) {
    return _cst_new_list_entry_summary(
      len,
    );
  }

  late final _cst_new_list_entry_summaryPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_cst_list_entry_summary> Function(
              ffi.Int32)>>('cst_new_list_entry_summary');
  late final _cst_new_list_entry_summary = _cst_new_list_entry_summaryPtr
      .asFunction<ffi.Pointer<wire_cst_list_entry_summary> Function(int)>();

  ffi.Pointer<wire_cst_list_matched_segment> cst_new_list_matched_segment(
    int len,
  ) {
    return _cst_new_list_matched_segment(
      len,
    );
  }

  late final _cst_new_list_matched_segmentPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_cst_list_matched_segment> Function(
              ffi.Int32)>>('cst_new_list_matched_segment');
  late final _cst_new_list_matched_segment = _cst_new_list_matched_segmentPtr
      .asFunction<ffi.Pointer<wire_cst_list_matched_segment> Function(int)>();

  ffi.Pointer<wire_cst_list_pr_search_result> cst_new_list_pr_search_result(
    int len,
  ) {
    return _cst_new_list_pr_search_result(
      len,
    );
  }

  late final _cst_new_list_pr_search_resultPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_cst_list_pr_search_result> Function(
              ffi.Int32)>>('cst_new_list_pr_search_result');
  late final _cst_new_list_pr_search_result = _cst_new_list_pr_search_resultPtr
      .asFunction<ffi.Pointer<wire_cst_list_pr_search_result> Function(int)>();

  ffi.Pointer<wire_cst_list_prim_u_32> cst_new_list_prim_u_32(
    int len,
  ) {
    return _cst_new_list_prim_u_32(
      len,
    );
  }

  late final _cst_new_list_prim_u_32Ptr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_cst_list_prim_u_32> Function(
              ffi.Int32)>>('cst_new_list_prim_u_32');
  late final _cst_new_list_prim_u_32 = _cst_new_list_prim_u_32Ptr
      .asFunction<ffi.Pointer<wire_cst_list_prim_u_32> Function(int)>();

  ffi.Pointer<wire_cst_list_prim_u_8> cst_new_list_prim_u_8(
    int len,
  ) {
    return _cst_new_list_prim_u_8(
      len,
    );
  }

  late final _cst_new_list_prim_u_8Ptr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_cst_list_prim_u_8> Function(
              ffi.Int32)>>('cst_new_list_prim_u_8');
  late final _cst_new_list_prim_u_8 = _cst_new_list_prim_u_8Ptr
      .asFunction<ffi.Pointer<wire_cst_list_prim_u_8> Function(int)>();

  ffi.Pointer<wire_cst_list_record_string_string>
      cst_new_list_record_string_string(
    int len,
  ) {
    return _cst_new_list_record_string_string(
      len,
    );
  }

  late final _cst_new_list_record_string_stringPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_cst_list_record_string_string> Function(
              ffi.Int32)>>('cst_new_list_record_string_string');
  late final _cst_new_list_record_string_string =
      _cst_new_list_record_string_stringPtr.asFunction<
          ffi.Pointer<wire_cst_list_record_string_string> Function(int)>();

  ffi.Pointer<wire_cst_list_spotlight_entry_summary>
      cst_new_list_spotlight_entry_summary(
    int len,
  ) {
    return _cst_new_list_spotlight_entry_summary(
      len,
    );
  }

  late final _cst_new_list_spotlight_entry_summaryPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_cst_list_spotlight_entry_summary> Function(
              ffi.Int32)>>('cst_new_list_spotlight_entry_summary');
  late final _cst_new_list_spotlight_entry_summary =
      _cst_new_list_spotlight_entry_summaryPtr.asFunction<
          ffi.Pointer<wire_cst_list_spotlight_entry_summary> Function(int)>();

  ffi.Pointer<wire_cst_list_variant_search_result>
      cst_new_list_variant_search_result(
    int len,
  ) {
    return _cst_new_list_variant_search_result(
      len,
    );
  }

  late final _cst_new_list_variant_search_resultPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_cst_list_variant_search_result> Function(
              ffi.Int32)>>('cst_new_list_variant_search_result');
  late final _cst_new_list_variant_search_result =
      _cst_new_list_variant_search_resultPtr.asFunction<
          ffi.Pointer<wire_cst_list_variant_search_result> Function(int)>();

  int dummy_method_to_enforce_bundling() {
    return _dummy_method_to_enforce_bundling();
  }

  late final _dummy_method_to_enforce_bundlingPtr =
      _lookup<ffi.NativeFunction<ffi.Int64 Function()>>(
          'dummy_method_to_enforce_bundling');
  late final _dummy_method_to_enforce_bundling =
      _dummy_method_to_enforce_bundlingPtr.asFunction<int Function()>();
}

final class wire_cst_list_prim_u_8 extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_cst_list_prim_u_32 extends ffi.Struct {
  external ffi.Pointer<ffi.Uint32> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_cst_list_String extends ffi.Struct {
  external ffi.Pointer<ffi.Pointer<wire_cst_list_prim_u_8>> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_cst_eg_search_result extends ffi.Struct {
  @ffi.Uint32()
  external int id;

  @ffi.Uint32()
  external int def_index;

  @ffi.Uint32()
  external int eg_index;

  external ffi.Pointer<wire_cst_list_prim_u_8> eg;
}

final class wire_cst_list_eg_search_result extends ffi.Struct {
  external ffi.Pointer<wire_cst_eg_search_result> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_cst_matched_segment extends ffi.Struct {
  external ffi.Pointer<wire_cst_list_prim_u_8> segment;

  @ffi.Bool()
  external bool matched;
}

final class wire_cst_list_matched_segment extends ffi.Struct {
  external ffi.Pointer<wire_cst_matched_segment> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_cst_english_search_result extends ffi.Struct {
  @ffi.Uint32()
  external int id;

  @ffi.Uint32()
  external int def_index;

  external ffi.Pointer<wire_cst_list_prim_u_8> variant;

  external ffi.Pointer<wire_cst_list_prim_u_8> pr;

  external ffi.Pointer<wire_cst_list_matched_segment> matched_eng;
}

final class wire_cst_list_english_search_result extends ffi.Struct {
  external ffi.Pointer<wire_cst_english_search_result> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_cst_record_string_string extends ffi.Struct {
  external ffi.Pointer<wire_cst_list_prim_u_8> field0;

  external ffi.Pointer<wire_cst_list_prim_u_8> field1;
}

final class wire_cst_list_record_string_string extends ffi.Struct {
  external ffi.Pointer<wire_cst_record_string_string> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_cst_entry_summary extends ffi.Struct {
  external ffi.Pointer<wire_cst_list_prim_u_8> variant;

  external ffi.Pointer<wire_cst_list_record_string_string> defs;
}

final class wire_cst_list_entry_summary extends ffi.Struct {
  external ffi.Pointer<wire_cst_entry_summary> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_cst_pr_search_result extends ffi.Struct {
  @ffi.Uint32()
  external int id;

  external ffi.Pointer<wire_cst_list_prim_u_8> variant;

  external ffi.Pointer<wire_cst_list_matched_segment> matched_pr;

  external ffi.Pointer<wire_cst_list_String> yues;

  external ffi.Pointer<wire_cst_list_String> engs;
}

final class wire_cst_list_pr_search_result extends ffi.Struct {
  external ffi.Pointer<wire_cst_pr_search_result> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_cst_spotlight_entry_summary extends ffi.Struct {
  @ffi.Uint32()
  external int id;

  external ffi.Pointer<wire_cst_list_String> variants;

  external ffi.Pointer<wire_cst_list_String> variants_simp;

  external ffi.Pointer<wire_cst_list_String> jyutpings;

  external ffi.Pointer<wire_cst_list_String> yales;

  external ffi.Pointer<wire_cst_list_prim_u_8> def;

  external ffi.Pointer<wire_cst_list_prim_u_8> def_simp;

  external ffi.Pointer<wire_cst_list_prim_u_8> def_en;
}

final class wire_cst_list_spotlight_entry_summary extends ffi.Struct {
  external ffi.Pointer<wire_cst_spotlight_entry_summary> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_cst_matched_variant extends ffi.Struct {
  external ffi.Pointer<wire_cst_list_prim_u_8> prefix;

  external ffi.Pointer<wire_cst_list_prim_u_8> query;

  external ffi.Pointer<wire_cst_list_prim_u_8> suffix;
}

final class wire_cst_variant_search_result extends ffi.Struct {
  @ffi.Uint32()
  external int id;

  external wire_cst_matched_variant matched_variant;

  external ffi.Pointer<wire_cst_list_String> yues;

  external ffi.Pointer<wire_cst_list_String> engs;
}

final class wire_cst_list_variant_search_result extends ffi.Struct {
  external ffi.Pointer<wire_cst_variant_search_result> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_cst_combined_search_results extends ffi.Struct {
  external ffi.Pointer<wire_cst_list_variant_search_result> variant_results;

  external ffi.Pointer<wire_cst_list_pr_search_result> pr_results;

  external ffi.Pointer<wire_cst_list_english_search_result> english_results;
}

final class wire_cst_record_opt_string_list_eg_search_result
    extends ffi.Struct {
  external ffi.Pointer<wire_cst_list_prim_u_8> field0;

  external ffi.Pointer<wire_cst_list_eg_search_result> field1;
}
