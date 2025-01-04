import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController;
  String? _error;
  late bool _busy;

  @override
  void initState() {
    super.initState();

    _busy = false;
    _usernameController = TextEditingController(text: '');
  }

  void _login(BuildContext context) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await Supabase.instance.client.auth.signInWithOtp(
          email: _usernameController.text,
          shouldCreateUser: true,
          emailRedirectTo: 'https://words.hk');

      if (context.mounted) {
        context.push('/verify-otp?email=${_usernameController.text}');
      }
    } on AuthException catch (e) {
      setState(() {
        _error = e.message;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Log In to Sync"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                          'Login/sign up via a one-time password sent to the following email:'),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                            labelText: "Email",
                            errorText: _error,
                            errorMaxLines: 5),
                        enabled: !_busy,
                        onFieldSubmitted: _busy
                            ? null
                            : (String value) {
                                _login(context);
                              },
                      ),
                      const SizedBox(height: 25),
                      TextButton(
                        onPressed: _busy
                            ? null
                            : () {
                                _login(context);
                              },
                        child: const Text('Login/Sign Up'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
