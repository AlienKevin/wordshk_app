import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:wordshk/models/language.dart';
import 'package:wordshk/pages/home_page.dart';
import 'package:wordshk/pages/introduction_page.dart';
import 'package:wordshk/sentry_dsn.dart';
import 'package:wordshk/src/rust/api/api.dart';
import 'package:wordshk/src/rust/frb_generated.dart';
import 'package:wordshk/states/analytics_settings_state.dart';
import 'package:wordshk/states/analytics_state.dart';
import 'package:wordshk/states/bookmark_state.dart';
import 'package:wordshk/states/entry_eg_font_size_state.dart';
import 'package:wordshk/states/entry_eg_jumpy_prs_state.dart';
import 'package:wordshk/states/entry_item_state.dart';
import 'package:wordshk/states/entry_language_state.dart';
import 'package:wordshk/states/exercise_introduction_state.dart';
import 'package:wordshk/states/history_state.dart';
import 'package:wordshk/states/input_mode_state.dart';
import 'package:wordshk/states/language_state.dart';
import 'package:wordshk/states/pronunciation_method_state.dart';
import 'package:wordshk/states/romanization_state.dart';
import 'package:wordshk/states/search_mode_state.dart';
import 'package:wordshk/states/search_query_state.dart';
import 'package:wordshk/states/speech_rate_state.dart';
import 'package:wordshk/states/spotlight_indexing_state.dart';

import 'aws_service.dart';
import 'constants.dart';
import 'device_info.dart';
import 'states/player_state.dart';

late final Future<Database> bookmarkDatabase;
late final Future<Database> historyDatabase;

final AwsService awsService = AwsService();

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final AnalyticsState analyticsState = AnalyticsState();
bool sentryEnabled = true;

class CustomSentryEventProcessor implements EventProcessor {
  @override
  FutureOr<SentryEvent?> apply(SentryEvent event, {dynamic hint}) {
    if (sentryEnabled) {
      return event;
    }
    // Returning null will discard the event, effectively stopping reporting
    return null;
  }
}

main() async {
  await RustLib.init();
  createLogStream().listen((msg) {
    print('[rust]: $msg');
  });

  // Avoid errors caused by flutter upgrade.
  WidgetsFlutterBinding.ensureInitialized();

  await SentryFlutter.init((options) {
    options.dsn = sentryDsn;
    // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
    // We recommend adjusting this value in production.
    options.tracesSampleRate = 0;
    options.addEventProcessor(CustomSentryEventProcessor());
  }, appRunner: runMyApp);
}

