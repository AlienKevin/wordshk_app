import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordshk/states/analytics_settings_state.dart';
import 'package:wordshk/widgets/settings/title.dart';

import '../constants.dart';
import '../widgets/settings/eg_jumpy_prs_radio_list_tiles.dart';
import '../widgets/settings/language_radio_list_tiles.dart';
import '../widgets/settings/radio_list_tile.dart';
import '../widgets/settings/romanization_radio_list_tiles.dart';

class IntroductionPage extends StatelessWidget {
  final SharedPreferences prefs;

  const IntroductionPage({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final isWideScreen =
        MediaQuery.of(context).size.width > wideScreenThreshold;

    const pageDecoration = PageDecoration(
      titlePadding: EdgeInsets.only(top: 0.0, bottom: 24.0),
      contentMargin: EdgeInsets.all(32.0),
    );
    return Container(
      decoration: BoxDecoration(
          color: isWideScreen
              ? Theme.of(context).canvasColor.withOpacity(0.9)
              : Theme.of(context).colorScheme.background),
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: wideScreenThreshold,
            maxHeight: isWideScreen ? wideScreenThreshold : double.maxFinite,
          ),
          child: IntroductionScreen(
              safeAreaList: const [false, false, true, true],
              onDone: () {
                context.go('/');
                prefs.setBool("firstTimeUser", false);
              },
              globalBackgroundColor: Theme.of(context).cardColor,
              showSkipButton: false,
              skipOrBackFlex: 0,
              nextFlex: 0,
              showBackButton: true,
              //rtl: true, // Display as right-to-left
              back: const Icon(Icons.arrow_back),
              next: const Icon(Icons.arrow_forward),
              done: Text(s.done,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              pages: [
                PageViewModel(
                  titleWidget: Align(
                      alignment: Alignment.centerLeft,
                      child: SettingsTitle(title: s.welcome)),
                  bodyWidget: Column(children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(s.introductionText)),
                    const SizedBox(height: 40),
                    Image(
                        width: 200,
                        image: Theme.of(context).brightness == Brightness.light
                            ? const AssetImage('assets/icon.png')
                            : const AssetImage('assets/icon_grey.png'))
                  ]),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  titleWidget: Align(
                      alignment: Alignment.centerLeft,
                      child: SettingsTitle(title: s.introductionLanguage)),
                  bodyWidget: const LanguageRadioListTiles(),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  titleWidget: Align(
                      alignment: Alignment.centerLeft,
                      child: SettingsTitle(title: s.introductionRomanization)),
                  bodyWidget: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RomanizationRadioListTiles(syncEntryRomanization: true),
                      SizedBox(height: 15),
                      EgIsJumpyPrsRadioListTiles(),
                    ],
                  ),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  titleWidget: Align(
                      alignment: Alignment.centerLeft,
                      child: SettingsTitle(title: s.sendAnalytics)),
                  bodyWidget: Column(children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(s.sendAnalyticsDescription)),
                    const SizedBox(height: 10),
                    const AnalyticsRadioListTiles(),
                  ]),
                  decoration: pageDecoration,
                )
              ]),
        ),
      ),
    );
  }
}

class AnalyticsRadioListTiles extends StatelessWidget {
  const AnalyticsRadioListTiles({super.key});

  @override
  Widget build(BuildContext context) {
    final enabled = context.watch<AnalyticsSettingsState>().enabled;

    onEnabledChange(bool? newEnabled) {
      if (newEnabled != null) {
        context.read<AnalyticsSettingsState>().setEnabled(newEnabled);
      }
    }

    analyticsRadioListTile(bool value) => SettingsRadioListTile<bool>(
        title: value
            ? AppLocalizations.of(context)!.agreeToShare
            : AppLocalizations.of(context)!.doNotShare,
        value: value,
        groupValue: enabled,
        onChanged: onEnabledChange);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      analyticsRadioListTile(true),
      analyticsRadioListTile(false),
    ]);
  }
}
