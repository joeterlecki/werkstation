#!/usr/bin/env bash

source "${SCRIPT_DIR}/utils/log.sh"

log_section "Node Version Manager"

export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"

LATEST_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
INSTALL_URL="https://raw.githubusercontent.com/nvm-sh/nvm/${LATEST_VERSION}/install.sh"
log_info "Installing Node Version Manager..."
curl -o- "$INSTALL_URL" | bash

NVM_CONFIG='
# NVM (Node Version Manager) Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
'

if [ -f "$HOME/.bashrc" ] && ! grep -q 'export NVM_DIR=' "$HOME/.bashrc" 2>/dev/null; then
    echo "$NVM_CONFIG" >> "$HOME/.bashrc"
    log_info "NVM configuration added to .bashrc"
else
    log_warn "NVM configuration already in .bashrc"
fi

if [ -f "$HOME/.zshrc" ] && ! grep -q 'export NVM_DIR=' "$HOME/.zshrc" 2>/dev/null; then
    echo "$NVM_CONFIG" >> "$HOME/.zshrc"
    log_info "NVM configuration added to .zshrc"
else
    log_warn "NVM configuration already in .zshrc"
fi

sleep 2

log_info "Sourcing NVM..."
source "$NVM_DIR/nvm.sh"

log_info "Installing Node LTS version..."
nvm install --lts

log_info "Node Version Manager and Node LTS installation complete"
