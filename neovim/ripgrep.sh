#!/usr/bin/env bash

source "${SCRIPT_DIR}/utils/log.sh"

log_section "Ripgrep"

if command -v rg &>/dev/null; then
    log_warn "Ripgrep installation found..."
    exit 0
fi

log_info "Installing Ripgrep..."
sudo zypper -n install ripgrep

log_info "Ripgrep installation complete"
