#!/usr/bin/env bash
source "$(dirname "$0")/../utils/log.sh"
log_section "Node Version Manager"

LATEST_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
INSTALL_URL="https://raw.githubusercontent.com/nvm-sh/nvm/${LATEST_VERSION}/install.sh"

if command -v nvm &>/dev/null; then
    CURRENT_VERSION="v$(nvm --version)"
    log_info "Current version: ${CURRENT_VERSION}"
    log_info "Latest version: ${LATEST_VERSION}"
    if [ "${CURRENT_VERSION}" = "${LATEST_VERSION}" ]; then
        log_warn "Already running the latest version of Node Version Manager"
        exit 0
    fi
    log_warn "Previous Node Version Manager installation found"
    curl -o- "$INSTALL_URL" | bash &>/dev/null
else
    log_info "Installing Node Version Manager..."
    curl -o- "$INSTALL_URL" | bash &>/dev/null
fi

if ! grep -q 'export NVM_DIR="$HOME/.nvm"' ~/.bashrc 2>/dev/null; then
    cat <<'EOF' >>~/.bashrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF
    log_info "NVM configuration added to .bashrc"
else
    log_warn "NVM configuration already in .bashrc"
fi

if ! grep -q 'export NVM_DIR="$HOME/.nvm"' ~/.zshrc 2>/dev/null; then
    cat <<'EOF' >>~/.zshrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF
    log_info "NVM configuration added to .zshrc"
else
    log_warn "NVM configuration already in .zshrc"
fi

log_info "Sourcing NVM..."
source ~/.nvm/nvm.sh &>/dev/null

# Get the latest LTS version number
LATEST_LTS=$(nvm version-remote --lts)
# Get the current version (if Node.js is installed)
CURRENT_NODE_VERSION=$(node -v 2>/dev/null || echo "none")

log_info "Current Node.js version: ${CURRENT_NODE_VERSION}"
log_info "Latest LTS version: ${LATEST_LTS}"

if [ "${CURRENT_NODE_VERSION}" = "none" ]; then
    log_info "No Node.js installation found. Installing latest LTS..."
    nvm install --lts &>/dev/null
elif [ "${CURRENT_NODE_VERSION}" = "${LATEST_LTS}" ]; then
    log_warn "Already running the latest Node.js LTS version"
else
    log_info "Updating to latest Node.js LTS version..."
    nvm install --lts &>/dev/null
fi

log_info "Node Version Manager and Node LTS installation complete"
