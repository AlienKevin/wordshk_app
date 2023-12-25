import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';
import 'package:wordshk/main.dart' as app_main;
import 'package:wordshk/models/language.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('take-screenshots', () {
    testWidgets('home-page', (tester) async {
      final language =
          Language.values.byName(const String.fromEnvironment("language"));
      await app_main.runMyApp(firstTimeUser: false, language: language);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      final double screenWidth =
          tester.view.physicalSize.width / tester.view.devicePixelRatio;
      print("screenWidth: $screenWidth");
      final isWideScreen = screenWidth > 600;

      // Clear the clipboard
      // await Clipboard.setData(const ClipboardData(text: ''));

      final menuButton = find.byIcon(Icons.menu);
      await tester.tap(menuButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final aboutButton = find.byKey(const Key("drawerAboutButton"));
      await tester.tap(aboutButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await takeScreenshot('about-page');

      await tester.tap(menuButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final dictionaryButton = find.byKey(const Key("drawerDictionaryButton"));
      await tester.tap(dictionaryButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final searchBar = find.byKey(const Key("homePageSearchBar"));
      await tester.enterText(
          searchBar,
          switch (language) {
            Language.en => "thanks",
            Language.zhHans => "唔该",
            Language.zhHant => "唔該",
            _ => throw "Unsupported language: $language",
          });
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await takeScreenshot('home-search');

      // Locate the 唔該 entry

      if (isWideScreen) {
        print("Hidding keyboard on wide screen");
        // Hide the on-screen keyboard
        binding.focusManager.primaryFocus?.unfocus();

        // Wait until keyboard is hidden
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      final entryButton = find.textContaining(
          switch (language) {
            Language.en => "m4 goi1",
            Language.zhHans => "向对方表示感激",
            Language.zhHant => "向對方表示感激",
            _ => throw "Unsupported language: $language",
          },
          findRichText: true);
      await tester.tap(entryButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await takeScreenshot('entry-page');
    });
  });
}

Future<void> takeScreenshot(String name) async {
  // Use your machine's local IP for iOS
  const androidHostIp = "10.0.2.2";
  const hostLocalIp = "100.64.4.251";
  final ip = Platform.isAndroid ? androidHostIp : hostLocalIp;
  final response = await http.post(
    Uri.parse('http://$ip:5000/takeScreenshot'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(name),
  );

  if (response.statusCode != 200) {
    throw "takeScreenshot failed: ${response.statusCode}";
  }
}
