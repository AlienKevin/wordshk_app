import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/language.dart';
import '../../states/language_state.dart';
import '../../widgets/preferences/radio_list_tile.dart';

class LanguageRadioListTiles extends StatelessWidget {
  const LanguageRadioListTiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageState>().language;

    onLanguageChange(Language? newLanguage) {
      if (newLanguage != null) {
        context.read<LanguageState>().updateLanguage(newLanguage);
      }
    }

    languageRadioListTile(Language value) => PreferencesRadioListTile<Language>(
        value.toString(), value, language, onLanguageChange);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      languageRadioListTile(Language.zhHantHK),
      languageRadioListTile(Language.en),
      languageRadioListTile(Language.zhHansCN),
      languageRadioListTile(Language.zhHantTW),
    ]);
  }
}
