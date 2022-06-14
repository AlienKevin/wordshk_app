import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bridge_generated.dart' show Romanization;

class RomanizationState with ChangeNotifier {
  late Romanization romanization;
  Map<String, List<String>> romanizationMap = {};

  RomanizationState(SharedPreferences prefs) {
    final romanizationIndex = prefs.getInt("romanization");
    (() async {
      await updateRomanization(
          romanizationIndex == null
              ? Romanization.Jyutping
              : Romanization.values[romanizationIndex],
          saveToSharedPreferences: false);
    })();
  }

  Future<void> updateRomanization(Romanization newRomanization,
      {bool saveToSharedPreferences = true}) async {
    romanization = newRomanization;
    if (newRomanization != Romanization.Jyutping && romanizationMap.isEmpty) {
      final tsv =
          await rootBundle.loadString("assets/cantonese_romanizations.tsv");
      final List<List<String>> rows = const CsvToListConverter(
              fieldDelimiter: "\t", shouldParseNumbers: false, eol: "\n")
          .convert(tsv);
      rows.removeAt(0); // skip the header row
      romanizationMap.addEntries(rows.map((row) {
        final jyutping = row[Romanization.Jyutping.index];
        return MapEntry(jyutping, row);
      }));
    }
    notifyListeners();
    if (saveToSharedPreferences) {
      SharedPreferences.getInstance().then((prefs) async {
        prefs.setInt("romanization", newRomanization.index);
      });
    }
  }

  String showPr(String jyutping) {
    if (romanization == Romanization.Jyutping) {
      return jyutping;
    } else {
      final romanizations = romanizationMap[jyutping];
      if (romanizations == null) {
        return "[$jyutping]";
      } else {
        return romanizations[romanization.index];
      }
    }
  }

  String showPrs(List<String> jyutpings, {Romanization? romanization}) {
    final myRomanization = romanization ?? this.romanization;
    if (myRomanization == Romanization.Jyutping) {
      return jyutpings.join(" ");
    } else {
      return jyutpings.map((jyutping) {
        final romanizations = romanizationMap[jyutping];
        if (romanizations == null) {
          return "[$jyutping]";
        } else {
          return romanizations[myRomanization.index];
        }
      }).join(" ");
    }
  }
}
