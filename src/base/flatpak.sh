#!/usr/bin/env bash
source "${SCRIPT_DIR}/utils/log.sh"
log_section "Flatpak"

log_info "Installing Flatpak..."
sudo dnf install -y flatpak 

log_info "Enabling flathub..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

log_info "Flatpak and packs installation complete"
