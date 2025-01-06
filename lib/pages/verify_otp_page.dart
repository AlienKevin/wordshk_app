// Source: https://github.com/dartling/passwordless/blob/0f3bdd28265b321bb8099679177757ed6316a5d5/lib/screens/verify_otp_screen.dart#L1

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wordshk/powersync.dart';
import 'package:wordshk/states/bookmark_state.dart';
import 'package:wordshk/states/history_state.dart';
import 'package:wordshk/states/login_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key, required this.email});

  final String email;

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  String? _error;
  bool _busy = false;
  final _otpController = TextEditingController();

  void verifyOtp(BuildContext context) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await Supabase.instance.client.auth.verifyOTP(
        email: widget.email,
        token: _otpController.text,
        type: OtpType.email,
      );

      // We connect and upgrade the database schema here so that by the time the watch() calls are made in the
      // ListsPage, watch will track the new tables instead..
      await connectDatabase();

      if (context.mounted) {
        context.read<BookmarkState>().watchChanges();
        context.read<HistoryState>().watchChanges();
        context.read<LoginState>().listen();
        context.go("/");
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
          title: Text(AppLocalizations.of(context)!.verifyOtp),
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
                            Text(AppLocalizations.of(context)!
                                .verifyOtpSentToEmail(widget.email)),
                            const SizedBox(height: 25),
                            TextField(
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: AppLocalizations.of(context)!
                                    .enterSixDigitCode,
                                errorText: _error,
                                errorMaxLines: 5,
                              ),
                              enabled: !_busy,
                            ),
                            TextButton(
                              onPressed: _busy
                                  ? null
                                  : () {
                                      verifyOtp(context);
                                    },
                              child:
                                  Text(AppLocalizations.of(context)!.verifyOtp),
                            )
                          ],
                        ),
                      ),
                    )))));
  }
}
