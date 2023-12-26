// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.4.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_web.dart';

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
  bool sse_decode_bool(SseDeserializer deserializer);

  @protected
  String cst_encode_AnyhowException(AnyhowException raw) {
    throw UnimplementedError();
  }

  @protected
  String cst_encode_String(String raw) {
    return raw;
  }

  @protected
  int cst_encode_box_autoadd_u_32(int raw) {
    return cst_encode_u_32(raw);
  }

  @protected
  List<dynamic> cst_encode_combined_search_results(CombinedSearchResults raw) {
    return [
      cst_encode_list_variant_search_result(raw.variantResults),
      cst_encode_list_pr_search_result(raw.prResults),
      cst_encode_list_english_search_result(raw.englishResults)
    ];
  }

  @protected
  List<dynamic> cst_encode_eg_search_result(EgSearchResult raw) {
    return [
      cst_encode_u_32(raw.id),
      cst_encode_u_32(raw.defIndex),
      cst_encode_u_32(raw.egIndex),
      cst_encode_String(raw.eg)
    ];
  }

  @protected
  List<dynamic> cst_encode_english_search_result(EnglishSearchResult raw) {
    return [
      cst_encode_u_32(raw.id),
      cst_encode_u_32(raw.defIndex),
      cst_encode_String(raw.variant),
      cst_encode_String(raw.pr),
      cst_encode_String(raw.eng)
    ];
  }

  @protected
  List<dynamic> cst_encode_entry_summary(EntrySummary raw) {
    return [
      cst_encode_String(raw.variant),
      cst_encode_list_record_string_string(raw.defs)
    ];
  }

  @protected
  List<dynamic> cst_encode_list_String(List<String> raw) {
    return raw.map(cst_encode_String).toList();
  }

  @protected
  List<dynamic> cst_encode_list_eg_search_result(List<EgSearchResult> raw) {
    return raw.map(cst_encode_eg_search_result).toList();
  }

  @protected
  List<dynamic> cst_encode_list_english_search_result(
      List<EnglishSearchResult> raw) {
    return raw.map(cst_encode_english_search_result).toList();
  }

  @protected
  List<dynamic> cst_encode_list_entry_summary(List<EntrySummary> raw) {
    return raw.map(cst_encode_entry_summary).toList();
  }

  @protected
  List<dynamic> cst_encode_list_pr_search_result(List<PrSearchResult> raw) {
    return raw.map(cst_encode_pr_search_result).toList();
  }

  @protected
  Uint32List cst_encode_list_prim_u_32(Uint32List raw) {
    return raw;
  }

  @protected
  Uint8List cst_encode_list_prim_u_8(Uint8List raw) {
    return raw;
  }

  @protected
  List<dynamic> cst_encode_list_record_string_string(
      List<(String, String)> raw) {
    return raw.map(cst_encode_record_string_string).toList();
  }

  @protected
  List<dynamic> cst_encode_list_spotlight_entry_summary(
      List<SpotlightEntrySummary> raw) {
    return raw.map(cst_encode_spotlight_entry_summary).toList();
  }

  @protected
  List<dynamic> cst_encode_list_variant_search_result(
      List<VariantSearchResult> raw) {
    return raw.map(cst_encode_variant_search_result).toList();
  }

  @protected
  String? cst_encode_opt_String(String? raw) {
    return raw == null ? null : cst_encode_String(raw);
  }

  @protected
  int? cst_encode_opt_box_autoadd_u_32(int? raw) {
    return raw == null ? null : cst_encode_box_autoadd_u_32(raw);
  }

  @protected
  List<dynamic> cst_encode_pr_search_result(PrSearchResult raw) {
    return [
      cst_encode_u_32(raw.id),
      cst_encode_String(raw.variant),
      cst_encode_String(raw.pr),
      cst_encode_list_String(raw.yues),
      cst_encode_list_String(raw.engs)
    ];
  }

  @protected
  List<dynamic> cst_encode_record_opt_string_list_eg_search_result(
      (String?, List<EgSearchResult>) raw) {
    return [
      cst_encode_opt_String(raw.$1),
      cst_encode_list_eg_search_result(raw.$2)
    ];
  }

  @protected
  List<dynamic> cst_encode_record_string_string((String, String) raw) {
    return [cst_encode_String(raw.$1), cst_encode_String(raw.$2)];
  }

  @protected
  List<dynamic> cst_encode_spotlight_entry_summary(SpotlightEntrySummary raw) {
    return [
      cst_encode_u_32(raw.id),
      cst_encode_list_String(raw.variants),
      cst_encode_list_String(raw.variantsSimp),
      cst_encode_list_String(raw.jyutpings),
      cst_encode_list_String(raw.yales),
      cst_encode_String(raw.def),
      cst_encode_String(raw.defSimp),
      cst_encode_String(raw.defEn)
    ];
  }

  @protected
  List<dynamic> cst_encode_variant_search_result(VariantSearchResult raw) {
    return [
      cst_encode_u_32(raw.id),
      cst_encode_String(raw.variant),
      cst_encode_list_String(raw.yues),
      cst_encode_list_String(raw.engs)
    ];
  }

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

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer);
}

