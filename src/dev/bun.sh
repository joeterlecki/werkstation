#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "Bun"

BUN_PATH='export BUN_INSTALL="$HOME/.bun"'
BUN_BIN_PATH='export PATH="$BUN_INSTALL/bin:$PATH"'


log_info "Installing Bun..."
curl -fsSL https://bun.sh/install | bash

BUN_PATH='export PATH="$HOME/.bun/bin:$PATH"'

if ! grep -q "$HOME/.bun/bin" "$HOME/.bashrc"; then
    log_info "Adding bun to bashrc..."
    echo "$BUN_PATH" >> "$HOME/.bashrc"
fi

if ! grep -q "$HOME/.bun/bin" "$HOME/.zshrc"; then
    log_info "Adding bun to zshrc..."
    echo "$BUN_PATH" >> "$HOME/.zshrc"
fi

log_info "Bun installation complete"
