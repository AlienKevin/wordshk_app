import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextButton drawerButton(String label, IconData icon, String gotoRoute,
            [Key? key]) =>
        TextButton.icon(
          key: key,
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
            context.go(gotoRoute);
          },
        );

    return SafeArea(
      top: false,
      bottom: false,
      child: SizedBox(
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
                    margin: EdgeInsets.zero,
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
                    "/",
                    const Key("drawerDictionaryButton")),
                const Divider(),
                drawerButton(AppLocalizations.of(context)!.exercise,
                    PlatformIcons(context).volumeUp, "/exercise"),
                const Divider(),
                drawerButton(
                    AppLocalizations.of(context)!.settings,
                    isMaterial(context)
                        ? Icons.settings_outlined
                        : CupertinoIcons.settings,
                    "/settings"),
              ],
            ),
          )),
    );
  }
}
