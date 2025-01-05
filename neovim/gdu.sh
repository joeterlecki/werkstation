#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "GDU Installation"

log_info "Detecting latest GDU version..."
LATEST_VERSION=$(curl -s https://api.github.com/repos/dundee/gdu/releases/latest |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/' |
    sed 's/^v//')
if [ -z "$LATEST_VERSION" ]; then
    log_error "Failed to detect latest version"
    exit 1
fi
log_info "Latest version: ${LATEST_VERSION}"

if command -v gdu &>/dev/null; then
    CURRENT_VERSION=$(gdu --version | cut -d ' ' -f 2)
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

DOWNLOAD_URL="https://github.com/dundee/gdu/releases/latest/download/gdu_linux_${ARCH}.tgz"

log_info "Working in temporary directory: $TEMP_DIR"

log_info "Downloading latest GDU release for $ARCH..."
curl -L "$DOWNLOAD_URL" -o "$TEMP_DIR/gdu.tgz"

log_info "Extracting GDU..."
tar xzf "$TEMP_DIR/gdu.tgz" -C "$TEMP_DIR"

log_info "Installing GDU..."
sudo mv "$TEMP_DIR/gdu_linux_${ARCH}" /usr/bin/gdu

log_info "Setting permissions..."
sudo chmod +x /usr/bin/gdu

log_info "GDU installation complete"
