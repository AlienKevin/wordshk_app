import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../bridge_generated.dart' show Script;

class SpeechRecognitionState with ChangeNotifier {
  final SpeechToText speechToText = SpeechToText();
  void Function(String)? onResult;
  void Function()? closeDialog;
  bool initialized = false;
  bool isAvailable = true;
  bool isDialogOpen = true;

  void setOnResult(void Function(String) newOnResult) {
    onResult = newOnResult;
  }

  void setCloseDialog(void Function() newCloseDialog) {
    closeDialog = newCloseDialog;
  }

  /// Each time to start a speech recognition session
  Future<void> startListening(Script script) async {
    if (!initialized) {
      // print("requesting speech recognition permissions...");
      Map<Permission, PermissionStatus> statuses = await [
        Permission.speech,
        Permission.microphone,
      ].request();
      // print("Finished getting speech recognition permissions...");
      if (statuses[Permission.speech]!.isPermanentlyDenied ||
          statuses[Permission.microphone]!.isPermanentlyDenied) {
        await openAppSettings();
      }
      // print("initializing speech recognition...");
      await speechToText.initialize(
          debugLogging: true,
          options: [
            SpeechToText.androidNoBluetooth,
            SpeechToText.androidIntentLookup,
          ],
          onError: (error) {
            // print("error: $error");
            // print("lastError: ${speechToText.lastError}");
            notifyListeners();
          });
      // print("finished initialization.");
      initialized = true;
    }
    var cantoneseLocaleId = Platform.isAndroid
        ? "yue_HK"
        : (script == Script.Traditional ? "zh-HK" : "yue-CN");
    // print("Looking for Cantonese locale id: $cantoneseLocaleId");
    var locales = await speechToText.locales();
    // print(locales.map((locale) => locale.localeId).toList());
    if (locales.any((locale) => locale.localeId == cantoneseLocaleId)) {
      // print("Cantonese speech recognition is supported!");
      isDialogOpen = true;
      await speechToText.listen(
        onResult: onSpeechResult,
        localeId: cantoneseLocaleId,
      );
    } else {
      isAvailable = false;
    }
    notifyListeners();
  }

  void cancelListening() async {
    isDialogOpen = false;
    await speechToText.cancel();
    // print("set isDialogOpen to false");
    notifyListeners();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    // print("Recognized: ${result.recognizedWords}");
    if (result.recognizedWords.isNotEmpty) {
      onResult!(result.recognizedWords);
      // iOS for some reason never stops listening
      // So the user has to manually close the dialog
      if (Platform.isAndroid && isDialogOpen) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (speechToText.isNotListening) {
            closeDialog!();
            isDialogOpen = false;
          }
        });
      }
      notifyListeners();
    }
  }
}
