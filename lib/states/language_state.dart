import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/language.dart';

class LanguageState with ChangeNotifier {
  Language? language;

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
    return newLanguage.toLocale;
  }

  void updateLanguage(Language newLanguage) {
    language = newLanguage;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("language", newLanguage.index);
    });
  }
}
