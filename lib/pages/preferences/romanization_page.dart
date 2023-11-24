import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/utils.dart';
import 'package:wordshk/widgets/constrained_content.dart';

import '../../bridge_generated.dart';
import '../../states/romanization_state.dart';
import '../../widgets/preferences/radio_list_tile.dart';
import '../../widgets/preferences/title.dart';

class RomanizationPreferencesPage extends StatelessWidget {
  const RomanizationPreferencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final entryRomanization = context.watch<RomanizationState>().romanization;

    onRomanizationChange(Romanization? newRomanization) {
      if (newRomanization != null) {
        context
            .read<RomanizationState>()
            .updateRomanization(newRomanization);
      }
    }

    romanizationRadioListTile(Romanization value) =>
        PreferencesRadioListTile<Romanization>(
            title: getRomanizationName(value, s),
            subtitle: getRomanizationDescription(value, s),
            value: value,
            groupValue: entryRomanization,
            onChanged: onRomanizationChange);

    return Scaffold(
        appBar: AppBar(title: Text(s.dictionaryDefinition)),
        body: ConstrainedContent(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                PreferencesTitle(title: s.romanization),
                romanizationRadioListTile(Romanization.Jyutping),
                romanizationRadioListTile(Romanization.Yale),
              ]),
            ),
          ),
        ));
  }
}
