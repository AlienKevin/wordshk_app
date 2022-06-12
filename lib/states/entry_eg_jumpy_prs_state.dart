import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntryEgJumpyPrsState with ChangeNotifier {
  bool isJumpy = false;

  void updateIsJumpy(bool newIsJumpy) {
    isJumpy = newIsJumpy;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setBool("entryEgJumpyPrs", newIsJumpy);
    });
  }
}
