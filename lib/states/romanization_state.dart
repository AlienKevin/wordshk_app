import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/romanization.dart';

class RomanizationState with ChangeNotifier {
  Romanization? romanization;
  Map<String, List<String>> romanizationMap = {};

  void updateRomanization(Romanization newRomanization) async {
    romanization = newRomanization;
    if (newRomanization != Romanization.jyutping && romanizationMap.isEmpty) {
      final tsv =
          await rootBundle.loadString("assets/cantonese_romanizations.tsv");
      final List<List<String>> rows = const CsvToListConverter(
              fieldDelimiter: "\t", shouldParseNumbers: false, eol: "\n")
          .convert(tsv);
      romanizationMap.addEntries(rows.map((row) {
        final jyutping = row[Romanization.jyutping.tsvColumn];
        return MapEntry(jyutping, row);
      }));
    }
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("romanization", newRomanization.index);
    });
  }

  String showPr(String jyutping) {
    if (romanization == Romanization.jyutping) {
      return jyutping;
    } else {
      final romanizations = romanizationMap[jyutping];
      if (romanizations == null) {
        return "[$jyutping]";
      } else {
        return romanizations[romanization!.tsvColumn];
      }
    }
  }

  String showPrs(List<String> jyutpings) {
    if (romanization == Romanization.jyutping) {
      return jyutpings.join(" ");
    } else {
      return jyutpings.map((jyutping) {
        final romanizations = romanizationMap[jyutping];
        if (romanizations == null) {
          return "[$jyutping]";
        } else {
          return romanizations[romanization!.tsvColumn];
        }
      }).join(" ");
    }
  }
}
