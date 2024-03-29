import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/src/rust/api/api.dart';
import 'package:wordshk/utils.dart';
import 'package:wordshk/widgets/constrained_content.dart';

import '../../states/romanization_state.dart';
import '../../widgets/settings/radio_list_tile.dart';
import '../../widgets/settings/title.dart';

class RomanizationSettingsPage extends StatelessWidget {
  const RomanizationSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final entryRomanization = context.watch<RomanizationState>().romanization;

    onRomanizationChange(Romanization? newRomanization) {
      if (newRomanization != null) {
        context.read<RomanizationState>().updateRomanization(newRomanization);
      }
    }

    romanizationRadioListTile(Romanization value) =>
        SettingsRadioListTile<Romanization>(
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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SettingsTitle(title: s.romanization),
                    romanizationRadioListTile(Romanization.jyutping),
                    romanizationRadioListTile(Romanization.yale),
                  ]),
            ),
          ),
        ));
  }
}
