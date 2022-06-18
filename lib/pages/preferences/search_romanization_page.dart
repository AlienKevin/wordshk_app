import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/preferences/search_romanization_radio_list_tiles.dart';
import '../../widgets/preferences/title.dart';

class SearchRomanizationPreferencesPage extends StatelessWidget {
  const SearchRomanizationPreferencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(title: Text(s.dictionarySearch)),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            PreferencesTitle(title: s.searchRomanization),
            const SearchRomanizationRadioListTiles(),
          ]),
        ));
  }
}
