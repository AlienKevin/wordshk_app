import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordshk/states/spotlight_indexing_state.dart';

import '../models/language.dart';

class LanguageState with ChangeNotifier {
  Language? language;
  final SpotlightIndexingState spotlightIndexingState;

  LanguageState(SharedPreferences prefs, this.spotlightIndexingState) {
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

    spotlightIndexingState.initSpotlightIndexLanguage(newLanguage);

    return newLanguage.toLocale;
  }

  void updateLanguage(Language newLanguage) {
    language = newLanguage;

    spotlightIndexingState.updateSpotlightIndexLanguage(newLanguage);

    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("language", newLanguage.index);
    });
  }
}
