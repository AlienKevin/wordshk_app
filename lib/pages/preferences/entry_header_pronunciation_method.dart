import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/states/pronunciation_method_state.dart';

import '../../models/pronunciation_method.dart';
import '../../utils.dart';
import '../../widgets/preferences/radio_list_tile.dart';
import '../../widgets/preferences/speech_rate_radio_list_tiles.dart';
import '../../widgets/preferences/title.dart';

class EntryHeaderPronunciationMethodPreferencesPage extends StatelessWidget {
  const EntryHeaderPronunciationMethodPreferencesPage({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final method = context.watch<PronunciationMethodState>().entryHeaderMethod;

    onMethodChange(PronunciationMethod? newMethod) {
      if (newMethod != null) {
        context
            .read<PronunciationMethodState>()
            .updateEntryHeaderPronunciationMethod(newMethod);
      }
    }

    methodRadioListTile(PronunciationMethod value) =>
        PreferencesRadioListTile<PronunciationMethod>(
            getPronunciationMethodName(value, s),
            value,
            method,
            onMethodChange);

    return Scaffold(
        appBar: AppBar(title: Text(s.dictionaryDefinition)),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            PreferencesTitle(title: s.entryHeaderPronunciationMethod),
            methodRadioListTile(PronunciationMethod.syllableRecordingsMale),
            methodRadioListTile(PronunciationMethod.syllableRecordingsFemale),
            const SizedBox(height: 20),
            PreferencesTitle(title: s.entryHeaderSpeechRate),
            const SpeechRateRadioListTiles(atHeader: true),
          ]),
        ));
  }
}
