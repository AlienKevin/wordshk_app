import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wordshk/pages/quality_control_page.dart';
import 'package:wordshk/pages/software_licenses_page.dart';

import '../bridge_generated.dart' show Script;
import '../constants.dart';
import '../custom_page_route.dart';
import '../main.dart';
import '../pages/about_page.dart';
import '../pages/dictionary_license_page.dart';

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
                height: 210 * MediaQuery.of(context).textScaleFactor * 0.9,
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
                  Icons.search,
                  (_) => HomePage(
                      title: 'words.hk',
                      script:
                          Localizations.localeOf(context).scriptCode == "Hans"
                              ? Script.Simplified
                              : Script.Traditional)),
              const Divider(),
              drawerButton(AppLocalizations.of(context)!.aboutWordshk,
                  Icons.info_outline, (_) => const AboutPage()),
              const Divider(),
              drawerButton(
                  AppLocalizations.of(context)!.qualityControl,
                  Icons.check,
                  (_) => const QualityControlPage(useBackNavigation: false)),
              const Divider(),
              drawerButton(
                  AppLocalizations.of(context)!.dictionaryLicense,
                  Icons.handshake_outlined,
                  (_) => const DictionaryLicensePage()),
              const Divider(),
              drawerButton(AppLocalizations.of(context)!.softwareLicenses,
                  Icons.balance, (_) => const SoftwareLicensesPage()),
            ],
          ),
        ));
  }
}
