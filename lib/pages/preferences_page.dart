import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:wordshk/custom_page_route.dart';
import 'package:wordshk/pages/preferences/entry_eg_page.dart';
import 'package:wordshk/pages/preferences/entry_explanation_language.dart';
import 'package:wordshk/pages/preferences/entry_romanization_page.dart';
import 'package:wordshk/pages/preferences/language_page.dart';
import 'package:wordshk/pages/preferences/search_romanization_page.dart';
import 'package:wordshk/utils.dart';

import '../states/entry_language_state.dart';
import '../states/language_state.dart';
import '../states/romanization_state.dart';
import '../states/search_romanization_state.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/preferences/settings_list.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    final language = context.watch<LanguageState>().language;
    final entryLanguage = context.watch<EntryLanguageState>().language;
    final romanization = context.watch<RomanizationState>().romanization;
    final searchRomanization =
        context.watch<SearchRomanizationState>().romanization;

    return Scaffold(
        appBar: AppBar(title: Text(s.preferences)),
        drawer: const NavigationDrawer(),
        body: MySettingsList(
          sections: [
            SettingsSection(
              title: Text(s.general),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  title: Text(s.language),
                  value: Text(language.toString()),
                  onPressed: (context) {
                    Navigator.push(
                        context,
                        CustomPageRoute(
                            builder: (context) =>
                                const LanguagePreferencesPage()));
                  },
                ),
              ],
            ),
            SettingsSection(
              title: Text(s.dictionarySearch),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  title: Text(s.searchRomanization),
                  value: Text(getRomanizationShortName(
                      searchRomanization, s, language)),
                  onPressed: (context) {
                    Navigator.push(
                        context,
                        CustomPageRoute(
                            builder: (context) =>
                                const SearchRomanizationPreferencesPage()));
                  },
                ),
              ],
            ),
            SettingsSection(
              title: Text(s.dictionaryDefinition),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  title: Text(s.entryExplanationsLanguage),
                  value: Text(getEntryLanguageName(entryLanguage, s)),
                  onPressed: (context) {
                    Navigator.push(
                        context,
                        CustomPageRoute(
                            builder: (context) =>
                                const EntryExplanationLanguagePreferencesPage()));
                  },
                ),
                SettingsTile.navigation(
                  title: Text(s.entryRomanization),
                  value:
                      Text(getRomanizationShortName(romanization, s, language)),
                  onPressed: (context) {
                    Navigator.push(
                        context,
                        CustomPageRoute(
                            builder: (context) =>
                                const EntryRomanizationPreferencesPage()));
                  },
                ),
                SettingsTile.navigation(
                  title: Text(s.dictionaryExample),
                  onPressed: (context) {
                    Navigator.push(
                        context,
                        CustomPageRoute(
                            builder: (context) =>
                                const EntryEgPreferencesPage()));
                  },
                ),
              ],
            ),
          ],
        ));
  }
}
