import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wordshk/models/language.dart';
import 'package:wordshk/states/language_state.dart';

class PrivacyPolicy extends StatelessWidget {
  Future<String> _loadPolicyMarkdown(String lang) async {
    String filePath = 'assets/privacy_policy/policy_$lang.md';
    return await rootBundle.loadString(filePath);
  }

  @override
  Widget build(BuildContext context) {
    final lang = (context.watch<LanguageState>().language ?? Language.en).name;

    return FutureBuilder(
      future: _loadPolicyMarkdown(lang),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          Sentry.captureException(snapshot.error);
          return Center(child: Text('Error loading policy'));
        } else {
          return Markdown(
            data: snapshot.data ?? '',
            shrinkWrap: true,
          );
        }
      },
    );
  }
}
