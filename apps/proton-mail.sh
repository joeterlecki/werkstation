#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

# Create temporary file and ensure cleanup
TEMP_FILE=$(mktemp)
trap 'rm -f "$TEMP_FILE"' EXIT

log_section "Proton Mail"

log_info "Downloading Proton Mail..."
curl -L -o "$TEMP_FILE" "https://proton.me/download/mail/linux/1.6.1/ProtonMail-desktop-beta.rpm"

log_info "Installing Proton Mail..."
sudo dnf install -y "$TEMP_FILE"

log_info "Proton Mail installation complete"
