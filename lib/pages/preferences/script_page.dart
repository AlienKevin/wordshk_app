import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wordshk/widgets/constrained_content.dart';

import '../../widgets/preferences/script_radio_list_tiles.dart';
import '../../widgets/preferences/title.dart';

class ScriptPreferencesPage extends StatelessWidget {
  const ScriptPreferencesPage({Key? key}) : super(key: key);

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
                  PreferencesTitle(title: s.cantoneseScript),
                  const ScriptRadioListTiles()
                ]),
          ),
        ));
  }
}
