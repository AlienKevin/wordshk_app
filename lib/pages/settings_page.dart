import 'package:flutter/material.dart' hide NavigationDrawer;
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:wordshk/states/analytics_settings_state.dart';
import 'package:wordshk/states/auto_paste_search_state.dart';
import 'package:wordshk/states/history_state.dart';
import 'package:wordshk/states/text_size_state.dart';
import 'package:wordshk/utils.dart';
import 'package:wordshk/widgets/constrained_content.dart';

import '../device_info.dart';
import '../states/entry_language_state.dart';
import '../states/language_state.dart';
import '../states/romanization_state.dart';
import '../states/search_bar_position_state.dart';
import '../states/speech_rate_state.dart';
import '../widgets/settings/settings_list.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> sendEmail(
        String recipient, String subject, String body) async {
      final Email email = Email(
        subject: subject,
        body: body,
        recipients: [recipient],
        isHTML: false,
      );

      const developerEmail = "kevinli020508@gmail.com";
      const facebookGroupUrl = "facebook.com/www.words.hk";

      try {
        await FlutterEmailSender.send(email);
      } catch (error) {
        print(error);

        final buttonTextColor =
            MediaQuery.of(context).platformBrightness == Brightness.light
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.onPrimary;

        showDialog(
          useRootNavigator: false,
          context: context,
          builder: (_) => AlertDialog(
            content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.emailClientNotFound),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.email,
                        ),
                        WidgetSpan(
                            child: IconButton(
                                visualDensity: VisualDensity.compact,
                                alignment: Alignment.bottomCenter,
                                color: buttonTextColor,
                                onPressed: () async {
                                  await Clipboard.setData(const ClipboardData(
                                      text: developerEmail));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(AppLocalizations.of(
                                              context)!
                                          .copiedToClipboard(developerEmail)),
                                    ),
                                  );
                                },
                                icon:
                                    Icon(Icons.copy, color: buttonTextColor))),
                        const TextSpan(
                          text: developerEmail,
                        )
                      ])),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.facebook,
                        ),
                        WidgetSpan(
                            child: IconButton(
                                visualDensity: VisualDensity.compact,
                                alignment: Alignment.bottomCenter,
                                color: buttonTextColor,
                                onPressed: () async {
                                  await Clipboard.setData(const ClipboardData(
                                      text: facebookGroupUrl));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(AppLocalizations.of(
                                              context)!
                                          .copiedToClipboard(facebookGroupUrl)),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.copy,
                                  color: buttonTextColor,
                                ))),
                        const TextSpan(
                          text: facebookGroupUrl,
                        ),
                      ])),
                    ])),
            actions: [
              TextButton(
                child: Text("OK", style: TextStyle(color: buttonTextColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }

    final s = AppLocalizations.of(context)!;

    final language = context.watch<LanguageState>().language!;
    final script = context.watch<LanguageState>().getScript();
    final entryLanguage = context.watch<EntryLanguageState>().language;
    final romanization = context.watch<RomanizationState>().romanization;
    final textSize = context.watch<TextSizeState>().getTextSize();
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
                  SettingsTile.navigation(
                    title: Text(s.textSize),
                    value: Text("${textSize.toString()}%"),
                    onPressed: (context) => context.push('/settings/text-size'),
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
                title: Text(s.search),
                tiles: [
                  SettingsTile.navigation(
                    title: Text(s.searchBarPosition),
                    value: Text(getSearchBarPositionName(
                        context
                            .watch<SearchBarPositionState>()
                            .getSearchBarPosition(),
                        s)),
                    onPressed: (context) {
                      context.push('/settings/search-bar-position');
                    },
                  ),
                  SettingsTile.navigation(
                    onPressed: (context) {
                      showDialog(
                        useRootNavigator: false,
                        context: context,
                        builder: (_) => AlertDialog(
                          content: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: Text(s.historyClearConfirmation)),
                          actions: [
                            TextButton(
                              child: Text(s.cancel,
                                  style: TextStyle(
                                      color: MediaQuery.of(context)
                                                  .platformBrightness ==
                                              Brightness.light
                                          ? null
                                          : Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: Text(s.confirm,
                                  style: TextStyle(
                                      color: MediaQuery.of(context)
                                                  .platformBrightness ==
                                              Brightness.light
                                          ? null
                                          : Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                              onPressed: () {
                                Navigator.of(context).pop();
                                final historyState =
                                    context.read<HistoryState>();
                                historyState.removeItems(historyState.items);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    title: Text(s.clearHistory),
                  ),
                  SettingsTile.switchTile(
                      initialValue:
                          context.watch<AutoPasteSearchState>().autoPasteSearch,
                      onToggle: (newAutoPasteSearch) {
                        context
                            .read<AutoPasteSearchState>()
                            .updateAutoPasteSearch(newAutoPasteSearch);
                      },
                      title: Text(s.autoPasteIntoSearchBar)),
                ],
              ),
              SettingsSection(
                title: Text(s.privacy),
                tiles: [
                  SettingsTile.navigation(
                    onPressed: (context) => context.push('/privacy-policy'),
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
                    onPressed: (context) async {
                      final subject =
                          AppLocalizations.of(context)!.wordshkFeedback;
                      PackageInfo packageInfo =
                          await PackageInfo.fromPlatform();
                      String version = packageInfo.version;
                      String buildNumber = packageInfo.buildNumber;
                      final body = "\n\n------------------\n"
                          "App version: $version+$buildNumber\n"
                          "Device info:\n${await getDeviceInfo()}";
                      sendEmail("kevinli020508@gmail.com", subject, body);
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
