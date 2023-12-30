import 'dart:io';

import 'package:flutter/material.dart' hide NavigationDrawer;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:wordshk/custom_page_route.dart';
import 'package:wordshk/pages/about_page.dart';
import 'package:wordshk/pages/preferences/entry_eg_page.dart';
import 'package:wordshk/pages/preferences/entry_explanation_language.dart';
import 'package:wordshk/pages/preferences/entry_header_speech_rate.dart';
import 'package:wordshk/pages/preferences/language_page.dart';
import 'package:wordshk/pages/preferences/romanization_page.dart';
import 'package:wordshk/pages/preferences/script_page.dart';
import 'package:wordshk/states/analytics_settings_state.dart';
import 'package:wordshk/states/spotlight_indexing_state.dart';
import 'package:wordshk/utils.dart';
import 'package:wordshk/widgets/constrained_content.dart';

import '../states/entry_language_state.dart';
import '../states/language_state.dart';
import '../states/romanization_state.dart';
import '../states/speech_rate_state.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/preferences/settings_list.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    final language = context.watch<LanguageState>().language!;
    final script = context.watch<LanguageState>().getScript();
    final entryLanguage = context.watch<EntryLanguageState>().language;
    final romanization = context.watch<RomanizationState>().romanization;
    final entryHeaderSpeechRate =
        context.watch<SpeechRateState>().entryHeaderRate;

    return Scaffold(
        appBar: AppBar(title: Text(s.settings)),
        drawer: const NavigationDrawer(),
        body: ConstrainedContent(
          child: MySettingsList(
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
                  SettingsTile.navigation(
                    title: Text(s.cantoneseScript),
                    value: Text(getScriptName(script, s)),
                    onPressed: (context) {
                      Navigator.push(
                          context,
                          CustomPageRoute(
                              builder: (context) =>
                                  const ScriptPreferencesPage()));
                    },
                  ),
                  SettingsTile.navigation(
                    title: Text(s.romanization),
                    value: Text(getRomanizationName(romanization, s)),
                    onPressed: (context) {
                      Navigator.push(
                          context,
                          CustomPageRoute(
                              builder: (context) =>
                                  const RomanizationPreferencesPage()));
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
                    title: Text(s.entryHeaderSpeechRate),
                    value: Text(getSpeechRateName(entryHeaderSpeechRate, s)),
                    onPressed: (context) {
                      Navigator.push(
                          context,
                          CustomPageRoute(
                              builder: (context) =>
                                  const EntryHeaderSpeechRatePreferencesPage()));
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
              SettingsSection(
                  tiles: ((Platform.isIOS || Platform.isMacOS)
                      ? <SettingsTile>[
                          SettingsTile.switchTile(
                              description: Text(s.spotlightSearchDescription),
                              initialValue: context
                                  .watch<SpotlightIndexingState>()
                                  .enabled,
                              onToggle: (newEnabled) {
                                context
                                    .read<SpotlightIndexingState>()
                                    .updateSpotlightIndexEnabled(newEnabled);
                              },
                              title: Text(s.spotlightSearch)),
                        ]
                      : [])),
              SettingsSection(
                title: Text(s.privacy),
                tiles: [
                  SettingsTile.navigation(
                    onPressed: (context) {
                      openLink("https://github.com/AlienKevin/wordshk_app/blob/main/privacy.md#privacy-policy");
                    },
                    title: Text(s.privacyPolicy),
                  ),
                  SettingsTile.switchTile(
                      initialValue:
                          context.watch<AnalyticsSettingsState>().enabled,
                      onToggle: (newEnabled) {
                        context
                            .read<AnalyticsSettingsState>()
                            .setEnabled(newEnabled);
                      },
                      title: Text(s.sendAnalytics)),
                ],
              ),
              SettingsSection(
                tiles: [
                  SettingsTile.navigation(
                    onPressed: (context) {
                      Navigator.push(
                          context,
                          CustomPageRoute(
                              builder: (context) => const AboutPage()));
                    },
                    title: Text(s.aboutWordshk),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
