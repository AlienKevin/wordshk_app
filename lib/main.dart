import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/rng.dart';
import 'package:wordshk/models/language.dart';
import 'package:wordshk/pages/about_page.dart';
import 'package:wordshk/pages/dictionary_license_page.dart';
import 'package:wordshk/pages/entry_not_published_page.dart';
import 'package:wordshk/pages/entry_page.dart';
import 'package:wordshk/pages/exercise_page.dart';
import 'package:wordshk/pages/home_page.dart';
import 'package:wordshk/pages/introduction_page.dart';
import 'package:wordshk/pages/privacy_policy_page.dart';
import 'package:wordshk/pages/quality_control_page.dart';
import 'package:wordshk/pages/settings/entry_eg_font_size_page.dart';
import 'package:wordshk/pages/settings/entry_eg_page.dart';
import 'package:wordshk/pages/settings/entry_eg_speech_rate.dart';
import 'package:wordshk/pages/settings/entry_explanation_language.dart';
import 'package:wordshk/pages/settings/entry_header_speech_rate.dart';
import 'package:wordshk/pages/settings/language_page.dart';
import 'package:wordshk/pages/settings/romanization_page.dart';
import 'package:wordshk/pages/settings/script_page.dart';
import 'package:wordshk/pages/settings/search_bar_position_page.dart';
import 'package:wordshk/pages/settings/text_size_page.dart';
import 'package:wordshk/pages/settings_page.dart';
import 'package:wordshk/pages/stories_catalog_page.dart';
import 'package:wordshk/pages/story_page.dart';
import 'package:wordshk/pages/tone_exercise_introduction_page.dart';
import 'package:wordshk/pages/tone_exercise_page.dart';
import 'package:wordshk/src/rust/api/api.dart';
import 'package:wordshk/src/rust/frb_generated.dart';
import 'package:wordshk/states/analytics_settings_state.dart';
import 'package:wordshk/states/analytics_state.dart';
import 'package:wordshk/states/auto_paste_search_state.dart';
import 'package:wordshk/states/bookmark_state.dart';
import 'package:wordshk/states/entry_eg_font_size_state.dart';
import 'package:wordshk/states/entry_eg_jumpy_prs_state.dart';
import 'package:wordshk/states/entry_item_state.dart';
import 'package:wordshk/states/entry_language_state.dart';
import 'package:wordshk/states/entry_state.dart';
import 'package:wordshk/states/exercise_introduction_state.dart';
import 'package:wordshk/states/history_state.dart';
import 'package:wordshk/states/input_mode_state.dart';
import 'package:wordshk/states/language_state.dart';
import 'package:wordshk/states/romanization_state.dart';
import 'package:wordshk/states/search_bar_position_state.dart';
import 'package:wordshk/states/search_query_state.dart';
import 'package:wordshk/states/speech_rate_state.dart';
import 'package:wordshk/utils.dart';
import 'package:wordshk/widgets/scaffold_with_bottom_navigation.dart';
import 'package:wordshk/states/text_size_state.dart';

import 'aws_service.dart';
import 'constants.dart';
import 'device_info.dart';
import 'models/embedded.dart';
import 'states/player_state.dart';

late final Future<Database> bookmarkDatabase;
late final Future<Database> historyDatabase;
late final GoRouter router;
late final ThemeData lightTheme;
late final ThemeData darkTheme;

late final bool isPhone;

final AwsService awsService = AwsService();

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final AnalyticsState analyticsState = AnalyticsState();
bool sentryEnabled = false;

FutureOr<SentryEvent?> beforeSend(SentryEvent event, Hint hint) async {
  if (sentryEnabled) {
    return event;
  } else {
    return null;
  }
}

Future<Uint8List?> getZippedDict(String dictPath) async {
  if (await File(dictPath).exists()) {
    try {
      Database db = await openDatabase(dictPath);
      final metadata = await db.query('rich_dict_metadata');
      final version = metadata.firstWhere((row) => row['key'] == 'version');
      if (version['value'] != (await PackageInfo.fromPlatform()).version) {
        debugPrint(
            "Got a newer version of dictionary database.\nReplacing the old version with the new one...");
      } else {
        // Same version, no need to replace
        return null;
      }
    } catch (e) {
      debugPrint('Error opening database: $e');
      debugPrint('Generating a new dictionary database...');
    }
  }
  final bytes = await rootBundle.load('assets/dict.db.gz');
  return Uint8List.sublistView(bytes);
}

