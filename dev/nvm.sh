#!/usr/bin/env bash

source "$(dirname "$0")/../utils/log.sh"

log_section "Node Version Manager"

log_info "Calculating latest Node Version Manager version..."
LATEST_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
INSTALL_URL="https://raw.githubusercontent.com/nvm-sh/nvm/${LATEST_VERSION}/install.sh"

log_warn "Setting NVM_DIR to check previous installation..."
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if command -v nvm &>/dev/null; then
    CURRENT_VERSION="v$(nvm --version)"
    log_info "Current version: ${CURRENT_VERSION}"
    log_info "Latest version: ${LATEST_VERSION}"

    if [ "${CURRENT_VERSION}" = "${LATEST_VERSION}" ]; then
        log_warn "Already running the latest version of Node Version Manager"
        log_info "Node Version Manager and Node LTS installation completed"
        exit 0
    fi

    log_warn "Previous Node Version Manager (NVM) installation found"
    log_warn "Executing default behaviour for updates..."
    curl -o- "$INSTALL_URL" | bash

    log_info "Appending NVM configuration to bashrc"
    if ! grep -q 'export NVM_DIR="$HOME/.nvm"' ~/.bashrc; then
        cat << 'EOF' >> ~/.bashrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF
       log_info "NVM configuration added to .bashrc"
    else
       log_warn "NVM configuration is already in .bashrc"
    fi

    log_info "Sourcing NVM..."
    source ~/.nvm/nvm.sh

    log_info "Installing current Node LTS..."
    nvm install --lts
else
    log_info "Installing node version manager (NVM)..."
    curl -o- "$INSTALL_URL" | bash

    log_info "Appending NVM configuration to bashrc"
    if ! grep -q 'export NVM_DIR="$HOME/.nvm"' ~/.bashrc; then
        cat << 'EOF' >> ~/.bashrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF
       log_info "NVM configuration added to .bashrc"
    else
       log_warn "NVM configuration is already in .bashrc"
    fi

    log_info "Sourcing NVM..."
    source ~/.nvm/nvm.sh

    log_info "Installing current Node LTS..."
    nvm install --lts
fi

log_info "Node Version Manager and Node LTS installation completed"
