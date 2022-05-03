import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wordshk/search_results_page.dart';

import 'bridge_generated.dart';
import 'constants.dart';
import 'custom_page_route.dart';

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
    const bodyLarge = TextStyle(fontSize: 28.0);
    const bodyMedium = TextStyle(fontSize: 20.0);
    const bodySmall = TextStyle(fontSize: 18.0);
    return MaterialApp(
      title: 'words.hk',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: blueSwatch,
        primaryColor: blueColor,
        fontFamily: 'ChironHeiHK',
        textTheme: const TextTheme(
          headlineSmall: headlineSmall,
          bodyLarge: bodyLarge,
          bodyMedium: bodyMedium,
          bodySmall: bodySmall,
        ),
        iconTheme: Theme.of(context)
            .iconTheme
            .copyWith(color: Theme.of(context).canvasColor),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
          textStyle:
              MaterialStateProperty.all(bodyLarge.copyWith(color: blueColor)),
          foregroundColor: MaterialStateProperty.resolveWith((_) => blueColor),
        )),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
              bodyLarge.copyWith(color: Colors.white)),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 35.0)),
        )),
      ),
      home: const MyHomePage(title: 'words.hk home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    return Scaffold(
      appBar: AppBar(title: const Text('words.hk')),
      drawer: SizedBox(
        width: 250,
        child: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "words.hk",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).canvasColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          height: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .fontSize! /
                              2),
                      Text(
                        'Crowd-sourced Cantonese dictionary for everyone.',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Theme.of(context).canvasColor),
                      )
                    ]),
              ),
              TextButton.icon(
                icon: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(Icons.search)),
                label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Dictionary',
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
                onPressed: () {
                  // Update the state of the app

                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body:
          // TODO: Show search history
          Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: AppBar().preferredSize.height * 1.5),
          child: Column(
            children: [
              Image(
                  width: MediaQuery.of(context).size.width * 0.7,
                  image: const AssetImage('assets/logo_wide.png')),
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
