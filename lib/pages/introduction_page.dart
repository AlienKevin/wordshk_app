import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordshk/pages/home_page.dart';
import 'package:wordshk/states/analytics_settings_state.dart';
import 'package:wordshk/widgets/preferences/title.dart';

import '../constants.dart';
import '../custom_page_route.dart';
import '../widgets/preferences/language_radio_list_tiles.dart';
import '../widgets/preferences/radio_list_tile.dart';
import '../widgets/preferences/romanization_radio_list_tiles.dart';

class IntroductionPage extends StatelessWidget {
  final SharedPreferences prefs;

  const IntroductionPage({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    const pageDecoration = PageDecoration(
      titlePadding: EdgeInsets.only(top: 0.0, bottom: 24.0),
      contentMargin: EdgeInsets.all(32.0),
    );
    return Container(
      decoration:
          BoxDecoration(color: Theme.of(context).canvasColor.withOpacity(0.9)),
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: wideScreenThreshold,
            maxHeight: wideScreenThreshold,
          ),
          child: IntroductionScreen(
              safeAreaList: const [false, false, true, true],
              onDone: () {
                Navigator.push(
                  context,
                  CustomPageRoute(
                      builder: (context) => const HomePage(title: "words.hk")),
                );
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
                      child: PreferencesTitle(title: s.welcome)),
                  bodyWidget: Column(children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(s.introductionText)),
                    const SizedBox(height: 40),
                    Image(
                        width: 200,
                        image: MediaQuery.of(context).platformBrightness ==
                                Brightness.light
                            ? const AssetImage('assets/icon.png')
                            : const AssetImage('assets/icon_grey.png'))
                  ]),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  titleWidget: Align(
                      alignment: Alignment.centerLeft,
                      child: PreferencesTitle(title: s.introductionLanguage)),
                  bodyWidget: const LanguageRadioListTiles(),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  titleWidget: Align(
                      alignment: Alignment.centerLeft,
                      child:
                          PreferencesTitle(title: s.introductionRomanization)),
                  bodyWidget: const RomanizationRadioListTiles(
                      syncEntryRomanization: true),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  titleWidget: Align(
                      alignment: Alignment.centerLeft,
                      child: PreferencesTitle(title: s.sendAnalytics)),
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

    analyticsRadioListTile(bool value) => PreferencesRadioListTile<bool>(
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
