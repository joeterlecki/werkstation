#!/usr/bin/env bash
source "$(dirname "${0}")/../utils/log.sh"
log_section "Bun"
BUN_PATH="export PATH=$PATH:$HOME/.bun/bin"

if command -v bun &>/dev/null; then
    log_warn "Previous Bun installation found..."
    exit 0
fi

log_info "Installing Bun..."
curl -fsSL https://bun.sh/install | bash

log_info "Adding Bun to Path..."
if ! grep -q "$BUN_PATH" ~/.bashrc; then
    log_info "Added Bun PATH to .bashrc"
    echo "$BUN_PATH" >>~/.bashrc

    log_info "Sourcing bashrc..."
    source $HOME/.bashrc
else
    log_info "Bun PATH already in .bashrc"
fi

log_info "Bun installation complete"
