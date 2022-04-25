# wordshk

words.hk dictionary for mobile

# Build

In your `Cargo.toml`, ensure the following `crate-type` is present:
```
[lib]
crate-type = ["lib", "staticlib", "cdylib"]
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

Build rust for iOS:
```
cargo lipo && cp target/universal/debug/libwordshk_api.a ../ios/Runner
```

Build rust for Android:
```
export ANDROID_NDK_HOME=~/Library/Android/sdk
export OPENSSL_DIR=/opt/homebrew/opt/openssl@3
cargo ndk -o ../android/app/src/main/jniLibs build
```

The toolchains folder may only be installed under `~/Library/Android/sdk/ndk-bundle/toolchains/`
but not `~/Library/Android/sdk/toolchains/`. In this case, you can run the following commands to copy
the `toolchains` folder:
```
cd ~/Library/Android/sdk
cp -r ndk-bundle/toolchains toolchains
```