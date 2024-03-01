import 'package:flutter/foundation.dart';

class SearchQueryState with ChangeNotifier {
  String query = "";
  late void Function(String) _typeString;
  late void Function() _backspace;
  late void Function() _moveToEndOfSelection;

  void setSearchBarCallbacks(void Function(String) typeString,
      void Function() backspace, void Function() moveToEndOfSelection) {
    _typeString = typeString;
    _backspace = backspace;
    _moveToEndOfSelection = moveToEndOfSelection;
  }

  void updateSearchQuery(String newQuery) {
    query = newQuery;
    notifyListeners();
  }

  void typeString(String string) {
    _typeString(string);
    notifyListeners();
  }

  void backspace() {
    _backspace();
    notifyListeners();
  }

  void moveToEndOfSelection() {
    _moveToEndOfSelection();
    notifyListeners();
  }
}
