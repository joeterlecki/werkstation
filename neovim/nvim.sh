#!/usr/bin/env bash

source "$(dirname "$0")/../utils/log.sh"

log_section "NVIM: AstroNVIM"

if command -v nvim &>/dev/null; then
    log_warn "Neovim installation found..."
    exit 0
fi

sudo apt-get install neovim -y

log_info "Neovim installation complete"
