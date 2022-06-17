import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechRecognitionState with ChangeNotifier {
  final SpeechToText speechToText = SpeechToText();
  String recognizedWords = "";
  late final void Function(String) onResult;

  SpeechRecognitionState() {
    (() async {
      await speechToText.initialize();
    })();
  }

  void setOnResult(void Function(String) newOnResult) {
    onResult = newOnResult;
  }

  /// Each time to start a speech recognition session
  void startListening() async {
    await speechToText.listen(onResult: onSpeechResult, localeId: "zh-HK");
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
      onResult(recognizedWords);
    }
    notifyListeners();
  }
}
