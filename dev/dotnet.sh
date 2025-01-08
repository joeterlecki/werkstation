#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"
log_section "Dotnet"

DOTNET_PATH='export PATH="$PATH:$HOME/.dotnet/tools"'

log_info "Installing latest dotnet sdks..."
sudo apt-get install -y dotnet-sdk-8.0

if ! grep -q "PATH=\"\$PATH:\$HOME/.dotnet/tools\"" "$HOME/.bashrc"; then
    log_info "Adding Dotnet Tools to Path in bashrc..."
    echo "$DOTNET_PATH" >>"$HOME/.bashrc"
else
    log_info "Dotnet PATH already in .bashrc"
fi

if ! grep -q "PATH=\"\$PATH:\$HOME/.dotnet/tools\"" "$HOME/.zshrc"; then
    log_info "Adding Dotnet Tools to Path in zshrc..."
    echo "$DOTNET_PATH" >>"$HOME/.zshrc"
else
    log_info "Dotnet PATH already in .zshrc"
fi

log_info "Dotnet installation complete"
