#!/usr/bin/env bash

source "$(dirname "$0")/../utils/log.sh"

log_section "Jetbrains Toolbox"

log_info "Verifying previous installation..."
TOOLBOX_DIR="/opt/jetbrains-toolbox"
BINARY_LINK="/usr/local/bin/jetbrains-toolbox"
JETBRAINS_PATH='export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"'
SKIKO_CONFIG='export SKIKO_RENDER_API=SOFTWARE'
WAYLAND_RUNTIME="ln -sf /mnt/wslg/runtime-dir/wayland-* $XDG_RUNTIME_DIR"

if [ -L "$BINARY_LINK" ] || [ -d "$TOOLBOX_DIR" ] || pgrep -f "jetbrains-toolbox" &>/dev/null; then
   log_warn "Jetbrains Toolbox previous installation exists..."
   
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

    log_info "Checking for SKIKO config in bashrc for ARM renderinig..."
    if [[ $IS_WSL -eq 1 ]] && [[ $(uname -m) == "aarch64" ]]; then
        if ! grep -q "$SKIKO_CONFIG" ~/.bashrc; then
            log_info "Adding SKIKO Config..."
            echo "$SKIKO_CONFIG" >>~/.bashrc

            log_info "Added SKIKO render configuration to .bashrc for WSL ARM"
        else
            log_info "SKIKO render configuration already in .bashrc"
        fi
    fi

    log_info "Checking for WAYLAND RUNTIME Condig for rendering..."
    if ! grep -q "$WAYLAND_RUNTIME" ~/.bashrc; then
        log_info "Adding WAYLAND RUNTIME Config..."
        echo "$WAYLAND_RUNTIME" >>~/.bashrc
    else
        log_info "WAYLAND RUNTIME configuration already in .bashrc"
    fi

    exit 0
else
    log_info "Calculating latest version..."
    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"

    log_info "Detecting latest version..."
    LATEST_URL=$(wget -qO- "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release" |
        jq -r '.TBA[0].downloads.linux.link')
    if [ -z "$LATEST_URL" ] || [ "$LATEST_URL" == "null" ]; then
        log_error "Failed to retrieve latest version from url"
        exit 0
    fi
    log_info "Retrieving latest Jetbrains Toolbox version..."
    wget -O toolbox.tar.gz "$LATEST_URL"
    if [ ! -f toolbox.tar.gz ]; then
        log_error "Failed to retrieve toolbox archvie..."
        exit 0
    fi

    log_info "Extracting Jetbrains Toolbox archive..."
    tar -xzf toolbox.tar.gz
    EXTRACT_DIR=$(find . -maxdepth 1 -type d -name "jetbrains-toolbox-*")
    if [ -z "$EXTRACT_DIR" ]; then
        log_error "Extraction failed..."
        exit 0
    fi
    log_info "Installing Toolbox to $TOOLBOX_DIR..."
    sudo mkdir -p "$TOOLBOX_DIR"
    sudo cp -r $EXTRACT_DIR/* "$TOOLBOX_DIR"
    sudo chmod +x "$TOOLBOX_DIR/jetbrains-toolbox"

    log_info "Creating symbolic link to /usr/local/bin/..."
    sudo ln -sf "$TOOLBOX_DIR/jetbrains-toolbox" "$BINARY_LINK"

    log_info "Cleaning up installation..."
    cd && rm -rf "$TMP_DIR"
   
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

    log_info "Checking for SKIKO config in bashrc for ARM renderinig..."
    if [[ $IS_WSL -eq 1 ]] && [[ $(uname -m) == "aarch64" ]]; then
        if ! grep -q "$SKIKO_CONFIG" ~/.bashrc; then
            log_info "Adding SKIKO Config..."
            echo "$SKIKO_CONFIG" >>~/.bashrc

            log_info "Added SKIKO render configuration to .bashrc for WSL ARM"
        else
            log_info "SKIKO render configuration already in .bashrc"
        fi
    fi

    log_info "Checking for WAYLAND RUNTIME Condig for rendering..."
    if ! grep -q "$WAYLAND_RUNTIME" ~/.bashrc; then
        log_info "Adding WAYLAND RUNTIME Config..."
        echo "$WAYLAND_RUNTIME" >>~/.bashrc
    else
        log_info "WAYLAND RUNTIME configuration already in .bashrc"
    fi

fi

log_info "Jetbrains Toolbox installation complete"