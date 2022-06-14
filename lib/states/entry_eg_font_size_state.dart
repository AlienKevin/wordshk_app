import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/font_size.dart';

class EntryEgFontSizeState with ChangeNotifier {
  late FontSize size;

  EntryEgFontSizeState(SharedPreferences prefs) {
    final fontSizeIndex = prefs.getInt("entryEgFontSize");
    size = fontSizeIndex == null
        ? FontSize.medium
        : FontSize.values[fontSizeIndex];
  }

  void updateSize(FontSize newSize) {
    size = newSize;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("entryEgFontSize", newSize.index);
    });
  }
}
