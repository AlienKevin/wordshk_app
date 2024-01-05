import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordshk/src/rust/api/api.dart';

import '../models/language.dart';

class LanguageState with ChangeNotifier {
  Language? language;
  Script? _script;

  LanguageState(SharedPreferences prefs) {
    final languageIndex = prefs.getInt("language");
    if (languageIndex != null) {
      language = Language.values[languageIndex];
      if (kDebugMode) {
        print("Loaded user language $language");
      }
    }

    final scriptIndex = prefs.getInt("script");
    if (scriptIndex != null) {
      _script = Script.values[scriptIndex];
      if (kDebugMode) {
        print("Loaded user script $_script");
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

  void updateScript(Script newScript) {
    _script = newScript;

    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("script", newScript.index);
    });
  }

  Script getScript() =>
      _script ??
      (language == Language.zhHans ? Script.simplified : Script.traditional);
}
