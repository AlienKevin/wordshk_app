# wordshk

words.hk dictionary for Android and iOS

<img alt='wordshk app logo' src='assets/icon.png' style='width: 150px'>

# Download

<a href="https://apps.apple.com/us/app/words-hk-%E7%B2%B5%E5%85%B8/id1621976909?itsct=apps_box_badge&amp;itscg=30200" style="display: inline-block; overflow: hidden; border-radius: 13px; width: 180px"><img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83&amp;releaseDate=1657756800&h=1600d970c262d2b70ad557b308a2154b" alt="Download on the App Store" style="border-radius: 13px; width: 200px; height: 95px;"></a>
<a href='https://play.google.com/store/apps/details?id=hk.words.wordshk&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png' height="80"/></a>
<a href="https://f-droid.org/repository/browse/?fdid=hk.words.wordshk"><img alt="Get it on F-Droid" height="80" src="https://f-droid.org/badge/get-it-on.png"/></a>

# Build

In your `Cargo.toml`, ensure the following `crate-type` is present:

```
[lib]
crate-type = ["staticlib", "cdylib"] # "staticlib" for iOS, "cdylib" for Android
```

We use the SMTP protocol to anonymously report bugs to the developers. If you wish to
receive bug reports via email, add `lib/smtp_credentials.dart` with the following variables:

```dart
String host = 'YOUR SMTP HOST'; // eg: 'smtp.mailgun.org'
String username =
    'YOUR SMTP USERNAME'; // eg: 'postmaster@sandbox.mailgun.org';
String password = 'YOUR SMTP PASSWORD';
String recipient = 'YOUR DEVELOPER EMAIL ADDRESS'; // eg: 'wordshk@gmail.com'
```

If you are not interested in the bug reports, add `lib/smtp_credentials.dart` with
following content:

```dart
String host = ''; // This turns off SMTP bug reporting
```

Give the build script execution permission:

```bash
chmod +x ./build_rust.sh
```

Run the build script to build Rust for Android and iOS:

```bash
./build_rust.sh
```

# How Does the Build Script Work?

## flutter_rust_bridge

The build script first generate a glue code that bridges Rust and Dart code using flutter_rust_bridge.

## iOS

The build script then generate a release version of the iOS binary:

```
cargo lipo --release && cp target/universal/debug/libwordshk_api.a ../ios/Runner
```

If the release build is too slow, you can replace the above line in the build script with
this instruction for running a debug build:

```
cargo lipo && cp target/universal/debug/libwordshk_api.a ../ios/Runner
```

## Android

The build script then generate a release version of the Android binary.

```
cargo ndk -o ../android/app/src/main/jniLibs build --release
```

If the release build is too slow, you can replace the above line in the build script with
this instruction for running a debug build:

```
cargo ndk -o ../android/app/src/main/jniLibs build
```

See [this tutorial](https://cjycode.com/flutter_rust_bridge/template/setup_android.html) to set up Android.

# Generate App Store images

Run snapshot:

```
bundle exec fastlane snapshot --configuration "Release" --stop_after_first_error
```

Reset all simulators in case of errors during snapshot:

```
bundle exec fastlane fastlane snapshot reset_simulators
```

# Normalize jyutping syllable audios

1. Open Adobe Audition, run the "Match Loudness" with these settings:
   
   * ITU-R BS.1770-3 Loudness
   * Target Loudness: -16 LUFS
   * Tolerance: 2 LU
   * Max True Peak Level: -2 dBTP
   * Look-ahead Time: 12ms
   * Release Time: 200ms

2. Export the files with matched loudness
   With export settings as follows:
   
   * Format MP3
   * Sample Type: Same as source
   * Format settings: MP3 24 Kbps CBR (Constant type)

3. Change directory into `assets/jyutping_female` or `assets/jyutping_male`.

4. Run `process_audios.sh`. This script does three things:
   
   1. Trim silence at the beginning and end of all mp3 files
   2. Pad the end of jap6sing1 syllables so they are not too short
   3. Peak normalize jap6sing1 syllables to make they as loud as other syllables

# TODO

- [ ] Show jyutping help before search or suggestions for fix during search
- [ ] Add spell checker suggestion to english search
- [x] Use word match percent instead of direct lookup for phrases with >1 words
- [ ] Test multi-language support for entries
- [ ] Add auto language detection for searches
- [x] Show possible jyutping when search result is not found.
- [x] Offer option to show entries in simplified
- [ ] Wait for fast2s to merge my 乾/干 PR and update to use the new version
- [ ] Make text selection in entries smoother
- [ ] Fix ruby positioning in Entry M/jam's <eg>: "好M唔M，M套？"
- [x] Customize keyboard bar for iOS and Android using https://pub.dev/packages/keyboard_actions
- [ ] Cut off audio when switching audio or exiting page
- [ ] Add Yale romanization support
- [ ] Convert traditional characters in links of eng explanation to simplified
- [x] Convert traditional characters in result not found to simplified

# Legal

Software: Copyright (C) 2022 Xiang Li, licensed under the MIT license.
Dictionary: Copyright (C) 2014-2022 Hong Kong Lexicography Limited.

"*words.hk*", "*wordshk*", "*粵典*" are trade names of Hong Kong Lexicography
Limited. Permission by Hong Kong Lexicography Limited must be obtained to
promote or distribute materials containing these names. In particular,
notwithstanding any permission (if applicable) to redistribute the source code
of this project and/or its derivative works by the copyright owner(s), unless
you obtain explicit permission from Hong Kong Lexicography Limited, you are
required to remove all mentions of "*words.hk*", "*wordshk*", "*粵典*" from
your redistributions.

The dictionary contents published by words.hk is copyrighted by Hong Kong
Lexicography Limited. You may be eligible to obtain a license from
https://words.hk/base/hoifong/
