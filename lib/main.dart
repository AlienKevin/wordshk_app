import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wordshk/search_results_page.dart';

import 'bridge_generated.dart';
import 'constants.dart';
import 'custom_page_route.dart';
import 'navigation_drawer.dart';

enum SearchMode {
  pr,
  variant,
  combined,
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = Set();
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
  runApp(MyApp());
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
        TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold);
    const titleLarge = TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold);
    const titleMedium = TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
    const titleSmall = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
    const bodyLarge = TextStyle(fontSize: 24.0);
    const bodyMedium = TextStyle(fontSize: 20.0);
    const bodySmall = TextStyle(fontSize: 16.0);
    var textTheme = const TextTheme(
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
    );
    var appBarTheme = AppBarTheme.of(context).copyWith(
      backgroundColor: blueColor,
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
        textTheme: textTheme,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
        textButtonTheme: textButtonTheme,
        elevatedButtonTheme: elevatedButtonTheme,
        dividerTheme: dividerTheme.copyWith(color: lightGreyColor));
    var darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        accentColor: blueColor,
      ),
      scaffoldBackgroundColor: Colors.black,
      backgroundColor: blackColor,
      primarySwatch: blueSwatch,
      primaryColor: blueColor,
      appBarTheme: appBarTheme,
      textSelectionTheme: textSelectionTheme,
      fontFamily: 'ChironHeiHK',
      textTheme: textTheme,
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
      textButtonTheme: textButtonTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      dividerTheme: dividerTheme.copyWith(color: darkGreyColor),
    );
    return MaterialApp(
      title: 'words.hk',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const HomePage(title: 'words.hk'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SearchMode searchMode = SearchMode.combined;

  @override
  void initState() {
    super.initState();
    DefaultAssetBundle.of(context).loadString("assets/api.json").then((json) {
      api.initApi(json: json);
    });
  }

  @override
  Widget build(BuildContext context) {
    var icon_wide = Image(
        width: MediaQuery.of(context).size.width * 0.7,
        image: const AssetImage('assets/icon_wide.png'));

    return Scaffold(
      appBar: AppBar(title: const Text('words.hk')),
      drawer: const NavigationDrawer(),
      body:
          // TODO: Show search history
          Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: AppBar().preferredSize.height * 1.5),
          child: Column(
            children: [
              MediaQuery.of(context).platformBrightness == Brightness.light
                  ? icon_wide
                  : ColorFiltered(
                      colorFilter: const ColorFilter.matrix([
                        // source: https://www.burkharts.net/apps/blog/over-the-rainbow-colour-filters/
                        // Inverter matrix
                        //R G  B  A  Const
                        -1, 0, 0, 0, 255,
                        0, -1, 0, 0, 255,
                        0, 0, -1, 0, 255,
                        0, 0, 0, 1, 0,
                      ]),
                      child: icon_wide),
              SizedBox(
                  height:
                      Theme.of(context).textTheme.bodyLarge!.fontSize! * 1.5),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CustomPageRoute(
                          builder: (context) =>
                              SearchResultsPage(searchMode: searchMode)),
                    );
                  },
                  child: const Text("Search")),
            ],
          ),
        ),
      ),
    );
  }
}
