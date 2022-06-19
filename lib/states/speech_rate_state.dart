import 'package:flutter/material.dart';

import '../models/speech_rate.dart';

class SpeechRateState with ChangeNotifier {
  SpeechRate entryHeaderRate = SpeechRate.medium;
  SpeechRate entryEgRate = SpeechRate.medium;

  void updateEntryHeaderSpeechRate(SpeechRate newRate) {
    entryHeaderRate = newRate;
    notifyListeners();
  }

  void updateEntryEgSpeechRate(SpeechRate newRate) {
    entryEgRate = newRate;
    notifyListeners();
  }
}
