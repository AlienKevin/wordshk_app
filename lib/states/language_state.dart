import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/language.dart';

class LanguageState with ChangeNotifier {
  Language? language;

  void updateLanguage(Language newLanguage) {
    language = newLanguage;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("language", newLanguage.index);
    });
  }
}
