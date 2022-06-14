import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/entry_language.dart';

class EntryLanguageState with ChangeNotifier {
  late EntryLanguage language;

  EntryLanguageState(SharedPreferences prefs) {
    final entryLanguageIndex = prefs.getInt("entryLanguage");
    language = entryLanguageIndex == null
        ? EntryLanguage.both
        : EntryLanguage.values[entryLanguageIndex];
  }

  void updateLanguage(EntryLanguage newLanguage) {
    language = newLanguage;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("entryLanguage", newLanguage.index);
    });
  }
}
