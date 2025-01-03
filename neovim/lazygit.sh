#!/usr/bin/env bash
source "$(dirname "${0}")/../utils/log.sh"

log_section "Lazygit Installation"

log_info "Detecting latest Lazygit version..."
LATEST_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/' |
    sed 's/^v//')
if [ -z "$LATEST_VERSION" ]; then
    log_error "Failed to detect latest version"
    exit 1
fi
log_info "Latest version: ${LATEST_VERSION}"

if command -v lazygit &>/dev/null; then
    CURRENT_VERSION=$(lazygit --version | grep -o "version=[0-9.]*," | sed 's/version=//;s/,//')
    log_info "Current version: ${CURRENT_VERSION}"
    if [[ "$LATEST_VERSION" > "$CURRENT_VERSION" ]]; then
        log_info "Update available, proceeding with installation..."
    else
        log_info "Current version is up to date"
        exit 0
    fi
fi

TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

if [ "$ARCH" = "arm64" ]; then
    DOWNLOAD_URL="https://github.com/jesseduffield/lazygit/releases/download/v${LATEST_VERSION}/lazygit_${LATEST_VERSION}_Linux_arm64.tar.gz"
else
    DOWNLOAD_URL="https://github.com/jesseduffield/lazygit/releases/download/v${LATEST_VERSION}/lazygit_${LATEST_VERSION}_Linux_x86_64.tar.gz"
fi

log_info "Working in temporary directory: $TEMP_DIR"

log_info "Downloading latest Lazygit release for $ARCH..."
curl -L "$DOWNLOAD_URL" -o "$TEMP_DIR/lazygit.tar.gz"

log_info "Extracting Lazygit..."
tar xf "$TEMP_DIR/lazygit.tar.gz" -C "$TEMP_DIR" lazygit

log_info "Installing Lazygit..."
sudo install "$TEMP_DIR/lazygit" -D -t /usr/local/bin/

log_info "Lazygit installation complete"
