import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide NavigationDrawer;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:wordshk/pages/quality_control_page.dart';
import 'package:wordshk/widgets/constrained_content.dart';

import '../utils.dart';
import '../widgets/navigation_drawer.dart';
import 'dictionary_license_page.dart';

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

    linkedTextSpanWithOnTap(String text, void Function() onTap,
        {IconData? icon}) {
      final color = Theme.of(context).colorScheme.secondary;
      return WidgetSpan(
          child: GestureDetector(
              onTap: onTap,
              child: Builder(builder: (context) {
                return RichText(
                    text: TextSpan(
                        children: [
                      icon == null
                          ? const TextSpan()
                          : WidgetSpan(child: Icon(icon, color: color)),
                      TextSpan(text: text),
                    ],
                        style: TextStyle(
                            color: color,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .fontSize)));
              })));
    }

    linkedTextSpan(String text, String link, {IconData? icon}) {
      return linkedTextSpanWithOnTap(text, () => openLink(link), icon: icon);
    }

    internalLinkedTextSpan(String text, void Function() onTap,
        {IconData? icon}) {
      return linkedTextSpanWithOnTap(text, onTap, icon: icon);
    }

    bulletTextSpan(String text, String link) => [
          const TextSpan(text: "   "),
          WidgetSpan(
              baseline: TextBaseline.alphabetic,
              alignment: PlaceholderAlignment.aboveBaseline,
              child: Icon(Icons.circle,
                  size: 12,
                  color: Theme.of(context).textTheme.bodyMedium?.color)),
          const TextSpan(text: "  "),
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
        body: ConstrainedContent(
          child: SingleChildScrollView(
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
                  const SizedBox(height: 10),
                  RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            internalLinkedTextSpan(
                                AppLocalizations.of(context)!
                                    .aboutWordshkCheckOutQualityControl, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const QualityControlPage()),
                              );
                            },
                                icon: PlatformIcons(context)
                                    .checkMarkCircledOutline),
                          ])),
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
                  const SizedBox(height: 10),
                  RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            internalLinkedTextSpan(
                                AppLocalizations.of(context)!
                                    .aboutWordshkCheckOutLicense, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DictionaryLicensePage()),
                              );
                            },
                                icon: isMaterial(context)
                                    ? Icons.article_outlined
                                    : CupertinoIcons.doc_text),
                          ])),
                  const SizedBox(height: 40),
                  section(
                    AppLocalizations.of(context)!.aboutWordshkPlatformsTitle,
                    TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                              text: AppLocalizations.of(context)!
                                  .aboutWordshkPlatformsText1),
                          linkedTextSpan(
                            "GitHub",
                            "https://github.com/AlienKevin/wordshk_app",
                          ),
                          TextSpan(
                              text: AppLocalizations.of(context)!
                                  .aboutWordshkPlatformsText2),
                          linkedTextSpan(
                            "words.hk",
                            "https://words.hk/zidin/",
                          ),
                          TextSpan(
                              text: AppLocalizations.of(context)!
                                  .aboutWordshkPlatformsText3),
                        ]),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            linkedTextSpan(
                                AppLocalizations.of(context)!
                                    .aboutWordshkCheckOutPrivacyNotice,
                                "https://github.com/AlienKevin/wordshk_app/blob/main/privacy.md",
                                icon: isMaterial(context)
                                    ? Icons.lock_outlined
                                    : CupertinoIcons.lock),
                          ])),
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
                              icon: isMaterial(context)
                                  ? Icons.email_outlined
                                  : CupertinoIcons.mail,
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
          ),
        ));
  }
}
