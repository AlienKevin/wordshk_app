import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sentry/sentry.dart';

class ShareFeedbackPage extends StatefulWidget {
  const ShareFeedbackPage({super.key});

  @override
  State<ShareFeedbackPage> createState() => _ShareFeedbackPageState();
}

class _ShareFeedbackPageState extends State<ShareFeedbackPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _userFeedback = '';
  String? _userEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.feedback),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _formKey.currentState!.save();

              if (_userFeedback.isNotEmpty ||
                  (_userEmail != null && _userEmail!.isNotEmpty)) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(AppLocalizations.of(context)!.discardDraft),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, null),
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(AppLocalizations.of(context)!.discard),
                      ),
                    ],
                  ),
                ).then((discardDraft) {
                  if (discardDraft) {
                    Navigator.pop(context);
                  }
                });
              } else {
                Navigator.pop(context);
              }
            },
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText:
                          AppLocalizations.of(context)!.shareFeedbackHintText,
                      border: const OutlineInputBorder(),
                    ),
                    onSaved: (String? value) {
                      _userFeedback = value!;
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .pleaseEnterSomeText;
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                      height: Theme.of(context).textTheme.bodyLarge!.fontSize!),
                  TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!
                          .optionalEmailAddressHintText,
                    ),
                    onSaved: (value) => _userEmail = value,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      }
                      if (!EmailValidator.validate(value)) {
                        return AppLocalizations.of(context)!
                            .pleaseEnterAValidEmailAddress;
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          try {
                            SentryId sentryId =
                                await Sentry.captureMessage("User Feedback");

                            final userFeedback = SentryUserFeedback(
                              eventId: sentryId,
                              comments: _userFeedback,
                              email: _userEmail,
                              name: null,
                            );

                            Sentry.captureUserFeedback(userFeedback);

                            if (!mounted) return;

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context)!
                                    .feedbackSubmitted)));

                            // Close the modal
                            Navigator.pop(context);
                          } catch (e) {
                            if (!mounted) return;

                            // Show error message
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!
                                    .feedbackFailedToSend,
                              ),
                              duration: const Duration(seconds: 2),
                            ));
                          }
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.submit),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
