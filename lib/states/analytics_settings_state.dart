import 'package:flutter/foundation.dart';

class AnalyticsSettingsState extends ChangeNotifier {
  bool enabled = false;

  AnalyticsSettingsState(prefs) {
    enabled = prefs.getBool("analyticsEnabled") ?? true;
  }

  void setEnabled(bool value) {
    enabled = value;
    notifyListeners();
  }
}
