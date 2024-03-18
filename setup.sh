# Install Rust
command -v rustc >/dev/null 2>&1 || { echo >&2 "Rust is not installed. Installing Rust..."; curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; }

# Detect shell type and source Rust environment accordingly
if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ] || [ -n "$ASH_VERSION" ] || [ -n "$DASH_VERSION" ] || [ -n "$PDKSH_VERSION" ]; then
    . "$HOME/.cargo/env"            # For sh/bash/zsh/ash/dash/pdksh
elif [ -n "$FISH_VERSION" ]; then
    source "$HOME/.cargo/env.fish"  # For fish
else
    echo "Unsupported shell. Please manually source Rust environment."
fi

# Install Flutter Rust Bridge
FLUTTER_RUST_BRIDGE_VERSION=$(grep flutter_rust_bridge: pubspec.yaml | awk '{print $2}' | sed 's/^\^/=/')
cargo install "flutter_rust_bridge_codegen@$FLUTTER_RUST_BRIDGE_VERSION"

if ! command -v flutter &> /dev/null; then
    echo "Flutter is not installed. Please install Flutter by visiting https://docs.flutter.dev/get-started/install"
    exit 1
fi

# Generate Rust bindings
flutter_rust_bridge_codegen generate
