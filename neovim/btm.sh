#!/usr/bin/env bash

source "$(dirname "$0")/../utils/log.sh"

log_section "Bottom System Monitor"

get_current_version() {
    dpkg-query --showformat='${Version}' --show bottom 2>/dev/null | sed 's/-1//'
}

log_info "Detecting latest Bottom version..."

LATEST_VERSION=$(curl -s https://api.github.com/repos/ClementTsang/bottom/releases/latest |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/' |
    sed 's/^v//')

if [ -z "$LATEST_VERSION" ]; then
    log_error "Failed to detect latest version"
    exit 1
fi

log_info "Latest version: ${LATEST_VERSION}"

if command -v btm &>/dev/null; then
    CURRENT_VERSION=$(get_current_version)
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

DEB_FILE="bottom_${LATEST_VERSION}-1_${ARCH}.deb"
DOWNLOAD_URL="https://github.com/ClementTsang/bottom/releases/download/${LATEST_VERSION}/${DEB_FILE}"

log_info "Downloading Bottom ${LATEST_VERSION}..."
if ! curl -L "$DOWNLOAD_URL" -o "${TEMP_DIR}/${DEB_FILE}"; then
    log_error "Failed to download Bottom"
    exit 1
fi

log_info "Installing Bottom..."
if ! sudo dpkg -i "${TEMP_DIR}/${DEB_FILE}"; then
    log_error "Failed to install Bottom"
    exit 1
fi

log_info "Bottom installation complete"
