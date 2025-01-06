#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"
log_section "Node Version Manager"

LATEST_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
INSTALL_URL="https://raw.githubusercontent.com/nvm-sh/nvm/${LATEST_VERSION}/install.sh"

log_info "Installing Node Version Manager..."
curl -o- "$INSTALL_URL" | bash 

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
source ~/.nvm/nvm.sh

nvm install --lts

log_info "Node Version Manager and Node LTS installation complete"
