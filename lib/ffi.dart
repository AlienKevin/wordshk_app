import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core_spotlight/flutter_core_spotlight.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

import 'bridge_generated.dart';
import 'models/language.dart';

const base = 'wordshk_api';
final path = Platform.isWindows ? '$base.dll' : 'lib$base.so';
late final dylib = loadLibForFlutter(path);
late final api = WordshkApiImpl(dylib);

Future<void> indexSpotlightSearch(
    Language language, Romanization romanization) async {
  // Delete previous index
  await deleteSpotlightSearchIndex();

  // Indexing a searchable item
  final summaries = await api.getSplotlightSummaries();
  // Run the indexing in a separate isolate
  // to prevent janking the UI
  BackgroundIsolateBinaryMessenger.ensureInitialized(
      RootIsolateToken.instance!);
  Stream<(int, List<T>)> chunkIterable<T>(
      Iterable<T> iterable, int chunkSize) async* {
    var iterator = iterable.iterator;
    var i = 0;
    while (iterator.moveNext()) {
      var currentChunk = <T>[];
      do {
        currentChunk.add(iterator.current);
      } while (currentChunk.length < chunkSize && iterator.moveNext());
      yield (i, currentChunk);
      i += 1;
    }
  }

  final items = await compute(
      (_) => summaries.expand((summary) {
            final prs = switch (romanization) {
              Romanization.Jyutping => summary.jyutpings,
              Romanization.Yale => summary.yales,
            };
            return summary.variants
                .mapIndexed((i, variant) => switch (language) {
                      Language.en => [
                          FlutterSpotlightItem(
                            uniqueIdentifier: "${summary.id}-$i-trad",
                            domainIdentifier: 'hk.words.wordshk',
                            attributeTitle: 'define $variant ${prs[i]}',
                            attributeDescription: summary.defEn,
                          )
                        ],
                      Language.yue || Language.zhHant => [
                          FlutterSpotlightItem(
                            uniqueIdentifier: "${summary.id}-$i-trad",
                            domainIdentifier: 'hk.words.wordshk',
                            attributeTitle: '解釋 $variant ${prs[i]}',
                            attributeDescription: summary.def,
                          )
                        ],
                      Language.zhHans =>
                        (summary.variantsSimp[i] == summary.variants[i]
                                ? <FlutterSpotlightItem>[]
                                : [
                                    FlutterSpotlightItem(
                                      uniqueIdentifier: "${summary.id}-$i-simp",
                                      domainIdentifier: 'hk.words.wordshk',
                                      attributeTitle:
                                          '解释 ${summary.variantsSimp[i]} ${prs[i]}',
                                      attributeDescription: summary.defSimp,
                                    ),
                                  ]) +
                            [
                              FlutterSpotlightItem(
                                uniqueIdentifier: "${summary.id}-$i-trad",
                                domainIdentifier: 'hk.words.wordshk',
                                attributeTitle:
                                    '解释 ${summary.variants[i]} ${prs[i]}',
                                attributeDescription: summary.defSimp,
                              )
                            ],
                    })
                .expand((i) => i)
                // check for empty defEn
                .where((item) => item.attributeDescription.isNotEmpty);
          }),
      ());

  if (kDebugMode) {
    print("Indexing ${items.length} items");
  }

  const batchSize = 10000;

  final batches = chunkIterable(items, batchSize);

  await for (final (i, batch) in batches) {
    String result =
        await FlutterCoreSpotlight.instance.indexSearchableItems(batch);
    if (kDebugMode) {
      print(
          "Index spotlight batch ${i + 1}/${(items.length / batchSize).ceil()} result: $result");
    }
  }
}

Future<void> deleteSpotlightSearchIndex() async {
  // Indexing a searchable item
  final summaries = await api.getSplotlightSummaries();
  // Run the deletion in a separate isolate
  // to prevent janking the UI
  BackgroundIsolateBinaryMessenger.ensureInitialized(
      RootIsolateToken.instance!);
  Stream<(int, List<T>)> chunkIterable<T>(
      Iterable<T> iterable, int chunkSize) async* {
    var iterator = iterable.iterator;
    var i = 0;
    while (iterator.moveNext()) {
      var currentChunk = <T>[];
      do {
        currentChunk.add(iterator.current);
      } while (currentChunk.length < chunkSize && iterator.moveNext());
      yield (i, currentChunk);
      i += 1;
    }
  }

  final items = summaries.expand((summary) => summary.variants
      .mapIndexed((i, variant) => [
            "${summary.id}-$i-simp",
            "${summary.id}-$i-trad",
          ])
      .expand((i) => i));

  if (kDebugMode) {
    print("Deleting ${items.length} items");
  }

  const batchSize = 10000;

  final batches = chunkIterable(items, batchSize);

  await for (final (i, batch) in batches) {
    String result =
        await FlutterCoreSpotlight.instance.deleteSearchableItems(batch);
    if (kDebugMode) {
      print(
          "Deleting spotlight index batch ${i + 1}/${(items.length / batchSize).ceil()} result: $result");
    }
  }
}
