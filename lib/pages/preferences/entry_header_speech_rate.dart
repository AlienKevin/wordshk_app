import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/preferences/speech_rate_radio_list_tiles.dart';
import '../../widgets/preferences/title.dart';

class EntryHeaderSpeechRatePreferencesPage extends StatelessWidget {
  const EntryHeaderSpeechRatePreferencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(title: Text(s.dictionaryDefinition)),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 20),
            PreferencesTitle(title: s.entryHeaderSpeechRate),
            const SpeechRateRadioListTiles(atHeader: true),
          ]),
        ));
  }
}
