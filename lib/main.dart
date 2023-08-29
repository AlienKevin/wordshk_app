import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordshk/pages/home_page.dart';
import 'package:wordshk/pages/introduction_page.dart';
import 'package:wordshk/states/entry_eg_font_size_state.dart';
import 'package:wordshk/states/entry_eg_jumpy_prs_state.dart';
import 'package:wordshk/states/entry_language_state.dart';
import 'package:wordshk/states/input_mode_state.dart';
import 'package:wordshk/states/language_state.dart';
import 'package:wordshk/states/pronunciation_method_state.dart';
import 'package:wordshk/states/romanization_state.dart';
import 'package:wordshk/states/search_mode_state.dart';
import 'package:wordshk/states/search_query_state.dart';
import 'package:wordshk/states/speech_rate_state.dart';

import 'constants.dart';
import 'states/player_state.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized(); // mandatory when awaiting on main
  final prefs = await SharedPreferences.getInstance();
  final bool firstTimeUser = prefs.getBool("firstTimeUser") ?? true;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SearchModeState>(
            create: (_) => SearchModeState()),
        ChangeNotifierProvider<SearchQueryState>(
            create: (_) => SearchQueryState()),
        ChangeNotifierProvider<InputModeState>(create: (_) => InputModeState()),
        ChangeNotifierProvider<LanguageState>(
            create: (context) => LanguageState(prefs, context), lazy: false),
        ChangeNotifierProvider<EntryLanguageState>(
            create: (_) => EntryLanguageState(prefs)),
        ChangeNotifierProvider<PronunciationMethodState>(
            create: (_) => PronunciationMethodState(prefs)),
        ChangeNotifierProvider<EntryEgFontSizeState>(
            create: (_) => EntryEgFontSizeState(prefs)),
        ChangeNotifierProvider<RomanizationState>(
            create: (_) => RomanizationState(prefs), lazy: false),
        ChangeNotifierProvider<EntryEgJumpyPrsState>(
            create: (_) => EntryEgJumpyPrsState(prefs)),
        ChangeNotifierProvider<PlayerState>(create: (_) => PlayerState()),
        ChangeNotifierProvider<SpeechRateState>(
            create: (_) => SpeechRateState()),
      ],
      child: MyApp(firstTimeUser: firstTimeUser, prefs: prefs),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool firstTimeUser;
  final SharedPreferences prefs;

  const MyApp({Key? key, required this.firstTimeUser, required this.prefs})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    accentColor(Brightness brightness) =>
        brightness == Brightness.light ? blueColor : lightBlueColor;
    const headlineLarge =
        TextStyle(fontSize: 46.0, fontWeight: FontWeight.w600);
    const headlineMedium =
        TextStyle(fontSize: 36.0, fontWeight: FontWeight.w600);
    const headlineSmall =
        TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600);
    const titleLarge = TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600);
    const titleMedium = TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600);
    const titleSmall = TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600);
    const bodyLarge = TextStyle(fontSize: 22.0);
    const bodyMedium = TextStyle(fontSize: 18.0);
    const bodySmall = TextStyle(fontSize: 16.0);
    var textTheme = const TextTheme(
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
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
    textSelectionTheme(Brightness brightness) => TextSelectionThemeData(
        selectionColor: lightBlueColor.withAlpha(50),
        selectionHandleColor:
            brightness == Brightness.light ? blueColor : lightBlueColor,
        cursorColor:
            brightness == Brightness.light ? blueColor : lightBlueColor);
    textButtonTheme(Brightness brightness) => TextButtonThemeData(
            style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
              bodyLarge.copyWith(color: accentColor(brightness))),
          foregroundColor:
              MaterialStateProperty.resolveWith((_) => accentColor(brightness)),
        ));
    elevatedButtonTheme(Brightness brightness) => ElevatedButtonThemeData(
            style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(accentColor(brightness)),
          textStyle: MaterialStateProperty.all(
              bodyLarge.copyWith(color: Colors.white)),
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
      textSelectionTheme: textSelectionTheme(Brightness.light),
      fontFamily: 'ChironHeiHK',
      textTheme: textTheme.copyWith(
          bodySmall: bodySmall.copyWith(color: darkGreyColor)),
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
      textButtonTheme: textButtonTheme(Brightness.light),
      elevatedButtonTheme: elevatedButtonTheme(Brightness.light),
      dividerColor: lightGreyColor,
      dividerTheme: dividerTheme,
    );
    var darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        accentColor: lightBlueColor,
        backgroundColor: blackColor,
      ),
      scaffoldBackgroundColor: Colors.black,
      primarySwatch: blueSwatch,
      primaryColor: blueColor,
      appBarTheme: appBarTheme,
      textSelectionTheme: textSelectionTheme(Brightness.dark),
      fontFamily: 'ChironHeiHK',
      textTheme: textTheme.copyWith(
          bodySmall: bodySmall.copyWith(color: lightGreyColor)),
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
      textButtonTheme: textButtonTheme(Brightness.dark),
      elevatedButtonTheme: elevatedButtonTheme(Brightness.dark),
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
        late final Locale resolvedLocale;
        if (locale?.languageCode == 'yue') {
          resolvedLocale = const Locale.fromSubtags(
              languageCode: 'zh',
              scriptCode: 'Hant',
              countryCode: 'HK'); // 'zh_Hant_HK'
        } else if (locale != null && supportedLocales.contains(locale)) {
          resolvedLocale = locale;
        } else if (locale?.languageCode == 'zh') {
          if (locale?.scriptCode == 'Hant') {
            resolvedLocale = const Locale.fromSubtags(
                languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW');
          } else {
            resolvedLocale = const Locale.fromSubtags(
                languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN');
          }
        } else {
          resolvedLocale = const Locale.fromSubtags(languageCode: 'en');
        }
        context.read<LanguageState>().syncLocale(resolvedLocale);
        return resolvedLocale;
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
      // home: const HomePage(title: 'words.hk'),
      home: widget.firstTimeUser
          ? IntroductionPage(prefs: widget.prefs)
          : const HomePage(title: "words.hk"),
    ));
  }
}
