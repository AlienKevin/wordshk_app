import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pronunciation_method.dart';

class PronunciationMethodState with ChangeNotifier {
  PronunciationMethod? entryEgMethod;

  void updatePronunciationMethod(PronunciationMethod newMethod) {
    entryEgMethod = newMethod;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("entryEgPronunciationMethod", newMethod.index);
    });
  }
}
