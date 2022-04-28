# wordshk

words.hk dictionary for mobile

# Build

In your `Cargo.toml`, ensure the following `crate-type` is present:
```
[lib]
crate-type = ["staticlib", "cdylib"] # "staticlib" for iOS, "cdylib" for Android
```

Run flutter-code-gen:
```
cd rust && \
flutter_rust_bridge_codegen \
--rust-input src/api.rs \
--dart-output ../lib/bridge_generated.dart \
--llvm-path /usr/local/homebrew/opt/llvm/ \
--c-output ../ios/Runner/bridge_generated.h
```

## iOS

Build rust for iOS:
```
cargo lipo && cp target/universal/debug/libwordshk_api.a ../ios/Runner
```

## Android
See [this tutorial](https://cjycode.com/flutter_rust_bridge/template/setup_android.html) to set up Android.

Build rust for Android:
```
cargo ndk -o ../android/app/src/main/jniLibs build
```
