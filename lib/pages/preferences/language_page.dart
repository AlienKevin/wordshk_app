import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/language.dart';
import '../../states/language_state.dart';
import '../../widgets/preferences/radio_list_tile.dart';
import '../../widgets/preferences/title.dart';

class LanguagePreferencesPage extends StatelessWidget {
  const LanguagePreferencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final language = context.watch<LanguageState>().language;

    onLanguageChange(Language? newLanguage) {
      if (newLanguage != null) {
        context.read<LanguageState>().updateLanguage(newLanguage);
      }
    }

    languageRadioListTile(Language value) => PreferencesRadioListTile<Language>(
        value.toString(), value, language, onLanguageChange);

    return Scaffold(
        appBar: AppBar(title: Text(s.general)),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            PreferencesTitle(title: s.language),
            languageRadioListTile(Language.zhHantHK),
            languageRadioListTile(Language.en),
            languageRadioListTile(Language.zhHansCN),
            languageRadioListTile(Language.zhHantTW),
          ]),
        ));
  }
}
