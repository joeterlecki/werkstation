#!/usr/bin/env bash

source "$(dirname "$0")/../utils/log.sh"

log_section "Jetbrains Toolbox"

log_info "Verifying previous installation..."

TOOLBOX_DIR="/opt/jetbrains-toolbox"
BINARY_LINK="/usr/local/bin/jetbrains-toolbox"

if [ -L "$BINARY_LINK" ] || [ -d "$TOOLBOX_DIR" ] || pgrep -f "jetbrains-toolbox" &>/dev/null; then
    log_warn "Jetbrains Toolbox previous installation exists..."
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

    # log_info "Adding Jetbrains Shell Scripts to PATH..."
    # if [[ ":$PATH:" != *":$HOME/.local/share/JetBrains/Toolbox/scripts:"* ]]; then
    #     echo 'export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"' >>~/.bashrc
    #     log_info "Toolbox scripts PATH added to .bashrc"
    # else
    #     log_warn "Jetbrains Toobox scripts already added to PATH..."
    # fi

    log_info "Jetbrains Toolbox installation complete"
fi
