import 'package:flutter/foundation.dart';

class SearchQueryState with ChangeNotifier {
  String query = "";
  late void Function(String) _typeCharacter;
  late void Function() _backspace;
  late void Function() _moveToEndOfSelection;

  void setSearchBarCallbacks(void Function(String) typeCharacter,
      void Function() backspace, void Function() moveToEndOfSelection) {
    _typeCharacter = typeCharacter;
    _backspace = backspace;
    _moveToEndOfSelection = moveToEndOfSelection;
  }

  void updateSearchQuery(String newQuery) {
    query = newQuery;
    notifyListeners();
  }

  void typeCharacter(String character) {
    _typeCharacter(character);
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
