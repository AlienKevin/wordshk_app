import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wordshk/widgets/constrained_content.dart';

import '../../widgets/settings/script_radio_list_tiles.dart';
import '../../widgets/settings/title.dart';

class ScriptSettingsPage extends StatelessWidget {
  const ScriptSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(title: Text(s.general)),
        body: ConstrainedContent(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsTitle(title: s.cantoneseScript),
                  const ScriptRadioListTiles()
                ]),
          ),
        ));
  }
}
