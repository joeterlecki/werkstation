#!/usr/bin/env bash

source "$(dirname "$0")/../utils/log.sh"

log_section "Tree-sitter CLI"

if command -v tree-sitter &>/dev/null; then
    log_warn "Previous Tree-sitter installation found..."
    exit 0
fi

log_info "Installing Tree-sitter..."
npm install -g tree-sitter-cli

log_info "Tree-sitter CLI installation complete"
