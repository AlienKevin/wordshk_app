import 'package:flutter/material.dart';

import '../models/search_mode.dart';

class SearchModeState with ChangeNotifier {
  SearchMode mode = SearchMode.combined;
  bool showSearchModeSelector = false;

  void updateSearchModeAndCloseSelector(SearchMode newMode) {
    mode = newMode;
    showSearchModeSelector = false;
    notifyListeners();
  }

  void updateSearchMode(SearchMode newMode) {
    mode = newMode;
    notifyListeners();
  }

  void toggleSearchModeSelector() {
    showSearchModeSelector = !showSearchModeSelector;
    notifyListeners();
  }
}
