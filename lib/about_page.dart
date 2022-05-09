import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          Text(paragraph)
        ]);

    return Scaffold(
        appBar: AppBar(title: const Text('About words.hk')),
        drawer: const NavigationDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                sectionWithImage(
                  "Introduction",
                  "We use crowd-sourcing methods to sustainably develop a comprehensive Cantonese dictionary that will be useful for both beginners and advanced users. We aim to provide complete explanations and illustrative example sentences.",
                  "assets/images/wordshk_editor_gathering.jpeg",
                ),
                const SizedBox(height: 40),
                sectionWithImage(
                  "Tenets",
                  "Words.hk is a descriptivist dictionary. Our goal is to document the actual contemporary state of the Cantonese language in Hong Kong, not to set an 'authoritative' standard. In addition to usage that is accepted by mainstream Cantonese users, we also document features that are used by a substantial minority.",
                  "assets/images/cantonese_map.png",
                ),
                const SizedBox(height: 40),
                sectionWithImage(
                  "Purpose",
                  "When we started the project, Cantonese dictionaries in Chinese included only words that are not Mandarin; whereas those in English focused on translating simple words and phrases. We believe that making a comprehensive, bilingual Cantonese dictionary would raise the status of Cantonese as a standalone and complete language, helping us pass on our heritage.",
                  "assets/images/old_cantonese_dictionary.jpeg",
                ),
                const SizedBox(height: 40),
                sectionWithImage(
                  "Open Content",
                  "We believe in ideas of open content, and we publish our content under a relatively permissive license. In addition, some of our data that may be useful for developing input methods, natural language processing etc. is released in the Public Domain.",
                  "assets/images/wordshk_open_data.jpeg",
                )
              ],
            ),
          ),
        ));
  }
}
