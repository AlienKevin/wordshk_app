import '../models/search_result_type.dart';

enum QueryType {
  hanzi,
  latin,
  other;

  factory QueryType.fromQuery(String query) =>
      query.trim().contains(RegExp(r'^[\p{Script=Hani}，⋯…]+$', unicode: true))
          ? QueryType.hanzi
          : query.trim().contains(RegExp(r"^[\p{Script=Latn} '\-.]+$", unicode: true))
              ? QueryType.latin
              : QueryType.other;

  toJson() => name;
}

class ResultNotFound {
  QueryType queryType;
  int queryLength;
  int tokenCount; // space-separated tokens

  ResultNotFound(String query):
      queryType = QueryType.fromQuery(query), queryLength = query.runes.length, tokenCount = query.split(RegExp(r'\s+')).length;

  Map<String, dynamic> toJson() => {
      'queryType': queryType.toJson(),
      'queryLength': queryLength,
      'tokenCount': tokenCount,
    };
}

class AnalyticsState {
  List<SearchResultType> searchResultTypesClicked = [];
  List<ResultNotFound> resultNotFounds = [];

  AnalyticsState();

  void clickSearchResultType(SearchResultType searchResultType) {
    searchResultTypesClicked.add(searchResultType);
  }

  void addResultNotFound(ResultNotFound notFound) {
    resultNotFounds.add(notFound);
    print("Added result not found: ${notFound.toJson()}");
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
      "resultNotFounds": resultNotFounds,
    };
  }
}
