import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide NavigationDrawer;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:wordshk/widgets/constrained_content.dart';

import '../utils.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  late TapGestureRecognizer qualityControlTapRecognizer;
  late TapGestureRecognizer licenseTapRecognizer;
  late TapGestureRecognizer privacyNoticeLinkTapRecognizer;
  late TapGestureRecognizer appLinkTapRecognizer;
  late TapGestureRecognizer wordshkLinkTapRecognizer;
  late TapGestureRecognizer joinWordshkEmailTapRecognizer;
  late TapGestureRecognizer wordshkFacebookLinkTapRecognizer;
  late List<TapGestureRecognizer> specialCreditsLinkTapRecognizerList;

  @override
  void initState() {
    super.initState();
    qualityControlTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        context.push("/quality-control");
      };

    licenseTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        context.push("/license");
      };

    privacyNoticeLinkTapRecognizer = TapGestureRecognizer()
      ..onTap = () => context.push("/privacy-policy");
    appLinkTapRecognizer = TapGestureRecognizer()
      ..onTap = () => openLink("https://github.com/AlienKevin/wordshk_app");
    wordshkLinkTapRecognizer = TapGestureRecognizer()
      ..onTap = () => openLink("https://words.hk/zidin/");
    joinWordshkEmailTapRecognizer = TapGestureRecognizer()
      ..onTap = () => openLink("mailto:join@words.hk");
    wordshkFacebookLinkTapRecognizer = TapGestureRecognizer()
      ..onTap = () => openLink("https://www.facebook.com/www.words.hk");

    specialCreditsLinkTapRecognizerList = [
      "https://github.com/fcbond/hkcancor",
      "http://www.linguistics.hku.hk/",
      "https://www.facebook.com/o.indicum",
      "https://twitter.com/cancheng",
      "https://chiron-fonts.github.io/",
      "https://repository.eduhk.hk/en/persons/chaak-ming%E5%8A%89%E6%93%87%E6%98%8E-lau",
      "https://visual-fonts.com/"
    ]
        .map((link) => TapGestureRecognizer()..onTap = () => openLink(link))
        .toList();
  }

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
          Text.rich(paragraph),
        ]);

    linkedTextSpanWithOnTap(String text, TapGestureRecognizer recognizer,
        {IconData? icon}) {
      final color = Theme.of(context).colorScheme.secondary;
      return TextSpan(children: [
        icon == null
            ? const TextSpan()
            : WidgetSpan(
                child: GestureDetector(
                    onTap: recognizer.onTap, child: Icon(icon, color: color))),
        TextSpan(text: text, recognizer: recognizer),
      ], style: TextStyle(color: color));
    }

    linkedTextSpan(String text, TapGestureRecognizer recognizer,
        {IconData? icon}) {
      return linkedTextSpanWithOnTap(text, recognizer, icon: icon);
    }

    internalLinkedTextSpan(String text, TapGestureRecognizer recognizer,
        {IconData? icon}) {
      return linkedTextSpanWithOnTap(text, recognizer, icon: icon);
    }

    bulletTextSpan(String text, TapGestureRecognizer recognizer) => [
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
            recognizer,
          )
        ];

    final specialCreditsTextList =
        AppLocalizations.of(context)!.aboutWordshkSpecialCreditsText.split(":");

    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.aboutWordshk)),
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
                  Text.rich(TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        internalLinkedTextSpan(
                            AppLocalizations.of(context)!
                                .aboutWordshkCheckOutQualityControl,
                            qualityControlTapRecognizer,
                            icon:
                                PlatformIcons(context).checkMarkCircledOutline),
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
                  Text.rich(TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        internalLinkedTextSpan(
                            AppLocalizations.of(context)!
                                .aboutWordshkCheckOutLicense,
                            licenseTapRecognizer,
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
                            appLinkTapRecognizer,
                          ),
                          TextSpan(
                              text: AppLocalizations.of(context)!
                                  .aboutWordshkPlatformsText2),
                          linkedTextSpan(
                            "words.hk",
                            wordshkLinkTapRecognizer,
                          ),
                          TextSpan(
                              text: AppLocalizations.of(context)!
                                  .aboutWordshkPlatformsText3),
                        ]),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        linkedTextSpan(
                            AppLocalizations.of(context)!
                                .aboutWordshkCheckOutPrivacyNotice,
                            privacyNoticeLinkTapRecognizer,
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
                              joinWordshkEmailTapRecognizer,
                            ),
                            const TextSpan(text: "  "),
                            linkedTextSpan(
                              icon: Icons.facebook_outlined,
                              AppLocalizations.of(context)!.facebook,
                              wordshkFacebookLinkTapRecognizer,
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
                                  specialCreditsLinkTapRecognizerList[i]),
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

  @override
  void dispose() {
    qualityControlTapRecognizer.dispose();
    licenseTapRecognizer.dispose();
    privacyNoticeLinkTapRecognizer.dispose();
    appLinkTapRecognizer.dispose();
    wordshkLinkTapRecognizer.dispose();
    joinWordshkEmailTapRecognizer.dispose();
    wordshkFacebookLinkTapRecognizer.dispose();
    for (var recognizer in specialCreditsLinkTapRecognizerList) {
      recognizer.dispose();
    }
    super.dispose();
  }
}
