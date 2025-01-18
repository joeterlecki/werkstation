#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"
log_section "Jetbrains Toolbox"

TOOLBOX_DIR="/opt/jetbrains-toolbox"
BINARY_LINK="/usr/local/bin/jetbrains-toolbox"
JETBRAINS_PATH='export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"'

if [[ ":$PATH:" != *":$HOME/.local/share/JetBrains/Toolbox/scripts:"* ]]; then
	log_warn "Toolbox scripts not found in current PATH"
else
	log_info "Toolbox scripts found in current PATH"
fi

if ! grep -q "PATH=\"\$PATH:\$HOME/.local/share/JetBrains/Toolbox/scripts\"" "$HOME/.bashrc"; then
	log_info "Adding Toolbox scripts PATH to .bashrc..."
	echo "$JETBRAINS_PATH" >>"$HOME/.bashrc"
else
	log_info "Toolbox scripts PATH already in .bashrc"
fi

if ! grep -q "PATH=\"\$PATH:\$HOME/.local/share/JetBrains/Toolbox/scripts\"" "$HOME/.zshrc"; then
	log_info "Adding Toolbox scripts PATH to .zshrc..."
	echo "$JETBRAINS_PATH" >>"$HOME/.zshrc"
else
	log_info "Toolbox scripts PATH already in .zshrc"
fi

if [ -L "$BINARY_LINK" ] || [ -d "$TOOLBOX_DIR" ] || pgrep -f "jetbrains-toolbox" &>/dev/null; then
	log_warn "Jetbrains Toolbox previous installation exists..."
	exit 0
fi

TEMP_DIR=$(mktemp -d)

log_info "Detecting latest version..."
LATEST_URL=$(wget -qO- "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release" | jq -r '.TBA[0].downloads.linux.link')
if [ -z "$LATEST_URL" ] || [ "$LATEST_URL" == "null" ]; then
	log_error "Failed to retrieve latest version from url"
	exit 1
fi

log_info "Retrieving latest Jetbrains Toolbox version..."
wget -O "$TEMP_DIR/toolbox.tar.gz" "$LATEST_URL"
if [ ! -f "$TEMP_DIR/toolbox.tar.gz" ]; then
	log_error "Failed to retrieve toolbox archive"
	exit 1
fi

log_info "Extracting Jetbrains Toolbox archive..."
tar -xzf "$TEMP_DIR/toolbox.tar.gz" -C "$TEMP_DIR"
EXTRACT_DIR=$(find "$TEMP_DIR" -maxdepth 1 -type d -name "jetbrains-toolbox-*")
if [ -z "$EXTRACT_DIR" ]; then
	log_error "Extraction failed"
	exit 1
fi

log_info "Installing Toolbox to $TOOLBOX_DIR..."
sudo mkdir -p "$TOOLBOX_DIR"
sudo cp -r "$EXTRACT_DIR"/* "$TOOLBOX_DIR"
sudo chmod +x "$TOOLBOX_DIR/jetbrains-toolbox"

log_info "Creating symbolic link to /usr/local/bin/..."
sudo ln -sf "$TOOLBOX_DIR/jetbrains-toolbox" "$BINARY_LINK"

rm -rf "$TEMP_DIR"
log_info "Jetbrains Toolbox installation complete"
