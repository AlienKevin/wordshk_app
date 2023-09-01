import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bridge_generated.dart' show Romanization;
import '../ffi.dart';

class RomanizationState with ChangeNotifier {
  late Romanization romanization;

  RomanizationState(SharedPreferences prefs) {
    final romanizationIndex = prefs.getInt("romanization");
    // Reset invalid romanization index to the jyutping default
    if (romanizationIndex != null && romanizationIndex >= Romanization.values.length) {
      prefs.setInt("romanization", Romanization.Jyutping.index);
      romanization = Romanization.Jyutping;
    } else {
      romanization = romanizationIndex == null
          ? Romanization.Jyutping
          : Romanization.values[romanizationIndex];
    }
    initPrIndices();
  }

  Future<File> get _prIndicesFile async {
    // TODO: consider changing to getApplicationCacheDirectory
    // to avoid storing index in user data folder
    // also remember to delete the past index stored in the Documents folder.
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/prIndices.msgpack');
  }

  void initPrIndices() async {
    final prIndicesFile = await _prIndicesFile;
    if (prIndicesFile.existsSync()) {
      api.updatePrIndices(prIndices: await prIndicesFile.readAsBytes());
    } else {
      prIndicesFile.writeAsBytes(await api.generatePrIndices(romanization: romanization));
    }
  }

  void updateRomanization(Romanization newRomanization) async {
    romanization = newRomanization;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setInt("romanization", newRomanization.index);
    });

    final prIndicesFile = await _prIndicesFile;
    prIndicesFile.writeAsBytes(await api.generatePrIndices(romanization: romanization));
  }

  Future<String> showPr(String jyutping) {
    return switch (romanization) {
      Romanization.Jyutping => Future.value(jyutping),
      Romanization.Yale => (() {
        return api.jyutpingToYale(jyutping: jyutping);
      })()
    };
  }

  Future<String> showPrs(List<String> jyutpings) {
    return switch (romanization) {
      Romanization.Jyutping => Future.value(jyutpings.join(" ")),
      Romanization.Yale => (() {
        return api.jyutpingToYale(jyutping: jyutpings.join(" "));
      })(),
    };
  }
}
