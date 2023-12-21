import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/utils.dart';

import '../../bridge_generated.dart';
import '../../states/language_state.dart';
import '../../widgets/preferences/radio_list_tile.dart';

class ScriptRadioListTiles extends StatelessWidget {
  const ScriptRadioListTiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final script = context.watch<LanguageState>().getScript();

    onScriptChange(Script? newScript) {
      if (newScript != null) {
        context.read<LanguageState>().updateScript(newScript);
      }
    }

    scriptRadioListTile(Script value) => PreferencesRadioListTile<Script>(
        title: getScriptName(value, s), value: value, groupValue: script, onChanged: onScriptChange);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      scriptRadioListTile(Script.Traditional),
      scriptRadioListTile(Script.Simplified),
    ]);
  }
}
