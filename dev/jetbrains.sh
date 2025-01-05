#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "Jetbrains Toolbox"

TOOLBOX_DIR="/opt/jetbrains-toolbox"
BINARY_LINK="/usr/local/bin/jetbrains-toolbox"
JETBRAINS_PATH='export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"'
SKIKO_CONFIG='export SKIKO_RENDER_API=SOFTWARE'
WAYLAND_RUNTIME='ln -sf /mnt/wslg/runtime-dir/wayland-* $XDG_RUNTIME_DIR/'

configure_environment() {
    if [[ ":$PATH:" != *":$HOME/.local/share/JetBrains/Toolbox/scripts:"* ]]; then
        log_warn "Toolbox scripts not found in current PATH"
    else
        log_info "Toolbox scripts found in current PATH"
    fi

    if ! grep -q "$JETBRAINS_PATH" ~/.bashrc; then
        echo "$JETBRAINS_PATH" >>~/.bashrc
        log_info "Added Toolbox scripts PATH to .bashrc"
    else
        log_info "Toolbox scripts PATH already in .bashrc"
    fi

    if [[ $IS_WSL -eq 1 ]] && [[ $(uname -m) == "aarch64" ]]; then
        if ! grep -q "$SKIKO_CONFIG" ~/.bashrc; then
            echo "$SKIKO_CONFIG" >>~/.bashrc
            log_info "Added SKIKO render configuration to .bashrc for WSL ARM"
        else
            log_info "SKIKO render configuration already in .bashrc"
        fi
    fi

    if ! grep -q '/mnt/wslg/runtime-dir/wayland-\* \$XDG_RUNTIME_DIR' ~/.bashrc; then
        echo "$WAYLAND_RUNTIME" >>~/.bashrc
        log_info "Added Wayland runtime configuration to .bashrc"
    else
        log_info "Wayland runtime configuration already in .bashrc"
    fi

    if ! grep -q "$JETBRAINS_PATH" ~/.zshrc; then
        echo "$JETBRAINS_PATH" >>~/.zshrc
        log_info "Added Toolbox scripts PATH to .zshrc"
    else
        log_info "Toolbox scripts PATH already in .zshrc"
    fi

    if [[ $IS_WSL -eq 1 ]] && [[ $(uname -m) == "aarch64" ]]; then
        if ! grep -q "$SKIKO_CONFIG" ~/.bashrc; then
            echo "$SKIKO_CONFIG" >>~/.bashrc
            log_info "Added SKIKO render configuration to .bashrc for WSL ARM"
        else
            log_info "SKIKO render configuration already in .zshrc"
        fi
    fi

    if ! grep -q '/mnt/wslg/runtime-dir/wayland-\* \$XDG_RUNTIME_DIR' ~/.zshrc; then
        echo "$WAYLAND_RUNTIME" >>~/.zshrc
        log_info "Added Wayland runtime configuration to .zshrc"
    else
        log_info "Wayland runtime configuration already in .zshrc"
    fi
}

if [ -L "$BINARY_LINK" ] || [ -d "$TOOLBOX_DIR" ] || pgrep -f "jetbrains-toolbox" &>/dev/null; then
    log_warn "Jetbrains Toolbox previous installation exists..."
    configure_environment
    exit 0
fi

TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR" || exit 1

log_info "Detecting latest version..."
LATEST_URL=$(wget -qO- "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release" | jq -r '.TBA[0].downloads.linux.link')
if [ -z "$LATEST_URL" ] || [ "$LATEST_URL" == "null" ]; then
    log_error "Failed to retrieve latest version from url"
    exit 1
fi

log_info "Retrieving latest Jetbrains Toolbox version..."
wget -O toolbox.tar.gz "$LATEST_URL"
if [ ! -f toolbox.tar.gz ]; then
    log_error "Failed to retrieve toolbox archive"
    exit 1
fi

log_info "Extracting Jetbrains Toolbox archive..."
tar -xzf toolbox.tar.gz
EXTRACT_DIR=$(find . -maxdepth 1 -type d -name "jetbrains-toolbox-*")
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

cd || exit 1
rm -rf "$TEMP_DIR"

configure_environment
log_info "Jetbrains Toolbox installation complete"
