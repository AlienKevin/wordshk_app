import 'package:flutter/material.dart';

import '../main.dart' show analyticsState;
import '../models/search_mode.dart';

class SearchModeState with ChangeNotifier {
  SearchMode mode = SearchMode.combined;
  bool showSearchModeSelector = false;

  void updateSearchModeAndCloseSelector(SearchMode newMode) {
    mode = newMode;
    analyticsState.addSearchMode(newMode);
    showSearchModeSelector = false;
    notifyListeners();
  }

  void updateSearchMode(SearchMode newMode) {
    mode = newMode;
    analyticsState.addSearchMode(newMode);
    notifyListeners();
  }

  void toggleSearchModeSelector() {
    showSearchModeSelector = !showSearchModeSelector;
    notifyListeners();
  }
}
