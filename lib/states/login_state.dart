import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wordshk/powersync.dart' as PowerSync;

class LoginState extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  LoginState() {
    _isLoggedIn = PowerSync.isLoggedIn();
    listen();
  }

  listen() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedOut) {
        _isLoggedIn = false;
        notifyListeners();
      } else if (event == AuthChangeEvent.signedIn) {
        _isLoggedIn = true;
        notifyListeners();
      }
    });
  }
}
