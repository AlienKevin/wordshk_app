import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutoPasteSearchState with ChangeNotifier {
  late bool autoPasteSearch;

  AutoPasteSearchState(SharedPreferences prefs) {
    final newAutoPasteSearch = prefs.getBool("autoPasteSearch");
    autoPasteSearch = newAutoPasteSearch ?? false;
  }

  void updateAutoPasteSearch(bool newAutoPasteSearch) {
    autoPasteSearch = newAutoPasteSearch;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setBool("autoPasteSearch", newAutoPasteSearch);
    });
  }
}
