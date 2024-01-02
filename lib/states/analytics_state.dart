import '../models/search_result_type.dart';

class AnalyticsState {
  List<SearchResultType> searchResultTypesClicked = [];

  AnalyticsState();

  void clickSearchResultType(SearchResultType searchResultType) {
    searchResultTypesClicked.add(searchResultType);
  }

  List _compressEnumList<T extends Enum>(List<T> list) {
    var result = [];
    for (final elem in list) {
      if (result.isNotEmpty && result[result.length - 1]["name"] == elem.name) {
        result[result.length - 1]["count"]++;
      } else {
        result.add({"name": elem.name, "count": 1});
      }
    }
    return result;
  }

  void clear() {
    searchResultTypesClicked.clear();
  }

  Map<String, dynamic> toJson() {
    return {
      "searchResultTypesClicked": _compressEnumList(searchResultTypesClicked),
    };
  }
}
