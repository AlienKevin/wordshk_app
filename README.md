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

# TODO
1. Handle prs starting with !
2. Entry hi-fi ruby rendering is broken, need to use RUBY_TEXT_IGNORE instead

# Legal

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
