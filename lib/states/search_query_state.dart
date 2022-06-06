import 'package:flutter/foundation.dart';

class SearchQueryState with ChangeNotifier {
  String query = "";

  void updateSearchQuery(String newQuery) {
    query = newQuery;
    notifyListeners();
  }
}
