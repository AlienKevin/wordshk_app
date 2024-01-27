import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordshk/models/search_bar_position.dart';

class SearchBarPositionState with ChangeNotifier {
  SearchBarPosition? _position;

  SearchBarPositionState(SharedPreferences prefs) {
    final searchBarPositionIndex = prefs.getInt("searchBarPosition");
    if (searchBarPositionIndex != null) {
      _position = SearchBarPosition.values[searchBarPositionIndex];
      if (kDebugMode) {
        print("Loaded search bar position as $_position");
      }
    }
  }

  void updateSearchBarPosition(SearchBarPosition newPosition) {
    _position = newPosition;

    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("searchBarPosition", newPosition.index);
    });
  }

  SearchBarPosition getSearchBarPosition() =>
      _position ?? SearchBarPosition.bottom;
}
