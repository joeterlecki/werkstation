#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"

log_section "Hashicorp"

log_info "Adding hashicorop dnf repo..."
sudo dnf-3 config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo

log_info "Installing Hashicorp tools..."
sudo dnf install -y terraform packer

log_info "Hashicorp tools installation complete"
