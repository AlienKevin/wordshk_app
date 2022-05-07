import 'package:flutter/material.dart';

import 'about_page.dart';
import 'constants.dart';
import 'custom_page_route.dart';
import 'main.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
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
              height: 210,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "words.hk",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: whiteColor),
                      ),
                      Text(
                        'Crowd-sourced Cantonese dictionary for everyone.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: whiteColor),
                      )
                    ]),
              ),
            ),
            TextButton.icon(
              icon: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.search)),
              label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Dictionary',
                    style: Theme.of(context).textTheme.titleSmall,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  CustomPageRoute(
                      builder: (context) => const HomePage(
                            title: 'words.hk',
                          )),
                );
              },
            ),
            const Divider(),
            TextButton.icon(
              icon: const Padding(
                  padding: EdgeInsets.only(left: 10), child: Icon(Icons.info)),
              label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'About words.hk',
                    style: Theme.of(context).textTheme.titleSmall,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  CustomPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
          ],
        ),
      ));
}
