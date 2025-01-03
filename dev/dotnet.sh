#!/usr/bin/env bash
source "$(dirname "${0}")/../utils/log.sh"

log_section "Dotnet"

DOTNET_PATH='export PATH=$PATH:$HOME/.dotnet/tools'

if command -v dotnet &>/dev/null; then
    log_warn "Previous Dotnet SDK installation found..."
    exit 0
fi

log_info "Updating APT sources..."
sudo apt-get update

log_info "Installing Dotnet SDK via APT..."
sudo apt-get install -y dotnet-sdk-8.0

log_info "Adding Dotnet Tools to Path..."
if ! grep -q "$DOTNET_PATH" ~/.bashrc; then
    echo "$DOTNET_PATH" >>~/.bashrc
    log_info "Added Dotnet PATH to .bashrc"
else
    log_info "Dotnet PATH already in .bashrc"
fi

log_info "Adding Dotnet Tools to Zsh Path..."
if ! grep -q "$DOTNET_PATH" ~/.zshrc; then
    echo "$DOTNET_PATH" >>~/.zshrc
    log_info "Added Dotnet PATH to .zshrc"
else
    log_info "Dotnet PATH already in .zshrc"
fi

log_info "Dotnet installation complete"
