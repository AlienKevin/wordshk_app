import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/language.dart';

class LanguageState with ChangeNotifier {
  late Language language;

  LanguageState(SharedPreferences prefs, BuildContext context) {
    final languageIndex = prefs.getInt("language");
    if (languageIndex == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final languageCode = Localizations.localeOf(context).toString();
        final newLanguage =
            Language.values.byName(languageCode.replaceAll("_", ""));
        language = newLanguage;
      });
    } else {
      language = Language.values[languageIndex];
    }
  }

  void updateLanguage(Language newLanguage) {
    language = newLanguage;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("language", newLanguage.index);
    });
  }
}
