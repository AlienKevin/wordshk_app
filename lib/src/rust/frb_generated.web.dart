// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.11.

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
  String dco_decode_String(dynamic raw);

  @protected
  bool dco_decode_bool(dynamic raw);

  @protected
  int dco_decode_box_autoadd_u_32(dynamic raw);

  @protected
  int dco_decode_box_autoadd_usize(dynamic raw);

  @protected
  CombinedSearchResults dco_decode_combined_search_results(dynamic raw);

  @protected
  EgSearchResult dco_decode_eg_search_result(dynamic raw);

  @protected
  EnglishSearchResult dco_decode_english_search_result(dynamic raw);

  @protected
  EntryDef dco_decode_entry_def(dynamic raw);

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
  List<EntryDef> dco_decode_list_entry_def(dynamic raw);

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
  List<VariantSearchResult> dco_decode_list_variant_search_result(dynamic raw);

  @protected
  MatchedInfix dco_decode_matched_infix(dynamic raw);

  @protected
  MatchedSegment dco_decode_matched_segment(dynamic raw);

  @protected
  int? dco_decode_opt_box_autoadd_u_32(dynamic raw);

  @protected
  int? dco_decode_opt_box_autoadd_usize(dynamic raw);

  @protected
  PrSearchResult dco_decode_pr_search_result(dynamic raw);

  @protected
  (int?, List<EnglishSearchResult>)
      dco_decode_record_opt_box_autoadd_usize_list_english_search_result(
          dynamic raw);

  @protected
  (
    int?,
    List<PrSearchResult>
  ) dco_decode_record_opt_box_autoadd_usize_list_pr_search_result(dynamic raw);

  @protected
  (int?, List<VariantSearchResult>)
      dco_decode_record_opt_box_autoadd_usize_list_variant_search_result(
          dynamic raw);

  @protected
  Romanization dco_decode_romanization(dynamic raw);

  @protected
  Script dco_decode_script(dynamic raw);

  @protected
  int dco_decode_u_32(dynamic raw);

  @protected
  int dco_decode_u_8(dynamic raw);

  @protected
  void dco_decode_unit(dynamic raw);

  @protected
  int dco_decode_usize(dynamic raw);

  @protected
  VariantSearchResult dco_decode_variant_search_result(dynamic raw);

  @protected
  String sse_decode_String(SseDeserializer deserializer);

  @protected
  bool sse_decode_bool(SseDeserializer deserializer);

  @protected
  int sse_decode_box_autoadd_u_32(SseDeserializer deserializer);

  @protected
  int sse_decode_box_autoadd_usize(SseDeserializer deserializer);

  @protected
  CombinedSearchResults sse_decode_combined_search_results(
      SseDeserializer deserializer);

  @protected
  EgSearchResult sse_decode_eg_search_result(SseDeserializer deserializer);

  @protected
  EnglishSearchResult sse_decode_english_search_result(
      SseDeserializer deserializer);

  @protected
  EntryDef sse_decode_entry_def(SseDeserializer deserializer);

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
  List<EntryDef> sse_decode_list_entry_def(SseDeserializer deserializer);

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
  List<VariantSearchResult> sse_decode_list_variant_search_result(
      SseDeserializer deserializer);

  @protected
  MatchedInfix sse_decode_matched_infix(SseDeserializer deserializer);

  @protected
  MatchedSegment sse_decode_matched_segment(SseDeserializer deserializer);

  @protected
  int? sse_decode_opt_box_autoadd_u_32(SseDeserializer deserializer);

  @protected
  int? sse_decode_opt_box_autoadd_usize(SseDeserializer deserializer);

  @protected
  PrSearchResult sse_decode_pr_search_result(SseDeserializer deserializer);

  @protected
  (int?, List<EnglishSearchResult>)
      sse_decode_record_opt_box_autoadd_usize_list_english_search_result(
          SseDeserializer deserializer);

  @protected
  (int?, List<PrSearchResult>)
      sse_decode_record_opt_box_autoadd_usize_list_pr_search_result(
          SseDeserializer deserializer);

  @protected
  (int?, List<VariantSearchResult>)
      sse_decode_record_opt_box_autoadd_usize_list_variant_search_result(
          SseDeserializer deserializer);

  @protected
  Romanization sse_decode_romanization(SseDeserializer deserializer);

  @protected
  Script sse_decode_script(SseDeserializer deserializer);

  @protected
  int sse_decode_u_32(SseDeserializer deserializer);

  @protected
  int sse_decode_u_8(SseDeserializer deserializer);

  @protected
  void sse_decode_unit(SseDeserializer deserializer);

  @protected
  int sse_decode_usize(SseDeserializer deserializer);

  @protected
  VariantSearchResult sse_decode_variant_search_result(
      SseDeserializer deserializer);

  @protected
  String cst_encode_String(String raw) {
    return raw;
  }

  @protected
  int cst_encode_box_autoadd_u_32(int raw) {
    return cst_encode_u_32(raw);
  }

  @protected
  int cst_encode_box_autoadd_usize(int raw) {
    return cst_encode_usize(raw);
  }

  @protected
  List<dynamic> cst_encode_combined_search_results(CombinedSearchResults raw) {
    return [
      cst_encode_record_opt_box_autoadd_usize_list_variant_search_result(
          raw.variantResults),
      cst_encode_record_opt_box_autoadd_usize_list_pr_search_result(
          raw.prResults),
      cst_encode_record_opt_box_autoadd_usize_list_english_search_result(
          raw.englishResults)
    ];
  }

  @protected
  List<dynamic> cst_encode_eg_search_result(EgSearchResult raw) {
    return [
      cst_encode_u_32(raw.id),
      cst_encode_u_32(raw.defIndex),
      cst_encode_u_32(raw.egIndex),
      cst_encode_matched_infix(raw.matchedEg)
    ];
  }

  @protected
  List<dynamic> cst_encode_english_search_result(EnglishSearchResult raw) {
    return [
      cst_encode_u_32(raw.id),
      cst_encode_u_32(raw.defIndex),
      cst_encode_list_String(raw.variants),
      cst_encode_list_matched_segment(raw.matchedEng)
    ];
  }

  @protected
  List<dynamic> cst_encode_entry_def(EntryDef raw) {
    return [
      cst_encode_String(raw.yueTrad),
      cst_encode_String(raw.yueSimp),
      cst_encode_String(raw.eng)
    ];
  }

  @protected
  List<dynamic> cst_encode_entry_summary(EntrySummary raw) {
    return [
      cst_encode_String(raw.variantTrad),
      cst_encode_String(raw.variantSimp),
      cst_encode_list_entry_def(raw.defs)
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
  List<dynamic> cst_encode_list_entry_def(List<EntryDef> raw) {
    return raw.map(cst_encode_entry_def).toList();
  }

  @protected
  List<dynamic> cst_encode_list_entry_summary(List<EntrySummary> raw) {
    return raw.map(cst_encode_entry_summary).toList();
  }

  @protected
  List<dynamic> cst_encode_list_matched_segment(List<MatchedSegment> raw) {
    return raw.map(cst_encode_matched_segment).toList();
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
  List<dynamic> cst_encode_list_variant_search_result(
      List<VariantSearchResult> raw) {
    return raw.map(cst_encode_variant_search_result).toList();
  }

  @protected
  List<dynamic> cst_encode_matched_infix(MatchedInfix raw) {
    return [
      cst_encode_String(raw.prefix),
      cst_encode_String(raw.query),
      cst_encode_String(raw.suffix)
    ];
  }

  @protected
  List<dynamic> cst_encode_matched_segment(MatchedSegment raw) {
    return [cst_encode_String(raw.segment), cst_encode_bool(raw.matched)];
  }

  @protected
  int? cst_encode_opt_box_autoadd_u_32(int? raw) {
    return raw == null ? null : cst_encode_box_autoadd_u_32(raw);
  }

  @protected
  int? cst_encode_opt_box_autoadd_usize(int? raw) {
    return raw == null ? null : cst_encode_box_autoadd_usize(raw);
  }

  @protected
  List<dynamic> cst_encode_pr_search_result(PrSearchResult raw) {
    return [
      cst_encode_u_32(raw.id),
      cst_encode_list_String(raw.variants),
      cst_encode_list_matched_segment(raw.matchedPr),
      cst_encode_list_String(raw.yues),
      cst_encode_list_String(raw.engs)
    ];
  }

  @protected
  List<dynamic>
      cst_encode_record_opt_box_autoadd_usize_list_english_search_result(
          (int?, List<EnglishSearchResult>) raw) {
    return [
      cst_encode_opt_box_autoadd_usize(raw.$1),
      cst_encode_list_english_search_result(raw.$2)
    ];
  }

  @protected
  List<dynamic> cst_encode_record_opt_box_autoadd_usize_list_pr_search_result(
      (int?, List<PrSearchResult>) raw) {
    return [
      cst_encode_opt_box_autoadd_usize(raw.$1),
      cst_encode_list_pr_search_result(raw.$2)
    ];
  }

  @protected
  List<dynamic>
      cst_encode_record_opt_box_autoadd_usize_list_variant_search_result(
          (int?, List<VariantSearchResult>) raw) {
    return [
      cst_encode_opt_box_autoadd_usize(raw.$1),
      cst_encode_list_variant_search_result(raw.$2)
    ];
  }

  @protected
  List<dynamic> cst_encode_variant_search_result(VariantSearchResult raw) {
    return [
      cst_encode_u_32(raw.id),
      cst_encode_matched_infix(raw.matchedVariant),
      cst_encode_list_String(raw.yues),
      cst_encode_list_String(raw.engs)
    ];
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
  int cst_encode_usize(int raw);

  @protected
  void sse_encode_String(String self, SseSerializer serializer);

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_u_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_usize(int self, SseSerializer serializer);

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
  void sse_encode_entry_def(EntryDef self, SseSerializer serializer);

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
  void sse_encode_list_entry_def(List<EntryDef> self, SseSerializer serializer);

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
  void sse_encode_list_variant_search_result(
      List<VariantSearchResult> self, SseSerializer serializer);

  @protected
  void sse_encode_matched_infix(MatchedInfix self, SseSerializer serializer);

  @protected
  void sse_encode_matched_segment(
      MatchedSegment self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_u_32(int? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_usize(int? self, SseSerializer serializer);

  @protected
  void sse_encode_pr_search_result(
      PrSearchResult self, SseSerializer serializer);

  @protected
  void sse_encode_record_opt_box_autoadd_usize_list_english_search_result(
      (int?, List<EnglishSearchResult>) self, SseSerializer serializer);

  @protected
  void sse_encode_record_opt_box_autoadd_usize_list_pr_search_result(
      (int?, List<PrSearchResult>) self, SseSerializer serializer);

  @protected
  void sse_encode_record_opt_box_autoadd_usize_list_variant_search_result(
      (int?, List<VariantSearchResult>) self, SseSerializer serializer);

  @protected
  void sse_encode_romanization(Romanization self, SseSerializer serializer);

  @protected
  void sse_encode_script(Script self, SseSerializer serializer);

  @protected
  void sse_encode_u_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_unit(void self, SseSerializer serializer);

  @protected
  void sse_encode_usize(int self, SseSerializer serializer);

  @protected
  void sse_encode_variant_search_result(
      VariantSearchResult self, SseSerializer serializer);
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

  void wire_generate_pr_indices(NativePortType port_, int romanization) =>
      wasmModule.wire_generate_pr_indices(port_, romanization);

  void wire_get_entry_group_json(NativePortType port_, int id) =>
      wasmModule.wire_get_entry_group_json(port_, id);

  void wire_get_entry_id(NativePortType port_, String query, int script) =>
      wasmModule.wire_get_entry_id(port_, query, script);

  void wire_get_entry_json(NativePortType port_, int id) =>
      wasmModule.wire_get_entry_json(port_, id);

  void wire_get_entry_summaries(NativePortType port_, Uint32List entry_ids) =>
      wasmModule.wire_get_entry_summaries(port_, entry_ids);

  void wire_get_jyutping(NativePortType port_, String query) =>
      wasmModule.wire_get_jyutping(port_, query);

  void wire_init_api(NativePortType port_) => wasmModule.wire_init_api(port_);

  void wire_init_utils(NativePortType port_) =>
      wasmModule.wire_init_utils(port_);
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

  external void wire_generate_pr_indices(
      NativePortType port_, int romanization);

  external void wire_get_entry_group_json(NativePortType port_, int id);

  external void wire_get_entry_id(
      NativePortType port_, String query, int script);

  external void wire_get_entry_json(NativePortType port_, int id);

  external void wire_get_entry_summaries(
      NativePortType port_, Uint32List entry_ids);

  external void wire_get_jyutping(NativePortType port_, String query);

  external void wire_init_api(NativePortType port_);

  external void wire_init_utils(NativePortType port_);
}
