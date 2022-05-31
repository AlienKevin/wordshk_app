import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/scalable_text_span.dart';

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

    linkedTextSpan(String text, String link, {IconData? icon}) {
      final color = Theme.of(context).colorScheme.secondary;
      return WidgetSpan(
          child: GestureDetector(
              onTap: () => openLink(link),
              child: Builder(builder: (context) {
                return RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: ScalableTextSpan(
                      context,
                      children: [
                        icon == null
                            ? const TextSpan()
                            : WidgetSpan(child: Icon(icon, color: color)),
                        TextSpan(text: text),
                      ],
                      style: TextStyle(color: color),
                    ));
              })));
    }

    bulletTextSpan(String text, String link) => [
          const TextSpan(text: "   "),
          WidgetSpan(
              baseline: TextBaseline.alphabetic,
              alignment: PlaceholderAlignment.aboveBaseline,
              child: Icon(Icons.circle,
                  size: 12,
                  color: Theme.of(context).textTheme.bodyMedium?.color)),
          const TextSpan(text: " "),
          linkedTextSpan(
            text,
            link,
          )
        ];

    final specialCreditsTextList =
        AppLocalizations.of(context)!.aboutWordshkSpecialCreditsText.split(":");
    final specialCreditsLinkList = [
      "http://compling.hss.ntu.edu.sg/hkcancor/",
      "http://www.linguistics.hku.hk/",
      "https://www.facebook.com/o.indicum",
      "https://twitter.com/cancheng",
      "https://chiron-fonts.github.io/",
      "https://repository.eduhk.hk/en/persons/chaak-ming%E5%8A%89%E6%93%87%E6%98%8E-lau"
    ];

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
                                  .aboutWordshkWantToHelpText),
                          linkedTextSpan(
                            icon: Icons.email_outlined,
                            AppLocalizations.of(context)!.email,
                            "mailto:join@words.hk",
                          ),
                          const TextSpan(text: "  "),
                          linkedTextSpan(
                            icon: Icons.facebook_outlined,
                            AppLocalizations.of(context)!.facebook,
                            "https://www.facebook.com/www.words.hk",
                          )
                        ])),
                const SizedBox(height: 40),
                section(
                    AppLocalizations.of(context)!
                        .aboutWordshkSpecialCreditsTitle,
                    TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          for (int i = 0;
                              i < specialCreditsTextList.length;
                              i += 1) ...[
                            ...bulletTextSpan(specialCreditsTextList[i],
                                specialCreditsLinkList[i]),
                            TextSpan(
                                text: i == specialCreditsTextList.length - 1
                                    ? ""
                                    : "\n")
                          ]
                        ])),
                SizedBox(
                    height: Theme.of(context).textTheme.bodyMedium!.fontSize),
              ],
            ),
          ),
        ));
  }
}
