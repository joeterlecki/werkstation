#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "GDU Installation"

TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

DOWNLOAD_URL="https://github.com/dundee/gdu/releases/latest/download/gdu_linux_amd64.tgz"

log_info "Working in temporary directory: $TEMP_DIR"

log_info "Downloading latest GDU release..."
curl -L "$DOWNLOAD_URL" -o "$TEMP_DIR/gdu.tgz"

log_info "Extracting GDU..."
tar xzf "$TEMP_DIR/gdu.tgz" -C "$TEMP_DIR"

log_info "Installing GDU..."
sudo mv "$TEMP_DIR/gdu_linux_${ARCH}" /usr/bin/gdu

log_info "Setting permissions..."
sudo chmod +x /usr/bin/gdu

log_info "GDU installation complete"
