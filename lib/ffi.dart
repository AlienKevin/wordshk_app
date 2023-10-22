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

Future<void> indexSpotlightSearch(Language language) async {
  // Indexing a searchable item
  final summaries = await api.getSplotlightSummaries();
  // Run the indexing in a separate isolate
  // to prevent janking the UI
  BackgroundIsolateBinaryMessenger.ensureInitialized(
      RootIsolateToken.instance!);
  if (kDebugMode) {
    print("Indexing ${summaries.length} items");
  }
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

  const batchSize = 200;

  final batches = chunkIterable(
      summaries.expand((summary) => summary.variants
          .mapIndexed((i, variant) => switch (language) {
                Language.en => [
                    FlutterSpotlightItem(
                      uniqueIdentifier: "${summary.id}-$i-trad",
                      domainIdentifier: 'hk.words.wordshk',
                      attributeTitle: 'define $variant ${summary.prs[i]}',
                      attributeDescription: summary.defEn,
                    )
                  ],
                Language.yue || Language.zhHant => [
                    FlutterSpotlightItem(
                      uniqueIdentifier: "${summary.id}-$i-trad",
                      domainIdentifier: 'hk.words.wordshk',
                      attributeTitle: '解釋 $variant ${summary.prs[i]}',
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
                                    '解释 ${summary.variantsSimp[i]} ${summary.prs[i]}',
                                attributeDescription: summary.defSimp,
                              ),
                            ]) +
                      [
                        FlutterSpotlightItem(
                          uniqueIdentifier: "${summary.id}-$i-trad",
                          domainIdentifier: 'hk.words.wordshk',
                          attributeTitle:
                              '解释 ${summary.variants[i]} ${summary.prs[i]}',
                          attributeDescription: summary.defSimp,
                        )
                      ],
              })
          .expand((i) => i)
          // check for empty defEn
          .where((item) => item.attributeDescription.isNotEmpty)),
      batchSize);

  await for (final (i, batch) in batches) {
    String result =
        await FlutterCoreSpotlight.instance.indexSearchableItems(batch);
    print("Index spotlight batch $i result: $result");
  }
}
