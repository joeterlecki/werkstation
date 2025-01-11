#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"
log_section "Kitty Terminal"

log_info "Installing kitty terminal..."
sudo dnf install kitty -y

log_info "Kitty terminal installation complete"

