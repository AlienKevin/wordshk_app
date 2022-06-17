import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../bridge_generated.dart' show Script;

class SpeechRecognitionState with ChangeNotifier {
  final SpeechToText speechToText = SpeechToText();
  String recognizedWords = "";
  void Function(String)? onResult;

  SpeechRecognitionState() {
    (() async {
      await speechToText.initialize(debugLogging: true, options: [
        SpeechToText.androidNoBluetooth,
        SpeechToText.androidIntentLookup
      ]);
      // Debug: Prints all available system speech recognition locales
      // var locales = await speechToText.locales();
      // print(locales.map((locale) => locale.localeId).toList());
    })();
  }

  void setOnResult(void Function(String) newOnResult) {
    onResult = newOnResult;
  }

  /// Each time to start a speech recognition session
  void startListening(Script script) async {
    await speechToText.listen(
        onResult: onSpeechResult,
        localeId: Platform.isAndroid
            ? "yue_HK"
            : (script == Script.Traditional ? "zh-HK" : "yue-CN"));
    notifyListeners();
  }

  void cancelListening() async {
    await speechToText.cancel();
    notifyListeners();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    recognizedWords = result.recognizedWords;
    if (!speechToText.isNotListening) {
      onResult!(recognizedWords);
    }
    notifyListeners();
  }
}
