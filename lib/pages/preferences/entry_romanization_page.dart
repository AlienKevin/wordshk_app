import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/utils.dart';

import '../../bridge_generated.dart';
import '../../states/romanization_state.dart';
import '../../widgets/preferences/radio_list_tile.dart';
import '../../widgets/preferences/title.dart';

class EntryRomanizationPreferencesPage extends StatelessWidget {
  const EntryRomanizationPreferencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final entryRomanization = context.watch<RomanizationState>().romanization;

    onEntryRomanizationChange(Romanization? newRomanization) {
      if (newRomanization != null) {
        context.read<RomanizationState>().updateRomanization(newRomanization);
      }
    }

    entryRomanizationRadioListTile(Romanization value) =>
        PreferencesRadioListTile<Romanization>(
            title: getRomanizationName(value, s),
            subtitle: getRomanizationDescription(value, s),
            value: value,
            groupValue: entryRomanization,
            onChanged: onEntryRomanizationChange);

    return Scaffold(
        appBar: AppBar(title: Text(s.dictionaryDefinition)),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              PreferencesTitle(title: s.entryRomanization),
              entryRomanizationRadioListTile(Romanization.Jyutping),
              entryRomanizationRadioListTile(Romanization.YaleNumbers),
              entryRomanizationRadioListTile(Romanization.YaleDiacritics),
              entryRomanizationRadioListTile(Romanization.CantonesePinyin),
              entryRomanizationRadioListTile(Romanization.Guangdong),
              entryRomanizationRadioListTile(Romanization.Ipa),
            ]),
          ),
        ));
  }
}
