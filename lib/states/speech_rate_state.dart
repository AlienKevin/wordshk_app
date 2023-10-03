import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/speech_rate.dart';

class SpeechRateState with ChangeNotifier {
  late SpeechRate entryHeaderRate;
  late SpeechRate entryEgRate;

  SpeechRateState(SharedPreferences prefs) {
    final entryHeaderSpeechRateIndex = prefs.getInt("entryHeaderSpeechRate");
    final entryEgSpeechRateIndex = prefs.getInt("entryEgSpeechRate");

    entryHeaderRate = entryHeaderSpeechRateIndex == null
        ? SpeechRate.slow
        : SpeechRate.values[entryHeaderSpeechRateIndex];
    entryEgRate = entryEgSpeechRateIndex == null
        ? SpeechRate.normal
        : SpeechRate.values[entryEgSpeechRateIndex];
  }

  void updateEntryHeaderSpeechRate(SpeechRate newRate) {
    entryHeaderRate = newRate;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("entryHeaderSpeechRate", newRate.index);
    });
  }

  void updateEntryEgSpeechRate(SpeechRate newRate) {
    entryEgRate = newRate;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("entryEgSpeechRate", newRate.index);
    });
  }
}
