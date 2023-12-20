import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';
import 'package:wordshk/main.dart' as app_main;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('take-screenshots', () {
    testWidgets('home-page',
            (tester) async {
      await app_main.runMyApp(firstTimeUser: false);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

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
      await tester.enterText(searchBar, "jyut man");
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await takeScreenshot('home-search');

      // Locate the 粵文 entry
      final entryButton = find.textContaining("jyut6 man4", findRichText: true);
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
