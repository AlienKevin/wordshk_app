import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextSizeState with ChangeNotifier {
  int? textSize;

  TextSizeState(SharedPreferences prefs) {
    final prefTextSize = prefs.getInt("textSize");
    if (prefTextSize != null) {
      textSize = prefTextSize;
      if (kDebugMode) {
        print("Loaded text size $prefTextSize");
      }
    }
  }
  
  int initTextSize(int newTextSize) {
    textSize ??= newTextSize;

    return newTextSize;
  }

  int getTextSize() {
    return textSize ?? 100;
  }

  void updateTextSize(int newTextSize) {
    textSize = newTextSize;

    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("textSize", newTextSize);
    });
  }
}
