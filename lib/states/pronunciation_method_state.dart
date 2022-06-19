import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pronunciation_method.dart';

class PronunciationMethodState with ChangeNotifier {
  late PronunciationMethod entryEgMethod;
  late PronunciationMethod entryHeaderMethod;

  PronunciationMethodState(SharedPreferences prefs) {
    final entryEgMethodIndex = prefs.getInt("entryEgPronunciationMethod");
    entryEgMethod = entryEgMethodIndex == null
        ? (Platform.isIOS
            ? PronunciationMethod.tts
            : PronunciationMethod.syllableRecordingsMale)
        : PronunciationMethod.values[entryEgMethodIndex];

    final entryHeaderMethodIndex =
        prefs.getInt("entryHeaderPronunciationMethod");
    entryHeaderMethod = entryHeaderMethodIndex == null
        ? PronunciationMethod.syllableRecordingsMale
        : PronunciationMethod.values[entryHeaderMethodIndex];
  }

  void updateEntryEgPronunciationMethod(PronunciationMethod newMethod) {
    entryEgMethod = newMethod;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("entryEgPronunciationMethod", newMethod.index);
    });
  }

  void updateEntryHeaderPronunciationMethod(PronunciationMethod newMethod) {
    entryHeaderMethod = newMethod;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("entryHeaderPronunciationMethod", newMethod.index);
    });
  }
}
