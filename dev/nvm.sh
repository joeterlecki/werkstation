#!/usr/bin/env bash

source "$(dirname "$0")/../utils/log.sh"

log_section "Node Version Manager"

log_info "Installing node version manager (NVM)..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

log_info "Sourcing NVM..."
source ~/.nvm/nvm.sh

log_info "Installing curretn Node LTS..."
nvm install --lts

log_info "Node Version Manager and Node LTS installation completed"