import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/utils.dart';

import '../../models/entry_language.dart';
import '../../states/entry_language_state.dart';
import '../../widgets/preferences/radio_list_tile.dart';
import '../../widgets/preferences/title.dart';

class EntryExplanationLanguagePreferencesPage extends StatelessWidget {
  const EntryExplanationLanguagePreferencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final entryLanguage = context.watch<EntryLanguageState>().language;

    onEntryLanguageChange(EntryLanguage? newLanguage) {
      if (newLanguage != null) {
        context.read<EntryLanguageState>().updateLanguage(newLanguage);
      }
    }

    entryLanguageRadioListTile(EntryLanguage value) =>
        PreferencesRadioListTile<EntryLanguage>(getEntryLanguageName(value, s),
            value, entryLanguage, onEntryLanguageChange);

    return Scaffold(
        appBar: AppBar(title: Text(s.dictionaryDefinition)),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            PreferencesTitle(title: s.entryExplanationsLanguage),
            entryLanguageRadioListTile(EntryLanguage.both),
            entryLanguageRadioListTile(EntryLanguage.cantonese),
            entryLanguageRadioListTile(EntryLanguage.english),
          ]),
        ));
  }
}
