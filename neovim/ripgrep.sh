#!/usr/bin/env bash

source "$(dirname "$0")/../utils/log.sh"

log_section "Ripgrep"

if command -v rg &>/dev/null; then
    log_warn "Ripgrep installation found..."
    exit 0
fi

log_info "Installing Ripgrep..."
sudo apt-get install ripgrep -y

log_info "Ripgrep installation complete"
