#!/usr/bin/env bash
source "$(dirname "$0")/../utils/log.sh"

log_section "Essential Packages"

PACKAGES=(
    curl
    wget
    git
    unzip
    build-essential
    software-properties-common
    apt-transport-https
    ca-certificates
    gnupg
    jq
    fuse
)

log_info "Installing common tools..."
sudo apt-get install -y "${PACKAGES[@]}"

log_info "Essential packages installation completed"