import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:wordshk/states/entry_eg_jumpy_prs_state.dart';
import 'package:wordshk/states/language_state.dart';
import 'package:wordshk/states/speech_rate_state.dart';
import 'package:wordshk/widgets/constrained_content.dart';
import 'package:wordshk/widgets/settings/settings_switch_tile.dart';

import '../../states/entry_eg_font_size_state.dart';
import '../../utils.dart';
import '../../widgets/settings/settings_list.dart';

class EntryEgSettingsPage extends StatelessWidget {
  const EntryEgSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final entryEgFontSize = context.watch<EntryEgFontSizeState>().size;
    final entryEgIsJumpy = context.watch<EntryEgJumpyPrsState>().isJumpy;
    final entryEgSpeechRate = context.watch<SpeechRateState>().entryEgRate;

    onEntryEgJumpyPrsChange(bool newIsJumpy) {
      context.read<EntryEgJumpyPrsState>().updateIsJumpy(newIsJumpy);
    }

    return Scaffold(
        appBar: AppBar(title: Text(s.dictionaryExample)),
        body: ConstrainedContent(
          child: MySettingsList(sections: [
            SettingsSection(
                title: Text(s.annotatedExample),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    title: Text(s.entryEgFontSize),
                    value: Text(getFontSizeName(entryEgFontSize, s)),
                    onPressed: (context) =>
                        context.push('/settings/entry/example/font-size'),
                  ),
                  SettingsTile.navigation(
                    title: Text(s.entryEgSpeechRate),
                    value: Text(getSpeechRateName(entryEgSpeechRate, s)),
                    onPressed: (context) =>
                        context.push('/settings/entry/example/speech-rate'),
                  ),
                  MySettingsSwitchTile(
                      initialValue: entryEgIsJumpy,
                      onToggle: onEntryEgJumpyPrsChange,
                      label: s.entryEgJumpyPrs)
                ]),
          ]),
        ));
  }
}
