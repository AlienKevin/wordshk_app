#!/bin/bash

pngquant assets/icon_512.png --force --quality 65-80 --output assets/icon_512.png

### Clean and rebuild flutter ###
flutter clean
flutter pub get

### Generate iOS and Android icons ###
flutter pub run flutter_launcher_icons:main -f pubspec.yaml

#### Generate splash screen for Android, and iOS ###
flutter pub run flutter_native_splash:create
