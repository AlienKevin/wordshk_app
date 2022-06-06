import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/entry_language.dart';

class EntryLanguageState with ChangeNotifier {
  EntryLanguage? language;

  void updateLanguage(EntryLanguage newLanguage) {
    language = newLanguage;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("entryLanguage", newLanguage.index);
    });
  }
}
