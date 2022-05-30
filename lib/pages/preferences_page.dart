import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/models/language.dart';

import '../main.dart';
import '../widgets/navigation_drawer.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageState>().language;

    onLanguageChange(Language? newLanguage) {
      if (newLanguage != null) {
        context.read<LanguageState>().updateLanguage(newLanguage);
      }
    }

    languageRadioListTile(String title, Language value) =>
        RadioListTile<Language>(
          title: Text(title),
          value: value,
          groupValue: language,
          onChanged: onLanguageChange,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          activeColor: Theme.of(context).colorScheme.secondary,
        );

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.preferences)),
      drawer: const NavigationDrawer(),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(AppLocalizations.of(context)!.language,
                  style: Theme.of(context).textTheme.titleLarge),
              languageRadioListTile('廣東話（香港）', Language.zhHantHK),
              languageRadioListTile('English', Language.en),
              languageRadioListTile('中文（中国大陆）', Language.zhHansCN),
              languageRadioListTile('中文（台灣）', Language.zhHantTW),
            ])),
      ),
    );
  }
}
