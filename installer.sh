#!/usr/bin/env bash
set -e

# Install locations
HEADER_DIR="/usr/local/include/kernc"
LIB_DIR="/usr/local/share/kernc"
BIN_DIR="/usr/local/bin"

echo "Installing Kern.."

# 1. Install C headers
echo "Installing headers to $HEADER_DIR..."
sudo mkdir -p "$HEADER_DIR"
sudo cp -r include/* "$HEADER_DIR"

# 0. Check for Lua 5.4
if ! command -v lua5.4 >/dev/null 2>&1; then
    echo "Error: Lua 5.4 is required but not installed."
    echo "Please install lua5.4 (e.g., sudo apt install lua5.4)"
    exit 1
fi

echo "Lua 5.4 found."

# 2. Install Lua compiler files
echo "Installing Lua compiler to $LIB_DIR..."
sudo mkdir -p "$LIB_DIR"
sudo cp kernc.lua "$LIB_DIR"
sudo cp kernpp.lua "$LIB_DIR"

# 3. Create launcher script
echo "Creating kernc launcher in $BIN_DIR..."
sudo tee "$BIN_DIR/kernc" > /dev/null <<EOF
#!/usr/bin/env bash
lua5.4 $LIB_DIR/kernc.lua "\$@"
EOF

sudo chmod +x "$BIN_DIR/kernc"

echo "KernC installed successfully."
echo "You can now run: kernc <file>"
