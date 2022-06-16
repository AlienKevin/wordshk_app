import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/states/search_romanization_state.dart';
import 'package:wordshk/utils.dart';

import '../../bridge_generated.dart';
import '../../widgets/preferences/radio_list_tile.dart';
import '../../widgets/preferences/title.dart';

class SearchRomanizationPreferencesPage extends StatelessWidget {
  const SearchRomanizationPreferencesPage({Key? key}) : super(key: key);

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
      }
    }

    searchRomanizationRadioListTile(Romanization value) =>
        PreferencesRadioListTile<Romanization>(getRomanizationName(value, s),
            value, searchRomanization, onSearchRomanizationChange);

    return Scaffold(
        appBar: AppBar(title: Text(s.dictionarySearch)),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            PreferencesTitle(title: s.searchRomanization),
            searchRomanizationRadioListTile(Romanization.Jyutping),
            searchRomanizationRadioListTile(Romanization.YaleNumbers),
            searchRomanizationRadioListTile(Romanization.CantonesePinyin),
            searchRomanizationRadioListTile(Romanization.SidneyLau),
          ]),
        ));
  }
}
