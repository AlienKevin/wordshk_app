import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/states/pronunciation_method_state.dart';
import 'package:wordshk/widgets/constrained_content.dart';
import 'package:wordshk/widgets/settings/speech_rate_radio_list_tiles.dart';

import '../../models/pronunciation_method.dart';
import '../../utils.dart';
import '../../widgets/settings/radio_list_tile.dart';
import '../../widgets/settings/title.dart';

class EntryEgPronunciationMethodSettingsPage extends StatelessWidget {
  const EntryEgPronunciationMethodSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final method = context.watch<PronunciationMethodState>().entryEgMethod;

    onMethodChange(PronunciationMethod? newMethod) {
      if (newMethod != null) {
        context
            .read<PronunciationMethodState>()
            .updateEntryEgPronunciationMethod(newMethod);
      }
    }

    methodRadioListTile(PronunciationMethod value) =>
        SettingsRadioListTile<PronunciationMethod>(
            title: getPronunciationMethodName(value, s),
            value: value,
            groupValue: method,
            onChanged: onMethodChange);

    return Scaffold(
        appBar: AppBar(title: Text(s.annotatedExample)),
        body: ConstrainedContent(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SettingsTitle(title: s.entryEgPronunciationMethod),
              methodRadioListTile(PronunciationMethod.onlineTts),
              methodRadioListTile(PronunciationMethod.tts),
              methodRadioListTile(PronunciationMethod.syllableRecordings),
              const SizedBox(height: 20),
              SettingsTitle(title: s.entryEgSpeechRate),
              const SpeechRateRadioListTiles(atHeader: false),
            ]),
          ),
        ));
  }
}
