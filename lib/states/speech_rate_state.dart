import 'package:flutter/material.dart';

import '../models/speech_rate.dart';

class SpeechRateState with ChangeNotifier {
  SpeechRate entryHeaderRate = SpeechRate.normal;
  SpeechRate entryEgRate = SpeechRate.normal;

  void updateEntryHeaderSpeechRate(SpeechRate newRate) {
    entryHeaderRate = newRate;
    notifyListeners();
  }

  void updateEntryEgSpeechRate(SpeechRate newRate) {
    entryEgRate = newRate;
    notifyListeners();
  }
}
