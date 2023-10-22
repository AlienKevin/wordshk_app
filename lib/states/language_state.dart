import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ffi.dart';
import '../models/language.dart';

class LanguageState with ChangeNotifier {
  Language? language;
  Timer? _indexingTimer;
  bool _isIndexingInProgress = false;  // Flag to keep track of indexing status

  LanguageState(SharedPreferences prefs, BuildContext context) {
    final languageIndex = prefs.getInt("language");
    if (languageIndex != null) {
      language = Language.values[languageIndex];
      if (kDebugMode) {
        print("Loaded user language $language");
      }
    }
  }

  Locale initLanguage(Language newLanguage) {
    language ??= newLanguage;

    if (Platform.isIOS || Platform.isMacOS) {
      _indexingTimer?.cancel();  // Cancel any existing timer
      _deferIndexSpotlightSearch(newLanguage);
    }

    return newLanguage.toLocale;
  }

  void updateLanguage(Language newLanguage) {
    if (Platform.isIOS || Platform.isMacOS) {
      _indexingTimer?.cancel();  // Cancel any existing timer
      if (language != newLanguage) {
        _deferIndexSpotlightSearch(newLanguage);
      }
    }

    language = newLanguage;

    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("language", newLanguage.index);
    });
  }

  void _deferIndexSpotlightSearch(Language newLanguage) {
    _indexingTimer = Timer(const Duration(seconds: 10), () async {
      // Check if an indexing operation is in progress
      if (_isIndexingInProgress) {
        // Defer the indexing
        _deferIndexSpotlightSearch(newLanguage);
        return;
      }

      // Set the flag to indicate that an indexing operation is in progress
      _isIndexingInProgress = true;

      // Perform the indexing
      indexSpotlightSearch(newLanguage).then((_) {
        // Reset the flag
        _isIndexingInProgress = false;

        if (kDebugMode) {
          print("Deferred indexing for $newLanguage executed.");
        }
      });
    });
  }
}
