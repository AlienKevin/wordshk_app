import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntryEgJumpyPrsState with ChangeNotifier {
  bool isJumpy = false;

  EntryEgJumpyPrsState(SharedPreferences prefs) {
    final newIsJumpy = prefs.getBool("entryEgJumpyPrs");
    isJumpy = newIsJumpy == null ? false : true;
  }

  void updateIsJumpy(bool newIsJumpy, {bool saveToSharedPreferences = true}) {
    isJumpy = newIsJumpy;
    notifyListeners();
    if (saveToSharedPreferences) {
      SharedPreferences.getInstance().then((prefs) async {
        prefs.setBool("entryEgJumpyPrs", newIsJumpy);
      });
    }
  }
}
