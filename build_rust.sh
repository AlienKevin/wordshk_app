cd rust || exit

# Install in case cargo.toml is changed
cargo install

# Generate iOS binary
cargo lipo --release && cp target/universal/debug/libwordshk_api.a ../ios/Runner &
# Generate Android binary
cargo ndk -o ../android/app/src/main/jniLibs build &
wait

# Generate bridge between Flutter and Rust
flutter_rust_bridge_codegen \
--rust-input src/api.rs \
--dart-output ../lib/bridge_generated.dart \
--llvm-path /usr/local/homebrew/opt/llvm/ \
--c-output ../ios/Runner/bridge_generated.h