import 'package:flutter/foundation.dart';

class SearchQueryState with ChangeNotifier {
  String query = "";
  late void Function(String) _typeString;
  late void Function() _backspace;
  late void Function() _moveToEndOfSelection;
  late void Function() _clear;

  void setSearchBarCallbacks(void Function(String) typeString,
      void Function() backspace, void Function() moveToEndOfSelection, void Function() clear) {
    _typeString = typeString;
    _backspace = backspace;
    _moveToEndOfSelection = moveToEndOfSelection;
    _clear = clear;
  }

  void updateSearchQuery(String newQuery) {
    query = newQuery;
    notifyListeners();
  }

  void typeString(String string) {
    _typeString(string);
    notifyListeners();
  }

  void clear() {
    _clear();
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
