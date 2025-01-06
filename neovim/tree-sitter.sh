#!/usr/bin/env bash

source "${SCRIPT_DIR}/utils/log.sh"

log_section "Tree-sitter CLI"

. "$NVM_DIR/nvm.sh"

if command -v tree-sitter &>/dev/null; then
    log_warn "Previous Tree-sitter installation found..."
    exit 0
fi

log_info "Installing Tree-sitter..."
npm install -g tree-sitter-cli

log_info "Tree-sitter CLI installation complete"
