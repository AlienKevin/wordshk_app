import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bridge_generated.dart' show Romanization;

class SearchRomanizationState with ChangeNotifier {
  late Romanization romanization;

  void updateRomanization(Romanization newRomanization) async {
    romanization = newRomanization;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("searchRomanization", newRomanization.index);
    });
  }
}
