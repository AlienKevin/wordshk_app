import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:integration_test/src/channel.dart';
import 'package:wordshk/main.dart' as app_main;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('take-screenshots', () {
    testWidgets('home-page',
            (tester) async {
      await app_main.runMyApp(firstTimeUser: false);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 5));

      // Clear the clipboard
      await Clipboard.setData(const ClipboardData(text: ''));

      final menuButton = find.byIcon(Icons.menu);
      await tester.tap(menuButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final aboutButton = find.byKey(const Key("drawerAboutButton"));
      await tester.tap(aboutButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await takeScreenshot(binding, tester, 'about-page');

      await tester.tap(menuButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final dictionaryButton = find.byKey(const Key("drawerDictionaryButton"));
      await tester.tap(dictionaryButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final searchBar = find.byKey(const Key("homePageSearchBar"));
      await tester.enterText(searchBar, "jyut");
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await takeScreenshot(binding, tester, 'home-search');

      // Locate the 粵 entry
      final entryButton = find.textContaining("short for Guangdong", findRichText: true);
      await tester.tap(entryButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await takeScreenshot(binding, tester, 'entry-page');

      print("====SCREENSHOTS====");
      print(jsonEncode(binding.reportData!['screenshots']));
    });
  });
}

Future<void> takeScreenshot(IntegrationTestWidgetsFlutterBinding binding, WidgetTester tester, String name) async {
  if (Platform.isAndroid) {
    await integrationTestChannel.invokeMethod<void>(
      'convertFlutterSurfaceToImage',
    );
  } // TODO: Change to binding.convertFlutterSurfaceToImage() when this issue is fixed: https://github.com/flutter/flutter/issues/92381
  await tester.pump();
  // TODO: Replace the following block with binding.takeScreenshot(name) when this issue is fixed: https://github.com/flutter/flutter/issues/92381
  binding.reportData ??= <String, dynamic>{};
  binding.reportData!['screenshots'] ??= <dynamic>[];
  integrationTestChannel.setMethodCallHandler((MethodCall call) async {
    switch (call.method) {
      case 'scheduleFrame':
        PlatformDispatcher.instance.scheduleFrame();
        break;
    }
    return null;
  });
  final rawBytes = await integrationTestChannel.invokeMethod<List<int>>(
    'captureScreenshot',
    <String, dynamic>{'name': name},
  );
  if (rawBytes == null) {
    throw StateError('Expected a list of bytes, but instead captureScreenshot returned null');
  }
  final data = <String, dynamic>{
    'screenshotName': name,
    'bytes': rawBytes,
  };
  assert(data.containsKey('bytes'), 'Missing bytes key');
  (binding.reportData!['screenshots'] as List<dynamic>).add(data);
  // TODO: Replace the above block with binding.takeScreenshot(name) when this issue is fixed: https://github.com/flutter/flutter/issues/92381

  if (Platform.isAndroid) {
    await integrationTestChannel.invokeMethod<void>(
      'revertFlutterImage',
    );
  } // TODO: Change to binding.revertFlutterImage() when this issue is fixed: https://github.com/flutter/flutter/issues/92381
}
