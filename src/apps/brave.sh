#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"
log_section "Brave Browser"

log_info "Installing brave..."
sudo dnf-3 config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo dnf install brave-browser -y

log_info "Brave browser installation complete"

