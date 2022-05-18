cd rust || exit

# Generate bridge between Flutter and Rust
flutter_rust_bridge_codegen \
--rust-input src/api.rs \
--dart-output ../lib/bridge_generated.dart \
--llvm-path /opt/homebrew/opt/llvm/ \
--c-output ../ios/Runner/bridge_generated.h

# Generate iOS binary
cargo lipo --release && cp target/universal/release/libwordshk_api.a ../ios/Runner &
# Generate Android binary
cargo ndk -o ../android/app/src/main/jniLibs build --release &
wait
