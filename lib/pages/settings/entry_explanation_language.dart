import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/utils.dart';
import 'package:wordshk/widgets/constrained_content.dart';

import '../../models/entry_language.dart';
import '../../states/entry_language_state.dart';
import '../../widgets/settings/radio_list_tile.dart';
import '../../widgets/settings/title.dart';

class EntryExplanationLanguageSettingsPage extends StatelessWidget {
  const EntryExplanationLanguageSettingsPage({Key? key}) : super(key: key);

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
        SettingsRadioListTile<EntryLanguage>(
            title: getEntryLanguageName(value, s),
            value: value,
            groupValue: entryLanguage,
            onChanged: onEntryLanguageChange);

    return Scaffold(
        appBar: AppBar(title: Text(s.dictionaryDefinition)),
        body: ConstrainedContent(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SettingsTitle(title: s.entryExplanationsLanguage),
              entryLanguageRadioListTile(EntryLanguage.both),
              entryLanguageRadioListTile(EntryLanguage.cantonese),
              entryLanguageRadioListTile(EntryLanguage.english),
            ]),
          ),
        ));
  }
}
