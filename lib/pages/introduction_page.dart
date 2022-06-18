import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:wordshk/models/language_background.dart';
import 'package:wordshk/pages/home_page.dart';
import 'package:wordshk/widgets/preferences/title.dart';

import '../custom_page_route.dart';
import '../widgets/preferences/language_radio_list_tiles.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      titlePadding: EdgeInsets.only(top: 0.0, bottom: 24.0),
      contentMargin: EdgeInsets.all(32.0),
    );
    return IntroductionScreen(
        isTopSafeArea: true,
        isBottomSafeArea: true,
        globalBackgroundColor: Colors.white,
        onDone: () {
          Navigator.push(
            context,
            CustomPageRoute(
                builder: (context) => const HomePage(title: "words.hk")),
          );
        },
        showSkipButton: false,
        skipOrBackFlex: 0,
        nextFlex: 0,
        showBackButton: true,
        //rtl: true, // Display as right-to-left
        back: const Icon(Icons.arrow_back),
        skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
        next: const Icon(Icons.arrow_forward),
        done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
        pages: [
          PageViewModel(
            titleWidget: const Align(
                alignment: Alignment.centerLeft,
                child: PreferencesTitle(title: "Welcome")),
            bodyWidget: Column(children: const [
              Text(
                  "Welcome to words.hk!\nEach learner's background is different and we want everyone to have the best Cantonese learning experience possible. So before you start, please take a moment to select your learning preferences."),
              SizedBox(height: 20),
              Image(width: 200, image: AssetImage('assets/icon.png'))
            ]),
            decoration: pageDecoration,
          ),
          PageViewModel(
            titleWidget: const Align(
                alignment: Alignment.centerLeft,
                child:
                    PreferencesTitle(title: "I feel most comfortable in...")),
            bodyWidget: const LanguageRadioListTiles(),
            decoration: pageDecoration,
          )
        ]);
  }
}
