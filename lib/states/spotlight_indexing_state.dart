import 'dart:async';

import 'package:flutter/foundation.dart';

import '../bridge_generated.dart';
import '../ffi.dart';
import '../models/language.dart';

class SpotlightIndexingState extends ChangeNotifier {
  Timer? _indexingTimer;
  bool _isIndexingInProgress = false; // Flag to keep track of indexing status
  Language? language;
  Romanization? romanization;

  updateSpotlightIndexLanguage(Language newLanguage) {
    language = newLanguage;
    if (language != null && romanization != null) {
      _deferIndexSpotlightSearch(language!, romanization!);
    }
  }

  updateSpotlightIndexRomanization(Romanization newRomanization) {
    romanization = newRomanization;
    if (language != null && romanization != null) {
      _deferIndexSpotlightSearch(language!, romanization!);
    }
  }

  void _deferIndexSpotlightSearch(
      Language language, Romanization romanization) {
    _indexingTimer?.cancel(); // Cancel any existing timer
    _indexingTimer = Timer(const Duration(seconds: 10), () async {
      // Check if an indexing operation is in progress
      if (_isIndexingInProgress) {
        // Defer the indexing
        _deferIndexSpotlightSearch(language, romanization);
        return;
      }

      // Set the flag to indicate that an indexing operation is in progress
      _isIndexingInProgress = true;

      // Perform the indexing
      await indexSpotlightSearch(language, romanization);

      // Reset the flag
      _isIndexingInProgress = false;

      if (kDebugMode) {
        print("Deferred indexing for $language + $romanization executed.");
      }
    });
  }
}
