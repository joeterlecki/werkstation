#!/usr/bin/env bash

source "${SCRIPT_DIR}/utils/log.sh"

log_section "Brew Packages"

log_info "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

log_warn "Modifying shell configuration zshrc and bashrc"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc

log_info "Installing tools from Brewfile"
brew bundle install --file="./Brewfile"

log_info "Instalation completed"