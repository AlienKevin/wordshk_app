import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';
import 'navigation_drawer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    sectionWithImage(String title, String paragraph, String imagePath) =>
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Image.asset(imagePath, fit: BoxFit.fitWidth),
          const SizedBox(
            height: 10,
          ),
          Text(title, style: Theme.of(context).textTheme.titleLarge!),
          Text(paragraph, style: Theme.of(context).textTheme.bodyMedium),
        ]);

    section(String title, TextSpan paragraph) =>
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge!),
          RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: paragraph),
        ]);

    void openLink(String url) async {
      var uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    }

    linkedTextSpan(String text, String link) => TextSpan(
        text: text,
        style: const TextStyle(color: blueColor),
        recognizer: TapGestureRecognizer()..onTap = () => openLink(link));

    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.aboutWordshk)),
        drawer: const NavigationDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                sectionWithImage(
                  AppLocalizations.of(context)!.aboutWordshkIntroductionTitle,
                  AppLocalizations.of(context)!.aboutWordshkIntroductionText,
                  "assets/images/wordshk_editor_gathering.jpeg",
                ),
                const SizedBox(height: 40),
                sectionWithImage(
                  AppLocalizations.of(context)!.aboutWordshkTenetsTitle,
                  AppLocalizations.of(context)!.aboutWordshkTenetsText,
                  "assets/images/cantonese_map.png",
                ),
                const SizedBox(height: 40),
                sectionWithImage(
                  AppLocalizations.of(context)!.aboutWordshkPurposeTitle,
                  AppLocalizations.of(context)!.aboutWordshkPurposeText,
                  "assets/images/old_cantonese_dictionary.jpeg",
                ),
                const SizedBox(height: 40),
                sectionWithImage(
                  AppLocalizations.of(context)!.aboutWordshkOpenContentTitle,
                  AppLocalizations.of(context)!.aboutWordshkOpenContentText,
                  "assets/images/wordshk_open_data.jpeg",
                ),
                const SizedBox(height: 40),
                section(
                    AppLocalizations.of(context)!.aboutWordshkWantToHelpTitle,
                    TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context)!
                                .aboutWordshkWantToHelpText,
                          ),
                          linkedTextSpan(
                            AppLocalizations.of(context)!.email,
                            "mailto:join@words.hk",
                          ),
                          const TextSpan(text: " | "),
                          linkedTextSpan(
                            AppLocalizations.of(context)!.facebook,
                            "https://www.facebook.com/www.words.hk",
                          )
                        ])),
              ],
            ),
          ),
        ));
  }
}