main() async {
  // Avoid errors caused by flutter upgrade.
  WidgetsFlutterBinding.ensureInitialized();

  // Start unzipping dict
  String cacheDir = (await getApplicationCacheDirectory()).path;
  final dictPath = join(cacheDir, 'dict.db');
  final dictZip = await getZippedDict(dictPath);

  await RustLib.init();
  createLogStream().listen((msg) {
    print('[rust]: $msg');
  });

  isPhone = await getIsPhone();

  // Turn off landscape mode on phones

  if (isPhone) {
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );
  }

  return runMyApp(dictPath: dictPath, dictZip: dictZip);
}

void runMyApp(
    {required String dictPath,
    Uint8List? dictZip,
    bool? firstTimeUser,
    Language? language}) async {
  await initApi(dictPath: dictPath, dictZip: dictZip ?? Uint8List(0));

  final prefs = await SharedPreferences.getInstance();
  if (kDebugMode) {
    print("Opening database...");
  }
  bookmarkDatabase = EntryItemState.createDatabase(
      tableName: "bookmarks", databaseName: "bookmarkedEntries");
  historyDatabase = EntryItemState.createDatabase(
      tableName: "history", databaseName: "historyEntries");

  WidgetsFlutterBinding.ensureInitialized(); // mandatory when awaiting on main
  final bool firstTimeUser_ =
      firstTimeUser ?? (prefs.getBool("firstTimeUser") ?? true);

  if (language != null) {
    prefs.setInt("language", language.index);
  }

  // Set UserId if not set
  if (prefs.getString("userId") == null) {
    var uuid = const Uuid();
    var v4Crypto = uuid.v4(config: V4Options(null, CryptoRNG()));
    await prefs.setString("userId", v4Crypto);
  }

  initializeRouter(firstTimeUser_, prefs);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AnalyticsSettingsState>(
            create: (_) => AnalyticsSettingsState(prefs)),
        ChangeNotifierProvider<AutoPasteSearchState>(
            create: (_) => AutoPasteSearchState(prefs)),
        ChangeNotifierProvider<SearchQueryState>(
            create: (_) => SearchQueryState()),
        ChangeNotifierProvider<SearchBarPositionState>(
            create: (_) => SearchBarPositionState(prefs)),
        ChangeNotifierProvider<InputModeState>(create: (_) => InputModeState()),
        ChangeNotifierProvider<LanguageState>(
            create: (context) => LanguageState(prefs), lazy: false),
        ChangeNotifierProvider<TextSizeState>(
            create: (context) => TextSizeState(prefs), lazy: false),
        ChangeNotifierProvider<EntryLanguageState>(
            create: (_) => EntryLanguageState(prefs)),
        ChangeNotifierProvider<EntryEgFontSizeState>(
            create: (_) => EntryEgFontSizeState(prefs)),
        ChangeNotifierProvider<RomanizationState>(
            create: (context) => RomanizationState(prefs), lazy: false),
        ChangeNotifierProvider<EntryEgJumpyPrsState>(
            create: (_) => EntryEgJumpyPrsState(prefs)),
        ChangeNotifierProvider<PlayerState>(create: (_) => PlayerState()),
        ChangeNotifierProvider<SpeechRateState>(
            create: (_) => SpeechRateState(prefs)),
        ChangeNotifierProvider<BookmarkState>(
            create: (_) => BookmarkState(
                tableName: "bookmarks", getDatabase: () => bookmarkDatabase),
            lazy: false),
        ChangeNotifierProvider<HistoryState>(
            create: (_) => HistoryState(
                tableName: "history", getDatabase: () => historyDatabase),
            lazy: false),
        ChangeNotifierProvider<ExerciseIntroductionState>(
            create: (_) => ExerciseIntroductionState(prefs)),
        ChangeNotifierProvider<EntryState>(create: (_) => EntryState()),
      ],
      child: MyApp(firstTimeUser: firstTimeUser_, prefs: prefs),
    ),
  );
}

