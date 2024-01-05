import 'package:flutter/material.dart' hide NavigationDrawer;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:wordshk/pages/share_feedback_page.dart';
import 'package:wordshk/states/analytics_settings_state.dart';
import 'package:wordshk/utils.dart';
import 'package:wordshk/widgets/constrained_content.dart';

import '../states/entry_language_state.dart';
import '../states/language_state.dart';
import '../states/romanization_state.dart';
import '../states/speech_rate_state.dart';
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
        body: ConstrainedContent(
          child: MySettingsList(
            sections: [
              SettingsSection(
                title: Text(s.general),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    title: Text(s.language),
                    value: Text(language.toString()),
                    onPressed: (context) => context.push('/settings/language'),
                  ),
                  SettingsTile.navigation(
                    title: Text(s.cantoneseScript),
                    value: Text(getScriptName(script, s)),
                    onPressed: (context) => context.push('/settings/script'),
                  ),
                  SettingsTile.navigation(
                    title: Text(s.romanization),
                    value: Text(getRomanizationName(romanization, s)),
                    onPressed: (context) =>
                        context.push('/settings/romanization'),
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
                      context.push('/settings/entry/definition/language');
                    },
                  ),
                  SettingsTile.navigation(
                    title: Text(s.entryHeaderSpeechRate),
                    value: Text(getSpeechRateName(entryHeaderSpeechRate, s)),
                    onPressed: (context) =>
                        context.push('/settings/entry/header/speech-rate'),
                  ),
                  SettingsTile.navigation(
                    title: Text(s.dictionaryExample),
                    onPressed: (context) =>
                        context.push('/settings/entry/example'),
                  ),
                ],
              ),
              SettingsSection(
                title: Text(s.privacy),
                tiles: [
                  SettingsTile.navigation(
                    onPressed: (context) {
                      openLink(
                          "https://github.com/AlienKevin/wordshk_app/blob/main/privacy.md#privacy-policy");
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
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (context) => const ShareFeedbackPage(),
                      );
                    },
                    title: Text(s.shareFeedback),
                  ),
                  SettingsTile.navigation(
                    onPressed: (context) {
                      context.push('/about');
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
