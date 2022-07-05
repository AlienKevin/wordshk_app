import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pronunciation_method.dart';

class PronunciationMethodState with ChangeNotifier {
  late PronunciationMethod entryEgMethod;

  PronunciationMethodState(SharedPreferences prefs) {
    final entryEgMethodIndex = prefs.getInt("entryEgPronunciationMethod");
    entryEgMethod = entryEgMethodIndex == null
        ? (Platform.isIOS
            ? PronunciationMethod.tts
            : PronunciationMethod.syllableRecordings)
        : PronunciationMethod.values[entryEgMethodIndex];
  }

  void updateEntryEgPronunciationMethod(PronunciationMethod newMethod) {
    entryEgMethod = newMethod;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("entryEgPronunciationMethod", newMethod.index);
    });
  }
}