EntryPage entryPageBuilder(BuildContext context, GoRouterState state) {
  final entryId = int.parse(state.pathParameters['entryId']!);
  final key = state.uri.queryParameters['key'] == null
      ? null
      : int.parse(state.uri.queryParameters['key']!);
  final showFirstEntryInGroupInitially =
      state.uri.queryParameters['showFirstInGroup'] == "true";
  final defIndex = state.uri.queryParameters['defIndex'] == null
      ? null
      : int.parse(state.uri.queryParameters['defIndex']!);
  final embedded = state.uri.queryParameters['embedded'] == null
      ? Embedded.topLevel
      : Embedded.values.byName(state.uri.queryParameters['embedded']!);

  // debugPrint("Going to entry $entryId");
  // debugPrint("showFirstEntryInGroupInitially: $showFirstEntryInGroupInitially");
  // debugPrint("embedded: $embedded");
  // debugPrint("defIndex: $defIndex");

  return EntryPage(
    key: key == null ? null : ValueKey(key),
    id: entryId,
    showFirstEntryInGroupInitially: showFirstEntryInGroupInitially,
    defIndex: defIndex,
    embedded: embedded,
  );
}

Future<String> redirectZidinV(BuildContext context, GoRouterState state) async {
  if (state.uri.hasFragment) {
    final fragment = state.uri.fragment;
    if (fragment.startsWith('w')) {
      final id = fragment.substring(1);
      return '/entry/id/$id?key=$id';
    } else {
      Sentry.captureMessage(
          'Fragment ${state.uri.fragment} does not start with a w');
    }
  }
  final id = state.pathParameters['entryId'];
  return '/entry/id/$id?key=$id';
}

Future<String> redirectZidinVariant(
    BuildContext context, GoRouterState state) async {
  if (state.uri.hasFragment) {
    final fragment = state.uri.fragment;
    if (fragment.startsWith('w')) {
      final id = fragment.substring(1);
      return '/entry/id/$id?key=$id';
    } else {
      Sentry.captureMessage(
          'Fragment ${state.uri.fragment} does not start with a w');
    }
  }

  final entryVariant = state.pathParameters['entryVariant']!;
  return getEntryId(query: entryVariant, script: Script.traditional).then((id) {
    if (id == null) {
      return '/entry/not-published/$entryVariant';
    } else {
      return '/entry/id/$id?key=$id&showFirstInGroup=true';
    }
  });
}