// Section: wire_class

class RustLibWire extends BaseWire {
  RustLibWire.fromExternalLibrary(ExternalLibrary lib);

  void dart_fn_deliver_output(int call_id, PlatformGeneralizedUint8ListPtr ptr_,
          int rust_vec_len_, int data_len_) =>
      wasmModule.dart_fn_deliver_output(
          call_id, ptr_, rust_vec_len_, data_len_);

  void wire_combined_search(NativePortType port_, int capacity, String query,
          int script, int romanization) =>
      wasmModule.wire_combined_search(
          port_, capacity, query, script, romanization);

  void wire_create_log_stream(NativePortType port_) =>
      wasmModule.wire_create_log_stream(port_);

  void wire_eg_search(NativePortType port_, int capacity,
          int max_first_index_in_eg, String query, int script) =>
      wasmModule.wire_eg_search(
          port_, capacity, max_first_index_in_eg, query, script);

  void wire_english_search(
          NativePortType port_, int capacity, String query, int script) =>
      wasmModule.wire_english_search(port_, capacity, query, script);

  void wire_generate_pr_indices(
          NativePortType port_, int romanization, String pr_indices_path) =>
      wasmModule.wire_generate_pr_indices(port_, romanization, pr_indices_path);

  void wire_get_entry_group_json(NativePortType port_, int id) =>
      wasmModule.wire_get_entry_group_json(port_, id);

  void wire_get_entry_id(NativePortType port_, String query, int script) =>
      wasmModule.wire_get_entry_id(port_, query, script);

  void wire_get_entry_json(NativePortType port_, int id) =>
      wasmModule.wire_get_entry_json(port_, id);

  void wire_get_entry_summaries(
          NativePortType port_, Uint32List entry_ids, int script) =>
      wasmModule.wire_get_entry_summaries(port_, entry_ids, script);

  void wire_get_jyutping(NativePortType port_, String query) =>
      wasmModule.wire_get_jyutping(port_, query);

  void wire_get_splotlight_summaries(NativePortType port_) =>
      wasmModule.wire_get_splotlight_summaries(port_);

  void wire_init_api(NativePortType port_, Uint8List dict_data,
          Uint8List english_index_data) =>
      wasmModule.wire_init_api(port_, dict_data, english_index_data);

  void wire_pr_search(NativePortType port_, int capacity, String query,
          int script, int romanization) =>
      wasmModule.wire_pr_search(port_, capacity, query, script, romanization);

  void wire_update_pr_indices(NativePortType port_, String pr_indices_path) =>
      wasmModule.wire_update_pr_indices(port_, pr_indices_path);

  void wire_variant_search(
          NativePortType port_, int capacity, String query, int script) =>
      wasmModule.wire_variant_search(port_, capacity, query, script);
}

@JS('wasm_bindgen')
external RustLibWasmModule get wasmModule;

@JS()
@anonymous
class RustLibWasmModule implements WasmModule {
  @override
  external Object /* Promise */ call([String? moduleName]);

  @override
  external RustLibWasmModule bind(dynamic thisArg, String moduleName);

  external void dart_fn_deliver_output(int call_id,
      PlatformGeneralizedUint8ListPtr ptr_, int rust_vec_len_, int data_len_);

  external void wire_combined_search(NativePortType port_, int capacity,
      String query, int script, int romanization);

  external void wire_create_log_stream(NativePortType port_);

  external void wire_eg_search(NativePortType port_, int capacity,
      int max_first_index_in_eg, String query, int script);

  external void wire_english_search(
      NativePortType port_, int capacity, String query, int script);

  external void wire_generate_pr_indices(
      NativePortType port_, int romanization, String pr_indices_path);

  external void wire_get_entry_group_json(NativePortType port_, int id);

  external void wire_get_entry_id(
      NativePortType port_, String query, int script);

  external void wire_get_entry_json(NativePortType port_, int id);

  external void wire_get_entry_summaries(
      NativePortType port_, Uint32List entry_ids, int script);

  external void wire_get_jyutping(NativePortType port_, String query);

  external void wire_get_splotlight_summaries(NativePortType port_);

  external void wire_init_api(
      NativePortType port_, Uint8List dict_data, Uint8List english_index_data);

  external void wire_pr_search(NativePortType port_, int capacity, String query,
      int script, int romanization);

  external void wire_update_pr_indices(
      NativePortType port_, String pr_indices_path);

  external void wire_variant_search(
      NativePortType port_, int capacity, String query, int script);
}