runMyApp({bool? firstTimeUser, Language? language}) async {
  try {
    // Asynchronously initialize api
    initApi();

    final prefs = await SharedPreferences.getInstance();
    if (kDebugMode) {
      print("Opening database...");
    }
    bookmarkDatabase = EntryItemState.createDatabase(
        tableName: "bookmarks", databaseName: "bookmarkedEntries");
    historyDatabase = EntryItemState.createDatabase(
        tableName: "history", databaseName: "historyEntries");

    WidgetsFlutterBinding
        .ensureInitialized(); // mandatory when awaiting on main
    final bool firstTimeUser_ = firstTimeUser ?? (prefs.getBool("firstTimeUser") ?? true);

    if (language != null) {
      prefs.setInt("language", language.index);
    }

    // Set UserId if not set
    if (prefs.getString("userId") == null) {
      var uuid = const Uuid();
      var v4Crypto = uuid.v4(options: {'rng': UuidUtil.cryptoRNG});
      await prefs.setString("userId", v4Crypto);
    }

    // Initialize AWS service
    await awsService.init();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AnalyticsSettingsState>(create: (_) => AnalyticsSettingsState(prefs)),
          ChangeNotifierProvider<SpotlightIndexingState>(
              create: (_) => SpotlightIndexingState(prefs)),
          ChangeNotifierProvider<SearchModeState>(
              create: (_) => SearchModeState()),
          ChangeNotifierProvider<SearchQueryState>(
              create: (_) => SearchQueryState()),
          ChangeNotifierProvider<InputModeState>(
              create: (_) => InputModeState()),
          ChangeNotifierProvider<LanguageState>(
              create: (context) => LanguageState(
                  prefs,
                  Provider.of<SpotlightIndexingState>(context,
                      listen: false)),
              lazy: false),
          ChangeNotifierProvider<EntryLanguageState>(
              create: (_) => EntryLanguageState(prefs)),
          ChangeNotifierProvider<PronunciationMethodState>(
              create: (_) => PronunciationMethodState(prefs)),
          ChangeNotifierProvider<EntryEgFontSizeState>(
              create: (_) => EntryEgFontSizeState(prefs)),
          ChangeNotifierProvider<RomanizationState>(
              create: (context) => RomanizationState(
                  prefs,
                  Provider.of<SpotlightIndexingState>(context,
                      listen: false)),
              lazy: false),
          ChangeNotifierProvider<EntryEgJumpyPrsState>(
              create: (_) => EntryEgJumpyPrsState(prefs)),
          ChangeNotifierProvider<PlayerState>(create: (_) => PlayerState()),
          ChangeNotifierProvider<SpeechRateState>(
              create: (_) => SpeechRateState(prefs)),
          ChangeNotifierProvider<BookmarkState>(
              create: (_) => BookmarkState(
                  tableName: "bookmarks",
                  getDatabase: () => bookmarkDatabase),
              lazy: false),
          ChangeNotifierProvider<HistoryState>(
              create: (_) => HistoryState(
                  tableName: "history", getDatabase: () => historyDatabase),
              lazy: false),
          ChangeNotifierProvider<ExerciseIntroductionState>(
              create: (_) => ExerciseIntroductionState(prefs))
        ],
        child: MyApp(firstTimeUser: firstTimeUser_, prefs: prefs),
      ),
    );
  } catch (exception, stackTrace) {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
  }
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
          backgroundColor: MaterialStateProperty.all(blueColor),
          textStyle: MaterialStateProperty.all(
              bodyLarge.copyWith(color: Colors.white)),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 35.0)),
        ));
    const dividerTheme = DividerThemeData(space: 0, thickness: 1);

    const lightThemeAccentColor = blueColor;
    const darkThemeAccentColor = lightBlueColor;

    var lightTheme = ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.light,
        accentColor: lightThemeAccentColor,
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
      useMaterial3: false,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        accentColor: lightBlueColor,
        backgroundColor: darkThemeAccentColor,
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
    return FGBGNotifier(
        onEvent: (event) async {
          if (event == FGBGType.background && context.read<AnalyticsSettingsState>().enabled) {
            final language = context.read<LanguageState>().language;
            final romanization = context.read<RomanizationState>().romanization.name;
            final egJumpyPrs = context.read<EntryEgJumpyPrsState>().isJumpy;
            final numBookmarks = context.read<BookmarkState>().items.length;
            final numHistory = context.read<HistoryState>().items.length;
            final entryEgPrMethod = context.read<PronunciationMethodState>().entryEgMethod;
            final entryEgFontSize = context.read<EntryEgFontSizeState>().size;
            final spotlightEnabled = context.read<SpotlightIndexingState>().enabled;

            final prefs = await SharedPreferences.getInstance();
            final lastSyncTime = prefs.getString("analyticsSyncTime");
            final timeNow = DateTime.now().toUtc();
            final timeNowString = timeNow.toIso8601String();
            if (kReleaseMode && lastSyncTime != null &&
                timeNow.difference(DateTime.parse(lastSyncTime)).inHours < 12) {
              return;
            }
            Map<String, dynamic> message = {
              // Use a fixed UserId for debugging
              "UserId": kDebugMode
                  ? "f16dfa0a-f7b2-4f13-bb33-676e09788819"
                  : prefs.getString("userId")!,
              "Timestamp": timeNowString,
              "deviceInfo": await getDeviceInfo(),
              "language": language,
              "romanization": romanization,
              "egJumpyPrs": egJumpyPrs,
              "numBookmarks": numBookmarks,
              "numHistory": numHistory,
              "entryEgPrMethod": entryEgPrMethod,
              "entryEgFontSize": entryEgFontSize,
              "spotlightEnabled": spotlightEnabled,
              ...analyticsState.toJson(),
            };
            final ok = await awsService.sendMessage(jsonEncode(message));
            if (ok) {
              // Clear analytics state if successfully sent
              analyticsState.clear();
              prefs.setString("analyticsSyncTime", timeNowString);
            }
          }
        },
        child: Portal(
        child: MaterialApp(
            scaffoldMessengerKey: scaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            locale: context.watch<LanguageState>().language?.toLocale,
            title: 'words.hk',
            localizationsDelegates: const [
              ...AppLocalizations.localizationsDelegates,
              MaterialLocalizationYueDelegate(),
              CupertinoLocalizationYueDelegate(),
            ],
            localeListResolutionCallback: (
              locales,
              supportedLocales,
            ) {
              if (kDebugMode) {
                print("Detected locales: $locales");
              }
              for (final locale in locales ?? []) {
                if (locale.languageCode == 'en') {
                  return context.read<LanguageState>().initLanguage(Language.en);
                } else if (locale.languageCode == 'yue') {
                  return context.read<LanguageState>().initLanguage(Language.yue);
                } else if (locale.languageCode == 'zh') {
                  if (locale.scriptCode == 'Hant') {
                    return context
                        .read<LanguageState>()
                        .initLanguage(Language.zhHant);
                  } else {
                    return context
                        .read<LanguageState>()
                        .initLanguage(Language.zhHans);
                  }
                }
              }
              // fallback to English
              return Language.en.toLocale;
            },
            supportedLocales: const [
              Locale.fromSubtags(
                  languageCode:
                      'en'), // generic English (defaults to American English)
              Locale.fromSubtags(
                  languageCode:
                      'yue'), // generic Cantonese 'yue' (traditional script)
              Locale.fromSubtags(
                  languageCode:
                      'zh'), // generic Chinese 'zh' (defaults to zh_Hans)
              Locale.fromSubtags(
                  languageCode: 'zh',
                  scriptCode: 'Hans'), // generic simplified Chinese 'zh_Hans'
              Locale.fromSubtags(
                  languageCode: 'zh',
                  scriptCode: 'Hant'), // generic traditional Chinese 'zh_Hant'
            ],
            theme: lightTheme,
            darkTheme: darkTheme,
            // home: const HomePage(title: 'words.hk'),
            home: widget.firstTimeUser
                ? IntroductionPage(prefs: widget.prefs)
                : const HomePage(title: "words.hk")),
      ),
    );
  }
}

class MaterialLocalizationYueDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const MaterialLocalizationYueDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'yue';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    // Here we load the 'zh_Hant_HK' locale instead.
    return await GlobalMaterialLocalizations.delegate
        .load(const Locale('zh', 'HK'));
  }

  @override
  bool shouldReload(MaterialLocalizationYueDelegate old) => false;
}

class CupertinoLocalizationYueDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const CupertinoLocalizationYueDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'yue';

  @override
  Future<CupertinoLocalizations> load(Locale locale) async {
    // Here we load the 'zh_Hant_HK' locale instead.
    return await DefaultCupertinoLocalizations.delegate
        .load(const Locale('zh', 'HK'));
  }

  @override
  bool shouldReload(CupertinoLocalizationYueDelegate old) => false;
}
