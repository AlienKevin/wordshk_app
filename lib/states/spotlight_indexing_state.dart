import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bridge_generated.dart';
import '../ffi.dart';
import '../main.dart';
import '../models/language.dart';

const indexingDelay = 2;

class SpotlightIndexingState with ChangeNotifier {
  Timer? _indexingTimer;
  bool _isIndexingInProgress = false; // Flag to keep track of indexing status
  Language? language;
  Romanization? romanization;
  bool? enabled;

  SpotlightIndexingState(SharedPreferences prefs) {
    // Load the initial value of the enabled flag
    enabled = prefs.getBool("spotlightIndexingEnabled") ?? false;
  }

  updateSpotlightIndexEnabled(bool newEnabled) {
    // Enable Spotlight if previously disabled
    if (newEnabled && !(enabled!)) {
      if (language != null && romanization != null) {
        _deferIndexSpotlightSearch(language!, romanization!);
      }
    } else {
      // Cancel any existing timer
      if (kDebugMode) {
        print("Cancelling existing timer");
      }
      _indexingTimer?.cancel();
    }
    enabled = newEnabled;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setBool("spotlightIndexingEnabled", newEnabled);
    });
    if (!newEnabled) {
      // Actually delete the index
      _deferDeleteSpotlightIndex();
    }
  }

  initSpotlightIndexLanguage(Language newLanguage) {
    language = newLanguage;
  }

  updateSpotlightIndexLanguage(Language newLanguage) {
    language = newLanguage;
    if (language != null && romanization != null && enabled == true) {
      _deferIndexSpotlightSearch(language!, romanization!);
    }
  }

  initSpotlightIndexRomanization(Romanization newRomanization) {
    romanization = newRomanization;
  }

  updateSpotlightIndexRomanization(Romanization newRomanization) {
    romanization = newRomanization;
    if (language != null && romanization != null && enabled == true) {
      _deferIndexSpotlightSearch(language!, romanization!);
    }
  }

  void _deferDeleteSpotlightIndex() {
    _indexingTimer?.cancel(); // Cancel any existing timer
    _indexingTimer = Timer(const Duration(seconds: indexingDelay), () async {
      // Check if an indexing operation is in progress
      if (_isIndexingInProgress) {
        // Defer the deletion
        _deferDeleteSpotlightIndex();
        return;
      }

      // Set the flag to indicate that an indexing operation is in progress
      _isIndexingInProgress = true;

      await deleteSpotlightSearchIndex();

      // Reset the flag
      _isIndexingInProgress = false;

      if (kDebugMode) {
        print("Deferred index deletion executed.");
      }
    });
  }

  void _deferIndexSpotlightSearch(
      Language language, Romanization romanization) {
    _indexingTimer?.cancel(); // Cancel any existing timer
    _indexingTimer = Timer(const Duration(seconds: indexingDelay), () async {
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
          content: Text(switch (language) {
            Language.en =>
              'Notice: The app might be a bit jerky for a few minutes while we update the dictionary data. Thanks for your patience.',
            Language.yue => '小提示：我哋喺度更新緊詞典資料，個app喺接落嚟嘅幾分鐘內可能會lag機。多謝你嘅耐心等候。',
            Language.zhHant => '小提示：我們正在更新詞典資料，APP在接下來的幾分鐘内可能會有卡頓。感謝您的耐心等待。',
            Language.zhHans => '小提示：我们正在更新词典资料，APP在接下来的两分钟内可能会有卡顿。感谢您的耐心等待。',
          }),
          duration: const Duration(minutes: 2),
          margin: const EdgeInsets.only(bottom: 50.0),
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.none,
          action: SnackBarAction(
            label: switch (language) {
              Language.en => 'OK',
              Language.yue || Language.zhHant || Language.zhHans => '好的',
            },
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
