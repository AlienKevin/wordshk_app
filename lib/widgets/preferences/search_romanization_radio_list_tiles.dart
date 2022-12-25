import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/states/search_romanization_state.dart';
import 'package:wordshk/utils.dart';

import '../../bridge_generated.dart';
import '../../states/romanization_state.dart';
import '../../widgets/preferences/radio_list_tile.dart';

class SearchRomanizationRadioListTiles extends StatelessWidget {
  final bool syncEntryRomanization;

  const SearchRomanizationRadioListTiles(
      {Key? key, this.syncEntryRomanization = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final searchRomanization =
        context.watch<SearchRomanizationState>().romanization;

    onSearchRomanizationChange(Romanization? newRomanization) {
      if (newRomanization != null) {
        context
            .read<SearchRomanizationState>()
            .updateRomanization(newRomanization);
        if (syncEntryRomanization) {
          context.read<RomanizationState>().updateRomanization(newRomanization);
        }
      }
    }

    searchRomanizationRadioListTile(Romanization value) =>
        PreferencesRadioListTile<Romanization>(
            title: getRomanizationName(value, s),
            subtitle: getRomanizationDescription(value, s),
            value: value,
            groupValue: searchRomanization,
            onChanged: onSearchRomanizationChange);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      searchRomanizationRadioListTile(Romanization.Jyutping),
      searchRomanizationRadioListTile(Romanization.YaleNumbers),
      searchRomanizationRadioListTile(Romanization.CantonesePinyin),
    ]);
  }
}
