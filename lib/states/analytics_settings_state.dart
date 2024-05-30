import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordshk/main.dart';

class AnalyticsSettingsState extends ChangeNotifier {
  bool? enabled;
  bool sentryInitialized = false;
  SharedPreferences prefs;

  AnalyticsSettingsState(this.prefs) {
    enabled = prefs.getBool("analyticsEnabled");
    if (enabled != null) {
      sentryEnabled = enabled!;
    }

    if (sentryEnabled) {
      initSentry();
    }
  }

  void initSentry() {
    if (!sentryInitialized) {
      SentryFlutter.init((options) {
        options.dsn =
            "https://1fc4b551176d3b595bfc45748e3111c8@o4505785577373696.ingest.sentry.io/4505785578487808";
        options.tracesSampleRate = kDebugMode ? 1.0 : 0.1;
        // The sampling rate for profiling is relative to tracesSampleRate
        // Setting to 1.0 will profile 100% of sampled transactions:
        options.profilesSampleRate = 1.0;
        options.beforeSend = beforeSend;
      });
    }
    sentryInitialized = true;
  }

  void setEnabled(bool value) {
    enabled = value;
    sentryEnabled = enabled!;
    prefs.setBool("analyticsEnabled", sentryEnabled);
    if (sentryEnabled) {
      initSentry();
    }
    notifyListeners();
  }
}
