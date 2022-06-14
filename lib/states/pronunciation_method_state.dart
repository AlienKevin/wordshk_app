import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pronunciation_method.dart';

class PronunciationMethodState with ChangeNotifier {
  late PronunciationMethod entryEgMethod;

  PronunciationMethodState(SharedPreferences prefs) {
    final methodIndex = prefs.getInt("entryEgPronunciationMethod");
    entryEgMethod = methodIndex == null
        ? (Platform.isIOS
            ? PronunciationMethod.tts
            : PronunciationMethod.syllableRecordings)
        : PronunciationMethod.values[methodIndex];
  }

  void updatePronunciationMethod(PronunciationMethod newMethod) {
    entryEgMethod = newMethod;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("entryEgPronunciationMethod", newMethod.index);
    });
  }
}
