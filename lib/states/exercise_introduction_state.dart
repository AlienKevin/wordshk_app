import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseIntroductionState with ChangeNotifier {
  late bool toneExerciseIntroduced;

  ExerciseIntroductionState(SharedPreferences prefs) {
    toneExerciseIntroduced = prefs.getBool("toneExerciseIntroduced") ?? false;
  }

  void setToneExerciseIntroduced() {
    toneExerciseIntroduced = true;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) async {
      prefs.setBool("toneExerciseIntroduced", true);
    });
  }
}
