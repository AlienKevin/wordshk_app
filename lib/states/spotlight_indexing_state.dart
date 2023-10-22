import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../bridge_generated.dart';
import '../ffi.dart';
import '../main.dart';
import '../models/language.dart';

class SpotlightIndexingState {
  Timer? _indexingTimer;
  bool _isIndexingInProgress = false; // Flag to keep track of indexing status
  Language? language;
  Romanization? romanization;

  updateSpotlightIndexLanguage(Language newLanguage) {
    print("updateSpotlightIndexLanguage");
    language = newLanguage;
    if (language != null && romanization != null) {
      _deferIndexSpotlightSearch(language!, romanization!);
    }
  }

  updateSpotlightIndexRomanization(Romanization newRomanization) {
    print("updateSpotlightIndexRomanization");
    romanization = newRomanization;
    if (language != null && romanization != null) {
      _deferIndexSpotlightSearch(language!, romanization!);
    }
  }

  void _deferIndexSpotlightSearch(
      Language language, Romanization romanization) {
    print("_deferIndexSpotlightSearch");
    _indexingTimer?.cancel(); // Cancel any existing timer
    _indexingTimer = Timer(const Duration(seconds: 10), () async {
      print("Running indexing. _isIndexingInProgress: $_isIndexingInProgress");

      // Check if an indexing operation is in progress
      if (_isIndexingInProgress) {
        // Defer the indexing
        _deferIndexSpotlightSearch(language, romanization);
        return;
      }

      // Set the flag to indicate that an indexing operation is in progress
      _isIndexingInProgress = true;

      // Show a banner to indicate that the indexing is in progress
      scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
          content: Text(
              switch (language) {
                Language.en => 'Quick heads-up: The app might be a bit jerky for a few minutes while we update the search index. Thanks for your patience.',
                Language.yue => '小提示：我哋喺度更新緊索引，app喺接落嚟嘅幾分鐘內可能會lag機。多謝你嘅耐心等候。',
                Language.zhHant => '小提示：我們正在更新索引，APP在接下來的幾分鐘内可能會有卡頓。感謝您的耐心等待。',
                Language.zhHans => '小提示：我们正在更新索引，APP在接下来的两分钟内可能会有卡顿。感谢您的耐心等待。',
              }),
          duration: const Duration(minutes: 2),
          action: SnackBarAction(
            label: switch (language) {
              Language.en => 'OK',
              Language.yue || Language.zhHant || Language.zhHans => '了解',
            },
            textColor: Colors.white,
            onPressed: () {
              scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            },
          )));

      // Perform the indexing
      await indexSpotlightSearch(language, romanization);

      scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

      // Reset the flag
      _isIndexingInProgress = false;

      if (kDebugMode) {
        print("Deferred indexing for $language + $romanization executed.");
      }
    });
  }
}
