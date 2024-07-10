import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordshk/states/analytics_settings_state.dart';
import 'package:wordshk/widgets/privacy_policy.dart';
import 'package:wordshk/widgets/settings/title.dart';

import '../constants.dart';
import '../widgets/settings/eg_jumpy_prs_radio_list_tiles.dart';
import '../widgets/settings/language_radio_list_tiles.dart';
import '../widgets/settings/radio_list_tile.dart';
import '../widgets/settings/romanization_radio_list_tiles.dart';

class IntroductionPage extends StatefulWidget {
  final SharedPreferences prefs;

  const IntroductionPage({Key? key, required this.prefs}) : super(key: key);

  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  bool agreeToPrivacyPolicy = false;

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
              ? Theme.of(context).brightness == Brightness.dark
                  ? darkGreyColor
                  : Theme.of(context).canvasColor.withOpacity(0.9)
              : (Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white)),
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: wideScreenThreshold,
            maxHeight: isWideScreen
                ? wideScreenThreshold /
                    min(MediaQuery.of(context).size.aspectRatio, 0.8)
                : double.maxFinite,
          ),
          child: IntroductionScreen(
              safeAreaList: const [false, false, true, true],
              onDone: () {
                context.go('/');
                widget.prefs.setBool("firstTimeUser", false);

                // Commit user's analytics choice to the default option
                //(enable analytics) if no choice was made.
                if (context.read<AnalyticsSettingsState>().enabled == null) {
                  context.read<AnalyticsSettingsState>().setEnabled(true);
                }
              },
              globalBackgroundColor:
                  (Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white),
              showSkipButton: false,
              skipOrBackFlex: 0,
              nextFlex: 0,
              showBackButton: true,
              showNextButton: agreeToPrivacyPolicy,
              isProgress: agreeToPrivacyPolicy,
              freeze: !agreeToPrivacyPolicy,
              //rtl: true, // Display as right-to-left
              back: const Icon(Icons.arrow_back),
              backSemantic:
                  MaterialLocalizations.of(context).previousPageTooltip,
              next: const Icon(Icons.arrow_forward),
              nextSemantic: MaterialLocalizations.of(context).nextPageTooltip,
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
                            : const AssetImage('assets/icon_grey.png')),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Row(children: [
                          Transform.scale(
                            scale:
                                1.5, // Adjust the scale factor to make the checkbox larger
                            child: Checkbox(
                              value: agreeToPrivacyPolicy,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  setState(() {
                                    agreeToPrivacyPolicy = value;
                                  });
                                }
                              },
                            ),
                          ),
                          Expanded(
                              child: Text.rich(
                            TextSpan(
                              text: s.introductionReadAndAgreeTo,
                              children: [
                                TextSpan(
                                  text: s.introductionThePrivacyPolicy,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        builder: (BuildContext context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(child: PrivacyPolicy()),
                                              SizedBox(
                                                  height: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .fontSize),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(s.close),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                ),
                              ],
                            ),
                          )),
                        ]))
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
        groupValue: enabled ?? true, // enable analytics by default
        onChanged: onEnabledChange);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      analyticsRadioListTile(true),
      analyticsRadioListTile(false),
    ]);
  }
}