initializeRouter(bool firstTimeUser, SharedPreferences prefs) {
  router = GoRouter(
    initialLocation: firstTimeUser ? '/introduction' : '/',
    routes: [
      GoRoute(
        path: '/introduction',
        builder: (context, state) => IntroductionPage(prefs: prefs),
      ),
      StatefulShellRoute.indexedStack(
          builder: (BuildContext context, GoRouterState state,
                  StatefulNavigationShell navigationShell) =>
              ScaffoldWithBottomNavigation(navigationShell: navigationShell),
          branches: <StatefulShellBranch>[
            StatefulShellBranch(routes: <RouteBase>[
              GoRoute(
                path: '/exercise',
                builder: (context, state) => const ExercisePage(),
                routes: [
                  GoRoute(
                    path: 'tone',
                    builder: (context, state) => const ToneExercisePage(),
                  ),
                  GoRoute(
                    path: 'tone/introduction',
                    builder: (context, state) => ToneExerciseIntroductionPage(
                        openedInExercise:
                            state.uri.queryParameters['openedInExercise'] ==
                                'true'),
                  ),
                  GoRoute(
                    path: 'stories',
                    builder: (context, state) => const StoriesCatalogPage(),
                  ),
                  GoRoute(
                    path: 'stories/:storyId',
                    builder: (context, state) {
                      final storyId =
                          int.parse(state.pathParameters['storyId']!);
                      return StoryPage(storyId: storyId);
                    },
                  ),
                ],
              ),
            ]),
            StatefulShellBranch(initialLocation: '/', routes: <RouteBase>[
              GoRoute(
                  path: '/',
                  builder: (context, state) =>
                      const HomePage(title: 'words.hk'),
                  routes: [
                    GoRoute(
                        path: 'entry/id/:entryId', builder: entryPageBuilder),
                    // Handle all variations of words.hk website entry URLs
                    // https://words.hk/zidin/v/92598	㗎 / 嘎 第#1條
                    // https://words.hk/zidin/v/92598#w100955	𠿪 / 㗎 第#3條
                    // https://words.hk/zidin/v/92598/㗎	㗎 / 嘎 第#1條
                    // https://words.hk/zidin/v/92598/㗎#w100955	𠿪 / 㗎 第#3條
                    // https://words.hk/zidin/幾	幾 第#1條
                    // https://words.hk/zidin/幾#w96806	幾 第#2條
                    GoRoute(path: 'zidin/v/:entryId', redirect: redirectZidinV),
                    GoRoute(
                        path: 'zidin/v/:entryId/:entryVariant',
                        redirect: redirectZidinV),
                    GoRoute(
                      path: 'zidin/:entryVariant',
                      redirect: redirectZidinVariant,
                    ),
                    GoRoute(
                      path: 'entry/not-published/:entryVariant',
                      builder: (context, state) => EntryNotPublishedPage(
                        entryVariant: state.pathParameters['entryVariant']!,
                      ),
                    ),
                  ])
            ]),
            StatefulShellBranch(
                initialLocation: '/settings',
                routes: <RouteBase>[
                  GoRoute(
                    path: '/about',
                    builder: (context, state) => const AboutPage(),
                  ),
                  GoRoute(
                    path: '/quality-control',
                    builder: (context, state) => const QualityControlPage(),
                  ),
                  GoRoute(
                    path: '/license',
                    builder: (context, state) => const DictionaryLicensePage(),
                  ),
                  GoRoute(
                    path: '/privacy-policy',
                    builder: (context, state) => PrivacyPolicyPage(),
                  ),
                  GoRoute(
                      path: '/settings',
                      builder: (context, state) => const SettingsPage(),
                      routes: [
                        GoRoute(
                          path: 'language',
                          builder: (context, state) =>
                              const LanguageSettingsPage(),
                        ),
                        GoRoute(
                            path: 'script',
                            builder: (context, state) =>
                                const ScriptSettingsPage()),
                        GoRoute(
                            path: 'romanization',
                            builder: (context, state) =>
                                const RomanizationSettingsPage()),
                        GoRoute(
                          path: 'text-size',
                          builder: (context, state) =>
                              const TextSizeSettingsPage(),
                        ),
                        GoRoute(
                          path: 'entry/definition/language',
                          builder: (context, state) =>
                              const EntryExplanationLanguageSettingsPage(),
                        ),
                        GoRoute(
                          path: 'entry/header/speech-rate',
                          builder: (context, state) =>
                              const EntryHeaderSpeechRateSettingsPage(),
                        ),
                        GoRoute(
                          path: 'entry/example',
                          builder: (context, state) =>
                              const EntryEgSettingsPage(),
                        ),
                        GoRoute(
                          path: 'entry/example/speech-rate',
                          builder: (context, state) =>
                              const EntryEgSpeechRateSettingsPage(),
                        ),
                        GoRoute(
                          path: 'entry/example/font-size',
                          builder: (context, state) =>
                              const EntryEgFontSizeSettingsPage(),
                        ),
                        GoRoute(
                          path: 'search-bar-position',
                          builder: (context, state) =>
                              const SearchBarPositionSettingsPage(),
                        ),
                      ]),
                ]),
          ])
    ],
    observers: [SentryNavigatorObserver()],
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

  @override
  void initState() {
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
    appBarTheme(Brightness brightness) => AppBarTheme.of(context).copyWith(
          backgroundColor:
              brightness == Brightness.light ? lightGreyColor : null,
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
          foregroundColor: MaterialStateProperty.all(Colors.white),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 35.0)),
        ));
    dividerColor(Brightness brightness) =>
        brightness == Brightness.light ? lightGreyColor : darkGreyColor;
    dividerTheme(Brightness brightness) => DividerThemeData(
        space: 0, thickness: 1, color: dividerColor(brightness));
    switchTheme(Brightness brightness) => SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith((states) {
            // On Android, the switch is invisible when not selected (because
            // it has the same color as the background), so we need to return
            // a different color for the thumb.
            if (Platform.isAndroid &&
                brightness == Brightness.light &&
                states.isEmpty) {
              return lightGreyColor;
            }
            return null; // Use default color for all other states
          }),
        );

    const lightThemeAccentColor = blueColor;
    const darkThemeAccentColor = lightBlueColor;

    lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        accentColor: lightThemeAccentColor,
      ),
      primarySwatch: blueSwatch,
      primaryColor: blueColor,
      appBarTheme: appBarTheme(Brightness.light),
      textSelectionTheme: textSelectionTheme(Brightness.light),
      fontFamily: 'ChironHeiHK',
      textTheme: textTheme.copyWith(
          bodySmall: bodySmall.copyWith(color: darkGreyColor)),
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
      textButtonTheme: textButtonTheme(Brightness.light),
      elevatedButtonTheme: elevatedButtonTheme(Brightness.light),
      dividerColor: dividerColor(Brightness.light),
      dividerTheme: dividerTheme(Brightness.light),
      switchTheme: switchTheme(Brightness.light),
    );
    darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        accentColor: lightBlueColor,
        backgroundColor: darkThemeAccentColor,
      ),
      scaffoldBackgroundColor: Colors.black,
      primarySwatch: blueSwatch,
      primaryColor: blueColor,
      canvasColor: Colors.black,
      appBarTheme: appBarTheme(Brightness.dark),
      textSelectionTheme: textSelectionTheme(Brightness.dark),
      fontFamily: 'ChironHeiHK',
      textTheme: textTheme.copyWith(
          bodySmall: bodySmall.copyWith(color: lightGreyColor)),
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
      textButtonTheme: textButtonTheme(Brightness.dark),
      elevatedButtonTheme: elevatedButtonTheme(Brightness.dark),
      dividerColor: dividerColor(Brightness.dark),
      dividerTheme: dividerTheme(Brightness.dark),
      switchTheme: switchTheme(Brightness.dark),
    );

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FGBGNotifier(
      onEvent: (event) async {
        if (event == FGBGType.background &&
            context.read<AnalyticsSettingsState>().enabled == true) {
          final language = context.read<LanguageState>().language;
          final romanization =
              context.read<RomanizationState>().romanization.name;
          final textSize = context.read<TextSizeState>().textSize;
          final egJumpyPrs = context.read<EntryEgJumpyPrsState>().isJumpy;
          final numBookmarks = context.read<BookmarkState>().items.length;
          final numHistory = context.read<HistoryState>().items.length;
          final entryEgFontSize = context.read<EntryEgFontSizeState>().size;

          final prefs = await SharedPreferences.getInstance();
          final lastSyncTime = prefs.getString("analyticsSyncTime");
          final timeNow = DateTime.now().toUtc();
          final timeNowString = timeNow.toIso8601String();
          if (/*kReleaseMode &&*/
              lastSyncTime != null &&
                  timeNow.difference(DateTime.parse(lastSyncTime)).inHours <
                      12) {
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
            "textSize": textSize,
            "romanization": romanization,
            "egJumpyPrs": egJumpyPrs,
            "numBookmarks": numBookmarks,
            "numHistory": numHistory,
            "entryEgFontSize": entryEgFontSize,
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
      child: Portal(child: Builder(builder: (context) {
        // Get the current text scale factor from your TextSizeState
        final textSize = context.watch<TextSizeState>().textSize;

        return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: textSize == null
                  ? null
                  : TextScaler.linear(textSize.toDouble() / 100),
            ),
            child: MaterialApp.router(
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
                    return context
                        .read<LanguageState>()
                        .initLanguage(Language.en);
                  } else if (locale.languageCode == 'yue') {
                    return context
                        .read<LanguageState>()
                        .initLanguage(Language.yue);
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
                    scriptCode:
                        'Hant'), // generic traditional Chinese 'zh_Hant'
              ],
              theme: lightTheme,
              darkTheme: darkTheme,
              routerConfig: router,
            ));
      })),
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
