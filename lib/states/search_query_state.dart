import 'package:flutter/foundation.dart';

class SearchQueryState with ChangeNotifier {
  String query = "";
  late void Function(String) typeCharacterInSearchBar;

  void setTypeCharacterInSearchBar(void Function(String) typeCharacter) {
    typeCharacterInSearchBar = typeCharacter;
  }

  void updateSearchQuery(String newQuery) {
    query = newQuery;
    notifyListeners();
  }

  void typeCharacter(String character) {
    typeCharacterInSearchBar(character);
    notifyListeners();
  }
}
