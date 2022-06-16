import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:wordshk/pages/preferences_page.dart';
import 'package:wordshk/pages/quality_control_page.dart';

import '../constants.dart';
import '../custom_page_route.dart';
import '../pages/about_page.dart';
import '../pages/dictionary_license_page.dart';
import '../pages/home_page.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextButton drawerButton(String label, IconData icon, gotoPage) =>
        TextButton.icon(
          icon: Padding(
              padding: const EdgeInsets.only(left: 10),
              child:
                  Icon(icon, color: Theme.of(context).colorScheme.secondary)),
          label: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.normal),
              )),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              CustomPageRoute(builder: gotoPage),
            );
          },
        );

    return SizedBox(
        width: 250,
        child: Drawer(
// Add a ListView to the drawer. This ensures the user can scroll
// through the options in the drawer if there isn't enough vertical
// space to fit everything.
          child: ListView(
// Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 180 * MediaQuery.of(context).textScaleFactor,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "粵典 words.hk",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: whiteColor),
                        ),
                        SizedBox(
                            height: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .fontSize! /
                                2),
                        Text(
                          AppLocalizations.of(context)!.wordshkSlogan,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: whiteColor),
                        )
                      ]),
                ),
              ),
              drawerButton(
                  AppLocalizations.of(context)!.dictionary,
                  PlatformIcons(context).search,
                  (_) => const HomePage(title: 'words.hk')),
              const Divider(),
              drawerButton(
                  AppLocalizations.of(context)!.aboutWordshk,
                  isMaterial(context)
                      ? Icons.info_outline
                      : CupertinoIcons.info,
                  (_) => const AboutPage()),
              const Divider(),
              drawerButton(
                  AppLocalizations.of(context)!.qualityControl,
                  PlatformIcons(context).checkMark,
                  (_) => const QualityControlPage(useBackNavigation: false)),
              const Divider(),
              drawerButton(
                  AppLocalizations.of(context)!.preferences,
                  isMaterial(context)
                      ? Icons.settings_outlined
                      : CupertinoIcons.settings,
                  (_) => const PreferencesPage()),
              const Divider(),
              drawerButton(
                  AppLocalizations.of(context)!.dictionaryLicense,
                  isMaterial(context)
                      ? Icons.article_outlined
                      : CupertinoIcons.doc_text,
                  (_) => const DictionaryLicensePage()),
            ],
          ),
        ));
  }
}
