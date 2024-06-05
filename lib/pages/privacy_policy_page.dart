import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:wordshk/states/language_state.dart';

class PrivacyPolicyPage extends StatelessWidget {
  Future<String> _loadPolicyMarkdown(String lang) async {
    String filePath = 'assets/privacy_policy/policy_$lang.md';
    return await rootBundle.loadString(filePath);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageState>().language!.name;

    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: FutureBuilder(
        future: _loadPolicyMarkdown(lang),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading policy'));
          } else {
            return Markdown(data: snapshot.data ?? '');
          }
        },
      ),
    );
  }
}
