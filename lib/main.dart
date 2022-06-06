import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/pages/home_page.dart';
import 'package:wordshk/states/entry_language_state.dart';
import 'package:wordshk/states/language_state.dart';
import 'package:wordshk/states/pronunciation_method_state.dart';
import 'package:wordshk/states/romanization_state.dart';
import 'package:wordshk/states/search_mode_state.dart';
import 'package:wordshk/states/search_query_state.dart';

import 'bridge_generated.dart';
import 'constants.dart';

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <Id>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

const base = 'wordshk_api';
final path = Platform.isWindows ? '$base.dll' : 'lib$base.so';
late final dylib = Platform.isIOS
    ? DynamicLibrary.process()
    : Platform.isMacOS
        ? DynamicLibrary.executable()
        : DynamicLibrary.open(path);
late final api = WordshkApiImpl(dylib);

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SearchModeState>(
            create: (_) => SearchModeState()),
        ChangeNotifierProvider<SearchQueryState>(
            create: (_) => SearchQueryState()),
        ChangeNotifierProvider<LanguageState>(create: (_) => LanguageState()),
        ChangeNotifierProvider<EntryLanguageState>(
            create: (_) => EntryLanguageState()),
        ChangeNotifierProvider<PronunciationMethodState>(
            create: (_) => PronunciationMethodState()),
        ChangeNotifierProvider<RomanizationState>(
            create: (_) => RomanizationState()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Map<int, Color> blueColorMap = {
    50: blueColor,
    100: blueColor,
    200: blueColor,
    300: blueColor,
    400: blueColor,
    500: blueColor,
    600: blueColor,
    700: blueColor,
    800: blueColor,
    900: blueColor,
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final blueSwatch = MaterialColor(blueColor.value, blueColorMap);
    const headlineSmall =
        TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold);
    const titleLarge = TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold);
    const titleMedium = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
    const titleSmall = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
    const bodyLarge = TextStyle(fontSize: 22.0);
    const bodyMedium = TextStyle(fontSize: 18.0);
    const bodySmall = TextStyle(fontSize: 16.0);
    var textTheme = const TextTheme(
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
    );
    var appBarTheme = AppBarTheme.of(context).copyWith(
      backgroundColor: blueColor,
      centerTitle: true,
    );
    const textSelectionTheme = TextSelectionThemeData(
        selectionColor: greyColor,
        selectionHandleColor: greyColor,
        cursorColor: greyColor);
    var textButtonTheme = TextButtonThemeData(
        style: ButtonStyle(
      textStyle:
          MaterialStateProperty.all(bodyLarge.copyWith(color: blueColor)),
      foregroundColor: MaterialStateProperty.resolveWith((_) => blueColor),
    ));
    var elevatedButtonTheme = ElevatedButtonThemeData(
        style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(blueColor),
      textStyle:
          MaterialStateProperty.all(bodyLarge.copyWith(color: Colors.white)),
      padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 20.0, horizontal: 35.0)),
    ));
    const dividerTheme = DividerThemeData(space: 0, thickness: 1);

    var lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.light,
        accentColor: blueColor,
      ),
      primarySwatch: blueSwatch,
      primaryColor: blueColor,
      appBarTheme: appBarTheme,
      textSelectionTheme: textSelectionTheme,
      fontFamily: 'ChironHeiHK',
      textTheme: textTheme.copyWith(
          bodySmall: bodySmall.copyWith(color: darkGreyColor)),
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
      textButtonTheme: textButtonTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      dividerColor: lightGreyColor,
      dividerTheme: dividerTheme,
    );
    var darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        accentColor: lightBlueColor,
      ),
      scaffoldBackgroundColor: Colors.black,
      backgroundColor: blackColor,
      primarySwatch: blueSwatch,
      primaryColor: blueColor,
      appBarTheme: appBarTheme,
      textSelectionTheme: textSelectionTheme,
      fontFamily: 'ChironHeiHK',
      textTheme: textTheme.copyWith(
          bodySmall: bodySmall.copyWith(color: lightGreyColor)),
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
      textButtonTheme: textButtonTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      dividerColor: darkGreyColor,
      dividerTheme: dividerTheme,
    );
    return Portal(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: context.watch<LanguageState>().language?.toLocale,
      title: 'words.hk',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeResolutionCallback: (
        locale,
        supportedLocales,
      ) {
        if (locale?.languageCode == 'yue') {
          return const Locale.fromSubtags(
              languageCode: 'zh',
              scriptCode: 'Hant',
              countryCode: 'HK'); // 'zh_Hant_HK'
        } else if (supportedLocales.contains(locale)) {
          return locale;
        } else if (locale?.languageCode == 'zh') {
          if (locale?.scriptCode == 'Hant') {
            return const Locale.fromSubtags(
                languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW');
          } else {
            return const Locale.fromSubtags(
                languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN');
          }
        } else {
          return const Locale.fromSubtags(languageCode: 'en');
        }
      },
      supportedLocales: const [
        Locale.fromSubtags(
            languageCode:
                'en'), // generic English (defaults to American English)// 'yue_Hant_HK'
        Locale.fromSubtags(
            languageCode:
                'zh'), // generic Chinese 'zh' (defaults to zh_Hans_CN)
        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode:
                'Hans'), // generic simplified Chinese 'zh_Hans' (defaults to zh_Hans_CN)
        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode:
                'Hant'), // generic traditional Chinese 'zh_Hant' (defaults to zh_Hant_TW)
        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hans',
            countryCode: 'CN'), // 'zh_Hans_CN'
        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant',
            countryCode: 'TW'), // 'zh_Hant_TW'
        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant',
            countryCode: 'HK'), // 'zh_Hant_HK'
      ],
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const HomePage(title: 'words.hk'),
    ));
  }
}
