import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wordshk/license.dart';

import 'expandable.dart';
import 'navigation_drawer.dart';

// Source: https://github.com/JohannesMilke/license_page_example/blob/master/lib/page/licenses_registry_page.dart
class SoftwareLicensesPage extends StatelessWidget {
  const SoftwareLicensesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Software Licenses'),
          centerTitle: true,
        ),
        drawer: const NavigationDrawer(),
        body: FutureBuilder<List<License>>(
          future: loadLicenses(),
          builder: (context, snapshot) {
            final licenses = snapshot.data;

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                return snapshot.hasError
                    ? const Center(
                        child: Text(
                            'An error occurred while loading the software licenses page.'))
                    : LicensesWidget(
                        licenses: licenses!,
                      );
            }
          },
        ),
      );

  Future<List<License>> loadLicenses() async => LicenseRegistry.licenses
      .asyncMap<License>((license) async {
        final title = license.packages.join('\n');
        final text = license.paragraphs
            .map<String>((paragraph) => paragraph.text)
            .join('\n\n');

        return License(title, text);
      })
      .toList()
      .then((licenses) {
        const appLicense =
            License("words.hk (this app)", """Copyright 2022 Xiang Li

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.""");
        return [appLicense, ...licenses];
      });
}

class LicensesWidget extends StatelessWidget {
  final List<License> licenses;

  const LicensesWidget({required this.licenses, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: licenses.length,
        itemBuilder: (context, index) {
          final license = licenses[index];

          return ListTile(
              title: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  license.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              subtitle: ExpandableNotifier(
                  child: applyExpandableTheme(Expandable(
                      collapsed: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              license.text.split("\n")[0],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            expandButton("Show license", Icons.expand_more,
                                Theme.of(context).textTheme.bodySmall!)
                          ]),
                      expanded: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              license.text,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            expandButton("Hide license", Icons.expand_less,
                                Theme.of(context).textTheme.bodySmall!)
                          ])))));
        },
      );
}
