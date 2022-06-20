import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/language.dart';

class LanguageState with ChangeNotifier {
  Language? language;

  LanguageState(SharedPreferences prefs, BuildContext context) {
    final languageIndex = prefs.getInt("language");
    if (languageIndex != null) {
      language = Language.values[languageIndex];
    }
  }

  void syncLocale(Locale newLocale) {
    language =
        Language.values.byName(newLocale.toLanguageTag().replaceAll("-", ""));
  }

  void updateLanguage(Language newLanguage) {
    language = newLanguage;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("language", newLanguage.index);
    });
  }
}
