#!/usr/bin/env bash

source "$(dirname "${0}")/../utils/log.sh"

log_section "Dotnet"

log_info "Checking for previous installation..."

if command -v dotnet &>/dev/null; then
    log_warn "Previous Dotnet SDK installation found..."
    exit 0
else
    log_info "Updating APT sources..."
    sudo apt-get update &&
        log_info "Installing Dotnet SDK via APT..."
    sudo apt-get install -y dotnet-sdk-8.0

    log_info "Adding Dotnet Tools to Path..."
    export PATH=$PATH:$HOME/.dotnet/tools

    log_info "Sourcing .bashrc for path changes..."

fi

log_info "Dotnet installation complete"
