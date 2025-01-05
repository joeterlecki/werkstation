#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "Bun"

# Define Bun's path addition correctly
BUN_PATH='export BUN_INSTALL="$HOME/.bun"'
BUN_BIN_PATH='export PATH="$BUN_INSTALL/bin:$PATH"'

if command -v bun &>/dev/null; then
    log_warn "Previous Bun installation found..."
    exit 0
fi

log_info "Installing Bun..."
curl -fsSL https://bun.sh/install | bash

log_info "Adding Bun to bash Path..."
if ! grep -q "BUN_INSTALL" ~/.bashrc; then
    log_info "Added Bun PATH to .bashrc"
    echo "$BUN_PATH" >>~/.bashrc
    echo "$BUN_BIN_PATH" >>~/.bashrc
    log_info "Sourcing bashrc..."
    source $HOME/.bashrc
else
    log_info "Bun PATH already in .bashrc"
fi

log_info "Adding Bun to zsh Path..."
if ! grep -q "BUN_INSTALL" ~/.zshrc; then
    log_info "Added Bun PATH to .zshrc"
    echo "$BUN_PATH" >>~/.zshrc
    echo "$BUN_BIN_PATH" >>~/.zshrc
else
    log_info "Bun PATH already in .zshrc"
fi

log_info "Bun installation complete"
