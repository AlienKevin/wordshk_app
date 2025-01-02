import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginState extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  LoginState() {
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
