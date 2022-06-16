import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:wordshk/pages/preferences/entry_eg_font_size_page.dart';
import 'package:wordshk/states/entry_eg_jumpy_prs_state.dart';
import 'package:wordshk/states/language_state.dart';
import 'package:wordshk/widgets/preferences/settings_switch_tile.dart';

import '../../custom_page_route.dart';
import '../../states/entry_eg_font_size_state.dart';
import '../../states/pronunciation_method_state.dart';
import '../../utils.dart';
import '../../widgets/preferences/settings_list.dart';
import 'entry_eg_pronunciation_method_page.dart';

class EntryEgPreferencesPage extends StatelessWidget {
  const EntryEgPreferencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final language = context.watch<LanguageState>().language;
    final entryEgFontSize = context.watch<EntryEgFontSizeState>().size;
    final entryEgPronunciationMethod =
        context.watch<PronunciationMethodState>().entryEgMethod;
    final entryEgIsJumpy = context.watch<EntryEgJumpyPrsState>().isJumpy;

    onEntryEgJumpyPrsChange(bool newIsJumpy) {
      context.read<EntryEgJumpyPrsState>().updateIsJumpy(newIsJumpy);
    }

    return Scaffold(
        appBar: AppBar(title: Text(s.dictionaryExample)),
        body: MySettingsList(sections: [
          SettingsSection(
              title: Text(s.annotatedExample),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  title: Text(s.entryEgFontSize),
                  value: Text(getFontSizeName(entryEgFontSize, s)),
                  onPressed: (context) {
                    Navigator.push(
                        context,
                        CustomPageRoute(
                            builder: (context) =>
                                const EntryEgFontSizePreferencesPage()));
                  },
                ),
                SettingsTile.navigation(
                  title: Text(s.entryEgPronunciationMethod),
                  value: Text(getPronunciationMethodShortName(
                      entryEgPronunciationMethod, s, language)),
                  onPressed: (context) {
                    Navigator.push(
                        context,
                        CustomPageRoute(
                            builder: (context) =>
                                const EntryEgPronunciationMethodPreferencesPage()));
                  },
                ),
                MySettingsSwitchTile(
                    initialValue: entryEgIsJumpy,
                    onToggle: onEntryEgJumpyPrsChange,
                    label: s.entryEgJumpyPrs)
              ]),
        ]));
  }
}
