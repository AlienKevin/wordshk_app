import 'package:flutter/foundation.dart';
import 'package:wordshk/main.dart';

class AnalyticsSettingsState extends ChangeNotifier {
  bool enabled = false;

  AnalyticsSettingsState(prefs) {
    enabled = prefs.getBool("analyticsEnabled") ?? true;
    sentryEnabled = enabled;
  }

  void setEnabled(bool value) {
    enabled = value;
    sentryEnabled = enabled;
    notifyListeners();
  }
}
