// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.78.0.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import 'dart:async';
import 'dart:convert';
import 'dart:ffi' as ffi;

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

abstract class WordshkApi {
  Future<void> initApi(
      {required String apiJson,
      required String englishIndexJson,
      required String wordList,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kInitApiConstMeta;

  Future<List<PrSearchResult>> prSearch(
      {required int capacity,
      required String query,
      required Script script,
      required Romanization romanization,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kPrSearchConstMeta;

  Future<List<VariantSearchResult>> variantSearch(
      {required int capacity,
      required String query,
      required Script script,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kVariantSearchConstMeta;

  Future<CombinedSearchResults> combinedSearch(
      {required int capacity,
      required String query,
      required Script script,
      required Romanization romanization,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kCombinedSearchConstMeta;

  Future<List<EnglishSearchResult>> englishSearch(
      {required int capacity,
      required String query,
      required Script script,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kEnglishSearchConstMeta;

  Future<String> getEntryJson({required int id, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kGetEntryJsonConstMeta;

  Future<List<String>> getEntryGroupJson({required int id, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kGetEntryGroupJsonConstMeta;

  Future<int?> getEntryId(
      {required String query, required Script script, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kGetEntryIdConstMeta;

  Future<List<String>> getJyutping({required String query, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kGetJyutpingConstMeta;
}

class CombinedSearchResults {
  final List<VariantSearchResult> variantResults;
  final List<PrSearchResult> prResults;
  final List<EnglishSearchResult> englishResults;

  const CombinedSearchResults({
    required this.variantResults,
    required this.prResults,
    required this.englishResults,
  });
}

class EnglishSearchResult {
  final int id;
  final int defIndex;
  final String variant;
  final String pr;
  final String eng;

  const EnglishSearchResult({
    required this.id,
    required this.defIndex,
    required this.variant,
    required this.pr,
    required this.eng,
  });
}

class PrSearchResult {
  final int id;
  final String variant;
  final String pr;

  const PrSearchResult({
    required this.id,
    required this.variant,
    required this.pr,
  });
}

enum Romanization {
  Jyutping,
  YaleNumbers,
  YaleDiacritics,
  CantonesePinyin,
  Guangdong,
  SidneyLau,
  Ipa,
}

enum Script {
  Simplified,
  Traditional,
}

class VariantSearchResult {
  final int id;
  final String variant;

  const VariantSearchResult({
    required this.id,
    required this.variant,
  });
}

class WordshkApiImpl implements WordshkApi {
  final WordshkApiPlatform _platform;
  factory WordshkApiImpl(ExternalLibrary dylib) =>
      WordshkApiImpl.raw(WordshkApiPlatform(dylib));

  /// Only valid on web/WASM platforms.
  factory WordshkApiImpl.wasm(FutureOr<WasmModule> module) =>
      WordshkApiImpl(module as ExternalLibrary);
  WordshkApiImpl.raw(this._platform);
  Future<void> initApi(
      {required String apiJson,
      required String englishIndexJson,
      required String wordList,
      dynamic hint}) {
    var arg0 = _platform.api2wire_String(apiJson);
    var arg1 = _platform.api2wire_String(englishIndexJson);
    var arg2 = _platform.api2wire_String(wordList);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_init_api(port_, arg0, arg1, arg2),
      parseSuccessData: _wire2api_unit,
      constMeta: kInitApiConstMeta,
      argValues: [apiJson, englishIndexJson, wordList],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kInitApiConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "init_api",
        argNames: ["apiJson", "englishIndexJson", "wordList"],
      );

  Future<List<PrSearchResult>> prSearch(
      {required int capacity,
      required String query,
      required Script script,
      required Romanization romanization,
      dynamic hint}) {
    var arg0 = api2wire_u32(capacity);
    var arg1 = _platform.api2wire_String(query);
    var arg2 = api2wire_script(script);
    var arg3 = api2wire_romanization(romanization);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_pr_search(port_, arg0, arg1, arg2, arg3),
      parseSuccessData: _wire2api_list_pr_search_result,
      constMeta: kPrSearchConstMeta,
      argValues: [capacity, query, script, romanization],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kPrSearchConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "pr_search",
        argNames: ["capacity", "query", "script", "romanization"],
      );

  Future<List<VariantSearchResult>> variantSearch(
      {required int capacity,
      required String query,
      required Script script,
      dynamic hint}) {
    var arg0 = api2wire_u32(capacity);
    var arg1 = _platform.api2wire_String(query);
    var arg2 = api2wire_script(script);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_variant_search(port_, arg0, arg1, arg2),
      parseSuccessData: _wire2api_list_variant_search_result,
      constMeta: kVariantSearchConstMeta,
      argValues: [capacity, query, script],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kVariantSearchConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "variant_search",
        argNames: ["capacity", "query", "script"],
      );

  Future<CombinedSearchResults> combinedSearch(
      {required int capacity,
      required String query,
      required Script script,
      required Romanization romanization,
      dynamic hint}) {
    var arg0 = api2wire_u32(capacity);
    var arg1 = _platform.api2wire_String(query);
    var arg2 = api2wire_script(script);
    var arg3 = api2wire_romanization(romanization);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_combined_search(port_, arg0, arg1, arg2, arg3),
      parseSuccessData: _wire2api_combined_search_results,
      constMeta: kCombinedSearchConstMeta,
      argValues: [capacity, query, script, romanization],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kCombinedSearchConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "combined_search",
        argNames: ["capacity", "query", "script", "romanization"],
      );

  Future<List<EnglishSearchResult>> englishSearch(
      {required int capacity,
      required String query,
      required Script script,
      dynamic hint}) {
    var arg0 = api2wire_u32(capacity);
    var arg1 = _platform.api2wire_String(query);
    var arg2 = api2wire_script(script);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_english_search(port_, arg0, arg1, arg2),
      parseSuccessData: _wire2api_list_english_search_result,
      constMeta: kEnglishSearchConstMeta,
      argValues: [capacity, query, script],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kEnglishSearchConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "english_search",
        argNames: ["capacity", "query", "script"],
      );

  Future<String> getEntryJson({required int id, dynamic hint}) {
    var arg0 = api2wire_u32(id);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_get_entry_json(port_, arg0),
      parseSuccessData: _wire2api_String,
      constMeta: kGetEntryJsonConstMeta,
      argValues: [id],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kGetEntryJsonConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "get_entry_json",
        argNames: ["id"],
      );

  Future<List<String>> getEntryGroupJson({required int id, dynamic hint}) {
    var arg0 = api2wire_u32(id);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_get_entry_group_json(port_, arg0),
      parseSuccessData: _wire2api_StringList,
      constMeta: kGetEntryGroupJsonConstMeta,
      argValues: [id],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kGetEntryGroupJsonConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "get_entry_group_json",
        argNames: ["id"],
      );

  Future<int?> getEntryId(
      {required String query, required Script script, dynamic hint}) {
    var arg0 = _platform.api2wire_String(query);
    var arg1 = api2wire_script(script);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_get_entry_id(port_, arg0, arg1),
      parseSuccessData: _wire2api_opt_box_autoadd_u32,
      constMeta: kGetEntryIdConstMeta,
      argValues: [query, script],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kGetEntryIdConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "get_entry_id",
        argNames: ["query", "script"],
      );

  Future<List<String>> getJyutping({required String query, dynamic hint}) {
    var arg0 = _platform.api2wire_String(query);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_get_jyutping(port_, arg0),
      parseSuccessData: _wire2api_StringList,
      constMeta: kGetJyutpingConstMeta,
      argValues: [query],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kGetJyutpingConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "get_jyutping",
        argNames: ["query"],
      );

  void dispose() {
    _platform.dispose();
  }
// Section: wire2api

  String _wire2api_String(dynamic raw) {
    return raw as String;
  }

  List<String> _wire2api_StringList(dynamic raw) {
    return (raw as List<dynamic>).cast<String>();
  }

  int _wire2api_box_autoadd_u32(dynamic raw) {
    return raw as int;
  }

  CombinedSearchResults _wire2api_combined_search_results(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 3)
      throw Exception('unexpected arr length: expect 3 but see ${arr.length}');
    return CombinedSearchResults(
      variantResults: _wire2api_list_variant_search_result(arr[0]),
      prResults: _wire2api_list_pr_search_result(arr[1]),
      englishResults: _wire2api_list_english_search_result(arr[2]),
    );
  }

  EnglishSearchResult _wire2api_english_search_result(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 5)
      throw Exception('unexpected arr length: expect 5 but see ${arr.length}');
    return EnglishSearchResult(
      id: _wire2api_u32(arr[0]),
      defIndex: _wire2api_u32(arr[1]),
      variant: _wire2api_String(arr[2]),
      pr: _wire2api_String(arr[3]),
      eng: _wire2api_String(arr[4]),
    );
  }

  List<EnglishSearchResult> _wire2api_list_english_search_result(dynamic raw) {
    return (raw as List<dynamic>).map(_wire2api_english_search_result).toList();
  }

  List<PrSearchResult> _wire2api_list_pr_search_result(dynamic raw) {
    return (raw as List<dynamic>).map(_wire2api_pr_search_result).toList();
  }

  List<VariantSearchResult> _wire2api_list_variant_search_result(dynamic raw) {
    return (raw as List<dynamic>).map(_wire2api_variant_search_result).toList();
  }

  int? _wire2api_opt_box_autoadd_u32(dynamic raw) {
    return raw == null ? null : _wire2api_box_autoadd_u32(raw);
  }

  PrSearchResult _wire2api_pr_search_result(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 3)
      throw Exception('unexpected arr length: expect 3 but see ${arr.length}');
    return PrSearchResult(
      id: _wire2api_u32(arr[0]),
      variant: _wire2api_String(arr[1]),
      pr: _wire2api_String(arr[2]),
    );
  }

  int _wire2api_u32(dynamic raw) {
    return raw as int;
  }

  int _wire2api_u8(dynamic raw) {
    return raw as int;
  }

  Uint8List _wire2api_uint_8_list(dynamic raw) {
    return raw as Uint8List;
  }

  void _wire2api_unit(dynamic raw) {
    return;
  }

  VariantSearchResult _wire2api_variant_search_result(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 2)
      throw Exception('unexpected arr length: expect 2 but see ${arr.length}');
    return VariantSearchResult(
      id: _wire2api_u32(arr[0]),
      variant: _wire2api_String(arr[1]),
    );
  }
}

// Section: api2wire

@protected
int api2wire_i32(int raw) {
  return raw;
}

@protected
int api2wire_romanization(Romanization raw) {
  return api2wire_i32(raw.index);
}

@protected
int api2wire_script(Script raw) {
  return api2wire_i32(raw.index);
}

@protected
int api2wire_u32(int raw) {
  return raw;
}

@protected
int api2wire_u8(int raw) {
  return raw;
}

// Section: finalizer

class WordshkApiPlatform extends FlutterRustBridgeBase<WordshkApiWire> {
  WordshkApiPlatform(ffi.DynamicLibrary dylib) : super(WordshkApiWire(dylib));

// Section: api2wire

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_String(String raw) {
    return api2wire_uint_8_list(utf8.encoder.convert(raw));
  }

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_uint_8_list(Uint8List raw) {
    final ans = inner.new_uint_8_list_0(raw.length);
    ans.ref.ptr.asTypedList(raw.length).setAll(0, raw);
    return ans;
  }
// Section: finalizer

// Section: api_fill_to_wire
}

// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_positional_boolean_parameters, annotate_overrides, constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint

/// generated by flutter_rust_bridge
class WordshkApiWire implements FlutterRustBridgeWireBase {
  @internal
  late final dartApi = DartApiDl(init_frb_dart_api_dl);

  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  WordshkApiWire(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  WordshkApiWire.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void store_dart_post_cobject(
    DartPostCObjectFnType ptr,
  ) {
    return _store_dart_post_cobject(
      ptr,
    );
  }

  late final _store_dart_post_cobjectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(DartPostCObjectFnType)>>(
          'store_dart_post_cobject');
  late final _store_dart_post_cobject = _store_dart_post_cobjectPtr
      .asFunction<void Function(DartPostCObjectFnType)>();

  Object get_dart_object(
    int ptr,
  ) {
    return _get_dart_object(
      ptr,
    );
  }

  late final _get_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Handle Function(ffi.UintPtr)>>(
          'get_dart_object');
  late final _get_dart_object =
      _get_dart_objectPtr.asFunction<Object Function(int)>();

  void drop_dart_object(
    int ptr,
  ) {
    return _drop_dart_object(
      ptr,
    );
  }

  late final _drop_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.UintPtr)>>(
          'drop_dart_object');
  late final _drop_dart_object =
      _drop_dart_objectPtr.asFunction<void Function(int)>();

  int new_dart_opaque(
    Object handle,
  ) {
    return _new_dart_opaque(
      handle,
    );
  }

  late final _new_dart_opaquePtr =
      _lookup<ffi.NativeFunction<ffi.UintPtr Function(ffi.Handle)>>(
          'new_dart_opaque');
  late final _new_dart_opaque =
      _new_dart_opaquePtr.asFunction<int Function(Object)>();

  int init_frb_dart_api_dl(
    ffi.Pointer<ffi.Void> obj,
  ) {
    return _init_frb_dart_api_dl(
      obj,
    );
  }

  late final _init_frb_dart_api_dlPtr =
      _lookup<ffi.NativeFunction<ffi.IntPtr Function(ffi.Pointer<ffi.Void>)>>(
          'init_frb_dart_api_dl');
  late final _init_frb_dart_api_dl = _init_frb_dart_api_dlPtr
      .asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  void wire_init_api(
    int port_,
    ffi.Pointer<wire_uint_8_list> api_json,
    ffi.Pointer<wire_uint_8_list> english_index_json,
    ffi.Pointer<wire_uint_8_list> word_list,
  ) {
    return _wire_init_api(
      port_,
      api_json,
      english_index_json,
      word_list,
    );
  }

  late final _wire_init_apiPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64,
              ffi.Pointer<wire_uint_8_list>,
              ffi.Pointer<wire_uint_8_list>,
              ffi.Pointer<wire_uint_8_list>)>>('wire_init_api');
  late final _wire_init_api = _wire_init_apiPtr.asFunction<
      void Function(int, ffi.Pointer<wire_uint_8_list>,
          ffi.Pointer<wire_uint_8_list>, ffi.Pointer<wire_uint_8_list>)>();

  void wire_pr_search(
    int port_,
    int capacity,
    ffi.Pointer<wire_uint_8_list> query,
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
              ffi.Pointer<wire_uint_8_list>,
              ffi.Int32,
              ffi.Int32)>>('wire_pr_search');
  late final _wire_pr_search = _wire_pr_searchPtr.asFunction<
      void Function(int, int, ffi.Pointer<wire_uint_8_list>, int, int)>();

  void wire_variant_search(
    int port_,
    int capacity,
    ffi.Pointer<wire_uint_8_list> query,
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
              ffi.Pointer<wire_uint_8_list>,
              ffi.Int32)>>('wire_variant_search');
  late final _wire_variant_search = _wire_variant_searchPtr.asFunction<
      void Function(int, int, ffi.Pointer<wire_uint_8_list>, int)>();

  void wire_combined_search(
    int port_,
    int capacity,
    ffi.Pointer<wire_uint_8_list> query,
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
              ffi.Pointer<wire_uint_8_list>,
              ffi.Int32,
              ffi.Int32)>>('wire_combined_search');
  late final _wire_combined_search = _wire_combined_searchPtr.asFunction<
      void Function(int, int, ffi.Pointer<wire_uint_8_list>, int, int)>();

  void wire_english_search(
    int port_,
    int capacity,
    ffi.Pointer<wire_uint_8_list> query,
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
              ffi.Pointer<wire_uint_8_list>,
              ffi.Int32)>>('wire_english_search');
  late final _wire_english_search = _wire_english_searchPtr.asFunction<
      void Function(int, int, ffi.Pointer<wire_uint_8_list>, int)>();

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
    ffi.Pointer<wire_uint_8_list> query,
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
          ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>,
              ffi.Int32)>>('wire_get_entry_id');
  late final _wire_get_entry_id = _wire_get_entry_idPtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>, int)>();

  void wire_get_jyutping(
    int port_,
    ffi.Pointer<wire_uint_8_list> query,
  ) {
    return _wire_get_jyutping(
      port_,
      query,
    );
  }

  late final _wire_get_jyutpingPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64, ffi.Pointer<wire_uint_8_list>)>>('wire_get_jyutping');
  late final _wire_get_jyutping = _wire_get_jyutpingPtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  ffi.Pointer<wire_uint_8_list> new_uint_8_list_0(
    int len,
  ) {
    return _new_uint_8_list_0(
      len,
    );
  }

  late final _new_uint_8_list_0Ptr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_uint_8_list> Function(
              ffi.Int32)>>('new_uint_8_list_0');
  late final _new_uint_8_list_0 = _new_uint_8_list_0Ptr
      .asFunction<ffi.Pointer<wire_uint_8_list> Function(int)>();

  void free_WireSyncReturn(
    WireSyncReturn ptr,
  ) {
    return _free_WireSyncReturn(
      ptr,
    );
  }

  late final _free_WireSyncReturnPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(WireSyncReturn)>>(
          'free_WireSyncReturn');
  late final _free_WireSyncReturn =
      _free_WireSyncReturnPtr.asFunction<void Function(WireSyncReturn)>();
}

final class _Dart_Handle extends ffi.Opaque {}

final class wire_uint_8_list extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> ptr;

  @ffi.Int32()
  external int len;
}

typedef DartPostCObjectFnType = ffi.Pointer<
    ffi.NativeFunction<
        ffi.Bool Function(DartPort port_id, ffi.Pointer<ffi.Void> message)>>;
typedef DartPort = ffi.Int64;
