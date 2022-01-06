# wordshk

words.hk dictionary for mobile

# Build

Run flutter-code-gen:
```
cd rust && flutter_rust_bridge_codegen --rust-input src/api.rs --dart-output ../lib/bridge_generated.dart --llvm-path /usr/local/homebrew/opt/llvm/ --c-output ../ios/Runner/bridge_generated.h
```

Build rust for iOS:
```
cargo lipo && cp target/universal/debug/libwordshk_api.a ../ios/Runner
```
