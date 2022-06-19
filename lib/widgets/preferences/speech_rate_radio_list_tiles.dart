import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/states/speech_rate_state.dart';

import '../../models/speech_rate.dart';
import '../../utils.dart';
import '../../widgets/preferences/radio_list_tile.dart';

class SpeechRateRadioListTiles extends StatelessWidget {
  final bool atHeader;

  const SpeechRateRadioListTiles({Key? key, required this.atHeader})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final state = context.watch<SpeechRateState>();
    final speechRate = atHeader ? state.entryHeaderRate : state.entryEgRate;

    onSpeechRateChange(SpeechRate? newRate) {
      if (newRate != null) {
        final state = context.read<SpeechRateState>();
        if (atHeader) {
          state.updateEntryHeaderSpeechRate(newRate);
        } else {
          state.updateEntryEgSpeechRate(newRate);
        }
      }
    }

    speechRateRadioListTile(SpeechRate value) =>
        PreferencesRadioListTile<SpeechRate>(
            getSpeechRateName(value, s), value, speechRate, onSpeechRateChange);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      speechRateRadioListTile(SpeechRate.normal),
      speechRateRadioListTile(SpeechRate.slow),
      speechRateRadioListTile(SpeechRate.verySlow),
    ]);
  }
}
