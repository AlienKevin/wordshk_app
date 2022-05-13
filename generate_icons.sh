#!/bin/bash

convert assets/icon_512.png -negate assets/icon_512_dark.png
pngquant assets/icon_512.png --force --quality 65-80 --output assets/icon_512.png
pngquant assets/icon_512_dark.png --force --quality 65-80 --output assets/icon_512_dark.png

### Clean and rebuild flutter ###
flutter clean
flutter pub get

### Generate iOS and Android icons ###
flutter pub run flutter_launcher_icons:main -f pubspec.yaml

#### Generate splash screen for Android, and iOS ###
flutter pub run flutter_native_splash:create
