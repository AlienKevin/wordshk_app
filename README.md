# wordshk

words.hk dictionary for mobile

# Build

In your `Cargo.toml`, ensure the following `crate-type` is present:

```
[lib]
crate-type = ["staticlib", "cdylib"] # "staticlib" for iOS, "cdylib" for Android
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
- [ ] Customize keyboard bar for iOS and Android using https://pub.dev/packages/keyboard_actions
- [ ] Cut off audio when switching audio or exiting page
- [ ] Add Yale romanization support
- [ ] Convert traditional characters in links of eng explanation to simplified

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
