import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wordshk/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late TextEditingController _passwordController;
  late TextEditingController _usernameController;
  String? _error;
  late bool _busy;

  @override
  void initState() {
    super.initState();

    _busy = false;
    _passwordController = TextEditingController(text: '');
    _usernameController = TextEditingController(text: '');
  }

  void _signup(BuildContext context) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final response = await Supabase.instance.client.auth.signUp(
          email: _usernameController.text, password: _passwordController.text);

      // We connect and upgrade the database schema here so that by the time the watch() calls are made in the
      // ListsPage, watch will track the new tables instead..
      await connectDatabase();

      if (context.mounted) {
        if (response.session != null) {
          context.go('/');
        } else {
          context.go('/login');
        }
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
          title: const Text(
              "PowerSync Flutter Supabase Todolist Optional Sync Demo"),
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
                      const Text('Sign Up'),
                      const SizedBox(height: 35),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(labelText: "Email"),
                        enabled: !_busy,
                        onFieldSubmitted: _busy
                            ? null
                            : (String value) {
                                _signup(context);
                              },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                            labelText: "Password", errorText: _error),
                        enabled: !_busy,
                        onFieldSubmitted: _busy
                            ? null
                            : (String value) {
                                _signup(context);
                              },
                      ),
                      const SizedBox(height: 25),
                      TextButton(
                        onPressed: _busy
                            ? null
                            : () {
                                _signup(context);
                              },
                        child: const Text('Sign Up'),
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
