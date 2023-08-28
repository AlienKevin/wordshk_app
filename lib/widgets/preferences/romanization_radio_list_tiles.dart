import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/utils.dart';

import '../../bridge_generated.dart';
import '../../states/romanization_state.dart';
import '../../widgets/preferences/radio_list_tile.dart';

class RomanizationRadioListTiles extends StatelessWidget {
  final bool syncEntryRomanization;

  const RomanizationRadioListTiles(
      {Key? key, this.syncEntryRomanization = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final romanization =
        context.watch<RomanizationState>().romanization;

    onRomanizationChange(Romanization? newRomanization) {
      if (newRomanization != null) {
        context
            .read<RomanizationState>()
            .updateRomanization(newRomanization);
        if (syncEntryRomanization) {
          context.read<RomanizationState>().updateRomanization(newRomanization);
        }
      }
    }

    RomanizationRadioListTile(Romanization value) =>
        PreferencesRadioListTile<Romanization>(
            title: getRomanizationName(value, s),
            subtitle: getRomanizationDescription(value, s),
            value: value,
            groupValue: romanization,
            onChanged: onRomanizationChange);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RomanizationRadioListTile(Romanization.Jyutping),
      RomanizationRadioListTile(Romanization.Yale),
    ]);
  }
}